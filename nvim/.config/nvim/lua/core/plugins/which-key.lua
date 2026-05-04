---@module 'lazy'
---@type LazySpec
return {
  {
    'folke/which-key.nvim',
    event = 'VimEnter',

    ---@module 'which-key'
    ---@type wk.Opts
    opts = {
      delay = 0,

      icons = {
        mappings = vim.g.have_nerd_font,
      },

      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'v' } },
        { '<leader>f', group = '[F]ile' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>g', group = '[G]it' },
        { '<leader>gh', group = '[G]it [h]unk', mode = { 'n', 'v' } },
        { '<leader>gd', group = '[G]it [d]iff', mode = { 'n' } },
        { '<leader>e', group = '[E]xplorer' },
        { '<leader>w', group = '[W]indow' },
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
      },
    },
  },
}
