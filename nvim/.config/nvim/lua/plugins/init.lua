-- lua/plugins/init.lua
return {
  -- -- ICONS ------------------------------------------------------
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- -- AUTOPAIRS --------------------------------------------------
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
  },

  -- -- INDENT GUIDES ----------------------------------------------
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    config = function()
      require("core.highlights").load_integration("blankline")
      require("ibl").setup({
        indent = { char = "│", highlight = "IblIndent" },
        scope = { highlight = "IblScope" },
      })
    end,
  },

  -- -- WHICH-KEY --------------------------------------------------
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 500,
      win = { border = require("core.config").ui.border },
    },
    config = function(_, opts)
      require("core.highlights").load_integration("whichkey")
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        { "<leader>f", group = "Find" },
        { "<leader>l", group = "LSP" },
        { "<leader>g", group = "Git" },
        { "<leader>d", group = "Diagnostics" },
        { "<leader>s", group = "Splits" },
        { "<leader>t", group = "Terminal" },
        { "<leader>b", group = "Buffers" },
        { "<leader>u", group = "UI / Theme" },
      })
    end,
  },

  -- -- COMMENT ----------------------------------------------------
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Toggle comment line" },
      { "gc", mode = { "n", "v" }, desc = "Toggle comment" },
    },
    opts = {},
  },

  -- -- SURROUND ---------------------------------------------------
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- -- ILLUMINATE -------------------------------------------------
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("illuminate").configure({
        delay = 200,
        large_file_cutoff = 2000,
        providers = { "lsp", "treesitter", "regex" },
      })
    end,
  },
}
