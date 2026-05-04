-- Tree-sitter incremental selection (main-branch nvim-treesitter has no built-in module).
-- Init: <leader>v in normal. Expand: <CR> in visual. Shrink: <BS> in visual.
-- Intentionally avoids normal-mode <CR> (see nvim/STARTUP_KEYMAP_REVIEW.md).

local api = vim.api
local ts = vim.treesitter

local M = {}

---@type table<integer, TSNode[]>
local stacks = {}

---@param range integer[] 0-based range from |vim.treesitter.get_node_range()|
---@param buf integer
---@return integer, integer, integer, integer
local function get_vim_range(range, buf)
  local srow, scol, erow, ecol = range[1], range[2], range[3], range[4]
  srow, scol, erow, ecol = srow + 1, scol + 1, erow + 1, ecol
  if ecol == 0 then
    erow = erow - 1
    local line = api.nvim_buf_get_lines(buf, erow - 1, erow, false)[1]
    ecol = line and #line or 1
    ecol = math.max(ecol, 1)
  end
  return srow, scol, erow, ecol
end

---@param buf integer
---@param node TSNode
local function update_selection(buf, node)
  local r = { ts.get_node_range(node) }
  local start_row, start_col, end_row, end_col = get_vim_range(r, buf)
  local mode = api.nvim_get_mode()
  if mode.mode ~= 'v' and mode.mode ~= 'V' and mode.mode ~= string.char(22) then
    api.nvim_cmd({ cmd = 'normal', bang = true, args = { 'v' } }, {})
  end
  api.nvim_win_set_cursor(0, { start_row, start_col - 1 })
  vim.cmd 'normal! o'
  api.nvim_win_set_cursor(0, { end_row, end_col - 1 })
end

function M.init_selection()
  local buf = api.nvim_get_current_buf()
  local p = ts.get_parser(buf)
  if p then
    p:parse()
  end
  local node = ts.get_node { bufnr = buf }
  if not node then
    return
  end
  stacks[buf] = { node }
  update_selection(buf, node)
end

function M.node_incremental()
  local buf = api.nvim_get_current_buf()
  local stack = stacks[buf]
  if not stack or #stack == 0 then
    M.init_selection()
    return
  end
  local parent = stack[#stack]:parent()
  if not parent then
    return
  end
  table.insert(stack, parent)
  update_selection(buf, parent)
end

function M.node_decremental()
  local buf = api.nvim_get_current_buf()
  local stack = stacks[buf]
  if not stack or #stack < 2 then
    return
  end
  table.remove(stack)
  local node = stack[#stack]
  if node then
    update_selection(buf, node)
  end
end

function M.setup()
  vim.keymap.set('n', '<leader>v', M.init_selection, { desc = 'Tree-sitter: start node selection' })
  vim.keymap.set('x', '<CR>', M.node_incremental, { desc = 'Tree-sitter: expand selection' })
  vim.keymap.set('x', '<BS>', M.node_decremental, { desc = 'Tree-sitter: shrink selection' })

  vim.api.nvim_create_autocmd('BufLeave', {
    callback = function(ev) stacks[ev.buf] = nil end,
  })
end

return M
