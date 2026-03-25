-- lua/core/options.lua
-- Loaded at startup before lazy.nvim. No plugin dependencies.

local opt = vim.opt

-- ================================================================
-- INDENTATION
-- ================================================================
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.shiftround = true

-- ================================================================
-- LINE NUMBERS
-- ================================================================
opt.number = true
opt.relativenumber = true
opt.numberwidth = 2
opt.signcolumn = "yes"

-- ================================================================
-- CURSOR & DISPLAY
-- ================================================================
opt.cursorline = true
opt.wrap = false
opt.linebreak = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.pumheight = 10
opt.showmode = false
opt.showtabline = 0
opt.conceallevel = 0
opt.ruler = false

-- ================================================================
-- SEARCH
-- ================================================================
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- ================================================================
-- SPLITS
-- ================================================================
opt.splitright = true
opt.splitbelow = true

-- ================================================================
-- CLIPBOARD
-- ================================================================
opt.clipboard = "unnamedplus"

-- ================================================================
-- FILES & UNDO
-- ================================================================
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.autoread = true

-- ================================================================
-- PERFORMANCE
-- ================================================================
opt.updatetime = 250
opt.timeoutlen = 400
opt.redrawtime = 1500

-- ================================================================
-- APPEARANCE
-- ================================================================
opt.termguicolors = true
opt.fillchars = {
  eob = " ",
  vert = "│",
  fold = " ",
  diff = "╱",
}
opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
}

-- ================================================================
-- COMPLETION
-- ================================================================
opt.completeopt = { "menuone", "noselect", "noinsert" }
opt.shortmess:append("c")

-- ================================================================
-- FOLDING
-- ================================================================
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- ================================================================
-- MISCELLANEOUS
-- ================================================================
opt.mouse = "a"
opt.mousemoveevent = true
opt.iskeyword:append("-")
opt.whichwrap:append("<>[]hl")
opt.formatoptions:remove("cro")
opt.shortmess:append("s")
opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
}

-- ================================================================
-- NEOVIDE (GUI) — no-op in terminal
-- ================================================================
if vim.g.neovide then
  opt.guifont = "JetBrainsMono Nerd Font:h13"
  vim.g.neovide_padding_top = 10
  vim.g.neovide_padding_bottom = 10
  vim.g.neovide_padding_left = 10
  vim.g.neovide_padding_right = 10
  vim.g.neovide_transparency = 0.95
  vim.g.neovide_cursor_vfx_mode = "railgun"
end

-- ================================================================
-- GLOBAL FLAGS (read by ui modules)
-- ================================================================
vim.g.have_nerd_font = true
