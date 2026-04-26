-- [[ Setting options ]]
-- See `:help vim.o`
-- For more options, see `:help option-list`

-- vim.opt (Setter): The best choice for config files. It handles lists, maps,
-- and booleans using clean Lua methods like :append().
-- vim.o (Getter/Logic): The best choice for reading values or simple logic.
-- It returns raw values (true/false, numbers) without extra overhead.
-- -> Use vim.opt for your setup, and vim.o for if-statements.

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.breakindent = true -- enable break indent

vim.opt.mouse = 'a' -- enable mouse mode, can be useful for resizing splits

-- show even with one match, do not preselect
vim.opt.completeopt = 'menuone,noselect'

-- hides the current mode ( like --INSERT-- )
vim.opt.showmode = false

-- enable undo/redo changes
vim.opt.undofile = true

-- case-insensitive seraching unless \C or one or more capital letters in the
-- search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- keep signcolumn on by default
vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 250 -- decrease update time
vim.opt.timeoutlen = 300 -- decrease mapped sequence wait time

-- configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- synce clipboard between OS and neovim
-- Schedule the setting after `UiEnter` because it c an increase startup-time
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- show tabs or trailing spaces
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- show which line your cursor is on
vim.opt.cursorline = true

-- minimall number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 15

-- raise a dialog asking
vim.opt.confirm = true

vim.opt.cmdheight = 0 -- hides the command-line unless needed

-- 0 - Show all text normally (no concealment)
-- 1 - Concealed text is completely hidden
-- 2 - Concealed text is replaced with one character (default for many setups)
-- 3 - Concealed text is completely hidden
vim.opt.conceallevel = 0

vim.opt.wildmode = 'longest:full,full' -- command-line completion mode

vim.opt.pumheight = 13 -- sets the max number of items in the popup menu
vim.opt.termguicolors = true -- enables 24-bit RGB color in the terminal
vim.opt.splitkeep = 'screen' -- keeps the text on the screen steady when splitting

-- use spaces for tabs
vim.opt.tabstop = 2 -- Defines how many spaces a tab character represents
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2 -- Determines the number of spaces for indentation
vim.opt.shiftround = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true -- convert typed tabs into spaces

vim.o.grepprg = 'rg --vimgrep'
vim.o.grepformat = '%f:%l:%c:%m' -- filename:line:column:message

-- vim: ts=2 sts=2 sw=2 et
