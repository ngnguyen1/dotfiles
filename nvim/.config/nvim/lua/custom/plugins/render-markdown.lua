---@module 'lazy'
---@type LazySpec
return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    keys = {
      { '<leader>mt', '<cmd>RenderMarkdown toggle<CR>', desc = 'Markdown render [T]oggle', ft = 'markdown' },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
