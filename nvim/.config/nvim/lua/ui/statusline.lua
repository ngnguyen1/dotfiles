-- lua/ui/statusline.lua
--
-- Transparent, icon-first, flat statusline layout.
-- LEFT:  [mode icon+pill] [file] [git] [diagnostics]
-- RIGHT: [encoding] [diagnostics] [lsp] [filetype] [progress] [position]

local M = {}
local api = vim.api
local fn = vim.fn

local mode_map = {
  n = { label = "NORMAL", hl = "St_NormalMode" },
  no = { label = "N·OP", hl = "St_NormalMode" },
  v = { label = "VISUAL", hl = "St_VisualMode" },
  V = { label = "V·LINE", hl = "St_VisualMode" },
  ["\22"] = { label = "V·BLOCK", hl = "St_VisualMode" },
  s = { label = "SELECT", hl = "St_VisualMode" },
  S = { label = "S·LINE", hl = "St_VisualMode" },
  i = { label = "INSERT", hl = "St_InsertMode" },
  ic = { label = "INSERT", hl = "St_InsertMode" },
  R = { label = "REPLACE", hl = "St_ReplaceMode" },
  Rc = { label = "REPLACE", hl = "St_ReplaceMode" },
  c = { label = "COMMAND", hl = "St_CommandMode" },
  t = { label = "TERMINAL", hl = "St_TerminalMode" },
  ["!"] = { label = "SHELL", hl = "St_NormalMode" },
}

local function h(group, str)
  return "%#" .. group .. "#" .. str
end

local function gap(n)
  return h("St_Base", string.rep(" ", n or 1))
end

local function module_mode()
  local raw = api.nvim_get_mode().mode
  local m = mode_map[raw] or mode_map.n
  return h(m.hl .. "_Icon", " 󰣩 ") .. h(m.hl, " " .. m.label .. " ") .. gap(1)
end

local function module_file()
  local name = fn.expand("%:t")
  if name == "" then
    name = "[No Name]"
  end

  local icon = "󰈚"
  local icon_hl = "St_FileIcon"
  local ok, dv = pcall(require, "nvim-web-devicons")
  if ok then
    local i, hl_name = dv.get_icon(name)
    if i then
      icon = i
      icon_hl = hl_name or icon_hl
    end
  end

  local modified = vim.bo.modified and h("St_Modified", " ●") or ""
  local readonly = vim.bo.readonly and h("St_Readonly", " 󰌾") or ""

  return h(icon_hl, " " .. icon .. " ")
    .. h("St_FileName", name)
    .. modified
    .. readonly
    .. gap(1)
end

local function module_git()
  local gs = vim.b.gitsigns_status_dict
  if not gs or not gs.head or gs.head == "" then
    return ""
  end

  local out = {}
  table.insert(out, h("St_GitBranch", "  " .. gs.head .. " "))
  if (gs.added or 0) > 0 then
    table.insert(out, h("St_GitAdded", " +" .. gs.added .. " "))
  end
  if (gs.changed or 0) > 0 then
    table.insert(out, h("St_GitChanged", "  ~" .. gs.changed .. " "))
  end
  if (gs.removed or 0) > 0 then
    table.insert(out, h("St_GitRemoved", " ■" .. gs.removed .. " "))
  end
  return table.concat(out) .. gap(1)
end

local function module_diagnostics()
  local d = vim.diagnostic
  local out = {}
  local items = {
    { d.severity.ERROR, "✘", "St_DiagError" },
    { d.severity.WARN, "▲", "St_DiagWarn" },
    { d.severity.HINT, "󰠠", "St_DiagHint" },
    { d.severity.INFO, "", "St_DiagInfo" },
  }
  for _, item in ipairs(items) do
    local n = #d.get(0, { severity = item[1] })
    if n > 0 then
      table.insert(out, h(item[3], " " .. item[2] .. " " .. n))
    end
  end
  if #out == 0 then
    return ""
  end
  return table.concat(out) .. gap(1)
end

local function module_encoding()
  local enc = vim.bo.fileencoding
  if enc == "" then
    enc = vim.o.encoding
  end
  if enc == "" then
    return ""
  end
  return h("St_Encoding", enc:upper() .. " ") .. gap(1)
end

local function module_lsp()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return ""
  end

  local name = clients[1].name
  for _, client in ipairs(clients) do
    if client.name ~= "null-ls" and client.name ~= "copilot" then
      name = client.name
      break
    end
  end

  return h("St_LspIcon", " 󰣩 ") .. h("St_LspName", name .. " ") .. gap(1)
end

local function module_filetype()
  local ft = vim.bo.filetype
  if ft == "" then
    return ""
  end

  local icon = ""
  local icon_hl = "St_FtIcon"
  local ok, dv = pcall(require, "nvim-web-devicons")
  if ok then
    local i, hl_name = dv.get_icon_by_filetype(ft)
    if i then
      icon = i
      icon_hl = hl_name or icon_hl
    end
  end

  return h(icon_hl, " " .. icon .. " ") .. h("St_FtName", ft .. " ") .. gap(1)
end

local function module_progress()
  local cur = fn.line(".")
  local total = fn.line("$")
  if total <= 0 then
    return ""
  end

  local pct
  if cur == 1 then
    pct = "Top"
  elseif cur == total then
    pct = "Bot"
  else
    pct = math.floor((cur / total) * 100) .. "%%"
  end
  return h("St_ProgressIcon", " 󰉸 ") .. h("St_Progress", pct .. " ") .. gap(1)
end

local function module_position()
  local line = fn.line(".")
  local col = fn.col(".")
  return h("St_PosIcon", " ≡ ") .. h("St_Pos", line .. ":" .. col .. " ")
end

local special_ft = {
  NvimTree = function()
    local cwd = vim.fn.getcwd():gsub(vim.env.HOME or "", "~")
    return h("St_NvimTreeSt", "  " .. cwd .. " ")
  end,
  qf = function()
    local title = vim.fn.getqflist({ title = true }).title or "Quickfix"
    return h("St_SpecialSt", "  " .. title .. " ")
  end,
  help = function()
    local name = vim.fn.expand("%:t:r")
    return h("St_SpecialSt", "  " .. name .. " ")
  end,
  lazy = function()
    return h("St_SpecialSt", "  lazy.nvim ")
  end,
  mason = function()
    return h("St_SpecialSt", "  Mason ")
  end,
  lspinfo = function()
    return h("St_SpecialSt", "  LSP Info ")
  end,
  checkhealth = function()
    return h("St_SpecialSt", "  Health ")
  end,
}

function M.render()
  local ft = vim.bo.filetype
  local buftype = vim.bo.buftype

  if special_ft[ft] then
    return special_ft[ft]()
  end

  if buftype ~= "" and buftype ~= "acwrite" then
    return h("St_Base", "")
  end

  local base = h("St_Base", "")
  local left = table.concat({
    module_mode(),
    module_file(),
    module_git(),
    module_diagnostics(),
  })
  local right = table.concat({
    module_encoding(),
    module_diagnostics(),
    module_lsp(),
    module_filetype(),
    module_progress(),
    module_position(),
  })

  return base .. left .. "%=" .. right
end

function M.setup()
  vim.opt.statusline = "%!v:lua.require('ui.statusline').render()"
  vim.opt.laststatus = 3

  local group = vim.api.nvim_create_augroup("StatuslineNvimTree", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "NvimTree",
    callback = function(event)
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(event.buf) then
          return
        end
        local win = vim.fn.bufwinid(event.buf)
        if win ~= -1 then
          vim.wo[win].statusline = "%!v:lua.require('ui.statusline').render()"
        end
      end)
    end,
    desc = "Keep global statusline visible in NvimTree",
  })

  vim.api.nvim_create_autocmd(
    { "ModeChanged", "BufEnter", "BufWritePost", "DiagnosticChanged", "LspAttach", "LspDetach" },
    { callback = function() vim.cmd.redrawstatus() end }
  )
end

return M
