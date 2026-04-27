-- [[ configure and install plugins ]]
-- To update plugins you can run:
-- :Lazy update

require('lazy').setup({
  -- NOTE: Plugins can be added via a link or github org/name.
  -- To run setup automatically, use `opts = {}`
  { 'NMAC427/guess-indent.nvim', opts = {} },
  require 'core.plugins.colorscheme',
  require 'core.plugins.lsp',
  require 'core.plugins.nvim-tree',
  require 'core.plugins.conform',
  require 'core.plugins.telescope',
  require 'core.plugins.treesitter',
  require 'core.plugins.autopairs',
  require 'core.plugins.surround',
  require 'core.plugins.git',
  require 'core.plugins.lualine',
  require 'core.plugins.which-key',
  require 'core.plugins.ibl',

  -- Custom plugins
  require 'custom.plugins.blink-cmp',
}, { ---@diagnostic disable-line: missing-fields
  -- disable auto update check
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
