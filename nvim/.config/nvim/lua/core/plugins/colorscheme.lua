---@module 'lazy'
---@type LazySpec
return {
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
