# Spec: lua/core/options.lua

> All vim.opt settings. Loaded before plugins in init.lua.

---

## Complete `lua/core/options.lua`

```lua
-- lua/core/options.lua
-- Loaded at startup before lazy.nvim. No plugin dependencies.

local opt = vim.opt

-- ================================================================
-- INDENTATION
-- ================================================================
opt.expandtab   = true    -- spaces instead of tabs
opt.shiftwidth  = 2       -- indent size
opt.tabstop     = 2       -- tab display width
opt.softtabstop = 2       -- spaces inserted/removed per Tab/Backspace
opt.smartindent = true    -- smart auto-indenting on new lines
opt.shiftround  = true    -- round indent to shiftwidth multiple

-- ================================================================
-- LINE NUMBERS
-- ================================================================
opt.number         = true   -- show absolute line number
opt.relativenumber = true   -- show relative numbers (great for motions)
opt.numberwidth    = 2      -- minimal gutter width
opt.signcolumn     = "yes"  -- always show sign column (no layout shift)

-- ================================================================
-- CURSOR & DISPLAY
-- ================================================================
opt.cursorline    = true    -- highlight the current line
opt.wrap          = false   -- no line wrapping
opt.linebreak     = true    -- if wrap=true, break at word boundaries
opt.scrolloff     = 8       -- keep 8 lines visible above/below cursor
opt.sidescrolloff = 8       -- keep 8 columns visible left/right
opt.pumheight     = 10      -- max items shown in completion popup
opt.showmode      = false   -- hide "-- INSERT --" (statusline does this)
opt.showtabline   = 0       -- never show native tab bar
opt.conceallevel  = 0       -- show all characters as-is in normal mode
opt.ruler         = false   -- hide default cursor position in cmdline

-- ================================================================
-- SEARCH
-- ================================================================
opt.ignorecase = true   -- case-insensitive search by default
opt.smartcase  = true   -- case-sensitive if query contains uppercase
opt.hlsearch   = true   -- highlight all matches
opt.incsearch  = true   -- show matches incrementally as you type

-- ================================================================
-- SPLITS
-- ================================================================
opt.splitright = true   -- :vsplit → new window on the right
opt.splitbelow = true   -- :split  → new window below

-- ================================================================
-- CLIPBOARD
-- ================================================================
opt.clipboard = "unnamedplus"   -- yank/paste uses system clipboard

-- ================================================================
-- FILES & UNDO
-- ================================================================
opt.undofile    = true
opt.undodir     = vim.fn.stdpath("data") .. "/undo"
opt.swapfile    = false
opt.backup      = false
opt.writebackup = false
opt.autoread    = true    -- reload file if changed outside Neovim

-- ================================================================
-- PERFORMANCE
-- ================================================================
opt.updatetime  = 250     -- ms before CursorHold fires (gitsigns, LSP hints)
opt.timeoutlen  = 400     -- ms to wait for key sequence (which-key sweet spot)
opt.redrawtime  = 1500    -- ms before giving up on slow syntax highlight

-- ================================================================
-- APPEARANCE
-- ================================================================
opt.termguicolors = true   -- 24-bit RGB colors (required by our theme system)
opt.fillchars = {
  eob  = " ",              -- hide ~ at end of buffer
  vert = "│",              -- vertical split separator
  fold = " ",
  diff = "╱",
}
opt.listchars = {
  tab   = "» ",
  trail = "·",
  nbsp  = "␣",
}

-- ================================================================
-- COMPLETION (affects built-in and nvim-cmp)
-- ================================================================
opt.completeopt = { "menuone", "noselect", "noinsert" }
opt.shortmess:append("c")   -- suppress completion messages in cmdline

-- ================================================================
-- FOLDING
-- ================================================================
opt.foldlevel      = 99
opt.foldlevelstart = 99
opt.foldenable     = true
-- treesitter-based folding (set in configs/treesitter.lua):
-- opt.foldmethod = "expr"
-- opt.foldexpr   = "nvim_treesitter#foldexpr()"

-- ================================================================
-- MISCELLANEOUS
-- ================================================================
opt.mouse          = "a"
opt.mousemoveevent = true
opt.iskeyword:append("-")          -- treat kebab-case as one word
opt.whichwrap:append("<>[]hl")     -- cursor wraps across lines
opt.formatoptions:remove("cro")    -- don't auto-insert comment leader on newline
opt.shortmess:append("sI")         -- suppress intro + search count messages
opt.sessionoptions = {
  "buffers", "curdir", "tabpages", "winsize",
  "help", "globals", "skiprtp", "folds",
}

-- ================================================================
-- NEOVIDE (GUI) — no-op in terminal
-- ================================================================
if vim.g.neovide then
  opt.guifont             = "JetBrainsMono Nerd Font:h13"
  vim.g.neovide_padding_top    = 10
  vim.g.neovide_padding_bottom = 10
  vim.g.neovide_padding_left   = 10
  vim.g.neovide_padding_right  = 10
  vim.g.neovide_transparency   = 0.95
  vim.g.neovide_cursor_vfx_mode = "railgun"
end

-- ================================================================
-- GLOBAL FLAGS (read by ui modules)
-- ================================================================
vim.g.have_nerd_font = true   -- signals that nerd font icons are available
```

---

## Cursor Instructions

- Load order: `init.lua` → `require("core.options")` → lazy bootstrap → plugins
- Never use `vim.cmd("set ...")` — always `vim.opt.*`
- Never set `opt.termguicolors = false` — our theme system requires true color
- `opt.showmode = false` is intentional — our custom statusline shows the mode
- The `formatoptions` line prevents `o` and `O` from auto-inserting `//` in code
