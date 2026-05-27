-- islands-dark.nvim
-- A Neovim 0.12 colorscheme ported faithfully from
-- bwya77/vscode-dark-islands (themes/islands-dark.json).
--
-- Usage:
--   require("islands-dark").setup({ transparent = false })
--   vim.cmd.colorscheme("islands-dark")

local M = {}

M.config = {
  transparent     = false, -- transparent background for normal/float surfaces
  italic_comments = true,  -- italicize comments (matches the VS Code theme)
  on_highlights   = nil,   -- function(hl, colors) to override groups
  on_colors       = nil,   -- function(colors) to override palette
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- Set the Neovim terminal's 16 ANSI slots from terminal.ansi* in the JSON.
local function set_terminal(c)
  vim.g.terminal_color_0  = c.ansi_black
  vim.g.terminal_color_1  = c.ansi_red
  vim.g.terminal_color_2  = c.ansi_green
  vim.g.terminal_color_3  = c.ansi_yellow
  vim.g.terminal_color_4  = c.ansi_blue
  vim.g.terminal_color_5  = c.ansi_magenta
  vim.g.terminal_color_6  = c.ansi_cyan
  vim.g.terminal_color_7  = c.ansi_white
  vim.g.terminal_color_8  = c.ansi_bright_black
  vim.g.terminal_color_9  = c.ansi_bright_red
  vim.g.terminal_color_10 = c.ansi_bright_green
  vim.g.terminal_color_11 = c.ansi_bright_yellow
  vim.g.terminal_color_12 = c.ansi_bright_blue
  vim.g.terminal_color_13 = c.ansi_bright_magenta
  vim.g.terminal_color_14 = c.ansi_bright_cyan
  vim.g.terminal_color_15 = c.ansi_bright_white
end

function M.load()
  if vim.g.colors_name then
    vim.cmd.highlight("clear")
  end
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd.syntax("reset")
  end

  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "islands-dark"

  local cfg = M.config

  -- Palette (with user override)
  local colors = vim.deepcopy(require("islands-dark.palette").colors)
  if type(cfg.on_colors) == "function" then
    cfg.on_colors(colors)
  end

  -- Assemble all highlight groups
  local groups = require("islands-dark.groups_core").get(colors, {
    transparent     = cfg.transparent,
    italic_comments = cfg.italic_comments,
  })
  local ts  = require("islands-dark.groups_treesitter").get(colors, {
    italic_comments = cfg.italic_comments,
  })
  local lsp = require("islands-dark.groups_lsp").get(colors, {})
  local plg = require("islands-dark.groups_plugins").get(colors, {
    transparent = cfg.transparent,
  })

  for k, v in pairs(ts)  do groups[k] = v end
  for k, v in pairs(lsp) do groups[k] = v end
  for k, v in pairs(plg) do groups[k] = v end

  -- User highlight overrides
  if type(cfg.on_highlights) == "function" then
    cfg.on_highlights(groups, colors)
  end

  -- Apply via the native 0.12 API
  for group, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  set_terminal(colors)
end

-- Convenience: matching lualine theme.
function M.lualine()
  local c = require("islands-dark.palette").colors
  return {
    normal = {
      a = { fg = c.bg, bg = c.blue,    gui = "bold" },
      b = { fg = c.fg, bg = c.bg_panel },
      c = { fg = c.fg, bg = c.bg },
    },
    insert  = { a = { fg = c.bg, bg = c.green_vivid, gui = "bold" } },
    visual  = { a = { fg = c.bg, bg = c.magenta,     gui = "bold" } },
    replace = { a = { fg = c.bg, bg = c.error,       gui = "bold" } },
    command = { a = { fg = c.bg, bg = c.orange,      gui = "bold" } },
    inactive = {
      a = { fg = c.fg_dim, bg = c.bg },
      b = { fg = c.fg_dim, bg = c.bg },
      c = { fg = c.fg_dim, bg = c.bg },
    },
  }
end

return M
