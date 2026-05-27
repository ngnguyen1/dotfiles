-- islands-dark: plugin highlight groups
-- VS Code UI color keys mapped to Neovim plugin groups where they correspond.

local M = {}

function M.get(c, opts)
  opts = opts or {}
  local transparent = opts.transparent or false
  local bg_sidebar  = transparent and c.none or c.bg_darker   -- elevated sidebar (recessed bg)
  local bg_float    = transparent and c.none or c.bg_panel    -- editorWidget / suggest
  local bg_tabs     = c.bg_darker                              -- editorGroupHeader

  return {
    -- ── Treesitter context ────────────────────────────────────────────────
    TreesitterContext           = { bg = c.bg_hover },         -- stickyScrollHover
    TreesitterContextLineNumber = { fg = c.blue, bg = c.bg_hover },
    TreesitterContextBottom     = { underline = true, sp = c.border_subtle },

    -- ── nvim-cmp / blink.cmp (editorSuggestWidget) ────────────────────────
    -- suggest bg = #2b2d30, selected bg = #25324d, highlight fg = #548af7
    CmpItemAbbr             = { fg = c.fg },
    CmpItemAbbrDeprecated   = { fg = c.warning, strikethrough = true },
    CmpItemAbbrMatch        = { fg = c.blue, bold = true },
    CmpItemAbbrMatchFuzzy   = { fg = c.blue, bold = true },
    CmpItemMenu             = { fg = c.fg_dim },
    CmpItemKindText         = { fg = c.green },
    CmpItemKindMethod       = { fg = c.blue_fn },
    CmpItemKindFunction     = { fg = c.blue_fn },
    CmpItemKindConstructor  = { fg = c.magenta },
    CmpItemKindField        = { fg = c.magenta },
    CmpItemKindVariable     = { fg = c.fg },
    CmpItemKindClass        = { fg = c.magenta },
    CmpItemKindInterface    = { fg = c.magenta },
    CmpItemKindModule       = { fg = c.magenta },
    CmpItemKindProperty     = { fg = c.magenta },
    CmpItemKindKeyword      = { fg = c.orange },
    CmpItemKindSnippet      = { fg = c.cyan },
    CmpItemKindConstant     = { fg = c.magenta },
    CmpItemKindEnum         = { fg = c.magenta },
    CmpItemKindEnumMember   = { fg = c.magenta },
    CmpItemKindOperator     = { fg = c.fg },
    CmpItemKindTypeParameter= { fg = c.magenta },
    BlinkCmpMenu            = { fg = c.fg, bg = c.bg_panel },
    BlinkCmpMenuBorder      = { fg = c.border, bg = c.bg_panel },
    BlinkCmpMenuSelection   = { bg = c.bg_selected, bold = true },
    BlinkCmpLabelMatch      = { fg = c.blue, bold = true },
    BlinkCmpKind            = { fg = c.cyan },
    BlinkCmpDoc             = { fg = c.fg, bg = c.bg_panel },
    BlinkCmpDocBorder       = { fg = c.border, bg = c.bg_panel },

    -- ── Telescope (quickInput + editorSuggestWidget palette) ─────────────
    TelescopeNormal          = { fg = c.fg, bg = bg_float },
    TelescopeBorder          = { fg = c.border, bg = bg_float },
    TelescopeTitle           = { fg = c.blue, bold = true },
    TelescopePromptNormal    = { fg = c.fg, bg = c.bg },        -- quickInput.background
    TelescopePromptBorder    = { fg = c.bg, bg = c.bg },
    TelescopePromptTitle     = { fg = c.bg, bg = c.blue, bold = true },
    TelescopePromptPrefix    = { fg = c.blue },
    TelescopePromptCounter   = { fg = c.fg_dim },
    TelescopeResultsNormal   = { fg = c.fg, bg = bg_float },
    TelescopeResultsBorder   = { fg = c.bg_panel, bg = bg_float },
    TelescopeResultsTitle    = { fg = bg_float, bg = bg_float },
    TelescopePreviewNormal   = { fg = c.fg, bg = bg_float },
    TelescopePreviewBorder   = { fg = c.bg_panel, bg = bg_float },
    TelescopePreviewTitle    = { fg = c.bg, bg = c.green_vivid, bold = true },
    TelescopeSelection       = { fg = c.fg, bg = c.bg_selected }, -- quickInputList.focus
    TelescopeSelectionCaret  = { fg = c.blue, bg = c.bg_selected },
    TelescopeMultiSelection  = { fg = c.magenta },
    TelescopeMatching        = { fg = c.blue, bold = true },      -- list.highlightForeground

    -- ── NvimTree (sideBar palette) ────────────────────────────────────────
    NvimTreeNormal            = { fg = c.fg, bg = bg_sidebar },
    NvimTreeNormalNC          = { fg = c.fg, bg = bg_sidebar },
    NvimTreeEndOfBuffer       = { fg = bg_sidebar, bg = bg_sidebar },
    NvimTreeRootFolder        = { fg = c.magenta, bold = true },
    NvimTreeFolderName        = { fg = c.fg },
    NvimTreeFolderIcon        = { fg = c.blue },
    NvimTreeOpenedFolderName  = { fg = c.fg, bold = true },
    NvimTreeOpenedFile        = { fg = c.fg },
    NvimTreeEmptyFolderName   = { fg = c.fg_dim },
    NvimTreeSymlink           = { fg = c.cyan },
    NvimTreeSpecialFile       = { fg = c.warning, underline = true },
    NvimTreeImageFile         = { fg = c.magenta },
    NvimTreeExecFile          = { fg = c.green_vivid },
    NvimTreeIndentMarker      = { fg = c.border_dim },           -- tree.indentGuidesStroke
    NvimTreeWinSeparator      = { fg = c.border, bg = c.bg },
    NvimTreeGitDirty          = { fg = c.blue },                 -- modifiedResource
    NvimTreeGitNew            = { fg = c.green_vivid },          -- untrackedResource
    NvimTreeGitDeleted        = { fg = c.error },
    NvimTreeGitStaged         = { fg = c.green_vivid },
    NvimTreeGitMerge          = { fg = c.warning },              -- conflictingResource
    NvimTreeGitIgnored        = { fg = c.fg_muted },
    NvimTreeGitRenamed        = { fg = c.cyan },
    NvimTreeCursorLine        = { bg = c.bg_hover },             -- list.hoverBackground

    -- ── neo-tree ──────────────────────────────────────────────────────────
    NeoTreeNormal             = { fg = c.fg, bg = bg_sidebar },
    NeoTreeNormalNC           = { fg = c.fg, bg = bg_sidebar },
    NeoTreeDirectoryName      = { fg = c.fg },
    NeoTreeDirectoryIcon      = { fg = c.blue },
    NeoTreeRootName           = { fg = c.magenta, bold = true },
    NeoTreeGitAdded           = { fg = c.green_vivid },
    NeoTreeGitModified        = { fg = c.blue },
    NeoTreeGitDeleted         = { fg = c.error },
    NeoTreeGitConflict        = { fg = c.warning },
    NeoTreeGitIgnored         = { fg = c.fg_muted },
    NeoTreeGitUntracked       = { fg = c.green_vivid },
    NeoTreeIndentMarker       = { fg = c.border_dim },
    NeoTreeWinSeparator       = { fg = bg_sidebar, bg = bg_sidebar },

    -- ── gitsigns (editorGutter / minimapGutter colors) ───────────────────
    GitSignsAdd       = { fg = c.green_vivid },                  -- editorGutter.added
    GitSignsChange    = { fg = c.blue },                         -- editorGutter.modified
    GitSignsDelete    = { fg = c.error },                        -- editorGutter.deleted
    GitSignsAddNr     = { fg = c.green_vivid },
    GitSignsChangeNr  = { fg = c.blue },
    GitSignsDeleteNr  = { fg = c.error },
    GitSignsAddLn     = { bg = c.diff_add_line },
    GitSignsChangeLn  = { bg = c.bg_selected },
    GitSignsDeleteLn  = { bg = c.diff_del_line },
    GitSignsCurrentLineBlame = { fg = c.fg_dim, italic = true },

    -- ── which-key ─────────────────────────────────────────────────────────
    WhichKey          = { fg = c.blue },
    WhichKeyGroup     = { fg = c.magenta },
    WhichKeyDesc      = { fg = c.fg },
    WhichKeySeparator = { fg = c.fg_dim },
    WhichKeyFloat     = { bg = bg_float },
    WhichKeyBorder    = { fg = c.border, bg = bg_float },
    WhichKeyValue     = { fg = c.fg_dim },

    -- ── indent-blankline v3 (editorIndentGuide colors) ───────────────────
    IblIndent     = { fg = c.border_dim },
    IblWhitespace = { fg = c.border_dim },
    IblScope      = { fg = c.border },                            -- activeBackground

    -- ── mini.indentscope ──────────────────────────────────────────────────
    MiniIndentscopeSymbol = { fg = c.border },
    MiniIndentscopePrefix = { nocombine = true },

    -- ── dashboard / alpha / starter ──────────────────────────────────────
    DashboardHeader   = { fg = c.blue },
    DashboardFooter   = { fg = c.fg_dim },
    DashboardCenter   = { fg = c.fg },
    DashboardShortCut = { fg = c.magenta },
    DashboardKey      = { fg = c.orange },
    AlphaHeader       = { fg = c.blue },
    AlphaButtons      = { fg = c.fg },
    AlphaShortcut     = { fg = c.magenta },
    AlphaFooter       = { fg = c.fg_dim },

    -- ── notify (notifications palette) ───────────────────────────────────
    NotifyERRORBorder = { fg = c.error },     NotifyERRORIcon = { fg = c.error },
    NotifyERRORTitle  = { fg = c.error },
    NotifyWARNBorder  = { fg = c.warning },   NotifyWARNIcon  = { fg = c.warning },
    NotifyWARNTitle   = { fg = c.warning },
    NotifyINFOBorder  = { fg = c.info },      NotifyINFOIcon  = { fg = c.info },
    NotifyINFOTitle   = { fg = c.info },
    NotifyDEBUGBorder = { fg = c.fg_dim },    NotifyDEBUGIcon = { fg = c.fg_dim },
    NotifyTRACEBorder = { fg = c.magenta },   NotifyTRACEIcon = { fg = c.magenta },

    -- ── bufferline (tab palette) ─────────────────────────────────────────
    BufferLineFill              = { bg = bg_tabs },
    BufferLineBackground        = { fg = c.fg_dim, bg = bg_tabs },     -- inactive
    BufferLineBufferVisible     = { fg = c.fg_dim, bg = bg_tabs },
    BufferLineBufferSelected    = { fg = c.fg, bg = c.bg, bold = true },
    BufferLineIndicatorSelected = { fg = c.blue, bg = c.bg },
    BufferLineSeparator         = { fg = c.border_tab, bg = bg_tabs },
    BufferLineSeparatorSelected = { fg = c.border_tab, bg = c.bg },
    BufferLineSeparatorVisible  = { fg = c.border_tab, bg = bg_tabs },
    BufferLineCloseButton       = { fg = c.fg_dim, bg = bg_tabs },
    BufferLineCloseButtonSelected = { fg = c.error, bg = c.bg },
    BufferLineCloseButtonVisible  = { fg = c.fg_dim, bg = bg_tabs },
    BufferLineModified          = { fg = c.blue, bg = bg_tabs },
    BufferLineModifiedSelected  = { fg = c.blue, bg = c.bg },
    BufferLineModifiedVisible   = { fg = c.blue, bg = bg_tabs },

    -- ── flash / leap / hop ────────────────────────────────────────────────
    FlashBackdrop = { fg = c.fg_dim },
    FlashLabel    = { fg = c.bg, bg = c.orange, bold = true },
    FlashMatch    = { fg = c.bg, bg = c.blue },
    LeapBackdrop  = { fg = c.fg_dim },
    LeapMatch     = { fg = c.bg, bg = c.blue, bold = true },
    LeapLabel     = { fg = c.bg, bg = c.orange, bold = true },
    HopNextKey    = { fg = c.orange, bold = true },
    HopNextKey1   = { fg = c.blue, bold = true },
    HopNextKey2   = { fg = c.blue_fn },
    HopUnmatched  = { fg = c.fg_dim },

    -- ── trouble ───────────────────────────────────────────────────────────
    TroubleNormal     = { fg = c.fg, bg = bg_sidebar },
    TroubleText       = { fg = c.fg },
    TroubleCount      = { fg = c.magenta, bg = c.bg_panel },
    TroubleNormalNC   = { fg = c.fg, bg = bg_sidebar },

    -- ── lazy.nvim ─────────────────────────────────────────────────────────
    LazyProgressdone = { fg = c.green_vivid, bold = true },
    LazyProgressTodo = { fg = c.fg_dim },
    LazyNormal       = { fg = c.fg, bg = bg_float },
    LazyButton       = { fg = c.fg, bg = c.bg_panel },
    LazyButtonActive = { fg = c.bg, bg = c.blue, bold = true },
    LazyH1           = { fg = c.bg, bg = c.blue, bold = true },

    -- ── mason ─────────────────────────────────────────────────────────────
    MasonNormal             = { fg = c.fg, bg = bg_float },
    MasonHeader             = { fg = c.bg, bg = c.blue, bold = true },
    MasonHighlight          = { fg = c.blue },
    MasonHighlightBlock     = { fg = c.bg, bg = c.green_vivid },
    MasonHighlightBlockBold = { fg = c.bg, bg = c.green_vivid, bold = true },
    MasonMuted              = { fg = c.fg_dim },
    MasonMutedBlock         = { fg = c.fg, bg = c.bg_panel },

    -- ── render-markdown.nvim ──────────────────────────────────────────────
    RenderMarkdownCode    = { bg = c.bg_lighter },
    RenderMarkdownH1Bg    = { bg = c.diff_del_line },
    RenderMarkdownH2Bg    = { bg = c.diff_add_line },
    RenderMarkdownH3Bg    = { bg = c.bg_panel },
    RenderMarkdownBullet  = { fg = c.orange },
    RenderMarkdownCodeInline = { fg = c.green, bg = c.bg_lighter },

    -- ── nvim-dap / dap-ui (debugTokenExpression palette) ──────────────────
    DapBreakpoint        = { fg = c.error },
    DapStopped           = { fg = c.green_vivid },
    DapUIValue           = { fg = c.green },                      -- value: #6aab73
    DapUIModifiedValue   = { fg = c.warning, bold = true },
    DapUIDecoration      = { fg = c.blue },
    DapUIVariable        = { fg = c.magenta },                    -- name: #c77dbb
    DapUIScope           = { fg = c.cyan },                       -- number-like
    DapUIType            = { fg = c.magenta },
    DapUIThread          = { fg = c.green_vivid },
    DapUIStoppedThread   = { fg = c.blue },
    DapUIWatchesEmpty    = { fg = c.fg_dim },
    DapUIWatchesValue    = { fg = c.green_vivid },
    DapUIWatchesError    = { fg = c.error },                      -- error: #f75464
    DapUIBreakpointsPath = { fg = c.blue_fn },
    DapUIBreakpointsInfo = { fg = c.cyan },
  }
end

return M
