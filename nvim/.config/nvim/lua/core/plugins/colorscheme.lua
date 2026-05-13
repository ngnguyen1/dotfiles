---@module 'lazy'
---@type LazySpec
return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      local handle = io.popen('defaults read -g AppleInterfaceStyle 2>/dev/null', 'r')
      local out = ''
      if handle then
        out = handle:read('*a') or ''
        handle:close()
      end
      local flavour = out:match('Dark') and 'mocha' or 'latte'
      if flavour == 'mocha' then
        vim.o.background = 'dark'
      else
        vim.o.background = 'light'
      end

      ---@diagnostic disable-next-line: missing-fields
      require('catppuccin').setup {
        flavour = flavour,
        transparent_background = false,
        no_italic = true,
        integrations = {
          treesitter = true,
          native_lsp = { enabled = true },
          telescope = true,
          gitsigns = true,
          nvimtree = true,
          which_key = true,
          indent_blankline = { enabled = true },
        },
      }
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
