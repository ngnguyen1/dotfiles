# Spec: Plugin Registry — All lazy.nvim Specs

> Every plugin split by domain file. All files live in lua/plugins/.

---

## `lua/plugins/init.lua` — Core Plugins

```lua
-- lua/plugins/init.lua
return {

  -- ── ICONS ──────────────────────────────────────────────────────
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,   -- loaded on demand by statusline and nvim-tree
  },

  -- ── AUTOPAIRS ──────────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts  = {
      fast_wrap       = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
  },

  -- ── INDENT GUIDES ──────────────────────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    event  = { "BufReadPost", "BufNewFile" },
    main   = "ibl",
    config = function()
      require("core.highlights").load_integration("blankline")
      require("ibl").setup({
        indent = { char = "│", highlight = "IblIndent" },
        scope  = { highlight = "IblScope" },
      })
    end,
  },

  -- ── WHICH-KEY ──────────────────────────────────────────────────
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts  = {
      preset = "helix",
      delay  = 500,
      win    = { border = require("core.config").ui.border },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      -- Group labels
      wk.add({
        { "<leader>f",  group = "Find" },
        { "<leader>l",  group = "LSP" },
        { "<leader>g",  group = "Git" },
        { "<leader>d",  group = "Diagnostics" },
        { "<leader>s",  group = "Splits" },
        { "<leader>t",  group = "Terminal" },
        { "<leader>b",  group = "Buffers" },
        { "<leader>u",  group = "UI / Theme" },
      })
    end,
  },

  -- ── GIT SIGNS ──────────────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    event  = { "BufReadPost", "BufNewFile" },
    config = function()
      require("core.highlights").load_integration("gitsigns")
      require("configs.gitsigns")
    end,
  },

  -- ── COMMENT ────────────────────────────────────────────────────
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n",          desc = "Toggle comment line" },
      { "gc",  mode = { "n", "v" }, desc = "Toggle comment" },
    },
    opts = {},
  },

  -- ── SURROUND ───────────────────────────────────────────────────
  {
    "kylechui/nvim-surround",
    version = "*",
    event   = "VeryLazy",
    opts    = {},
  },

  -- ── ILLUMINATE (highlight word under cursor) ───────────────────
  {
    "RRethy/vim-illuminate",
    event  = { "BufReadPost", "BufNewFile" },
    config = function()
      require("illuminate").configure({
        delay          = 200,
        large_file_cutoff = 2000,
        providers      = { "lsp", "treesitter", "regex" },
      })
    end,
  },
}
```

---

## `lua/plugins/ui.lua` — File Explorer + Telescope

```lua
-- lua/plugins/ui.lua
return {

  -- ── FILE EXPLORER ──────────────────────────────────────────────
  {
    "nvim-tree/nvim-tree.lua",
    cmd  = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    config = function()
      require("core.highlights").load_integration("nvimtree")
      require("configs.nvimtree")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
      },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    cmd  = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>",               desc = "Find Files" },
      { "<leader>fw", "<cmd>Telescope live_grep<cr>",                desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",                  desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",                desc = "Help Tags" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>",                 desc = "Recent Files" },
      { "<leader>fm", "<cmd>Telescope marks<cr>",                    desc = "Marks" },
      { "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>",desc = "Fuzzy in Buffer" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>",                  desc = "Keymaps" },
      { "<leader>fc", "<cmd>Telescope commands<cr>",                 desc = "Commands" },
    },
    config = function()
      require("core.highlights").load_integration("telescope")
      require("configs.telescope")
    end,
  },

  -- ── TODO COMMENTS ──────────────────────────────────────────────
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event  = { "BufReadPost", "BufNewFile" },
    opts   = { signs = false },
    keys   = {
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
    },
  },

  -- ── TROUBLE (diagnostics list) ─────────────────────────────────
  {
    "folke/trouble.nvim",
    cmd  = { "Trouble", "TroubleToggle" },
    keys = {
      { "<leader>dt", "<cmd>Trouble diagnostics toggle<cr>",  desc = "Trouble Diagnostics" },
      { "<leader>ds", "<cmd>Trouble symbols toggle<cr>",      desc = "Trouble Symbols" },
    },
    opts = { use_diagnostic_signs = true },
  },
}
```

---

## `lua/configs/nvimtree.lua`

```lua
-- lua/configs/nvimtree.lua
-- Two key goals handled here:
--   1. Transparent background  → renderer uses highlight groups set in
--      core/integrations/nvimtree.lua (all bg = "NONE")
--   2. Statusline always visible → disable_netrw + do NOT set
--      vim.wo.statusline = "" (that is NvimTree's default behavior which we
--      override via the autocmd in ui/statusline.lua setup())

require("nvim-tree").setup({

  -- ── DISABLE NETRW (required by nvim-tree docs) ─────────────────
  -- Also set these in init.lua BEFORE lazy loads:
  --   vim.g.loaded_netrw       = 1
  --   vim.g.loaded_netrwPlugin = 1
  hijack_netrw           = true,
  disable_netrw          = true,

  -- ── DO NOT TOUCH THE STATUSLINE ────────────────────────────────
  -- NvimTree normally hides the statusline in its window by setting
  -- vim.wo.statusline = "". We block that here and let our autocmd
  -- in ui/statusline.lua restore the global expr instead.
  -- NOTE: this option was removed in newer nvim-tree versions.
  -- The autocmd approach in ui/statusline.lua is the reliable fallback.

  -- ── APPEARANCE ─────────────────────────────────────────────────
  renderer = {
    -- Transparent bg comes from highlight groups, not this option,
    -- but root_folder_label keeps the path visible without a filled bg.
    root_folder_label     = ":~:s?$?/..?",
    highlight_git         = true,    -- color filenames by git status
    highlight_opened_files= "name",  -- bold the currently open file
    add_trailing          = false,   -- no trailing / on directories
    group_empty           = true,    -- collapse single-child dirs

    indent_markers = {
      enable  = true,
      icons   = { corner = "└", edge = "│", item = "│", none = " " },
    },

    icons = {
      glyphs = {
        default  = "󰈚",
        symlink  = "",
        folder   = {
          default      = "",
          open         = "",
          empty        = "",
          empty_open   = "",
          symlink      = "",
          symlink_open = "",
          arrow_open   = "",
          arrow_closed = "",
        },
        git = {
          unstaged  = "✗",
          staged    = "✓",
          unmerged  = "",
          renamed   = "➜",
          untracked = "★",
          deleted   = "",
          ignored   = "◌",
        },
      },
    },
  },

  -- ── WINDOW ─────────────────────────────────────────────────────
  view = {
    width           = 30,
    side            = "left",
    preserve_window_proportions = true,
    -- IMPORTANT: do not set signcolumn or statuscolumn here —
    -- leave them at defaults so the window inherits global settings.
  },

  -- ── BEHAVIOR ───────────────────────────────────────────────────
  actions = {
    open_file = {
      quit_on_open  = false,
      resize_window = true,
    },
  },

  update_focused_file = {
    enable      = true,   -- auto-reveal current file in tree
    update_root = false,
  },

  git = {
    enable  = true,
    ignore  = false,   -- show gitignored files (dimmed)
    timeout = 400,
  },

  filters = {
    dotfiles = false,   -- show dotfiles
    custom   = { "^.git$", "node_modules", ".cache" },
  },

  -- ── DIAGNOSTICS IN TREE ─────────────────────────────────────────
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      error   = " ",
      warning = " ",
      hint    = "󰠠 ",
      info    = " ",
    },
  },
})
```

> **Transparency note for Cursor:** The transparent background is achieved
> entirely through highlight groups in `core/integrations/nvimtree.lua`.
> There is no `transparent` option in nvim-tree itself. Every `NvimTree*`
> group that would normally carry a background must have `bg = "NONE"`.
> The most critical ones are `NvimTreeNormal`, `NvimTreeNormalNC`, and
> `NvimTreeEndOfBuffer`.

---

```lua
-- lua/plugins/lsp.lua
return {

  -- ── MASON ──────────────────────────────────────────────────────
  {
    "williamboman/mason.nvim",
    -- lazy=false so :MasonInstall works immediately without opening a file
    lazy  = false,
    config = function()
      require("core.highlights").load_integration("mason")
      require("mason").setup({
        ui = {
          border = require("core.config").ui.border,
          icons  = {
            package_installed   = "✓",
            package_pending     = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- ── MASON TOOL INSTALLER ───────────────────────────────────────
  -- Declaratively installs ALL tools (LSP servers + formatters + linters)
  -- in one place. Run :MasonToolsInstall after changing this list.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy         = false,
    dependencies = "williamboman/mason.nvim",
    config       = function()
      require("mason-tool-installer").setup({
        -- All tools are declared here. This is the single source of truth.
        -- LSP servers, formatters, and linters are all listed together.
        ensure_installed = {
          -- ── LSP SERVERS ────────────────────────────────────────
          "lua-language-server",          -- lua_ls
          "html-lsp",                     -- html
          "css-lsp",                      -- cssls
          "typescript-language-server",   -- ts_ls
          "eslint-lsp",                   -- eslint
          "pyright",                      -- pyright
          "rust-analyzer",                -- rust_analyzer
          "bash-language-server",         -- bashls
          "dockerfile-language-server",   -- dockerls
          "yaml-language-server",         -- yamlls
          "marksman",                     -- marksman (markdown)

          -- ── FORMATTERS ─────────────────────────────────────────
          "stylua",           -- Lua
          "prettier",         -- JS/TS/HTML/CSS/JSON/YAML/Markdown
          "black",            -- Python
          "isort",            -- Python imports
          "rustfmt",          -- Rust (usually ships with rust-analyzer)
          "shfmt",            -- Shell

          -- ── LINTERS ────────────────────────────────────────────
          "eslint_d",         -- JS/TS (daemon, much faster than eslint)
          "ruff",             -- Python (replaces flake8/pylint)
          "shellcheck",       -- Shell
          "markdownlint",     -- Markdown
        },

        -- Automatically install/update on Neovim startup
        auto_update = false,
        run_on_start = true,
        start_delay  = 3000,   -- ms delay before installing (let UI settle)
      })
    end,
  },

  -- ── MASON-LSPCONFIG ────────────────────────────────────────────
  -- Bridges mason package names → lspconfig server names
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "williamboman/mason.nvim",
    event        = { "BufReadPre", "BufNewFile" },
    opts         = {
      -- Do NOT put servers here — use mason-tool-installer above instead.
      -- This just enables auto-configuration of installed servers.
      automatic_installation = false,
    },
  },

  -- ── LSPCONFIG ──────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    event        = { "BufReadPre", "BufNewFile" },
    config       = function()
      require("configs.lspconfig")
    end,
  },

  -- ── FIDGET (LSP progress spinner) ─────────────────────────────
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts  = {
      notification = { window = { winblend = 0 } },
    },
  },
}
```

---

## Mason Tool Management — Quick Reference

| Task                        | Command                          |
| --------------------------- | -------------------------------- |
| Open Mason UI               | `:Mason`                         |
| Install all tools from spec | `:MasonToolsInstall`             |
| Update all installed tools  | `:MasonToolsUpdate`              |
| Check what's installed      | `:Mason` → browse list           |
| Install one tool manually   | `:MasonInstall <package-name>`   |
| Uninstall a tool            | `:MasonUninstall <package-name>` |

> **Single source of truth:** add/remove tools only in the `ensure_installed` list
> inside `mason-tool-installer`. Never scatter `:MasonInstall` calls elsewhere.

---

## `lua/plugins/completion.lua`

```lua
-- lua/plugins/completion.lua
return {

  {
    "L3MON4D3/LuaSnip",
    lazy         = true,
    dependencies = "rafamadriz/friendly-snippets",
    build        = (vim.uv.os_uname().sysname ~= "Windows_NT")
                   and "make install_jsregexp" or nil,
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event        = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "onsails/lspkind.nvim",   -- VSCode-style pictograms
    },
    config = function()
      require("core.highlights").load_integration("cmp")
      require("configs.cmp")
    end,
  },
}
```

---

## `lua/plugins/treesitter.lua`

```lua
-- lua/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build  = ":TSUpdate",
    event  = { "BufReadPost", "BufNewFile" },
    config = function()
      require("core.highlights").load_integration("treesitter")
      require("configs.treesitter")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event        = { "BufReadPost", "BufNewFile" },
    opts         = { max_lines = 3 },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event        = { "BufReadPost", "BufNewFile" },
  },
}
```

---

## `lua/plugins/formatting.lua`

```lua
-- lua/plugins/formatting.lua
return {
  {
    "stevearc/conform.nvim",
    event  = "BufWritePre",
    config = function() require("configs.conform") end,
  },
  {
    "mfussenegger/nvim-lint",
    event  = { "BufReadPost", "BufNewFile" },
    config = function() require("configs.lint") end,
  },
}
```

---

## `lua/plugins/git.lua`

```lua
-- lua/plugins/git.lua
return {
  {
    "kdheepak/lazygit.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd  = { "LazyGit", "LazyGitCurrentFile" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>",            desc = "LazyGit" },
      { "<leader>gf", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit file" },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd  = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>",         desc = "DiffView" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
    },
  },
}
```

---

## Lazy-Loading Trigger Summary

| Trigger               | When it fires                         | Best for                     |
| --------------------- | ------------------------------------- | ---------------------------- |
| `lazy=false`          | Startup, always                       | Nothing (avoid if possible)  |
| `event="BufReadPost"` | After reading any file                | LSP, treesitter, gitsigns    |
| `event="InsertEnter"` | Entering insert mode                  | Completion, autopairs        |
| `event="VeryLazy"`    | After UI renders, idle                | which-key, non-critical      |
| `cmd="X"`             | When `:X` is run for the first time   | nvim-tree, Mason, LazyGit    |
| `keys={...}`          | On the first keypress                 | Telescope, surround, comment |
| `ft={"lua"}`          | When a matching filetype buffer opens | Language-specific tools      |
