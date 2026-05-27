---@module 'lazy'
---@type LazySpec
return {
  {
    dir = vim.fn.stdpath('config') .. '/lua/custom/themes/one-dark-islands',
    name = 'one-dark-islands',
    lazy = false,
    priority = 1000,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('core.theme').apply()
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
