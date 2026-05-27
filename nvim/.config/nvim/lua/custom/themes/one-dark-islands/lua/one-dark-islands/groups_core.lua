-- one-dark-islands: highlight group definitions
-- Returns a flat table { GroupName = { fg=..., bg=..., ... }, ... }
-- consumed by init.lua via vim.api.nvim_set_hl (Neovim 0.12 native API).

local M = {}

function M.get(c, opts)
  opts = opts or {}
  local transparent = opts.transparent or false
  local italic_comments = opts.italic_comments ~= false   -- default true
  local italic_params   = opts.italic_parameters ~= false -- default true

  -- background helper: respect transparent mode for "normal" surfaces only
  local bg_main  = transparent and c.none or c.bg
  local bg_panel = transparent and c.none or c.bg_dark

  local hl = {
    -- ── Editor / UI ──────────────────────────────────────────────────────
    Normal            = { fg = c.fg, bg = bg_main },
    NormalNC          = { fg = c.fg, bg = bg_main },
    NormalFloat       = { fg = c.fg, bg = transparent and c.none or c.bg_float },
    FloatBorder       = { fg = c.border, bg = transparent and c.none or c.bg_float },
    FloatTitle        = { fg = c.accent, bg = transparent and c.none or c.bg_float, bold = true },
    ColorColumn       = { bg = c.bg_light },
    Conceal           = { fg = c.fg_dim },
    Cursor            = { fg = c.bg, bg = c.accent_dark },
    lCursor           = { fg = c.bg, bg = c.accent_dark },
    CursorIM          = { fg = c.bg, bg = c.accent_dark },
    CursorColumn      = { bg = c.cursor_line },
    CursorLine        = { bg = c.cursor_line },
    Directory         = { fg = c.accent },
    DiffAdd           = { bg = c.diff_add },
    DiffChange        = { bg = c.diff_change },
    DiffDelete        = { bg = c.diff_delete },
    DiffText          = { bg = c.selection },
    EndOfBuffer       = { fg = bg_main },
    ErrorMsg          = { fg = c.error },
    VertSplit         = { fg = c.border, bg = bg_main },
    WinSeparator      = { fg = c.border, bg = bg_main },
    Folded            = { fg = c.fg_dim, bg = c.selection },
    FoldColumn        = { fg = c.line_nr, bg = bg_main },
    SignColumn        = { fg = c.line_nr, bg = bg_main },
    IncSearch         = { fg = c.bg, bg = c.whiskey },
    CurSearch         = { fg = c.bg, bg = c.whiskey },
    Substitute        = { fg = c.bg, bg = c.coral },
    LineNr            = { fg = c.line_nr },
    LineNrAbove       = { fg = c.line_nr },
    LineNrBelow       = { fg = c.line_nr },
    CursorLineNr      = { fg = c.line_nr_active, bold = true },
    MatchParen        = { bg = c.selection, bold = true },
    ModeMsg           = { fg = c.fg, bold = true },
    MsgArea           = { fg = c.fg },
    MoreMsg           = { fg = c.green },
    NonText           = { fg = c.indent },
    Pmenu             = { fg = c.fg, bg = c.bg_float },
    PmenuSel          = { fg = c.fg, bg = c.selection },
    PmenuKind         = { fg = c.chalky, bg = c.bg_float },
    PmenuKindSel      = { fg = c.chalky, bg = c.selection },
    PmenuExtra        = { fg = c.fg_dim, bg = c.bg_float },
    PmenuExtraSel     = { fg = c.fg_dim, bg = c.selection },
    PmenuSbar         = { bg = c.bg_float },
    PmenuThumb        = { bg = c.fg_dim },
    PmenuMatch        = { fg = c.accent, bg = c.bg_float, bold = true },
    PmenuMatchSel     = { fg = c.accent, bg = c.selection, bold = true },
    Question          = { fg = c.green },
    QuickFixLine      = { bg = c.selection, bold = true },
    Search            = { bg = c.search },
    SpecialKey        = { fg = c.indent },
    SpellBad          = { sp = c.error, undercurl = true },
    SpellCap          = { sp = c.chalky, undercurl = true },
    SpellLocal        = { sp = c.fountain_blue, undercurl = true },
    SpellRare         = { sp = c.purple, undercurl = true },
    StatusLine        = { fg = c.fg, bg = c.bg_dark },
    StatusLineNC      = { fg = c.fg_dim, bg = c.bg_dark },
    TabLine           = { fg = c.fg_dim, bg = c.bg_dark },
    TabLineFill       = { bg = c.bg_dark },
    TabLineSel        = { fg = c.fg, bg = c.bg_light },
    Title             = { fg = c.accent, bold = true },
    Visual            = { bg = c.selection },
    VisualNOS         = { bg = c.selection },
    WarningMsg        = { fg = c.chalky },
    Whitespace        = { fg = c.indent },
    WildMenu          = { fg = c.fg, bg = c.selection },
    Winbar            = { fg = c.fg_dim, bg = bg_main },
    WinbarNC          = { fg = c.fg_dim, bg = bg_main },

    -- ── Legacy syntax groups (vim regex highlighters) ──────────────────────
    Comment        = { fg = c.fg_dim, italic = italic_comments },
    Constant       = { fg = c.fountain_blue },
    String         = { fg = c.green },
    Character      = { fg = c.green },
    Number         = { fg = c.whiskey },
    Float          = { fg = c.whiskey },
    Boolean        = { fg = c.fountain_blue },
    Identifier     = { fg = c.coral },
    Function       = { fg = c.malibu },
    Statement      = { fg = c.purple },
    Conditional    = { fg = c.purple },
    Repeat         = { fg = c.purple },
    Label          = { fg = c.coral },
    Operator       = { fg = c.fountain_blue },
    Keyword        = { fg = c.purple },
    Exception      = { fg = c.purple },
    PreProc        = { fg = c.purple },
    Include        = { fg = c.purple },
    Define         = { fg = c.purple },
    Macro          = { fg = c.fountain_blue },
    PreCondit      = { fg = c.purple },
    Type           = { fg = c.chalky },
    StorageClass   = { fg = c.chalky },
    Structure      = { fg = c.chalky },
    Typedef        = { fg = c.chalky },
    Special        = { fg = c.fountain_blue },
    SpecialChar    = { fg = c.fountain_blue },
    Tag            = { fg = c.coral },
    Delimiter      = { fg = c.fg },
    SpecialComment = { fg = c.purple, italic = italic_comments },
    Debug          = { fg = c.coral },
    Underlined     = { fg = c.accent, underline = true },
    Ignore         = { fg = c.fg_dim },
    Error          = { fg = c.error },
    Todo           = { fg = c.chalky, italic = true, bold = true },

    -- ── Diagnostics (LSP) ──────────────────────────────────────────────────
    DiagnosticError            = { fg = c.error },
    DiagnosticWarn             = { fg = c.chalky },
    DiagnosticInfo             = { fg = c.accent },
    DiagnosticHint             = { fg = c.fountain_blue },
    DiagnosticOk               = { fg = c.green },
    DiagnosticVirtualTextError = { fg = c.error, bg = c.err_bg },
    DiagnosticVirtualTextWarn  = { fg = c.chalky, bg = c.warn_bg },
    DiagnosticVirtualTextInfo  = { fg = c.accent, bg = c.bg_light },
    DiagnosticVirtualTextHint  = { fg = c.fountain_blue, bg = c.bg_light },
    DiagnosticVirtualTextOk    = { fg = c.green, bg = c.bg_light },
    DiagnosticUnderlineError   = { sp = c.error, undercurl = true },
    DiagnosticUnderlineWarn    = { sp = c.chalky, undercurl = true },
    DiagnosticUnderlineInfo    = { sp = c.accent, undercurl = true },
    DiagnosticUnderlineHint    = { sp = c.fountain_blue, undercurl = true },
    DiagnosticUnderlineOk      = { sp = c.green, undercurl = true },
    DiagnosticDeprecated       = { fg = c.fg_dim, strikethrough = true },
    DiagnosticUnnecessary      = { fg = c.fg_dim },
    DiagnosticSignError        = { fg = c.error },
    DiagnosticSignWarn         = { fg = c.chalky },
    DiagnosticSignInfo         = { fg = c.accent },
    DiagnosticSignHint         = { fg = c.fountain_blue },

    -- ── LSP base / references ──────────────────────────────────────────────
    LspReferenceText       = { bg = c.selection },
    LspReferenceRead       = { bg = c.selection },
    LspReferenceWrite      = { bg = c.selection },
    LspSignatureActiveParameter = { fg = c.chalky, bold = true },
    LspInlayHint           = { fg = c.fg_dim, bg = c.bg_light },
    LspCodeLens            = { fg = c.fg_dim, italic = true },
    LspCodeLensSeparator   = { fg = c.indent },
  }

  -- Parameter italics toggle is applied in the Treesitter/semantic section.
  hl._italic_params = italic_params
  return hl
end

return M
