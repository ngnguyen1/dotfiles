-- lua/plugins/lsp.lua
return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("core.highlights").load_integration("mason")
      require("mason").setup({
        ui = {
          border = require("core.config").ui.border,
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    dependencies = "williamboman/mason.nvim",
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "lua-language-server",
          "html-lsp",
          "css-lsp",
          "typescript-language-server",
          "eslint-lsp",
          "pyright",
          "rust-analyzer",
          "bash-language-server",
          "dockerfile-language-server",
          "yaml-language-server",
          "marksman",
          "stylua",
          "prettier",
          "black",
          "isort",
          "rustfmt",
          "shfmt",
          "eslint_d",
          "ruff",
          "shellcheck",
          "markdownlint",
        },
        auto_update = false,
        run_on_start = true,
        start_delay = 3000,
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "williamboman/mason.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      automatic_installation = false,
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("configs.lspconfig")
    end,
  },

  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = { window = { winblend = 0 } },
    },
  },
}
