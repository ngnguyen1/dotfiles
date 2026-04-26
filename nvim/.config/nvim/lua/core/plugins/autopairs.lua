---@module 'lazy'
---@type LazySpec
return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      check_ts = true,

      disable_filetype = {
        'TelescopePrompt',
        'spectre_panel',
      },

      fast_wrap = {
        map = '<M-e>',
      },
    },

    config = function(_, opts)
      local npairs = require 'nvim-autopairs'
      npairs.setup(opts)
    end,
  },
}
