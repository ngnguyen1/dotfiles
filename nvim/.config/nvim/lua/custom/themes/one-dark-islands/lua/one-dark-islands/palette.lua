-- one-dark-islands: color palette
-- Ported faithfully from bataevvlad/one-dark-islands-theme (JetBrains)
--   one_dark_islands.theme.json  -> UI colors
--   one_dark.xml                 -> editor / syntax token colors
-- Hex values are copied verbatim from those files; nothing is invented.

local M = {}

M.colors = {
  -- ── Base UI ────────────────────────────────────────────────────────────
  bg            = "#282c34", -- background        (Editor.background, TEXT bg)
  bg_light      = "#2c313a", -- backgroundLight   (notifications, tab underline)
  bg_dark       = "#21252b", -- backgroundDark    (sidebars, statusline, title)
  bg_darker     = "#1d2026", -- TextField/ToolTip background (inputs, floats)
  bg_float      = "#21252b", -- popup / float background
  fg            = "#abb2bf", -- foreground
  fg_dim        = "#5c6370", -- foregroundDim     (comments, line-nr inactive)
  border        = "#181a1f", -- border / Borders.color
  selection     = "#3e4451", -- selection         (visual, matched brace)
  cursor_line   = "#2c313c", -- CARET_ROW_COLOR
  line_nr       = "#4b5263", -- LINE_NUMBERS_COLOR
  line_nr_active= "#abb2bf", -- LINE_NUMBER_ON_CARET_ROW_COLOR
  indent        = "#3b4048", -- INDENT_GUIDE / WHITESPACES
  indent_active = "#5c6370", -- SELECTED_TEARLINE_COLOR
  hover_bg      = "#323842", -- tab/tree hover backgrounds
  pressed_bg    = "#4d5566", -- pressed / hint-current backgrounds

  -- ── Accents ────────────────────────────────────────────────────────────
  accent        = "#61afef", -- accent (links, focus, modified)
  accent_dark   = "#528bff", -- accentDark / caret

  -- ── Syntax palette (the classic One Dark eight) ─────────────────────────
  coral         = "#e06c75", -- variables, tags, fields, errors-in-diff
  chalky        = "#e5c07b", -- classes, types, interfaces, annotations
  green         = "#98c379", -- strings, added lines
  malibu        = "#61afef", -- functions, methods (== accent)
  purple        = "#c678dd", -- keywords, doc tags, pseudo
  whiskey       = "#d19a66", -- numbers, attributes, css color values
  fountain_blue = "#56b6c2", -- constants, operators, escapes, builtins
  error         = "#f44747", -- invalid escape / hard error

  -- ── Console / ANSI (terminal) ───────────────────────────────────────────
  ansi_black        = "#3f4451",
  ansi_dark_black   = "#1d2026",
  ansi_red          = "#e06c75",
  ansi_dark_red     = "#be5046",
  ansi_green        = "#98c379",
  ansi_dark_green   = "#7a9f60",
  ansi_yellow       = "#e5c07b",
  ansi_dark_yellow  = "#d19a66",
  ansi_blue         = "#61afef",
  ansi_dark_blue    = "#528bff",
  ansi_magenta      = "#c678dd",
  ansi_dark_magenta = "#a352b3",
  ansi_cyan         = "#56b6c2",
  ansi_dark_cyan    = "#3e9099",
  ansi_white        = "#abb2bf",
  ansi_dark_white   = "#828997",

  -- ── Diff / VCS / diagnostics backgrounds ────────────────────────────────
  diff_add      = "#2d3d2d", -- DIFF_INSERTED bg
  diff_change   = "#2d3d4d", -- DIFF_MODIFIED bg
  diff_delete   = "#3f2d2d", -- DIFF_DELETED bg
  diff_conflict = "#45302b", -- DIFF_CONFLICT bg
  search        = "#314365", -- SEARCH_RESULT bg
  err_bg        = "#3d2b2f", -- Notification.errorBackground
  warn_bg       = "#3d3627", -- ValidationTooltip.warningBackground

  -- Git status accents (from FILESTATUS_* / GitLog icon colors)
  git_add       = "#98c379",
  git_change    = "#e5c07b", -- MODIFIED_LINES_COLOR
  git_delete    = "#e06c75",

  -- semantic helpers
  none          = "NONE",
}

return M
