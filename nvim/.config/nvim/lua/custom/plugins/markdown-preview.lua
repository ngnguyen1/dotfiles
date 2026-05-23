---@module 'lazy'
---@type LazySpec
return {
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function() vim.fn['mkdp#util#install']() end,
    keys = {
      { '<leader>mp', '<cmd>MarkdownPreview<CR>', desc = 'Markdown [P]review open', ft = 'markdown' },
      { '<leader>ms', '<cmd>MarkdownPreviewStop<CR>', desc = 'Markdown preview [S]top', ft = 'markdown' },
      { '<leader>mt', '<cmd>MarkdownPreviewToggle<CR>', desc = 'Markdown preview [T]oggle', ft = 'markdown' },
    },
    init = function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_theme = 'dark'
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
