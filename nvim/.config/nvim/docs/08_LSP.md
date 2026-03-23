# Spec: LSP Setup
> lua/configs/lspconfig.lua — servers, on_attach, capabilities, diagnostics

---

## Architecture

```
mason.nvim               ← installs external binaries
  ├── mason-lspconfig    ← ensures LSP servers are installed
  └── mason-tool-installer
       └── ensures formatters + linters are installed on startup
        └── nvim-lspconfig
              ├── on_attach()    ← runs when LSP attaches to buffer
              │     └── sets buffer-local keymaps + autocmds
              ├── capabilities   ← extended by cmp-nvim-lsp
              └── per-server setup({ on_attach, capabilities, settings })
```

---

## `lua/configs/lspconfig.lua`

```lua
-- lua/configs/lspconfig.lua

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Extend capabilities with nvim-cmp's completion support
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- Broader file watching support
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

-- ================================================================
-- ON_ATTACH — runs when an LSP server attaches to a buffer
-- ================================================================
local on_attach = function(client, bufnr)
  local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, {
      buffer  = bufnr,
      desc    = "LSP: " .. desc,
      silent  = true,
      noremap = true,
    })
  end

  -- Navigation
  map("gd",         vim.lsp.buf.definition,       "Go to Definition")
  map("gD",         vim.lsp.buf.declaration,      "Go to Declaration")
  map("gi",         vim.lsp.buf.implementation,   "Go to Implementation")
  map("gt",         vim.lsp.buf.type_definition,  "Go to Type Definition")
  map("gr",         "<cmd>Telescope lsp_references<cr>", "References")

  -- Hover / signature
  map("K",          vim.lsp.buf.hover,            "Hover Docs")
  map("<C-k>",      vim.lsp.buf.signature_help,   "Signature Help")

  -- Code actions
  map("<leader>ca", vim.lsp.buf.code_action,      "Code Action")
  map("<leader>rn", vim.lsp.buf.rename,           "Rename Symbol")

  -- Workspace
  map("<leader>wa", vim.lsp.buf.add_workspace_folder,    "Add Workspace Folder")
  map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
  map("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "List Workspace Folders")

  -- Format (also handled by conform.nvim on save)
  map("<leader>lf", function()
    vim.lsp.buf.format({ async = true })
  end, "Format Buffer")

  -- Inline diagnostics via illuminate
  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup("LspDocumentHighlight_" .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer   = bufnr,
      group    = group,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer   = bufnr,
      group    = group,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- Disable semantic tokens — let treesitter handle highlighting
  -- (NvChad does this in on_init; we do it here for clarity)
  client.server_capabilities.semanticTokensProvider = nil
end

-- ================================================================
-- DIAGNOSTIC DISPLAY CONFIG
-- ================================================================
local icons = require("core.config").lsp.icons
local diagnostic_signs = {
  [vim.diagnostic.severity.ERROR] = icons.Error,
  [vim.diagnostic.severity.WARN] = icons.Warn,
  [vim.diagnostic.severity.INFO] = icons.Info,
  [vim.diagnostic.severity.HINT] = icons.Hint,
}

vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    source = "if_many",
  },
  signs = { text = diagnostic_signs },
  underline       = true,
  update_in_insert= false,
  severity_sort   = true,
  float = {
    border  = require("core.config").ui.border,
    source  = "always",
    header  = "",
    prefix  = "",
  },
})

-- ================================================================
-- SERVER LIST
-- All servers set up with default on_attach + capabilities.
-- Add name here → mason auto-installs it.
-- ================================================================
local servers = {
  -- Web
  "html", "cssls", "ts_ls", "eslint",

  -- Lua (Neovim)
  "lua_ls",

  -- Python
  "pyright",

  -- Rust
  "rust_analyzer",

  -- Shell
  "bashls",

  -- Config
  "dockerls", "yamlls",

  -- Markdown
  "marksman",
}

-- Define default config for all servers
for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    on_attach    = on_attach,
    capabilities = capabilities,
  })
end

-- ================================================================
-- PER-SERVER OVERRIDES
-- ================================================================

-- lua_ls: teach it about Neovim's vim global
vim.lsp.config("lua_ls", {
  on_attach    = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime   = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
        },
      },
      diagnostics = { globals = { "vim" } },
      telemetry   = { enable = false },
    },
  },
})

-- pyright: strict type checking
vim.lsp.config("pyright", {
  on_attach    = on_attach,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = { typeCheckingMode = "basic" },
    },
  },
})

-- Enable configured servers
for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end
```

---

## On_Attach Keymap Summary

| Key          | Action                        |
|--------------|-------------------------------|
| `gd`         | Go to definition              |
| `gD`         | Go to declaration             |
| `gi`         | Go to implementation          |
| `gt`         | Go to type definition         |
| `gr`         | References (Telescope)        |
| `K`          | Hover documentation           |
| `<C-k>`      | Signature help                |
| `<leader>ca` | Code action                   |
| `<leader>rn` | Rename symbol                 |
| `<leader>lf` | Format buffer (LSP)           |
| `<leader>wa` | Add workspace folder          |
| `<leader>wl` | List workspace folders        |

---

## Cursor Instructions

- `on_attach` is a **buffer-local** function — all keymaps inside it use `buffer = bufnr`
- `capabilities` must be extended with `cmp_nvim_lsp.default_capabilities()` **before** any
  `vim.lsp.config(server, opts)` call — otherwise completion won't receive LSP completions
- Setting `client.server_capabilities.semanticTokensProvider = nil` disables semantic tokens;
  treesitter provides better consistent highlights
- Per-server overrides come **after** the default loop — `vim.lsp.config("lua_ls", ...)` overrides defaults
- Add each new server to the `servers` table, then enable via `vim.lsp.enable(server)`

---

## Lua Diagnostics Notes

- `lua_ls` is configured with `diagnostics.globals = { "vim" }` inside `lspconfig.lua`.
- Workspace-level tooling also knows about `vim` via `.luarc.json` (Lua language server) and
  `.luacheckrc` (luacheck), so "Undefined global vim" warnings stay quiet in config files.
