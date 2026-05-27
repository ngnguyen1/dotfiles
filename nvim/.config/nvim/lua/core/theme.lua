---@class core.theme
---Detect macOS light/dark and apply the matching colorscheme:
---  Dark  → one-dark-islands (local theme under lua/one-dark-islands)
---  Light → catppuccin latte

local M = {}

---@return boolean is_dark `true` when macOS appearance is Dark
function M.is_dark()
  local handle = io.popen('defaults read -g AppleInterfaceStyle 2>/dev/null', 'r')
  if not handle then return false end
  local out = handle:read('*a') or ''
  handle:close()
  return out:match('Dark') ~= nil
end

---Apply theme matching current macOS appearance. Returns the colorscheme name.
---@return string
function M.apply()
  local is_dark = M.is_dark()
  vim.o.background = is_dark and 'dark' or 'light'

  if is_dark then
    local ok, odi = pcall(require, 'one-dark-islands')
    if ok then
      odi.setup { transparent = false, italic_comments = true, italic_parameters = true }
    end
    vim.cmd.colorscheme 'one-dark-islands'
    M.refresh_lualine()
    return 'one-dark-islands'
  end

  local ok, catppuccin = pcall(require, 'catppuccin')
  if ok then
    ---@diagnostic disable-next-line: missing-fields
    catppuccin.setup {
      flavour = 'latte',
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
  vim.cmd.colorscheme 'catppuccin'
  M.refresh_lualine()
  return 'catppuccin-latte'
end

---Return the lualine theme matching current appearance.
function M.lualine_theme()
  if M.is_dark() then
    local ok, odi = pcall(require, 'one-dark-islands')
    if ok then return odi.lualine() end
  end
  return 'auto'
end

---Re-apply lualine with the matching theme (no-op if lualine not loaded).
function M.refresh_lualine()
  local ok, lualine = pcall(require, 'lualine')
  if not ok then return end
  local cfg = lualine.get_config and lualine.get_config() or {}
  cfg.options = cfg.options or {}
  cfg.options.theme = M.lualine_theme()
  lualine.setup(cfg)
end

return M
