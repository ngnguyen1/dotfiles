-- islands-dark.nvim : extras/wezterm.lua
--
-- WezTerm color-scheme export, generated from the exact bwya77 palette
-- (themes/islands-dark.json). All 16 ANSI slots are pulled straight from
-- the `terminal.ansi*` keys in that JSON.
--
-- Usage A — drop the generated TOML into ~/.config/wezterm/colors/:
--   require("islands-dark.extras.wezterm").write_toml(
--     os.getenv("HOME") .. "/.config/wezterm/colors/islands-dark.toml")
-- Usage B — live table inside wezterm.lua:
--   local id = require("islands-dark.extras.wezterm")
--   config.color_schemes = { ["Islands Dark"] = id.scheme }
--   config.color_scheme  = "Islands Dark"

local M = {}

-- Palette mirror (self-contained so WezTerm can load this file alone) ──────
local p = {
  bg          = "#181a1d", -- editor.background
  bg_darker   = "#161619", -- editorGroupHeader.tabsBackground
  bg_panel    = "#2b2d30", -- menu / dropdown.list
  fg          = "#bcbec4", -- editor.foreground
  fg_dim      = "#7a7e85",
  cursor      = "#bcbec4", -- terminalCursor.foreground
  selection   = "#373b39", -- terminal.selectionBackground

  -- ANSI (normal) — copied verbatim from terminal.ansi* in the JSON
  ansi = {
    "#181a1d", -- 0 black           (ansiBlack)
    "#f75464", -- 1 red             (ansiRed)
    "#73b00a", -- 2 green           (ansiGreen)
    "#e8a33e", -- 3 yellow          (ansiYellow)
    "#548af7", -- 4 blue            (ansiBlue)
    "#c77dbb", -- 5 magenta         (ansiMagenta)
    "#2aacb8", -- 6 cyan            (ansiCyan)
    "#bcbec4", -- 7 white           (ansiWhite)
  },
  brights = {
    "#6f737a", -- 8  bright black   (ansiBrightBlack)
    "#f9667a", -- 9  bright red     (ansiBrightRed)
    "#8ccf15", -- 10 bright green   (ansiBrightGreen)
    "#f0b95e", -- 11 bright yellow  (ansiBrightYellow)
    "#7cacf8", -- 12 bright blue    (ansiBrightBlue)
    "#d79fd2", -- 13 bright magenta (ansiBrightMagenta)
    "#42c6d2", -- 14 bright cyan    (ansiBrightCyan)
    "#d4d5d9", -- 15 bright white   (ansiBrightWhite)
  },
}

-- The WezTerm scheme table ──────────────────────────────────────────────────
M.scheme = {
  foreground    = p.fg,
  background    = p.bg,

  cursor_bg     = p.cursor,
  cursor_fg     = p.bg,
  cursor_border = p.cursor,

  selection_fg  = p.fg,
  selection_bg  = p.selection,

  scrollbar_thumb = p.fg_dim,
  split           = p.bg_darker,

  ansi    = p.ansi,
  brights = p.brights,

  compose_cursor = p.ansi[3],   -- yellow (matches inputOption focus accents)
  visual_bell    = p.selection,

  -- Tab bar — themed to match the JetBrains "Islands" chrome:
  --   inactive tabs on bg_darker (#161619), active tab on bg (#181a1d).
  tab_bar = {
    background = p.bg_darker,
    active_tab = {
      bg_color  = p.bg,
      fg_color  = p.fg,
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = p.bg_darker,
      fg_color = p.fg_dim,
    },
    inactive_tab_hover = {
      bg_color = p.bg_darker,
      fg_color = "#b0b2b8", -- tab.hoverForeground from the JSON
      italic   = true,
    },
    new_tab = {
      bg_color = p.bg_darker,
      fg_color = p.fg_dim,
    },
    new_tab_hover = {
      bg_color = p.selection,
      fg_color = p.fg,
    },
  },
}

-- Helpers ────────────────────────────────────────────────────────────────────
local function quote(v) return '"' .. v .. '"' end
local function array(t)
  local parts = {}
  for _, v in ipairs(t) do parts[#parts + 1] = quote(v) end
  return "[" .. table.concat(parts, ", ") .. "]"
end

function M.to_toml()
  local s = M.scheme
  local L = {}
  local function w(line) L[#L + 1] = line end

  w("[metadata]")
  w('name = "Islands Dark"')
  w('author = "Neovim port of bwya77/vscode-dark-islands"')
  w("")
  w("[colors]")
  w("foreground = "      .. quote(s.foreground))
  w("background = "      .. quote(s.background))
  w("cursor_bg = "       .. quote(s.cursor_bg))
  w("cursor_fg = "       .. quote(s.cursor_fg))
  w("cursor_border = "   .. quote(s.cursor_border))
  w("selection_fg = "    .. quote(s.selection_fg))
  w("selection_bg = "    .. quote(s.selection_bg))
  w("scrollbar_thumb = " .. quote(s.scrollbar_thumb))
  w("split = "           .. quote(s.split))
  w("compose_cursor = "  .. quote(s.compose_cursor))
  w("visual_bell = "     .. quote(s.visual_bell))
  w("ansi = "            .. array(s.ansi))
  w("brights = "         .. array(s.brights))
  w("")
  w("[colors.tab_bar]")
  w("background = " .. quote(s.tab_bar.background))
  w("")
  w("[colors.tab_bar.active_tab]")
  w("bg_color = "  .. quote(s.tab_bar.active_tab.bg_color))
  w("fg_color = "  .. quote(s.tab_bar.active_tab.fg_color))
  w("intensity = " .. quote(s.tab_bar.active_tab.intensity))
  w("")
  w("[colors.tab_bar.inactive_tab]")
  w("bg_color = " .. quote(s.tab_bar.inactive_tab.bg_color))
  w("fg_color = " .. quote(s.tab_bar.inactive_tab.fg_color))
  w("")
  w("[colors.tab_bar.inactive_tab_hover]")
  w("bg_color = " .. quote(s.tab_bar.inactive_tab_hover.bg_color))
  w("fg_color = " .. quote(s.tab_bar.inactive_tab_hover.fg_color))
  w("italic = true")
  w("")
  w("[colors.tab_bar.new_tab]")
  w("bg_color = " .. quote(s.tab_bar.new_tab.bg_color))
  w("fg_color = " .. quote(s.tab_bar.new_tab.fg_color))
  w("")
  w("[colors.tab_bar.new_tab_hover]")
  w("bg_color = " .. quote(s.tab_bar.new_tab_hover.bg_color))
  w("fg_color = " .. quote(s.tab_bar.new_tab_hover.fg_color))

  return table.concat(L, "\n") .. "\n"
end

function M.write_toml(path)
  local f, err = io.open(path, "w")
  if not f then return false, err end
  f:write(M.to_toml())
  f:close()
  return true
end

return M
