-- [[ Basic keymaps ]]
-- See `:help vim.keymap.set()`

local map = vim.keymap.set

map('n', ';', ':', { desc = 'cmd enter command mode' })

-- clear highlights on search when pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- buffer navigation
map('n', ']b', '<cmd>bnext<CR>', { desc = 'Next buffer' })
map('n', '[b', '<cmd>bprevious<CR>', { desc = 'Prev buffer' })

-- NOTE: window focus <C-h/j/k/l> is owned by vim-tmux-navigator (see
-- custom/plugins/tmux-navigator.lua); its `keys` table overrides plain
-- <C-w> maps, so they are defined there as the single source of truth.

-- visual mode: move selection
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- delete/paste without clobbering register
map({ 'n', 'v' }, '<leader>d', '"_d', { desc = 'Delete without yanking' })
map('v', 'p', '"_dP', { desc = 'Paste without clobbering register' })

-- visual mode: indent keep selection
map('v', '<', '<gv', { desc = 'Indent left' })
map('v', '>', '>gv', { desc = 'Indent right' })

-- keep cursor centered when scrolling/searching
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down centered' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up centered' })
map('n', 'n', 'nzzzv', { desc = 'Next search centered' })
map('n', 'N', 'Nzzzv', { desc = 'Prev search centered' })

-- join line keep cursor in place
map('n', 'J', 'mzJ`z', { desc = 'Join line keep cursor' })

-- select all
map('n', '<C-a>', 'gg<S-v>G', { desc = 'Select all' })

-- window splits
map('n', '<leader>wv', '<C-w>v', { desc = 'Window split [V]ertical' })
map('n', '<leader>wh', '<C-w>s', { desc = 'Window split [H]orizontal' })
map('n', '<leader>we', '<C-w>=', { desc = 'Window [E]qual size' })
map('n', '<leader>wx', '<cmd>close<CR>', { desc = 'Window close' })

-- window resize
map('n', '<leader>w+', '<cmd>resize +2<CR>', { desc = 'Window height +' })
map('n', '<leader>w-', '<cmd>resize -2<CR>', { desc = 'Window height -' })
map('n', '<leader>w>', '<cmd>vertical resize +2<CR>', { desc = 'Window width +' })
map('n', '<leader>w<', '<cmd>vertical resize -2<CR>', { desc = 'Window width -' })

-- vim: ts=2 sts=2 sw=2 et
