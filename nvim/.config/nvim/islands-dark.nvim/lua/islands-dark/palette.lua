-- islands-dark: color palette
-- Ported faithfully from bwya77/vscode-dark-islands
--   themes/islands-dark.json
-- Every hex value is copied verbatim from that file; nothing is invented.

local M = {}

M.colors = {
  -- ── Base surfaces (the "island" backgrounds) ───────────────────────────
  bg            = "#181a1d", -- editor.background, sideBar, activityBar, statusBar
  bg_darker     = "#161619", -- tab.inactiveBackground, editorGroupHeader.tabsBackground
  bg_lighter    = "#1e2024", -- notebook.cellEditorBackground
  bg_panel      = "#2b2d30", -- menu, dropdown.listBackground, peek/suggest
  bg_panel_alt  = "#1e1f22", -- notificationCenterHeader / quickInputTitle
  bg_widget     = "#181a1d", -- editorWidget, editorHoverWidget border-less surfaces
  bg_hover      = "#252629", -- editor.lineHighlightBackground, stickyScrollHover
  bg_selected   = "#25324d", -- list focus / commandCenter / inputOption active
  cursor_line   = "#252629", -- editor.lineHighlightBackground

  -- ── Foreground / text ─────────────────────────────────────────────────
  fg            = "#bcbec4", -- editor.foreground
  fg_alt        = "#bababa", -- HTML attribute name (slight off-white)
  fg_bright     = "#d4d5d9", -- terminal.ansiBrightWhite
  fg_dim        = "#7a7e85", -- breadcrumb / inactive / comments
  fg_dimmer     = "#6f737a", -- activityBar inactive / ansiBrightBlack
  fg_muted      = "#4e5157", -- lineNumber / gitDecoration ignored
  fg_faint      = "#35383d", -- statusBar.foreground
  fg_active     = "#a1a3ab", -- editorLineNumber.activeForeground

  -- ── Borders & lines ────────────────────────────────────────────────────
  border        = "#3c3f41", -- dropdown / checkbox / button.secondary borders
  border_dim    = "#3c3f45", -- tree.indentGuidesStroke
  border_panel  = "#2b2d30", -- panelSection / debugToolBar / merge borders
  border_subtle = "#25262a", -- pickerGroup / editorWidget border
  border_tab    = "#19191e", -- tab.border
  indent        = "#3c3f41", -- editorIndentGuide.activeBackground / whitespace

  -- ── Accent colors ──────────────────────────────────────────────────────
  blue          = "#548af7", -- primary accent (links, buttons, modified)
  blue_hover    = "#6d9df8", -- button.hoverBackground
  blue_light    = "#7cacf8", -- textLink.activeForeground
  blue_fn       = "#56a8f5", -- functions, methods, JSX components
  blue_bright   = "#7cacf8", -- terminal.ansiBrightBlue

  orange        = "#cf8e6d", -- keywords, storage, tags (the "JetBrains orange")
  orange_bright = "#e8a33e", -- warnings, deprecated marker
  orange_warn   = "#e8a33e", -- editorWarning, debug bg
  orange_warn_bright = "#f0b95e",

  magenta       = "#c77dbb", -- types, classes, properties, enums
  magenta_bright= "#d79fd2", -- terminal.ansiBrightMagenta

  green         = "#6aab73", -- strings, markup.inserted (soft)
  green_vivid   = "#73b00a", -- git added, find match border (vivid)
  green_bright  = "#8ccf15",

  cyan          = "#2aacb8", -- numbers, regex, units, rust lifetimes
  cyan_bright   = "#42c6d2",

  yellow        = "#bbb529", -- decorators, annotations, attributes
  red           = "#f75464", -- errors, deletions
  red_bright    = "#f9667a",

  -- ── Diff / VCS / state backgrounds ─────────────────────────────────────
  -- Source JSON values include 8-digit alpha (e.g. #73b00a18). Neovim's
  -- nvim_set_hl only accepts 6-digit RGB, so these are pre-blended against
  -- the editor bg (#181a1d) to preserve the visual intent.
  diff_add_bg     = "#21281b", -- diffEditor.insertedTextBackground (#73b00a18 on bg)
  diff_del_bg     = "#2d1f24", -- diffEditor.removedTextBackground  (#f7546418 on bg)
  diff_add_line   = "#1f261b", -- diffEditor.insertedLineBackground (#73b00a15 on bg)
  diff_del_line   = "#2a1f23", -- diffEditor.removedLineBackground  (#f7546415 on bg)
  diff_match      = "#32593d", -- find match background (solid)
  selection       = "#373b39", -- editor.selectionBackground (solid)
  selection_dim   = "#222426", -- editor.inactiveSelectionBackground (#373b3950 on bg)
  search_hl       = "#2b2d30", -- editor.findMatchHighlightBackground (#54575b50 on bg)

  -- ── Status / states ────────────────────────────────────────────────────
  error           = "#f75464",
  warning         = "#e8a33e",
  info            = "#548af7",
  hint            = "#7a7e85",
  success         = "#73b00a",

  -- ── Terminal ANSI (from terminal.ansi* in JSON) ────────────────────────
  ansi_black           = "#181a1d",
  ansi_red             = "#f75464",
  ansi_green           = "#73b00a",
  ansi_yellow          = "#e8a33e",
  ansi_blue            = "#548af7",
  ansi_magenta         = "#c77dbb",
  ansi_cyan            = "#2aacb8",
  ansi_white           = "#bcbec4",
  ansi_bright_black    = "#6f737a",
  ansi_bright_red      = "#f9667a",
  ansi_bright_green    = "#8ccf15",
  ansi_bright_yellow   = "#f0b95e",
  ansi_bright_blue     = "#7cacf8",
  ansi_bright_magenta  = "#d79fd2",
  ansi_bright_cyan     = "#42c6d2",
  ansi_bright_white    = "#d4d5d9",

  none = "NONE",
}

return M
