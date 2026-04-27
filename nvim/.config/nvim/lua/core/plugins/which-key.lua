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
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>e', group = '[E]xplorer' },
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
      },
    },
  },
}
