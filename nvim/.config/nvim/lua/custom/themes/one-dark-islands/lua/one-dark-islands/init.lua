-- one-dark-islands.nvim
-- A Neovim 0.12 colorscheme ported faithfully from
-- bataevvlad/one-dark-islands-theme (JetBrains "One Dark Islands").
--
-- Usage:
--   require("one-dark-islands").setup({ transparent = false })
--   vim.cmd.colorscheme("one-dark-islands")

local M = {}

M.config = {
  transparent       = false, -- transparent background for normal/float surfaces
  italic_comments   = true,  -- italicize comments (matches FONT_TYPE=2)
  italic_parameters = true,  -- italicize parameters (matches FONT_TYPE=2)
  on_highlights     = nil,   -- function(hl, colors) to override groups
  on_colors         = nil,   -- function(colors) to override palette
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- Set the Neovim terminal's 16 ANSI slots from the JetBrains Console.* colors.
local function set_terminal(c)
  vim.g.terminal_color_0  = c.ansi_black
  vim.g.terminal_color_1  = c.ansi_red
  vim.g.terminal_color_2  = c.ansi_green
  vim.g.terminal_color_3  = c.ansi_yellow
  vim.g.terminal_color_4  = c.ansi_blue
  vim.g.terminal_color_5  = c.ansi_magenta
  vim.g.terminal_color_6  = c.ansi_cyan
  vim.g.terminal_color_7  = c.ansi_white
  vim.g.terminal_color_8  = c.ansi_dark_black
  vim.g.terminal_color_9  = c.ansi_dark_red
  vim.g.terminal_color_10 = c.ansi_dark_green
  vim.g.terminal_color_11 = c.ansi_dark_yellow
  vim.g.terminal_color_12 = c.ansi_dark_blue
  vim.g.terminal_color_13 = c.ansi_dark_magenta
  vim.g.terminal_color_14 = c.ansi_dark_cyan
  vim.g.terminal_color_15 = c.ansi_dark_white
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
  vim.g.colors_name = "one-dark-islands"

  local cfg = M.config

  -- Palette (allow user override)
  local colors = require("one-dark-islands.palette").colors
  colors = vim.deepcopy(colors)
  if type(cfg.on_colors) == "function" then
    cfg.on_colors(colors)
  end

  -- Assemble all highlight groups
  local groups = require("one-dark-islands.groups_core").get(colors, {
    transparent       = cfg.transparent,
    italic_comments   = cfg.italic_comments,
    italic_parameters = cfg.italic_parameters,
  })
  local italic_params = groups._italic_params
  groups._italic_params = nil -- strip internal flag before applying

  local ts  = require("one-dark-islands.groups_treesitter").get(colors, italic_params)
  local lsp = require("one-dark-islands.groups_lsp").get(colors, italic_params)
  local plg = require("one-dark-islands.groups_plugins").get(colors, {
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

-- Convenience accessor for building a matching lualine theme.
function M.lualine()
  local c = require("one-dark-islands.palette").colors
  return {
    normal = {
      a = { fg = c.bg, bg = c.accent,  gui = "bold" },
      b = { fg = c.fg, bg = c.selection },
      c = { fg = c.fg, bg = c.bg_dark },
    },
    insert  = { a = { fg = c.bg, bg = c.green,  gui = "bold" } },
    visual  = { a = { fg = c.bg, bg = c.purple, gui = "bold" } },
    replace = { a = { fg = c.bg, bg = c.coral,  gui = "bold" } },
    command = { a = { fg = c.bg, bg = c.whiskey, gui = "bold" } },
    inactive = {
      a = { fg = c.fg_dim, bg = c.bg_dark },
      b = { fg = c.fg_dim, bg = c.bg_dark },
      c = { fg = c.fg_dim, bg = c.bg_dark },
    },
  }
end

return M
