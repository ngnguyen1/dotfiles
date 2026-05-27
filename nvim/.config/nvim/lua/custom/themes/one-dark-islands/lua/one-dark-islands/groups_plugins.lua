-- one-dark-islands: plugin highlight groups
-- Common ecosystem coverage. Colors stay within the One Dark Islands palette.

local M = {}

function M.get(c, opts)
  opts = opts or {}
  local transparent = opts.transparent or false
  local bg_main  = transparent and c.none or c.bg
  local bg_float = transparent and c.none or c.bg_float

  return {
    -- ── Treesitter context ────────────────────────────────────────────────
    TreesitterContext           = { bg = c.bg_light },
    TreesitterContextLineNumber = { fg = c.accent, bg = c.bg_light },
    TreesitterContextBottom     = { underline = true, sp = c.border },

    -- ── nvim-cmp / blink.cmp ──────────────────────────────────────────────
    CmpItemAbbr             = { fg = c.fg },
    CmpItemAbbrDeprecated   = { fg = c.fg_dim, strikethrough = true },
    CmpItemAbbrMatch        = { fg = c.accent, bold = true },   -- matchForeground
    CmpItemAbbrMatchFuzzy   = { fg = c.accent, bold = true },
    CmpItemMenu             = { fg = c.fg_dim },
    CmpItemKindText         = { fg = c.green },
    CmpItemKindMethod       = { fg = c.malibu },
    CmpItemKindFunction     = { fg = c.malibu },
    CmpItemKindConstructor  = { fg = c.chalky },
    CmpItemKindField        = { fg = c.coral },
    CmpItemKindVariable     = { fg = c.coral },
    CmpItemKindClass        = { fg = c.chalky },
    CmpItemKindInterface    = { fg = c.chalky },
    CmpItemKindModule       = { fg = c.coral },
    CmpItemKindProperty     = { fg = c.coral },
    CmpItemKindKeyword      = { fg = c.purple },
    CmpItemKindSnippet      = { fg = c.fountain_blue },
    CmpItemKindConstant     = { fg = c.fountain_blue },
    CmpItemKindEnum         = { fg = c.chalky },
    CmpItemKindEnumMember   = { fg = c.fountain_blue },
    CmpItemKindOperator     = { fg = c.fountain_blue },
    CmpItemKindTypeParameter= { fg = c.chalky },
    BlinkCmpMenu            = { fg = c.fg, bg = bg_float },
    BlinkCmpMenuBorder      = { fg = c.border, bg = bg_float },
    BlinkCmpLabelMatch      = { fg = c.accent, bold = true },
    BlinkCmpKind            = { fg = c.fountain_blue },
    BlinkCmpDoc             = { fg = c.fg, bg = bg_float },
    BlinkCmpDocBorder       = { fg = c.border, bg = bg_float },

    -- ── Telescope ─────────────────────────────────────────────────────────
    TelescopeNormal          = { fg = c.fg, bg = bg_float },
    TelescopeBorder          = { fg = c.border, bg = bg_float },
    TelescopeTitle           = { fg = c.accent, bold = true },
    TelescopePromptNormal    = { fg = c.fg, bg = c.bg_darker },
    TelescopePromptBorder    = { fg = c.bg_darker, bg = c.bg_darker },
    TelescopePromptTitle     = { fg = c.bg, bg = c.accent, bold = true },
    TelescopePromptPrefix    = { fg = c.accent },
    TelescopePromptCounter   = { fg = c.fg_dim },
    TelescopeResultsNormal   = { fg = c.fg, bg = bg_float },
    TelescopeResultsBorder   = { fg = c.bg_float, bg = bg_float },
    TelescopeResultsTitle    = { fg = bg_float, bg = bg_float },
    TelescopePreviewNormal   = { fg = c.fg, bg = bg_float },
    TelescopePreviewBorder   = { fg = c.bg_float, bg = bg_float },
    TelescopePreviewTitle    = { fg = c.bg, bg = c.green, bold = true },
    TelescopeSelection       = { fg = c.fg, bg = c.selection },
    TelescopeSelectionCaret  = { fg = c.coral, bg = c.selection },
    TelescopeMultiSelection  = { fg = c.purple },
    TelescopeMatching        = { fg = c.accent, bold = true },

    -- ── NvimTree ──────────────────────────────────────────────────────────
    NvimTreeNormal            = { fg = c.fg, bg = transparent and c.none or c.bg_dark },
    NvimTreeNormalNC          = { fg = c.fg, bg = transparent and c.none or c.bg_dark },
    NvimTreeEndOfBuffer       = { fg = transparent and c.none or c.bg_dark },
    NvimTreeRootFolder        = { fg = c.purple, bold = true },
    NvimTreeFolderName        = { fg = c.fg },
    NvimTreeFolderIcon        = { fg = c.accent },
    NvimTreeOpenedFolderName  = { fg = c.fg, bold = true },
    NvimTreeEmptyFolderName   = { fg = c.fg_dim },
    NvimTreeSymlink           = { fg = c.fountain_blue },
    NvimTreeSpecialFile       = { fg = c.chalky, underline = true },
    NvimTreeImageFile         = { fg = c.purple },
    NvimTreeExecFile          = { fg = c.green },
    NvimTreeIndentMarker      = { fg = c.indent },
    NvimTreeWinSeparator      = { fg = c.border, bg = c.border },
    NvimTreeGitDirty          = { fg = c.git_change },
    NvimTreeGitNew            = { fg = c.git_add },
    NvimTreeGitDeleted        = { fg = c.git_delete },
    NvimTreeGitStaged         = { fg = c.green },
    NvimTreeGitMerge          = { fg = c.coral },
    NvimTreeGitRenamed        = { fg = c.purple },
    NvimTreeCursorLine        = { bg = c.selection },

    -- ── neo-tree ──────────────────────────────────────────────────────────
    NeoTreeNormal             = { fg = c.fg, bg = transparent and c.none or c.bg_dark },
    NeoTreeNormalNC           = { fg = c.fg, bg = transparent and c.none or c.bg_dark },
    NeoTreeDirectoryName      = { fg = c.fg },
    NeoTreeDirectoryIcon      = { fg = c.accent },
    NeoTreeRootName           = { fg = c.purple, bold = true },
    NeoTreeGitAdded           = { fg = c.git_add },
    NeoTreeGitModified        = { fg = c.git_change },
    NeoTreeGitDeleted         = { fg = c.git_delete },
    NeoTreeIndentMarker       = { fg = c.indent },
    NeoTreeWinSeparator       = { fg = c.border, bg = c.border },

    -- ── gitsigns ──────────────────────────────────────────────────────────
    GitSignsAdd       = { fg = c.git_add },
    GitSignsChange    = { fg = c.git_change },
    GitSignsDelete    = { fg = c.git_delete },
    GitSignsAddNr     = { fg = c.git_add },
    GitSignsChangeNr  = { fg = c.git_change },
    GitSignsDeleteNr  = { fg = c.git_delete },
    GitSignsAddLn     = { bg = c.diff_add },
    GitSignsChangeLn  = { bg = c.diff_change },
    GitSignsDeleteLn  = { bg = c.diff_delete },
    GitSignsCurrentLineBlame = { fg = c.fg_dim, italic = true },

    -- ── which-key ─────────────────────────────────────────────────────────
    WhichKey          = { fg = c.accent },
    WhichKeyGroup     = { fg = c.coral },
    WhichKeyDesc      = { fg = c.fg },
    WhichKeySeparator = { fg = c.fg_dim },
    WhichKeyFloat     = { bg = bg_float },
    WhichKeyBorder    = { fg = c.border, bg = bg_float },
    WhichKeyValue     = { fg = c.fg_dim },

    -- ── indent-blankline (v3) ─────────────────────────────────────────────
    IblIndent     = { fg = c.indent },
    IblWhitespace = { fg = c.indent },
    IblScope      = { fg = c.indent_active },

    -- ── mini.indentscope ──────────────────────────────────────────────────
    MiniIndentscopeSymbol = { fg = c.indent_active },
    MiniIndentscopePrefix = { nocombine = true },

    -- ── dashboard / alpha / starter ───────────────────────────────────────
    DashboardHeader   = { fg = c.accent },
    DashboardFooter   = { fg = c.fg_dim },
    DashboardCenter   = { fg = c.fg },
    DashboardShortCut = { fg = c.coral },
    DashboardKey      = { fg = c.whiskey },
    AlphaHeader       = { fg = c.accent },
    AlphaButtons      = { fg = c.fg },
    AlphaShortcut     = { fg = c.coral },
    AlphaFooter       = { fg = c.fg_dim },

    -- ── notify ────────────────────────────────────────────────────────────
    NotifyERRORBorder = { fg = c.coral },   NotifyERRORIcon = { fg = c.coral },
    NotifyERRORTitle  = { fg = c.coral },
    NotifyWARNBorder  = { fg = c.chalky },  NotifyWARNIcon  = { fg = c.chalky },
    NotifyWARNTitle   = { fg = c.chalky },
    NotifyINFOBorder  = { fg = c.accent },  NotifyINFOIcon  = { fg = c.accent },
    NotifyINFOTitle   = { fg = c.accent },
    NotifyDEBUGBorder = { fg = c.fg_dim },  NotifyDEBUGIcon = { fg = c.fg_dim },
    NotifyTRACEBorder = { fg = c.purple },  NotifyTRACEIcon = { fg = c.purple },

    -- ── bufferline ────────────────────────────────────────────────────────
    BufferLineFill              = { bg = c.bg_dark },
    BufferLineBackground        = { fg = c.fg_dim, bg = c.bg_dark },
    BufferLineBufferVisible     = { fg = c.fg_dim, bg = c.bg_dark },
    BufferLineBufferSelected    = { fg = c.fg, bg = c.bg_light, bold = true },
    BufferLineIndicatorSelected = { fg = c.accent, bg = c.bg_light },
    BufferLineSeparator         = { fg = c.border, bg = c.bg_dark },
    BufferLineSeparatorSelected = { fg = c.border, bg = c.bg_light },
    BufferLineCloseButtonSelected = { fg = c.coral, bg = c.bg_light },

    -- ── lualine (only base; lualine usually themes itself) ────────────────
    -- expose palette via require("one-dark-islands").lualine() instead.

    -- ── flash / leap / hop ────────────────────────────────────────────────
    FlashBackdrop = { fg = c.fg_dim },
    FlashLabel    = { fg = c.bg, bg = c.coral, bold = true },
    FlashMatch    = { fg = c.bg, bg = c.accent },
    LeapBackdrop  = { fg = c.fg_dim },
    LeapMatch     = { fg = c.bg, bg = c.accent, bold = true },
    LeapLabel     = { fg = c.bg, bg = c.coral, bold = true },
    HopNextKey    = { fg = c.coral, bold = true },
    HopNextKey1   = { fg = c.accent, bold = true },
    HopNextKey2   = { fg = c.malibu },
    HopUnmatched  = { fg = c.fg_dim },

    -- ── trouble ───────────────────────────────────────────────────────────
    TroubleNormal     = { fg = c.fg, bg = transparent and c.none or c.bg_dark },
    TroubleText       = { fg = c.fg },
    TroubleCount      = { fg = c.purple, bg = c.bg_light },
    TroubleNormalNC   = { fg = c.fg, bg = transparent and c.none or c.bg_dark },

    -- ── lazy.nvim ─────────────────────────────────────────────────────────
    LazyProgressdone = { fg = c.green, bold = true },
    LazyProgressTodo = { fg = c.fg_dim },
    LazyNormal       = { fg = c.fg, bg = bg_float },
    LazyButton       = { fg = c.fg, bg = c.bg_light },
    LazyButtonActive = { fg = c.bg, bg = c.accent, bold = true },
    LazyH1           = { fg = c.bg, bg = c.accent, bold = true },

    -- ── mason ─────────────────────────────────────────────────────────────
    MasonNormal             = { fg = c.fg, bg = bg_float },
    MasonHeader             = { fg = c.bg, bg = c.accent, bold = true },
    MasonHighlight          = { fg = c.accent },
    MasonHighlightBlock     = { fg = c.bg, bg = c.green },
    MasonHighlightBlockBold = { fg = c.bg, bg = c.green, bold = true },
    MasonMuted              = { fg = c.fg_dim },
    MasonMutedBlock         = { fg = c.fg, bg = c.bg_light },

    -- ── render-markdown.nvim ──────────────────────────────────────────────
    RenderMarkdownCode    = { bg = c.bg_light },
    RenderMarkdownH1Bg    = { bg = c.diff_delete },
    RenderMarkdownH2Bg    = { bg = c.warn_bg },
    RenderMarkdownH3Bg    = { bg = c.diff_add },
    RenderMarkdownBullet  = { fg = c.coral },
    RenderMarkdownCodeInline = { fg = c.fountain_blue, bg = c.bg_light },

    -- ── nvim-dap / dap-ui ─────────────────────────────────────────────────
    DapBreakpoint        = { fg = c.coral },
    DapStopped           = { fg = c.green },
    DapUIValue           = { fg = c.fg },
    DapUIModifiedValue   = { fg = c.chalky, bold = true }, -- changedValueForeground
    DapUIDecoration      = { fg = c.accent },
    DapUIVariable        = { fg = c.coral },
    DapUIScope           = { fg = c.fountain_blue },
    DapUIType            = { fg = c.chalky },
    DapUIThread          = { fg = c.green },
    DapUIStoppedThread   = { fg = c.accent },
  }
end

return M
