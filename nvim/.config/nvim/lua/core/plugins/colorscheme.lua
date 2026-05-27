---@module 'lazy'
---@type LazySpec
return {
  {
    -- Local dev path. To publish: replace with `'your-name/islands-dark.nvim'`
    -- and delete the `dir` key.
    dir = vim.fn.stdpath('config') .. '/islands-dark.nvim',
    name = 'islands-dark',
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
      italic_comments = true,
      -- on_colors = function(c) end,
      -- on_highlights = function(hl, c) end,
    },
    config = function(_, opts)
      require('islands-dark').setup(opts)
    end,
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
