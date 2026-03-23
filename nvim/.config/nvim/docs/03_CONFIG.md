# Spec: lua/core/config.lua — User Control Panel
> The single file a user edits to personalize everything.
> Inspired by NvChad's chadrc.lua concept — one table, all preferences.

---

## Design Goal

`core/config.lua` is the **only file a user needs to touch** for:
- Switching themes
- Changing statusline style
- Dashboard content
- LSP diagnostic icons
- Transparency
- UI borders

Every other module (`highlights.lua`, `statusline.lua`, etc.) reads from this table.

---

## Complete `lua/core/config.lua`

```lua
-- lua/core/config.lua
-- User preferences. Read by: highlights.lua, ui/*.lua, configs/*.lua
-- Change things here — don't touch the modules directly.

---@class UserConfig
local M = {}

-- ================================================================
-- THEME
-- ================================================================
M.theme = {
  name         = "onedark",       -- theme file: lua/themes/<name>.lua
  toggle_dark  = "onedark",       -- <leader>tt cycles between these two
  toggle_light = "one_light",
  transparency = false,           -- true = transparent background (needs compositor)
}

-- ================================================================
-- STATUSLINE
-- ================================================================
M.statusline = {
  -- "default" | "minimal" | "block" | "arrow"
  style     = "default",
  -- separator characters between modules
  -- default: slant-style (NvChad-inspired)
  -- round  : curved separators
  -- block  : no separators, just spaces
  separator = "slant",
  -- which modules to show, in order
  order = {
    "mode", "file", "git", "diagnostics",
    "%=",                               -- right-align everything after this
    "lsp_name", "filetype", "fileprogress", "cursor",
  },
}

-- ================================================================
-- DASHBOARD
-- ================================================================
M.dashboard = {
  enabled = true,

  -- Legacy static header (runtime dashboard now renders dynamic cowsay quotes)
  header = {
    "",
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "",
  },

  -- { icon, label, key shortcut, vim command }
  buttons = {
    { "󰱼", "Find Files",   "ff", "Telescope find_files" },
    { "󱋡", "Recent Files", "fo", "Telescope oldfiles" },
    { "󰱽", "Find Word",    "fw", "Telescope live_grep" },
    { "󰃀", "Bookmarks",    "bm", "Telescope marks" },
    { "󰔎", "Themes",       "tt", "lua require('core.highlights').pick_theme()" },
    { "󱁤", "Config",       "nc", "e $MYVIMRC" },
  },
}

-- ================================================================
-- LSP DIAGNOSTIC ICONS
-- ================================================================
M.lsp = {
  icons = {
    Error = " ",
    Warn  = " ",
    Hint  = "󰠠 ",
    Info  = " ",
  },
  -- Show virtual text diagnostics inline
  virtual_text = true,
  -- Show diagnostics in float on CursorHold
  float_on_hold = true,
}

-- ================================================================
-- UI BORDERS
-- ================================================================
-- Applied to: LSP hover, signature, mason, lazy, telescope
M.ui = {
  border = "rounded",   -- "none" | "single" | "double" | "rounded" | "solid"
}

-- ================================================================
-- ICONS
-- ================================================================
M.icons = {
  -- Override any icon from lua/core/icons.lua here
  -- git = { added = "" }
}

return M
```

---

## How Other Modules Read This

```lua
-- In any module:
local config = require("core.config")

-- Example: highlights.lua
local theme_name = config.theme.name      -- "onedark"

-- Example: statusline.lua
local style = config.statusline.style     -- "default"

-- Example: lspconfig.lua
local icons = config.lsp.icons            -- { Error = " ", ... }
```

---

## Theme Toggle Flow

```
User presses <leader>tt
  → core/highlights.lua reads config.theme.toggle_dark / toggle_light
  → determines which theme to switch to
  → updates config.theme.name in memory
  → recompiles all highlight groups
  → re-applies via vim.api.nvim_set_hl()
  → statusline re-render on next redraw
```

---

## Cursor Instructions

- This file is the **user-facing API** — keep it simple, no complex Lua logic here
- Every option must have a comment explaining valid values
- Other modules read this with `require("core.config")` — never pass config as arguments
- Do not call `vim.opt` or `vim.keymap.set` from this file — it is a pure data table
