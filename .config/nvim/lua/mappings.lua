require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local nomap = vim.keymap.del
local ss = require "smart-splits"

vim.g.kitty_navigator_no_mappings = 1

-- Remove default nvchad's mapping
nomap("n", "<C-h>")
nomap("n", "<C-j>")
nomap("n", "<C-k>")
nomap("n", "<C-l>")
nomap("n", "<C-n>")
nomap("n", "<Leader>e")

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<Leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })

-- -- C-s to save file
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

local directions = { h = "Left", j = "Down", k = "Up", l = "Right" }

for key, dir in pairs(directions) do
  map({ "n", "t" }, "<C-S-" .. key .. ">", "<cmd>KittyNavigate" .. dir .. "<cr>", {
    desc = "Move to " .. dir:lower() .. " split (shifted)",
  })
end

-- Using <tab/shift-tab> to indent in normal/insert mode
map("n", "<Tab>", ">>", { noremap = true, silent = true })
map("n", "<S-Tab>", "<<", { noremap = true, silent = true })
map("i", "<S-Tab>", "<C-d>", { noremap = true, silent = true })

-- Using <tab> to indent in visual mode
map("v", "<Tab>", ">gv", { noremap = true, silent = true })
map("v", "<S-Tab>", "<gv", { noremap = true, silent = true })

-- Delete words with C-Backspace/Alt-Backspace in insert mode
map("x", "<C-BS>", "<C-w>", { noremap = true, silent = true })
map("i", "<C-BS>", "<C-w>", { noremap = true, silent = true })
map("i", "<M-BS>", "<C-w>", { noremap = true, silent = true })

-- Nvim DAP
map("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
map("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
map("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
map("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
map("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debugger toggle breakpoint" })
map(
  "n",
  "<Leader>dd",
  "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  { desc = "Debugger set conditional breakpoint" }
)
map("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
map("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })

-- rustaceanvim
map("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })

-- Resize window
map("n", "<M-Left>", ss.resize_left, { desc = "resize left" })
map("n", "<M-Down>", ss.resize_down, { desc = "resize down" })
map("n", "<M-Up>", ss.resize_up, { desc = "resize up" })
map("n", "<M-Right>", ss.resize_right, { desc = "resize right" })

-- Buffers
local buffer_switch = require "buffer_switch"
map("n", "<M-Tab>", buffer_switch.toggle, { desc = "Toggle last buffer (back-and-forth)" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<Leader>bb", buffer_switch.toggle, { desc = "Switch to last buffer" })
map("n", "<Leader>bd", "<cmd>bdelete<cr>", { desc = "Delete current buffer" })

