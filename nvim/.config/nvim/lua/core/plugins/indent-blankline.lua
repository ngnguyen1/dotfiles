---@module 'lazy'
---@type LazySpec
return {
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = 'BufReadPre',
    opts = {
      indent = {
        char = '│',
        tab_char = '│',
      },

      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },

      exclude = {
        filetypes = {
          'help',
          'dashboard',
          'NvimTree',
          'Trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
          '',
        },
      },
    },
  },
}
