-- islands-dark: core editor UI + legacy syntax + diagnostics
-- Token color decisions follow themes/islands-dark.json (bwya77):
--   keywords / storage / tags         -> orange   (#cf8e6d)
--   types / classes / properties / enums -> magenta (#c77dbb)
--   functions / methods               -> blue_fn  (#56a8f5)
--   strings                           -> green    (#6aab73)
--   numbers / regex / units           -> cyan     (#2aacb8)
--   decorators / annotations          -> yellow   (#bbb529)
--   variables / parameters / operators-> fg       (#bcbec4)

local M = {}

function M.get(c, opts)
  opts = opts or {}
  local transparent     = opts.transparent or false
  local italic_comments = opts.italic_comments ~= false  -- default true

  local bg_main  = transparent and c.none or c.bg
  local bg_panel = transparent and c.none or c.bg_panel
  local bg_float = transparent and c.none or c.bg_panel

  local hl = {
    -- ── Editor / UI ──────────────────────────────────────────────────────
    Normal          = { fg = c.fg, bg = bg_main },
    NormalNC        = { fg = c.fg, bg = bg_main },
    NormalFloat     = { fg = c.fg, bg = bg_float },
    FloatBorder     = { fg = c.border, bg = bg_float },
    FloatTitle      = { fg = c.blue, bg = bg_float, bold = true },
    FloatFooter     = { fg = c.fg_dim, bg = bg_float },
    ColorColumn     = { bg = c.bg_panel },
    Conceal         = { fg = c.fg_dim },
    Cursor          = { fg = c.bg, bg = c.fg },
    lCursor         = { fg = c.bg, bg = c.fg },
    CursorIM        = { fg = c.bg, bg = c.fg },
    CursorColumn    = { bg = c.cursor_line },
    CursorLine      = { bg = c.cursor_line },
    Directory       = { fg = c.blue },
    DiffAdd         = { bg = c.diff_add_line },
    DiffChange      = { bg = c.bg_selected },
    DiffDelete      = { bg = c.diff_del_line },
    DiffText        = { bg = c.diff_match },
    EndOfBuffer     = { fg = bg_main },
    ErrorMsg        = { fg = c.error },
    VertSplit       = { fg = c.border_tab, bg = bg_main },
    WinSeparator    = { fg = c.border_tab, bg = bg_main },
    Folded          = { fg = c.fg_dim, bg = c.bg_selected },
    FoldColumn      = { fg = c.fg_muted, bg = bg_main },
    SignColumn      = { fg = c.fg_muted, bg = bg_main },
    IncSearch       = { fg = c.bg, bg = c.green_vivid, bold = true },
    CurSearch       = { fg = c.bg, bg = c.green_vivid, bold = true },
    Substitute      = { fg = c.bg, bg = c.orange },
    LineNr          = { fg = c.fg_muted },
    LineNrAbove     = { fg = c.fg_muted },
    LineNrBelow     = { fg = c.fg_muted },
    CursorLineNr    = { fg = c.fg_active, bold = true },
    MatchParen      = { fg = c.fg, bg = c.border, bold = true },
    ModeMsg         = { fg = c.fg, bold = true },
    MsgArea         = { fg = c.fg },
    MoreMsg         = { fg = c.green },
    NonText         = { fg = c.indent },
    Pmenu           = { fg = c.fg, bg = c.bg_panel },
    PmenuSel        = { fg = c.fg, bg = c.bg_selected, bold = true },
    PmenuKind       = { fg = c.magenta, bg = c.bg_panel },
    PmenuKindSel    = { fg = c.magenta, bg = c.bg_selected, bold = true },
    PmenuExtra      = { fg = c.fg_dim, bg = c.bg_panel },
    PmenuExtraSel   = { fg = c.fg_dim, bg = c.bg_selected, bold = true },
    PmenuSbar       = { bg = c.bg_panel },
    PmenuThumb      = { bg = c.fg_muted },
    PmenuMatch      = { fg = c.blue, bg = c.bg_panel, bold = true },
    PmenuMatchSel   = { fg = c.blue, bg = c.bg_selected, bold = true },
    Question        = { fg = c.green },
    QuickFixLine    = { bg = c.bg_selected, bold = true },
    Search          = { bg = c.search_hl },
    SpecialKey      = { fg = c.indent },
    SpellBad        = { sp = c.error, undercurl = true },
    SpellCap        = { sp = c.warning, undercurl = true },
    SpellLocal      = { sp = c.cyan, undercurl = true },
    SpellRare       = { sp = c.magenta, undercurl = true },
    StatusLine      = { fg = c.fg_faint, bg = c.bg },
    StatusLineNC    = { fg = c.fg_muted, bg = c.bg },
    TabLine         = { fg = c.fg_dim, bg = c.bg_darker },
    TabLineFill     = { bg = c.bg_darker },
    TabLineSel      = { fg = c.fg, bg = c.bg, bold = true },
    Title           = { fg = c.blue, bold = true },
    Visual          = { bg = c.selection },
    VisualNOS       = { bg = c.selection },
    WarningMsg      = { fg = c.warning },
    Whitespace      = { fg = c.indent },
    WildMenu        = { fg = c.fg, bg = c.bg_selected },
    Winbar          = { fg = c.fg_dim, bg = bg_main },
    WinbarNC        = { fg = c.fg_dimmer, bg = bg_main },

    -- ── Legacy syntax groups (vim regex highlighters) ────────────────────
    -- These mirror the bwya77 token color choices.
    Comment        = { fg = c.fg_dim, italic = italic_comments },

    Constant       = { fg = c.orange },         -- constant.language → orange
    String         = { fg = c.green },          -- string → green
    Character      = { fg = c.green },
    Number         = { fg = c.cyan },           -- constant.numeric → cyan
    Float          = { fg = c.cyan },
    Boolean        = { fg = c.orange },         -- constant.language.boolean → orange

    Identifier     = { fg = c.fg },             -- variable → fg
    Function       = { fg = c.blue_fn },        -- entity.name.function → blue

    Statement      = { fg = c.orange },         -- keyword family → orange
    Conditional    = { fg = c.orange },
    Repeat         = { fg = c.orange },
    Label          = { fg = c.orange },
    Operator       = { fg = c.fg },             -- keyword.operator → fg
    Keyword        = { fg = c.orange },
    Exception      = { fg = c.orange },

    PreProc        = { fg = c.orange },
    Include        = { fg = c.orange },
    Define         = { fg = c.orange },
    Macro          = { fg = c.blue_fn, bold = true },
    PreCondit      = { fg = c.orange },

    Type           = { fg = c.magenta },        -- entity.name.type → magenta
    StorageClass   = { fg = c.orange },         -- storage → orange (bwya77 quirk)
    Structure      = { fg = c.magenta },
    Typedef        = { fg = c.magenta },

    Special        = { fg = c.orange },         -- template-expression / escape
    SpecialChar    = { fg = c.orange },         -- escape → orange (bwya77 quirk)
    Tag            = { fg = c.orange },         -- HTML tags → orange
    Delimiter      = { fg = c.fg },             -- punctuation → fg
    SpecialComment = { fg = c.orange, italic = italic_comments },
    Debug          = { fg = c.error },
    Underlined     = { fg = c.blue, underline = true },
    Ignore         = { fg = c.fg_muted },
    Error          = { fg = c.error },
    Todo           = { fg = c.warning, italic = true, bold = true },

    -- ── Diagnostics (LSP) ────────────────────────────────────────────────
    DiagnosticError            = { fg = c.error },
    DiagnosticWarn             = { fg = c.warning },
    DiagnosticInfo             = { fg = c.info },
    DiagnosticHint             = { fg = c.cyan },
    DiagnosticOk               = { fg = c.success },
    DiagnosticVirtualTextError = { fg = c.error,   bg = c.bg_panel },
    DiagnosticVirtualTextWarn  = { fg = c.warning, bg = c.bg_panel },
    DiagnosticVirtualTextInfo  = { fg = c.info,    bg = c.bg_panel },
    DiagnosticVirtualTextHint  = { fg = c.cyan,    bg = c.bg_panel },
    DiagnosticVirtualTextOk    = { fg = c.success, bg = c.bg_panel },
    DiagnosticUnderlineError   = { sp = c.error,   undercurl = true },
    DiagnosticUnderlineWarn    = { sp = c.warning, undercurl = true },
    DiagnosticUnderlineInfo    = { sp = c.info,    undercurl = true },
    DiagnosticUnderlineHint    = { sp = c.cyan,    undercurl = true },
    DiagnosticUnderlineOk      = { sp = c.success, undercurl = true },
    DiagnosticDeprecated       = { fg = c.warning, strikethrough = true }, -- invalid.deprecated
    DiagnosticUnnecessary      = { fg = c.fg_muted },
    DiagnosticSignError        = { fg = c.error },
    DiagnosticSignWarn         = { fg = c.warning },
    DiagnosticSignInfo         = { fg = c.info },
    DiagnosticSignHint         = { fg = c.cyan },

    -- ── LSP base / references / inlay ────────────────────────────────────
    LspReferenceText            = { bg = c.selection },
    LspReferenceRead            = { bg = c.selection },
    LspReferenceWrite           = { bg = c.selection },
    LspSignatureActiveParameter = { fg = c.warning, bold = true },
    LspInlayHint                = { fg = c.fg_dim, bg = c.indent }, -- inlayHint.background
    LspCodeLens                 = { fg = c.fg_muted, italic = true }, -- editorCodeLens.foreground
    LspCodeLensSeparator        = { fg = c.indent },
  }

  return hl
end

return M
