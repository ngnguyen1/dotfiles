require "nvchad.options"

-- add yours here!

-- local o = vim.o
local opt = vim.opt

-- to enable cursorline!
opt.cursorlineopt ='both'

-- nvchad's configuration is <>[]hl
-- this option will Reset whichwrap to Neovim default (b,s only) backspaces
-- and space wrap
opt.whichwrap = "b,s"

-- Line numbers and navigation
opt.relativenumber = true
opt.scrolloff = 15
opt.sidescrolloff = 15

-- Indentation and tabs
opt.shiftround = true
opt.autoindent = true

-- Search behaviors
opt.hlsearch = false
opt.inccommand = "nosplit"

-- Performance
opt.timeoutlen = 300
opt.updatetime = 200
