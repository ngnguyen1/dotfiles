---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-treesitter/nvim-treesitter',

    lazy = false,
    build = ':TSUpdate',
    -- branch = 'main',

    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
      },
    },

    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
      },

      auto_install = true,

      highlight = {
        enable = true,
      },

      indent = {
        enable = true,
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<CR>',
          node_incremental = '<CR>',
          scope_incremental = false,
          node_decremental = '<BS>',
        },
      },

      textobjects = {
        select = {
          enable = true,
          lookahead = true,

          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',

            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',

            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
          },
        },

        move = {
          enable = true,
          set_jumps = true,

          goto_next_start = {
            [']f'] = '@function.outer',
            [']c'] = '@class.outer',
          },

          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[c'] = '@class.outer',
          },
        },

        swap = {
          enable = true,

          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },

          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      },
    },

    config = function(_, opts) require('nvim-treesitter').setup(opts) end,
  },
}
