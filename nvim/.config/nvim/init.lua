-- Set <space> as the leader key

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- use Nerd font
vim.g.have_nerd_font = true

-- [[ Setting options ]]
require 'options'

-- [[ Basic Autocommands ]]
require 'autocmds'

-- [[ Basic keymaps ]]
require 'keymaps'

-- [[ install `lazy.nvim` as plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugin ]]
require 'lazy-plugins'

require('custom.folding').setup()

-- vim: ts=2 sts=2 sw=2 et
