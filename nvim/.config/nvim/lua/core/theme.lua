---@class core.theme
---Detect and apply Catppuccin from macOS light/dark (same rule as tmux theme.conf).

local M = {}

---@return string flavour `'mocha'|'latte'`
---@return boolean is_dark
function M.detect()
  local handle = io.popen('defaults read -g AppleInterfaceStyle 2>/dev/null', 'r')
  local out = ''
  if handle then
    out = handle:read('*a') or ''
    handle:close()
  end
  local is_dark = out:match('Dark') ~= nil
  local flavour = is_dark and 'mocha' or 'latte'
  return flavour, is_dark
end

local function catppuccin_opts(flavour)
  return {
    flavour = flavour,
    transparent_background = false,
    no_italic = true,
    integrations = {
      treesitter = true,
      native_lsp = { enabled = true },
      telescope = true,
      gitsigns = true,
      nvimtree = true,
      which_key = true,
      indent_blankline = { enabled = true },
    },
  }
end

---Re-run Catppuccin setup and colorscheme. Returns a string for `nvim --remote-expr`.
---@return string
function M.apply()
  local flavour, is_dark = M.detect()
  if is_dark then
    vim.o.background = 'dark'
  else
    vim.o.background = 'light'
  end

  local ok, catppuccin = pcall(require, 'catppuccin')
  if ok then
    ---@diagnostic disable-next-line: missing-fields
    catppuccin.setup(catppuccin_opts(flavour))
  end
  vim.cmd.colorscheme 'catppuccin'
  return flavour
end

return M
