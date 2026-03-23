# Spec: Theming System

> Our own base46-inspired theme engine: palette tables → compiled highlight groups

---

## Architecture

```
lua/themes/<n>.lua          ← palette definition (30 named colors + 16 base16)
        │
        ▼
lua/core/highlights.lua     ← reads palette, maps colors → vim highlight groups
        │                      also handles: overrides, transparency, integrations
        ▼
vim.api.nvim_set_hl()       ← applies all groups to Neovim
        │
        ▼
[Plugin configs call]
  highlights.load("telescope")   ← lazy-loads per-plugin highlight groups
```

---

## Theme Palette Format — `lua/themes/<name>.lua`

Every theme file must return this exact structure:

```lua
-- lua/themes/onedark.lua

local M = {}

M.type = "dark"   -- "dark" | "light"

-- 30-color semantic palette (NvChad base30-inspired naming)
M.palette = {
  -- Background shades (dark → light)
  black         = "#1e222a",
  darker_black  = "#1b1f27",
  black2        = "#252931",
  one_bg        = "#282c34",
  one_bg2       = "#353b45",
  one_bg3       = "#373b43",
  line          = "#31353d",

  -- Greys
  grey          = "#42464e",
  grey_fg       = "#565c64",
  grey_fg2      = "#6f737b",
  light_grey    = "#6f737b",

  -- Main foreground
  white         = "#abb2bf",

  -- Accent colors
  red           = "#e06c75",
  baby_pink     = "#DE8C92",
  pink          = "#ff75a0",
  green         = "#98c379",
  vibrant_green = "#7eca9c",
  blue          = "#61afef",
  nord_blue     = "#81A1C1",
  seablue       = "#4fa6ed",
  yellow        = "#e5c07b",
  sun           = "#EBCB8B",
  purple        = "#c678dd",
  dark_purple   = "#c882e7",
  teal          = "#519ABA",
  orange        = "#d19a66",
  cyan          = "#56b6c2",

  -- UI-specific
  statusline_bg = "#22262e",
  lightbg       = "#2d3139",
  pmenu_bg      = "#61afef",
  folder_bg     = "#61afef",
}

-- Statusline style for this theme.
-- The renderer in ui/statusline.lua reads M.statusline to know
-- which separator chars and which highlight slots to use.
M.statusline = {
  -- Separator style: "arrow" | "round" | "block" | "none"
  -- arrow → powerline-style  slanted chevrons
  -- round → curved pill ends
  -- block → hard square edges (no separator glyph, just spacing)
  -- none  → flat, no separators at all
  separator = "arrow",

  -- Mode pill colors  { fg = palette_key, bg = palette_key }
  -- These map onto St_NormalMode, St_InsertMode, etc. highlight groups
  mode_colors = {
    normal   = { fg = "black", bg = "blue" },
    insert   = { fg = "black", bg = "green" },
    visual   = { fg = "black", bg = "purple" },
    replace  = { fg = "black", bg = "orange" },
    command  = { fg = "black", bg = "yellow" },
    terminal = { fg = "black", bg = "green" },
  },
}

-- Base16 palette (used by terminal color schemes + some plugins)
M.base16 = {
  base00 = "#1e222a",   -- default background
  base01 = "#353b45",   -- lighter background
  base02 = "#3e4451",   -- selection background
  base03 = "#545862",   -- comments, invisibles
  base04 = "#565c64",   -- dark foreground (for status bars)
  base05 = "#abb2bf",   -- default foreground
  base06 = "#b6bdca",   -- light foreground
  base07 = "#c8ccd4",   -- lightest foreground
  base08 = "#e06c75",   -- red (variables, xml tags)
  base09 = "#d19a66",   -- orange (integers, booleans)
  base0A = "#e5c07b",   -- yellow (classes, attribute IDs)
  base0B = "#98c379",   -- green (strings)
  base0C = "#56b6c2",   -- cyan (support, escape chars)
  base0D = "#61afef",   -- blue (functions, methods)
  base0E = "#c678dd",   -- purple (keywords, selectors)
  base0F = "#be5046",   -- dark red (deprecated)
}

return M
```

---

## Tokyo Night / Tokyo Storm Theme — `lua/themes/tokyonight.lua`

Based on the Tokyo Storm palette: `#1a1b26` bg · `#24283c` pill · `#bb9af7` purple · `#7aa2f7` blue · `#7dcfb1` teal

```lua
-- lua/themes/tokyonight.lua

local M = {}

M.type = "dark"

M.palette = {
  -- Backgrounds (Tokyo Storm — slightly lighter than Tokyo Night)
  black         = "#1a1b26",   -- main bg
  darker_black  = "#16161e",
  black2        = "#1f2335",
  one_bg        = "#24283c",   -- pill/segment bg
  one_bg2       = "#292e42",
  one_bg3       = "#2f3549",
  line          = "#292e42",

  -- Greys
  grey          = "#3b4261",
  grey_fg       = "#565f89",
  grey_fg2      = "#737aa2",
  light_grey    = "#737aa2",

  -- Main foreground
  white         = "#c0caf5",

  -- Accent colors
  red           = "#f7768e",
  baby_pink     = "#ff9e9e",
  pink          = "#ff007c",
  green         = "#9ece6a",
  vibrant_green = "#73daca",
  blue          = "#7aa2f7",
  nord_blue     = "#2ac3de",
  seablue       = "#7dcfb1",
  yellow        = "#e0af68",
  sun           = "#ff9e64",
  purple        = "#bb9af7",
  dark_purple   = "#9d7cd8",
  teal          = "#7dcfb1",
  orange        = "#ff9e64",
  cyan          = "#2ac3de",

  -- UI-specific
  statusline_bg = "#16161e",
  lightbg       = "#24283c",
  pmenu_bg      = "#7aa2f7",
  folder_bg     = "#7aa2f7",
}

M.base16 = {
  base00 = "#1a1b26", base01 = "#16161e", base02 = "#2f3549", base03 = "#444b6a",
  base04 = "#787c99", base05 = "#a9b1d6", base06 = "#cbccd1", base07 = "#d5d6db",
  base08 = "#c0caf5", base09 = "#a9b1d6", base0A = "#0db9d7", base0B = "#9ece6a",
  base0C = "#b4f9f8", base0D = "#2ac3de", base0E = "#bb9af7", base0F = "#f7768e",
}

-- Statusline: round pill ends, purple/teal/blue mode colors matching the screenshot
M.statusline = {
  separator = "round",
  mode_colors = {
    normal   = { fg = "black2", bg = "purple" },
    insert   = { fg = "black2", bg = "teal" },
    visual   = { fg = "black2", bg = "blue" },
    replace  = { fg = "black2", bg = "red" },
    command  = { fg = "black2", bg = "yellow" },
    terminal = { fg = "black2", bg = "green" },
  },
}

return M
```

---

## How `M.statusline` Drives the Renderer

Each theme's `M.statusline` table is read by `ui/statusline.lua` at highlight-compile time.
This means switching themes automatically repaints the statusline separator style and mode colors.

| Key           | Values                                       | Effect                         |
| ------------- | -------------------------------------------- | ------------------------------ |
| `separator`   | `"arrow"` `"round"` `"block"` `"none"`       | Which glyph separates segments |
| `mode_colors` | `{ fg = "palette_key", bg = "palette_key" }` | Mode pill per-mode colors      |

Palette key strings (e.g. `"purple"`) are resolved to hex at compile time via `M.palette[key]`.

---

```lua
-- lua/core/highlights.lua
-- Reads the active theme palette and applies all highlight groups.

local M = {}
local config = require("core.config")

---@type table  Current active palette
M.palette = {}

-- ── LOAD THEME ───────────────────────────────────────────────────
function M.load(theme_name)
  local ok, theme = pcall(require, "themes." .. theme_name)
  if not ok then
    vim.notify("Theme not found: " .. theme_name, vim.log.levels.WARN)
    return
  end

  M.palette = theme.palette
  M.type    = theme.type
  -- Store statusline style so ui/statusline.lua can read it
  M.statusline = theme.statusline or {
    separator  = "arrow",
    mode_colors = {
      normal   = { fg = "black", bg = "blue" },
      insert   = { fg = "black", bg = "green" },
      visual   = { fg = "black", bg = "purple" },
      replace  = { fg = "black", bg = "orange" },
      command  = { fg = "black", bg = "yellow" },
      terminal = { fg = "black", bg = "green" },
    },
  }

  -- Set base16 terminal colors
  for i, color in ipairs({
    theme.base16.base00, theme.base16.base01,
    theme.base16.base02, theme.base16.base03,
    theme.base16.base04, theme.base16.base05,
    theme.base16.base06, theme.base16.base07,
    theme.base16.base08, theme.base16.base09,
    theme.base16.base0A, theme.base16.base0B,
    theme.base16.base0C, theme.base16.base0D,
    theme.base16.base0E, theme.base16.base0F,
  }) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end

  M.apply_all()
end

-- ── APPLY ALL HIGHLIGHT GROUPS ───────────────────────────────────
function M.apply_all()
  local p    = M.palette
  local hl   = vim.api.nvim_set_hl
  local bg   = config.theme.transparency and "NONE" or p.black

  -- Reset all highlights to start clean
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end
  vim.o.background = M.type

  -- ── EDITOR BASE ──────────────────────────────────────────────
  hl(0, "Normal",       { fg = p.white,      bg = bg })
  hl(0, "NormalFloat",  { fg = p.white,      bg = p.darker_black })
  hl(0, "NormalNC",     { fg = p.white,      bg = bg })
  hl(0, "FloatBorder",  { fg = p.grey_fg,    bg = p.darker_black })
  hl(0, "FloatTitle",   { fg = p.white,      bg = p.darker_black, bold = true })

  hl(0, "CursorLine",   { bg = p.black2 })
  hl(0, "CursorLineNr", { fg = p.white,      bold = true })
  hl(0, "LineNr",       { fg = p.grey })
  hl(0, "SignColumn",   { bg = bg })
  hl(0, "FoldColumn",   { fg = p.grey_fg,    bg = bg })
  hl(0, "Folded",       { fg = p.grey_fg,    bg = p.black2 })

  hl(0, "ColorColumn",  { bg = p.black2 })
  hl(0, "Conceal",      { fg = p.grey_fg })
  hl(0, "NonText",      { fg = p.grey })
  hl(0, "Whitespace",   { fg = p.grey })
  hl(0, "SpecialKey",   { fg = p.grey })
  hl(0, "EndOfBuffer",  { fg = bg })

  -- ── SPLITS & BORDERS ─────────────────────────────────────────
  hl(0, "VertSplit",    { fg = p.line,    bg = bg })
  hl(0, "WinSeparator", { fg = p.line,    bg = bg })

  -- ── SELECTION ────────────────────────────────────────────────
  hl(0, "Visual",    { bg = p.one_bg2 })
  hl(0, "VisualNOS", { bg = p.one_bg2 })

  -- ── SEARCH ───────────────────────────────────────────────────
  hl(0, "Search",    { fg = p.black,  bg = p.yellow })
  hl(0, "IncSearch", { fg = p.black,  bg = p.orange })
  hl(0, "CurSearch", { fg = p.black,  bg = p.orange })

  -- ── MESSAGES ─────────────────────────────────────────────────
  hl(0, "ModeMsg",   { fg = p.green })
  hl(0, "MoreMsg",   { fg = p.green })
  hl(0, "Question",  { fg = p.blue })
  hl(0, "WarningMsg",{ fg = p.yellow })
  hl(0, "ErrorMsg",  { fg = p.red })

  -- ── SYNTAX ───────────────────────────────────────────────────
  hl(0, "Comment",   { fg = p.grey_fg,  italic = true })
  hl(0, "Constant",  { fg = p.cyan })
  hl(0, "String",    { fg = p.green })
  hl(0, "Character", { fg = p.green })
  hl(0, "Number",    { fg = p.orange })
  hl(0, "Boolean",   { fg = p.orange })
  hl(0, "Float",     { fg = p.orange })
  hl(0, "Identifier",{ fg = p.red })
  hl(0, "Function",  { fg = p.blue })
  hl(0, "Statement", { fg = p.purple })
  hl(0, "Keyword",   { fg = p.purple,   italic = true })
  hl(0, "Operator",  { fg = p.cyan })
  hl(0, "Type",      { fg = p.yellow })
  hl(0, "Special",   { fg = p.orange })
  hl(0, "Underlined",{ underline = true })
  hl(0, "Error",     { fg = p.red })
  hl(0, "Todo",      { fg = p.black,    bg = p.yellow, bold = true })

  -- ── LSP DIAGNOSTICS ──────────────────────────────────────────
  local icons = require("core.config").lsp.icons
  hl(0, "DiagnosticError",          { fg = p.red })
  hl(0, "DiagnosticWarn",           { fg = p.yellow })
  hl(0, "DiagnosticHint",           { fg = p.vibrant_green })
  hl(0, "DiagnosticInfo",           { fg = p.blue })
  hl(0, "DiagnosticVirtualTextError",{ fg = p.red,    bg = "#2d2226", italic = true })
  hl(0, "DiagnosticVirtualTextWarn", { fg = p.yellow, bg = "#2d2b20", italic = true })
  hl(0, "DiagnosticVirtualTextHint", { fg = p.vibrant_green, italic = true })
  hl(0, "DiagnosticVirtualTextInfo", { fg = p.blue,   italic = true })
  hl(0, "DiagnosticUnderlineError", { sp = p.red,    undercurl = true })
  hl(0, "DiagnosticUnderlineWarn",  { sp = p.yellow, undercurl = true })
  hl(0, "DiagnosticUnderlineHint",  { sp = p.vibrant_green, undercurl = true })
  hl(0, "DiagnosticUnderlineInfo",  { sp = p.blue,   undercurl = true })

  -- Diagnostic sign icons
  for severity, icon in pairs(icons) do
    local name = "DiagnosticSign" .. severity
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  end

  -- ── COMPLETION MENU ──────────────────────────────────────────
  hl(0, "Pmenu",      { fg = p.white,    bg = p.one_bg })
  hl(0, "PmenuSel",   { fg = p.black,    bg = p.pmenu_bg, bold = true })
  hl(0, "PmenuSbar",  { bg = p.one_bg2 })
  hl(0, "PmenuThumb", { bg = p.grey })

  -- ── STATUSLINE (transparent background) ──────────────────────────
  -- bg = "NONE" on every group → items float on editor background.
  -- Mode colors still come from theme's M.statusline.mode_colors.
  -- Each mode gets TWO groups:
  --   [mode]       → the pill itself  (colored bg, for the label text)
  --   [mode]_Icon  → the 󰣩 icon before the pill (fg = pill color, bg = NONE)
  local mc = M.statusline.mode_colors
  local function pc(key) return p[key] or key end

  hl(0, "StatusLine",   { fg = p.white, bg = "NONE" })
  hl(0, "StatusLineNC", { fg = p.grey,  bg = "NONE" })
  hl(0, "St_Base",      { fg = p.white, bg = "NONE" })

  local modes = {
    { hl = "St_NormalMode",   mc = mc.normal   },
    { hl = "St_InsertMode",   mc = mc.insert   },
    { hl = "St_VisualMode",   mc = mc.visual   },
    { hl = "St_ReplaceMode",  mc = mc.replace  },
    { hl = "St_CommandMode",  mc = mc.command  },
    { hl = "St_TerminalMode", mc = mc.terminal },
  }
  for _, m in ipairs(modes) do
    -- Pill: colored bg for the label
    hl(0, m.hl,           { fg = pc(m.mc.fg), bg = pc(m.mc.bg), bold = true })
    -- Icon: same color as pill bg, transparent bg — icon "attaches" to pill visually
    hl(0, m.hl .. "_Icon",{ fg = pc(m.mc.bg), bg = "NONE" })
  end

  -- File
  hl(0, "St_FileIcon",  { fg = p.blue,          bg = "NONE" })  -- devicons overrides
  hl(0, "St_FileName",  { fg = p.white,          bg = "NONE", bold = true })
  hl(0, "St_Modified",  { fg = p.yellow,         bg = "NONE" })
  hl(0, "St_Readonly",  { fg = p.red,            bg = "NONE" })

  -- Git
  hl(0, "St_GitBranch", { fg = p.purple,         bg = "NONE" })
  hl(0, "St_GitAdded",  { fg = p.green,          bg = "NONE" })
  hl(0, "St_GitChanged",{ fg = p.blue,           bg = "NONE" })
  hl(0, "St_GitRemoved",{ fg = p.red,            bg = "NONE" })

  -- Diagnostics (statusline-specific, separate from buffer diagnostics)
  hl(0, "St_DiagError", { fg = p.red,            bg = "NONE" })
  hl(0, "St_DiagWarn",  { fg = p.yellow,         bg = "NONE" })
  hl(0, "St_DiagHint",  { fg = p.vibrant_green,  bg = "NONE" })
  hl(0, "St_DiagInfo",  { fg = p.blue,           bg = "NONE" })

  -- Encoding
  hl(0, "St_Encoding",  { fg = p.grey_fg,        bg = "NONE" })

  -- LSP
  hl(0, "St_LspIcon",   { fg = p.green,          bg = "NONE" })
  hl(0, "St_LspName",   { fg = p.green,          bg = "NONE" })

  -- Filetype
  hl(0, "St_FtIcon",    { fg = p.blue,           bg = "NONE" })  -- devicons overrides
  hl(0, "St_FtName",    { fg = p.grey_fg,        bg = "NONE" })

  -- Position
  hl(0, "St_PosIcon",      { fg = p.blue,    bg = "NONE" })
  hl(0, "St_Pos",          { fg = p.white,   bg = "NONE" })

  -- Progress (between filetype and position)
  hl(0, "St_ProgressIcon", { fg = p.grey_fg, bg = "NONE" })
  hl(0, "St_Progress",     { fg = p.grey_fg, bg = "NONE" })

  -- Special windows (nvim-tree, quickfix, help, lazy, mason)
  hl(0, "St_NvimTreeSt",   { fg = p.grey_fg, bg = "NONE", italic = true })
  hl(0, "St_SpecialSt",    { fg = p.grey_fg, bg = "NONE", italic = true })

  -- ── INDENT GUIDES ─────────────────────────────────────────────
  hl(0, "IblIndent",  { fg = p.line })
  hl(0, "IblScope",   { fg = p.grey })

  -- ── GIT SIGNS ─────────────────────────────────────────────────
  hl(0, "GitSignsAdd",    { fg = p.green })
  hl(0, "GitSignsChange", { fg = p.blue })
  hl(0, "GitSignsDelete", { fg = p.red })

  -- Apply user overrides from config
  M.apply_overrides()
end

-- ── USER OVERRIDES ────────────────────────────────────────────────
function M.apply_overrides()
  local overrides = require("core.config").theme.overrides or {}
  for group, opts in pairs(overrides) do
    -- Replace palette color names with hex values
    local resolved = {}
    for k, v in pairs(opts) do
      resolved[k] = M.palette[v] or v
    end
    vim.api.nvim_set_hl(0, group, resolved)
  end
end

-- ── INTEGRATION LOADER (per-plugin highlight groups) ──────────────
-- Plugins call this to load their own highlight groups lazily.
-- Pattern mirrors NvChad's dofile(vim.g.base46_cache .. "telescope")
---@param name string  e.g. "telescope", "nvimtree", "cmp"
function M.load_integration(name)
  local ok, integration = pcall(require, "core.integrations." .. name)
  if ok and type(integration) == "function" then
    integration(M.palette)
  end
end

-- ── THEME PICKER (via vim.ui.select) ──────────────────────────────
function M.pick_theme()
  local themes = vim.fn.globpath(
    vim.fn.stdpath("config") .. "/lua/themes", "*.lua", false, true
  )
  local names = vim.tbl_map(function(f)
    return vim.fn.fnamemodify(f, ":t:r")
  end, themes)

  vim.ui.select(names, { prompt = "Select theme: " }, function(choice)
    if choice then
      require("core.config").theme.name = choice
      M.load(choice)
      vim.notify("Theme: " .. choice, vim.log.levels.INFO)
    end
  end)
end

-- ── TOGGLE DARK / LIGHT ───────────────────────────────────────────
function M.toggle()
  local cfg     = require("core.config").theme
  local current = cfg.name
  local next    = (current == cfg.toggle_dark) and cfg.toggle_light or cfg.toggle_dark
  cfg.name = next
  M.load(next)
end

-- ── SETUP (called from init.lua) ─────────────────────────────────
function M.setup()
  M.load(require("core.config").theme.name)
end

return M
```

---

## Integration Files — `lua/core/integrations/<plugin>.lua`

Each integration file is a function that receives the active palette and sets
plugin-specific highlight groups. This mirrors NvChad's per-integration bytecode files.

**Example: `lua/core/integrations/telescope.lua`**

```lua
-- lua/core/integrations/telescope.lua
return function(p)
  local hl = vim.api.nvim_set_hl
  hl(0, "TelescopeBorder",         { fg = p.darker_black, bg = p.darker_black })
  hl(0, "TelescopePromptBorder",   { fg = p.black2,       bg = p.black2 })
  hl(0, "TelescopePromptNormal",   { fg = p.white,        bg = p.black2 })
  hl(0, "TelescopePromptPrefix",   { fg = p.red,          bg = p.black2 })
  hl(0, "TelescopeNormal",         { bg = p.darker_black })
  hl(0, "TelescopePreviewTitle",   { fg = p.black,        bg = p.green })
  hl(0, "TelescopePromptTitle",    { fg = p.black,        bg = p.red })
  hl(0, "TelescopeResultsTitle",   { fg = p.darker_black, bg = p.darker_black })
  hl(0, "TelescopeSelection",      { bg = p.black2,       fg = p.white })
  hl(0, "TelescopeSelectionCaret", { fg = p.red,          bg = p.black2 })
  hl(0, "TelescopeMatching",       { fg = p.blue,         bold = true })
end
```

**`lua/core/integrations/nvimtree.lua`** — transparent sidebar background

```lua
-- lua/core/integrations/nvimtree.lua
-- ALL bg values must be "NONE" for true transparency.
-- If any group keeps a solid bg color it will paint over the editor background.
return function(p)
  local hl = vim.api.nvim_set_hl

  -- ── CORE WINDOW ─────────────────────────────────────────────
  hl(0, "NvimTreeNormal",          { fg = p.white,   bg = "NONE" })
  hl(0, "NvimTreeNormalNC",        { fg = p.grey_fg, bg = "NONE" }) -- inactive window
  hl(0, "NvimTreeEndOfBuffer",     { fg = "NONE",    bg = "NONE" }) -- hides trailing ~
  hl(0, "NvimTreeWinSeparator",    { fg = p.line,    bg = "NONE" }) -- border between panes

  -- ── ROOT FOLDER HEADER ───────────────────────────────────────
  hl(0, "NvimTreeRootFolder",      { fg = p.blue,    bold = true })

  -- ── FILES & FOLDERS ─────────────────────────────────────────
  hl(0, "NvimTreeFolderIcon",      { fg = p.folder_bg })
  hl(0, "NvimTreeFolderName",      { fg = p.white })
  hl(0, "NvimTreeOpenedFolderName",{ fg = p.white,   bold = true })
  hl(0, "NvimTreeEmptyFolderName", { fg = p.grey_fg })
  hl(0, "NvimTreeFileName",        { fg = p.white })
  hl(0, "NvimTreeOpenedFile",      { fg = p.white,   bold = true })
  hl(0, "NvimTreeSpecialFile",     { fg = p.yellow,  underline = true })
  hl(0, "NvimTreeImageFile",       { fg = p.purple })
  hl(0, "NvimTreeExecFile",        { fg = p.green,   bold = true })
  hl(0, "NvimTreeSymlink",         { fg = p.cyan })
  hl(0, "NvimTreeSymlinkIcon",     { fg = p.cyan })

  -- ── CURSOR LINE ──────────────────────────────────────────────
  -- Subtle highlight so selection is visible without a solid block
  hl(0, "NvimTreeCursorLine",      { bg = p.one_bg })

  -- ── GIT STATUS DECORATIONS ──────────────────────────────────
  hl(0, "NvimTreeGitNew",          { fg = p.green })
  hl(0, "NvimTreeGitDirty",        { fg = p.yellow })
  hl(0, "NvimTreeGitDeleted",      { fg = p.red })
  hl(0, "NvimTreeGitStaged",       { fg = p.green })
  hl(0, "NvimTreeGitMerge",        { fg = p.orange })
  hl(0, "NvimTreeGitRenamed",      { fg = p.blue })
  hl(0, "NvimTreeGitIgnored",      { fg = p.grey_fg })

  -- ── INDENT MARKERS ───────────────────────────────────────────
  hl(0, "NvimTreeIndentMarker",    { fg = p.grey })

  -- ── LIVE FILTER ──────────────────────────────────────────────
  hl(0, "NvimTreeLiveFilterPrefix",{ fg = p.purple, bold = true })
  hl(0, "NvimTreeLiveFilterValue", { fg = p.white,  bold = true })
end
```

**Integrations to create** (one file each):

- `telescope.lua`
- `nvimtree.lua`
- `cmp.lua`
- `mason.lua`
- `whichkey.lua`
- `gitsigns.lua`
- `treesitter.lua`
- `blankline.lua`
- `dashboard.lua`
- `statusline.lua`

---

## Adding a New Theme

1. Copy `lua/themes/onedark.lua` to `lua/themes/mytheme.lua`
2. Replace all hex values with your own colors
3. Set `M.type = "dark"` or `"light"`
4. In config.lua: `M.theme.name = "mytheme"`
5. Restart or run `:lua require("core.highlights").load("mytheme")`

---

## Cursor Instructions

- `M.apply_all()` must call `vim.cmd("highlight clear")` first — otherwise old groups linger
- Integration files receive the **palette table**, not the full theme module
- `M.load_integration(name)` is called from each plugin's `config` function —
  not at startup. This keeps startup fast (same principle as NvChad's base46 cache).
- All color values passed to `nvim_set_hl` must be hex strings (`"#rrggbb"`) or omitted
- Transparency: when `config.theme.transparency = true`, replace `bg = p.black` with `bg = "NONE"`
  wherever it appears as a window background
