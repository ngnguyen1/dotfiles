-- lua/plugins/completion.lua
return {
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    dependencies = "rafamadriz/friendly-snippets",
    build = (vim.uv.os_uname().sysname ~= "Windows_NT") and "make install_jsregexp" or nil,
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "onsails/lspkind.nvim",
    },
    config = function()
      require("core.highlights").load_integration("cmp")
      require("configs.cmp")
    end,
  },
}
