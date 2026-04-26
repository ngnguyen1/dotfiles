---@module 'lazy'
---@type LazySpec
return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      {
        'mason-org/mason.nvim',
        cmd = 'Mason',
        opts = {},
      },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      require('core.lsp').setup()
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
