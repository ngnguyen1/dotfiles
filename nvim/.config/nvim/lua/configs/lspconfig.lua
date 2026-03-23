-- lua/configs/lspconfig.lua

local capabilities = vim.lsp.protocol.make_client_capabilities()

local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

capabilities.workspace = capabilities.workspace or {}
capabilities.workspace.didChangeWatchedFiles = capabilities.workspace.didChangeWatchedFiles or {}
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

local on_attach = function(client, bufnr)
  local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, {
      buffer = bufnr,
      desc = "LSP: " .. desc,
      silent = true,
      noremap = true,
    })
  end

  map("gd", vim.lsp.buf.definition, "Go to Definition")
  map("gD", vim.lsp.buf.declaration, "Go to Declaration")
  map("gi", vim.lsp.buf.implementation, "Go to Implementation")
  map("gt", vim.lsp.buf.type_definition, "Go to Type Definition")
  map("gr", "<cmd>Telescope lsp_references<cr>", "References")

  map("K", vim.lsp.buf.hover, "Hover Docs")
  map("<C-k>", vim.lsp.buf.signature_help, "Signature Help")

  map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
  map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")

  map("<leader>wa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder")
  map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
  map("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "List Workspace Folders")

  map("<leader>lf", function()
    vim.lsp.buf.format({ async = true })
  end, "Format Buffer")

  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup("LspDocumentHighlight_" .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      group = group,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = bufnr,
      group = group,
      callback = vim.lsp.buf.clear_references,
    })
  end

  client.server_capabilities.semanticTokensProvider = nil
end

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
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = require("core.config").ui.border,
    source = "always",
    header = "",
    prefix = "",
  },
})

local servers = {
  "html",
  "cssls",
  "ts_ls",
  "eslint",
  "lua_ls",
  "pyright",
  "rust_analyzer",
  "bashls",
  "dockerls",
  "yamlls",
  "marksman",
}

for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

vim.lsp.config("lua_ls", {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
        },
      },
      diagnostics = { globals = { "vim" } },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config("pyright", {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = { typeCheckingMode = "basic" },
    },
  },
})

for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end
