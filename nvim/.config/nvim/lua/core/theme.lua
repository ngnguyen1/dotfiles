---@class core.theme
---Detect macOS light/dark and apply the matching colorscheme:
---  Dark  → islands-dark (local plugin at islands-dark.nvim/)
---  Light → catppuccin latte

local M = {}

local APPEARANCE_FILE = (vim.env.HOME or vim.fn.expand '~') .. '/.config/theme-reload/appearance'

---In-session fallback used only when the cache file is absent (e.g. theme-reload
---LaunchAgent not installed, or first launch before it has ever run).
local probed ---@type boolean|nil

---Read the appearance published by `theme-reload/reload.sh` (no subprocess).
---@return boolean|nil is_dark `nil` when the file is missing/unreadable
local function read_cache_file()
  local ok, lines = pcall(vim.fn.readfile, APPEARANCE_FILE, '', 1)
  if not ok or not lines or not lines[1] then return nil end
  local val = vim.trim(lines[1])
  if val == 'dark' then return true end
  if val == 'light' then return false end
  return nil
end

---Last-resort probe (macOS only). Spawns once per session and caches the result.
---@return boolean
local function probe_defaults()
  if probed == nil then
    local ok, out = pcall(function() return vim.system({ 'defaults', 'read', '-g', 'AppleInterfaceStyle' }):wait() end)
    probed = ok and (out.stdout or ''):match 'Dark' ~= nil or false
  end
  return probed
end

---@return boolean is_dark `true` when macOS appearance is Dark
function M.is_dark()
  local cached = read_cache_file()
  if cached ~= nil then return cached end
  return probe_defaults()
end

---Apply theme matching current macOS appearance. Returns the colorscheme name.
---@return string
function M.apply()
  local is_dark = M.is_dark()
  vim.o.background = is_dark and 'dark' or 'light'

  if is_dark then
    vim.cmd.colorscheme 'islands-dark'
    M.refresh_lualine(is_dark)
    return 'islands-dark'
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
  M.refresh_lualine(is_dark)
  return 'catppuccin-latte'
end

---Return the lualine theme matching current appearance.
---@param is_dark? boolean reuse a known value to avoid re-reading the cache
function M.lualine_theme(is_dark)
  if is_dark == nil then is_dark = M.is_dark() end
  if is_dark then
    local ok, ids = pcall(require, 'islands-dark')
    if ok then return ids.lualine() end
  end
  return 'auto'
end

---Re-apply lualine with the matching theme (no-op if lualine not loaded).
---@param is_dark? boolean reuse a known value to avoid re-reading the cache
function M.refresh_lualine(is_dark)
  local ok, lualine = pcall(require, 'lualine')
  if not ok then return end
  local cfg = lualine.get_config and lualine.get_config() or {}
  cfg.options = cfg.options or {}
  cfg.options.theme = M.lualine_theme(is_dark)
  lualine.setup(cfg)
end

return M
