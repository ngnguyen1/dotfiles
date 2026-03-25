-- lua/core/mappings.lua
-- Global mappings only. Plugin keys -> keys = {} in plugin spec.

local map = vim.keymap.set

-- ================================================================
-- GENERAL
-- ================================================================
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear search highlights" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<Esc><cmd>w<CR>", { desc = "Save file (insert)" })
map("n", "<leader>q", "<cmd>qa<CR>", { desc = "Quit all" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force quit all" })
map("n", ";", ":", { desc = "CMD enter command mode" })

-- ================================================================
-- BETTER MOVEMENT
-- ================================================================
map("n", "n", "nzzzv", { desc = "Next result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev result (centered)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })

-- ================================================================
-- BUFFERS
-- ================================================================
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<leader>x", function()
  local cur = vim.api.nvim_get_current_buf()
  vim.cmd("bprevious")
  vim.api.nvim_buf_delete(cur, { force = false })
end, { desc = "Close buffer" })
map("n", "<leader>X", "<cmd>%bd|e#<CR>", { desc = "Close all other buffers" })

-- ================================================================
-- SPLITS
-- ================================================================
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontal" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>sc", "<cmd>close<CR>", { desc = "Close split" })

map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Resize up" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Resize down" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Resize left" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Resize right" })

-- ================================================================
-- EDITING
-- ================================================================
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("x", "<leader>p", '"_dP', { desc = "Paste without clobbering register" })
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
map({ "n", "v" }, "<leader>D", '"_d', { desc = "Delete to void register" })
map("v", "<", "<gv", { desc = "Indent left (stay selected)" })
map("v", ">", ">gv", { desc = "Indent right (stay selected)" })
map("n", "J", "mzJ`z", { desc = "Join line (cursor stable)" })

-- ================================================================
-- FILE EXPLORER
-- ================================================================
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
map("n", "<leader>fe", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" })
map("n", "<leader>fr", "<cmd>NvimTreeFindFile<CR>", { desc = "Reveal file in explorer" })

-- ================================================================
-- DIAGNOSTICS
-- ================================================================
map("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Diagnostic float" })
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev diagnostic" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Diagnostic quickfix" })

-- ================================================================
-- UI / THEME
-- ================================================================
map("n", "<leader>ut", function()
  require("core.highlights").toggle()
end, { desc = "Toggle dark/light theme" })

map("n", "<leader>up", function()
  require("core.highlights").pick_theme()
end, { desc = "Pick theme" })

map("n", "<leader>uz", function()
  local cfg = require("core.config")
  cfg.theme.transparency = not cfg.theme.transparency
  require("core.highlights").load(cfg.theme.name)
end, { desc = "Toggle transparency" })

-- ================================================================
-- TERMINAL
-- ================================================================
local term_buf = nil
local term_win = nil

local function toggle_float_term()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, false)
    term_win = nil
    return
  end
  local cols = vim.o.columns
  local rows = vim.o.lines
  local w = math.floor(cols * 0.8)
  local h = math.floor(rows * 0.8)
  if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
    term_buf = vim.api.nvim_create_buf(false, true)
  end
  term_win = vim.api.nvim_open_win(term_buf, true, {
    relative = "editor",
    width = w,
    height = h,
    row = math.floor((rows - h) / 2),
    col = math.floor((cols - w) / 2),
    style = "minimal",
    border = require("core.config").ui.border,
    title = " Terminal ",
    title_pos = "center",
  })
  if vim.bo[term_buf].buftype ~= "terminal" then
    vim.cmd("terminal")
    term_buf = vim.api.nvim_get_current_buf()
  end
  vim.cmd("startinsert")
end

map({ "n", "t" }, "<A-i>", toggle_float_term, { desc = "Toggle floating terminal" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("n", "<leader>th", "<cmd>split | terminal<CR>", { desc = "Horizontal terminal" })
map("n", "<leader>tv", "<cmd>vsplit | terminal<CR>", { desc = "Vertical terminal" })
