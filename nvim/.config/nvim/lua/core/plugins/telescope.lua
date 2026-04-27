---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    keys = {
      {
        '<leader>ff',
        function() require('telescope.builtin').find_files() end,
        desc = '[F]ile [F]ind',
      },
      {
        '<leader>fr',
        function() require('telescope.builtin').oldfiles() end,
        desc = '[F]ile [R]ecent',
      },
      {
        '<leader>fg',
        function() require('telescope.builtin').live_grep() end,
        desc = '[F]ile [G]rep',
      },
      {
        '<leader>fb',
        function() require('telescope.builtin').buffers() end,
        desc = '[F]ile [B]uffers',
      },
      {
        '<leader>fd',
        function()
          require('telescope.builtin').find_files {
            cwd = vim.fn.expand '~/personal/dotfiles',
            prompt_title = 'Dotfiles',
          }
        end,
        desc = '[F]ile [D]otfiles',
      },
      {
        '<leader><leader>',
        function() require('telescope.builtin').buffers() end,
        desc = 'Find Buffers',
      },
    },

    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },

    opts = function()
      local actions = require 'telescope.actions'

      return {
        defaults = {
          mappings = {
            i = {
              ['<esc>'] = actions.close,
            },
          },
        },

        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
    end,

    config = function(_, opts)
      local telescope = require 'telescope'

      telescope.setup(opts)

      -- load extensions safely
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')
    end,
  },
}
