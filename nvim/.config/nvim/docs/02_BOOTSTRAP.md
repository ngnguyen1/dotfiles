# Spec: Bootstrap — init.lua

> Entry point. Sets up leaders, loads options, bootstraps lazy.nvim.

---

## Complete `init.lua`

```lua
-- ================================================================
-- LEADERS — must be set before lazy.nvim loads any plugin
-- ================================================================
vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

-- Disable netrw BEFORE lazy loads nvim-tree (required by nvim-tree docs)
vim.g.loaded_netrw       = 1
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
  local out  = vim.fn.system({
    "git", "clone",
    "--filter=blob:none",
    "--branch=stable",
    repo, lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit...",   "" },
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
    -- All lua/plugins/*.lua files are auto-discovered and merged
    { import = "plugins" },
  },

  defaults = {
    lazy    = true,    -- lazy-load everything unless marked lazy=false
    version = false,   -- always use latest git commit, not semver tags
  },

  install = {
    -- Try to apply our own theme during install screen
    colorscheme = { "habamax" },  -- fallback until our theme system is ready
  },

  checker = {
    enabled = true,   -- check for updates in background
    notify  = false,  -- silent — don't pop notifications
  },

  change_detection = {
    notify = false,   -- don't notify when config files change
  },

  performance = {
    rtp = {
      -- Disable built-in plugins we don't need
      disabled_plugins = {
        "gzip",
        "matchit",       -- use nvim-matchup if needed
        "netrwPlugin",   -- replaced by nvim-tree
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },

  ui = {
    border = "rounded",
    title  = " lazy.nvim ",
    icons  = {
      ft          = "",
      lazy        = "󰂠 ",
      loaded      = "",
      not_loaded  = "",
    },
  },
})

-- ================================================================
-- POST-PLUGIN SETUP (runs after all plugins are loaded)
-- ================================================================
require("core.autocmds")
require("core.mappings")
require("core.highlights")   -- compile theme → apply highlights

-- Mount hand-rolled UI modules
require("ui.statusline").setup()

-- Show dashboard on startup (no file arg)
if vim.fn.argc(-1) == 0 then
  require("ui.dashboard").open()
end
```

---

## lazy.nvim Field Reference

| Field          | Type      | Description                                                               |
| -------------- | --------- | ------------------------------------------------------------------------- |
| `[1]`          | string    | `"author/repo"` — plugin URL (GitHub shorthand)                           |
| `lazy`         | bool      | Defer loading? `true` by default via `defaults.lazy`                      |
| `event`        | string[]  | Load on Neovim event (e.g. `"BufReadPost"`)                               |
| `cmd`          | string[]  | Load when this Ex command is first called                                 |
| `ft`           | string[]  | Load only for these filetypes                                             |
| `keys`         | table[]   | Load on keypress; simultaneously registers the keymap                     |
| `dependencies` | string[]  | Plugins that must load first                                              |
| `opts`         | table     | Passed directly to `plugin.setup(opts)` — use when no custom logic needed |
| `config`       | function  | Full setup function — use when `opts` isn't enough                        |
| `init`         | function  | Always runs at startup, regardless of lazy status                         |
| `build`        | string/fn | Shell command or function run after install/update                        |
| `enabled`      | bool/fn   | Set to `false` to completely disable a plugin                             |
| `priority`     | number    | Higher loads earlier. Use `1000` for colorschemes.                        |
| `version`      | string    | Pin to a semver tag (e.g. `"*"` = latest tag)                             |

---

## First-Run Instructions for Cursor

After generating all files:

1. Open Neovim: `nvim`
2. lazy.nvim bootstraps + all plugins install automatically
3. Restart Neovim
4. Run `:MasonInstall <servers>` for LSP servers
5. Run `:TSInstall all` for treesitter parsers
6. `:checkhealth` should show no critical errors
