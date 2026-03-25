-- lua/core/config.lua
-- User preferences. Read by: highlights.lua, ui/*.lua, configs/*.lua
-- Change things here -- don't touch the modules directly.

---@class UserConfig
local M = {}

-- ================================================================
-- THEME
-- ================================================================
M.theme = {
  name = "tokyonight", -- theme file: lua/themes/<name>.lua
  toggle_dark = "onedark", -- <leader>tt cycles between these two
  toggle_light = "tokyonight",
  transparency = true, -- true = transparent background (needs compositor)
}

-- ================================================================
-- STATUSLINE
-- ================================================================
M.statusline = {
  -- "default" | "minimal" | "block" | "arrow"
  style = "default",
  -- separator characters between modules
  -- default: slant-style (NvChad-inspired)
  -- round  : curved separators
  -- block  : no separators, just spaces
  separator = "slant",
  -- which modules to show, in order
  order = {
    "mode",
    "file",
    "git",
    "diagnostics",
    "%=", -- right-align everything after this
    "lsp_name",
    "filetype",
    "cursor",
  },
}

-- ================================================================
-- LSP DIAGNOSTIC ICONS
-- ================================================================
M.lsp = {
  icons = {
    Error = " ",
    Warn = " ",
    Hint = "󰠠 ",
    Info = " ",
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
  border = "rounded", -- "none" | "single" | "double" | "rounded" | "solid"
}

-- ================================================================
-- ICONS
-- ================================================================
M.icons = {
  -- Override any icon from lua/core/icons.lua here
  -- git = { added = "" }
}

return M
