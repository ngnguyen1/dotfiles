-- ================================================================
-- LEADERS — must be set before lazy.nvim loads any plugin
-- ================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
require("core.compat")
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ================================================================
-- OPTIONS — load before plugins (affects plugin behavior)
-- ================================================================
require("core.options")

-- ================================================================
-- BOOTSTRAP lazy.nvim
-- ================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    repo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit...", "" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

-- ================================================================
-- LAZY SETUP
-- ================================================================
require("lazy").setup({
  spec = {
    -- Import lua/plugins/*.lua files
    { import = "plugins" },
  },

  defaults = {
    lazy = true,
    version = false,
  },

  install = {
    colorscheme = { "habamax" },
  },

  checker = {
    enabled = true,
    notify = false,
  },

  change_detection = {
    notify = false,
  },

  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },

  ui = {
    border = "rounded",
    title = " lazy.nvim ",
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },
})

-- ================================================================
-- POST-PLUGIN SETUP
-- ================================================================
require("core.autocmds")
require("core.mappings")
require("core.highlights").setup()

require("ui.statusline").setup()
