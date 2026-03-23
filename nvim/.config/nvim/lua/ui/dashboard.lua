-- lua/ui/dashboard.lua
-- Minimal startup dashboard. Inspired by NvChad's Nvdash.

local M = {}
local api = vim.api
local cfg = require("core.config").dashboard

local quotes = {
  "Edit smarter, not harder.",
  "Small configs, fast startup.",
  "Ship it before sunset.",
  "Keep it modal and minimal.",
  "One keymap away from flow.",
  "Refactor fearlessly.",
  "Make the common case fast.",
  "Today is a good day to grep.",
  "Automate the boring edits.",
  "Readable config beats clever config.",
}

local seeded = false
local button_edge_padding = 3
local button_inner_gap = 2
local button_vertical_padding = 1

local function random_index(max)
  if not seeded then
    local seed = (vim.loop.hrtime() + os.time()) % 2147483647
    math.randomseed(seed)
    math.random()
    math.random()
    seeded = true
  end
  return math.random(max)
end

local function build_header()
  local quote = quotes[random_index(#quotes)]
  local function wrap_words(text, max_width)
    local out = {}
    local line = ""
    for word in text:gmatch("%S+") do
      local next_line = (line == "") and word or (line .. " " .. word)
      if vim.fn.strwidth(next_line) > max_width then
        if line == "" then
          out[#out + 1] = word
        else
          out[#out + 1] = line
          line = word
        end
      else
        line = next_line
      end
    end
    if line ~= "" then
      out[#out + 1] = line
    end
    return out
  end

  local function fallback_cowsay(msg)
    local wrapped = wrap_words(msg, 44)
    local max_len = 0
    for _, part in ipairs(wrapped) do
      max_len = math.max(max_len, vim.fn.strwidth(part))
    end

    local bubble = { " " .. string.rep("_", max_len + 2) }
    if #wrapped == 1 then
      bubble[#bubble + 1] = string.format("< %-"
        .. tostring(max_len)
        .. "s >", wrapped[1])
    else
      for i, part in ipairs(wrapped) do
        if i == 1 then
          bubble[#bubble + 1] = string.format("/ %-"
            .. tostring(max_len)
            .. "s \\", part)
        elseif i == #wrapped then
          bubble[#bubble + 1] = string.format("\\ %-"
            .. tostring(max_len)
            .. "s /", part)
        else
          bubble[#bubble + 1] = string.format("| %-"
            .. tostring(max_len)
            .. "s |", part)
        end
      end
    end
    bubble[#bubble + 1] = " " .. string.rep("-", max_len + 2)
    bubble[#bubble + 1] = "        \\   ^__^"
    bubble[#bubble + 1] = "         \\  (oo)\\_______"
    bubble[#bubble + 1] = "            (__)\\       )\\/\\"
    bubble[#bubble + 1] = "                ||----w |"
    bubble[#bubble + 1] = "                ||     ||"
    return bubble
  end

  if vim.fn.executable("cowsay") == 1 then
    local lines = vim.fn.systemlist({ "cowsay", "-W", "44", quote })
    if vim.v.shell_error == 0 and type(lines) == "table" and #lines > 0 then
      return lines
    end
  end

  return fallback_cowsay(quote)
end

local function plugin_stats_line()
  local ok, lazy = pcall(require, "lazy")
  if not ok or type(lazy.stats) ~= "function" then
    return nil
  end

  local stats = lazy.stats()
  local loaded = tonumber(stats.loaded or 0) or 0
  local total = tonumber(stats.count or loaded) or loaded
  return string.format("%d/%d plugins loaded", loaded, total)
end

local function max_display_width(lines)
  local max_w = 0
  for _, line in ipairs(lines) do
    max_w = math.max(max_w, vim.fn.strwidth(line))
  end
  return max_w
end

local function pad_right_to_width(str, width)
  local pad = math.max(0, width - vim.fn.strwidth(str))
  return str .. string.rep(" ", pad)
end

function M.open()
  if not cfg.enabled then
    return
  end
  if vim.fn.argc() > 0 then
    return
  end

  require("core.highlights").load_integration("dashboard")

  local buf = api.nvim_create_buf(false, true)
  api.nvim_set_current_buf(buf)
  local win = api.nvim_get_current_win()
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.b[buf].miniindentscope_disable = true
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].cursorline = false
  vim.wo[win].signcolumn = "no"

  local win_w = api.nvim_win_get_width(0)
  local win_h = api.nvim_win_get_height(0)
  local lines = {}
  local content = {}
  local marks = {}

  local function center(str)
    local pad = math.floor((win_w - vim.fn.strwidth(str)) / 2)
    pad = math.max(0, pad)
    return string.rep(" ", pad) .. str, pad
  end

  local function push(kind, raw, extra)
    content[#content + 1] = {
      kind = kind,
      raw = raw,
      extra = extra or {},
    }
  end

  local header_lines = build_header()
  local header_width = max_display_width(header_lines)

  local button_rows = {}
  local button_left_max_width = 0
  for _, btn in ipairs(cfg.buttons) do
    local icon, label, key = btn[1], btn[2], btn[3]
    local key_text = "[" .. key .. "]"
    local left = (icon ~= "" and (icon .. " ") or "") .. label
    button_left_max_width = math.max(button_left_max_width, vim.fn.strwidth(left))
    button_rows[#button_rows + 1] = { left = left, key_text = key_text }
  end

  local button_content_width = button_left_max_width + button_inner_gap + 4
  local panel_width = math.max(header_width, button_content_width + (button_edge_padding * 2))
  local button_inner_width = math.max(0, panel_width - (button_edge_padding * 2))
  local side = string.rep(" ", button_edge_padding)

  for _, line in ipairs(header_lines) do
    push("header", pad_right_to_width(line, panel_width))
  end
  push("spacer", "")

  for _ = 1, button_vertical_padding do
    push("button_pad", string.rep(" ", panel_width))
  end
  for _, btn in ipairs(button_rows) do
    local left_w = vim.fn.strwidth(btn.left)
    local key_w = vim.fn.strwidth(btn.key_text)
    local gap = math.max(button_inner_gap, button_inner_width - left_w - key_w)
    local row = btn.left .. string.rep(" ", gap) .. btn.key_text
    local raw = side .. pad_right_to_width(row, button_inner_width) .. side
    push("button", raw, { key_text = btn.key_text })
  end
  for _ = 1, button_vertical_padding do
    push("button_pad", string.rep(" ", panel_width))
  end
  push("spacer", "")

  local plugin_line = plugin_stats_line()
  if plugin_line then
    push("footer", plugin_line)
  end
  local version = "Neovim v" .. tostring(vim.version())
  push("footer", version)

  local top_pad = math.max(0, math.floor((win_h - #content) / 2))
  for _ = 1, top_pad do
    lines[#lines + 1] = ""
  end

  for _, item in ipairs(content) do
    local centered, left_pad = center(item.raw)
    lines[#lines + 1] = centered
    marks[#marks + 1] = {
      kind = item.kind,
      line = #lines - 1,
      pad = left_pad,
      raw = item.raw,
      key_text = item.extra.key_text,
    }
  end

  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = true

  local first_button_line = nil
  local first_button_col = nil
  local ns = api.nvim_create_namespace("dashboard")
  for _, mark in ipairs(marks) do
    if mark.kind == "header" then
      api.nvim_buf_set_extmark(buf, ns, mark.line, 0, { line_hl_group = "DashboardHeader" })
    elseif mark.kind == "button" or mark.kind == "button_pad" then
      if mark.kind == "button" and not first_button_line then
        first_button_line = mark.line
        first_button_col = mark.pad + button_edge_padding
      end
      api.nvim_buf_set_extmark(buf, ns, mark.line, mark.pad, {
        end_col = mark.pad + #mark.raw,
        hl_group = "DashboardButton",
      })
      local s, e = string.find(mark.raw, mark.key_text or "", 1, true)
      if mark.kind == "button" and s and e then
        api.nvim_buf_set_extmark(buf, ns, mark.line, mark.pad + s - 1, {
          end_col = mark.pad + e,
          hl_group = "DashboardKey",
        })
      end
    elseif mark.kind == "footer" then
      api.nvim_buf_set_extmark(buf, ns, mark.line, 0, { line_hl_group = "DashboardFooter" })
    end
  end

  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true

  local function focus_first_action()
    if not first_button_line then
      return
    end
    local target_col = first_button_col or 0
    local ok = pcall(api.nvim_win_set_cursor, 0, { first_button_line + 1, target_col })
    if not ok then
      pcall(api.nvim_win_set_cursor, 0, { first_button_line + 1, 0 })
    end
  end
  focus_first_action()

  api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
    buffer = buf,
    callback = focus_first_action,
    desc = "Dashboard: focus first action row",
  })

  for _, btn in ipairs(cfg.buttons) do
    local key, cmd = btn[3], btn[4]
    vim.keymap.set("n", key, "<cmd>" .. cmd .. "<CR>", {
      buffer = buf,
      silent = true,
      nowait = true,
    })
  end
  vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
  vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = buf, silent = true })
end

return M
