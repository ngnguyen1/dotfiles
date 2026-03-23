-- lua/core/highlights.lua
-- Reads the active theme palette and applies all highlight groups.

local M = {}
local config = require("core.config")

---@type table Current active palette
M.palette = {}
M.statusline = {
  separator = "arrow",
  mode_colors = {
    normal = { fg = "black", bg = "blue" },
    insert = { fg = "black", bg = "green" },
    visual = { fg = "black", bg = "purple" },
    replace = { fg = "black", bg = "orange" },
    command = { fg = "black", bg = "yellow" },
    terminal = { fg = "black", bg = "green" },
  },
}

-- -- LOAD THEME ---------------------------------------------------
function M.load(theme_name)
  local ok, theme = pcall(require, "themes." .. theme_name)
  if not ok then
    vim.notify("Theme not found: " .. theme_name, vim.log.levels.WARN)
    return
  end

  M.palette = theme.palette
  M.type = theme.type
  M.statusline = vim.tbl_deep_extend("force", {
    separator = "arrow",
    mode_colors = {
      normal = { fg = "black", bg = "blue" },
      insert = { fg = "black", bg = "green" },
      visual = { fg = "black", bg = "purple" },
      replace = { fg = "black", bg = "orange" },
      command = { fg = "black", bg = "yellow" },
      terminal = { fg = "black", bg = "green" },
    },
  }, theme.statusline or {})

  -- Set base16 terminal colors
  for i, color in ipairs({
    theme.base16.base00,
    theme.base16.base01,
    theme.base16.base02,
    theme.base16.base03,
    theme.base16.base04,
    theme.base16.base05,
    theme.base16.base06,
    theme.base16.base07,
    theme.base16.base08,
    theme.base16.base09,
    theme.base16.base0A,
    theme.base16.base0B,
    theme.base16.base0C,
    theme.base16.base0D,
    theme.base16.base0E,
    theme.base16.base0F,
  }) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end

  M.apply_all()
  vim.g.colors_name = theme_name
end

-- -- APPLY ALL HIGHLIGHT GROUPS -----------------------------------
function M.apply_all()
  local p = M.palette
  local hl = vim.api.nvim_set_hl
  local bg = config.theme.transparency and "NONE" or p.black

  -- Reset all highlights to start clean
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.o.background = M.type

  -- -- EDITOR BASE ----------------------------------------------
  hl(0, "Normal", { fg = p.white, bg = bg })
  hl(0, "NormalFloat", { fg = p.white, bg = p.darker_black })
  hl(0, "NormalNC", { fg = p.white, bg = bg })
  hl(0, "FloatBorder", { fg = p.grey_fg, bg = p.darker_black })
  hl(0, "FloatTitle", { fg = p.white, bg = p.darker_black, bold = true })

  hl(0, "CursorLine", { bg = p.black2 })
  hl(0, "CursorLineNr", { fg = p.white, bold = true })
  hl(0, "LineNr", { fg = p.grey })
  hl(0, "SignColumn", { bg = bg })
  hl(0, "FoldColumn", { fg = p.grey_fg, bg = bg })
  hl(0, "Folded", { fg = p.grey_fg, bg = p.black2 })

  hl(0, "ColorColumn", { bg = p.black2 })
  hl(0, "Conceal", { fg = p.grey_fg })
  hl(0, "NonText", { fg = p.grey })
  hl(0, "Whitespace", { fg = p.grey })
  hl(0, "SpecialKey", { fg = p.grey })
  hl(0, "EndOfBuffer", { fg = bg })

  -- -- SPLITS & BORDERS -----------------------------------------
  hl(0, "VertSplit", { fg = p.line, bg = bg })
  hl(0, "WinSeparator", { fg = p.line, bg = bg })

  -- -- SELECTION ------------------------------------------------
  hl(0, "Visual", { bg = p.one_bg2 })
  hl(0, "VisualNOS", { bg = p.one_bg2 })

  -- -- SEARCH ---------------------------------------------------
  hl(0, "Search", { fg = p.black, bg = p.yellow })
  hl(0, "IncSearch", { fg = p.black, bg = p.orange })
  hl(0, "CurSearch", { fg = p.black, bg = p.orange })

  -- -- MESSAGES -------------------------------------------------
  hl(0, "ModeMsg", { fg = p.green })
  hl(0, "MoreMsg", { fg = p.green })
  hl(0, "Question", { fg = p.blue })
  hl(0, "WarningMsg", { fg = p.yellow })
  hl(0, "ErrorMsg", { fg = p.red })

  -- -- SYNTAX ---------------------------------------------------
  hl(0, "Comment", { fg = p.grey_fg, italic = true })
  hl(0, "Constant", { fg = p.cyan })
  hl(0, "String", { fg = p.green })
  hl(0, "Character", { fg = p.green })
  hl(0, "Number", { fg = p.orange })
  hl(0, "Boolean", { fg = p.orange })
  hl(0, "Float", { fg = p.orange })
  hl(0, "Identifier", { fg = p.red })
  hl(0, "Function", { fg = p.blue })
  hl(0, "Statement", { fg = p.purple })
  hl(0, "Keyword", { fg = p.purple, italic = true })
  hl(0, "Operator", { fg = p.cyan })
  hl(0, "Type", { fg = p.yellow })
  hl(0, "Special", { fg = p.orange })
  hl(0, "Underlined", { underline = true })
  hl(0, "Error", { fg = p.red })
  hl(0, "Todo", { fg = p.black, bg = p.yellow, bold = true })

  -- -- LSP DIAGNOSTICS ------------------------------------------
  hl(0, "DiagnosticError", { fg = p.red })
  hl(0, "DiagnosticWarn", { fg = p.yellow })
  hl(0, "DiagnosticHint", { fg = p.vibrant_green })
  hl(0, "DiagnosticInfo", { fg = p.blue })
  hl(0, "DiagnosticVirtualTextError", { fg = p.red, bg = "#2d2226", italic = true })
  hl(0, "DiagnosticVirtualTextWarn", { fg = p.yellow, bg = "#2d2b20", italic = true })
  hl(0, "DiagnosticVirtualTextHint", { fg = p.vibrant_green, italic = true })
  hl(0, "DiagnosticVirtualTextInfo", { fg = p.blue, italic = true })
  hl(0, "DiagnosticUnderlineError", { sp = p.red, undercurl = true })
  hl(0, "DiagnosticUnderlineWarn", { sp = p.yellow, undercurl = true })
  hl(0, "DiagnosticUnderlineHint", { sp = p.vibrant_green, undercurl = true })
  hl(0, "DiagnosticUnderlineInfo", { sp = p.blue, undercurl = true })

  -- -- COMPLETION MENU ------------------------------------------
  hl(0, "Pmenu", { fg = p.white, bg = p.one_bg })
  hl(0, "PmenuSel", { fg = p.black, bg = p.pmenu_bg, bold = true })
  hl(0, "PmenuSbar", { bg = p.one_bg2 })
  hl(0, "PmenuThumb", { bg = p.grey })

  -- -- STATUSLINE -----------------------------------------------
  local mc = M.statusline.mode_colors or {}
  local function pc(value, fallback)
    local candidate = value or fallback
    return p[candidate] or candidate
  end

  hl(0, "StatusLine", { fg = p.white, bg = "NONE" })
  hl(0, "StatusLineNC", { fg = p.grey, bg = "NONE" })
  hl(0, "St_Base", { fg = p.white, bg = "NONE" })

  local modes = {
    { name = "Normal", key = "normal", default_fg = "black", default_bg = "blue" },
    { name = "Insert", key = "insert", default_fg = "black", default_bg = "green" },
    { name = "Visual", key = "visual", default_fg = "black", default_bg = "purple" },
    { name = "Replace", key = "replace", default_fg = "black", default_bg = "orange" },
    { name = "Command", key = "command", default_fg = "black", default_bg = "yellow" },
    { name = "Terminal", key = "terminal", default_fg = "black", default_bg = "green" },
  }

  for _, mode in ipairs(modes) do
    local mode_cfg = mc[mode.key] or {}
    local fg = pc(mode_cfg.fg, mode.default_fg)
    local bg_mode = pc(mode_cfg.bg, mode.default_bg)
    hl(0, "St_" .. mode.name .. "Mode", { fg = fg, bg = bg_mode, bold = true })
    hl(0, "St_" .. mode.name .. "Mode_Icon", { fg = bg_mode, bg = "NONE" })
  end

  hl(0, "St_FileIcon", { fg = p.blue, bg = "NONE" })
  hl(0, "St_FileName", { fg = p.white, bg = "NONE", bold = true })
  hl(0, "St_Modified", { fg = p.yellow, bg = "NONE" })
  hl(0, "St_Readonly", { fg = p.red, bg = "NONE" })

  hl(0, "St_GitBranch", { fg = p.purple, bg = "NONE" })
  hl(0, "St_GitAdded", { fg = p.green, bg = "NONE" })
  hl(0, "St_GitChanged", { fg = p.blue, bg = "NONE" })
  hl(0, "St_GitRemoved", { fg = p.red, bg = "NONE" })

  hl(0, "St_DiagError", { fg = p.red, bg = "NONE" })
  hl(0, "St_DiagWarn", { fg = p.yellow, bg = "NONE" })
  hl(0, "St_DiagHint", { fg = p.vibrant_green, bg = "NONE" })
  hl(0, "St_DiagInfo", { fg = p.blue, bg = "NONE" })

  hl(0, "St_Encoding", { fg = p.grey_fg, bg = "NONE" })
  hl(0, "St_LspIcon", { fg = p.green, bg = "NONE" })
  hl(0, "St_LspName", { fg = p.green, bg = "NONE" })

  hl(0, "St_FtIcon", { fg = p.blue, bg = "NONE" })
  hl(0, "St_FtName", { fg = p.grey_fg, bg = "NONE" })

  hl(0, "St_ProgressIcon", { fg = p.grey_fg, bg = "NONE" })
  hl(0, "St_Progress", { fg = p.grey_fg, bg = "NONE" })
  hl(0, "St_PosIcon", { fg = p.blue, bg = "NONE" })
  hl(0, "St_Pos", { fg = p.white, bg = "NONE" })

  hl(0, "St_NvimTreeSt", { fg = p.grey_fg, bg = "NONE", italic = true })
  hl(0, "St_SpecialSt", { fg = p.grey_fg, bg = "NONE", italic = true })

  -- -- INDENT GUIDES ---------------------------------------------
  hl(0, "IblIndent", { fg = p.line })
  hl(0, "IblScope", { fg = p.grey })

  -- -- GIT SIGNS -------------------------------------------------
  hl(0, "GitSignsAdd", { fg = p.green })
  hl(0, "GitSignsChange", { fg = p.blue })
  hl(0, "GitSignsDelete", { fg = p.red })

  -- Apply user overrides from config
  M.apply_overrides()
end

-- -- USER OVERRIDES ------------------------------------------------
function M.apply_overrides()
  local overrides = require("core.config").theme.overrides or {}
  for group, opts in pairs(overrides) do
    local resolved = {}
    for k, v in pairs(opts) do
      resolved[k] = M.palette[v] or v
    end
    vim.api.nvim_set_hl(0, group, resolved)
  end
end

-- -- INTEGRATION LOADER (per-plugin highlight groups) --------------
---@param name string e.g. "telescope", "nvimtree", "cmp"
function M.load_integration(name)
  local ok, integration = pcall(require, "core.integrations." .. name)
  if ok and type(integration) == "function" then
    integration(M.palette)
  end
end

-- -- THEME PICKER (via vim.ui.select) ------------------------------
function M.pick_theme()
  local themes = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/themes", "*.lua", false, true)
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

-- -- TOGGLE DARK / LIGHT -------------------------------------------
function M.toggle()
  local cfg = require("core.config").theme
  local current = cfg.name
  local next_theme = (current == cfg.toggle_dark) and cfg.toggle_light or cfg.toggle_dark
  cfg.name = next_theme
  M.load(next_theme)
end

-- -- SETUP (called from init.lua) ----------------------------------
function M.setup()
  M.load(require("core.config").theme.name)
end

return M
