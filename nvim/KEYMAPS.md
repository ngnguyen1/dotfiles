# Neovim Keymaps Reference

## General (`keymaps.lua`)

| Key | Mode | Action |
|-----|------|--------|
| `;` | n | Enter command mode |
| `<Esc>` | n | Clear search highlights |
| `]b` / `[b` | n | Next / prev buffer |
| `<C-h/j/k/l>` | n | Move focus between windows |
| `<C-d>` / `<C-u>` | n | Scroll down / up centered |
| `n` / `N` | n | Next / prev search result centered |
| `J` | n | Join line, keep cursor in place |
| `<C-a>` | n | Select all |
| `<leader>d` | n/v | Delete without yanking |

## Visual Mode (`keymaps.lua`)

| Key | Action |
|-----|--------|
| `J` / `K` | Move selection down / up |
| `p` | Paste without clobbering register |
| `<` / `>` | Indent left / right (keep selection) |

## Window (`<leader>w`) — `keymaps.lua`

| Key | Action |
|-----|--------|
| `<leader>wv` | Split vertical |
| `<leader>wh` | Split horizontal |
| `<leader>we` | Equal size all windows |
| `<leader>wx` | Close window |
| `<leader>w+` / `<leader>w-` | Window height +2 / -2 |
| `<leader>w>` / `<leader>w<` | Window width +2 / -2 |

## Code (`<leader>c`) — `core/lsp.lua` + `conform.lua`

| Key | Action | Source |
|-----|--------|--------|
| `<leader>ca` | Code actions | lsp.lua |
| `<leader>cf` | Format buffer / selection | conform.lua |
| `<leader>cr` | Rename symbol | lsp.lua |
| `<leader>cd` | Diagnostic float (line) | lsp.lua |
| `<leader>cD` | Diagnostics list (buffer) | lsp.lua |
| `<leader>ci` | Organize imports | lsp.lua |
| `<leader>cs` | Document symbols | lsp.lua |

> `:FormatDisable` / `:FormatEnable` toggle autoformat (conform.lua user commands).

## File (`<leader>f`) — `core/plugins/telescope.lua`

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fr` | Recent files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fd` | Find dotfiles (`~/personal/dotfiles`) |
| `<leader><leader>` | Buffers (quick) |

## Explorer (`<leader>e`) — `core/plugins/nvim-tree.lua`

| Key | Action |
|-----|--------|
| `<leader>ee` | Toggle explorer |
| `<leader>ef` | Find current file in explorer |
| `<leader>er` | Refresh explorer |
| `<leader>ec` | Collapse explorer |

## LSP Go-to (`gr`) — `core/lsp.lua`

| Key | Action |
|-----|--------|
| `grn` | Rename |
| `gra` | Code action |
| `gD` | Source definition (vtsls command) |
| `grf` | File references (vtsls command) |
| `grr` | References |
| `gri` | Implementation |
| `grd` | Definition |
| `grt` | Type definition |
| `gO` | Document symbols |
| `gW` | Workspace symbols |

## Toggle (`<leader>t`) — `core/lsp.lua`

| Key | Action |
|-----|--------|
| `<leader>th` | Toggle inlay hints (LSP buffer-local) |

## Git (`<leader>g`) — `core/plugins/git.lua`

### Gitsigns — hunk actions (buffer-local)

| Key | Mode | Action |
|-----|------|--------|
| `]h` / `[h` | n | Next / prev hunk |
| `<leader>ghs` | n/v | Stage hunk |
| `<leader>ghr` | n/v | Reset hunk |
| `<leader>ghS` | n | Stage buffer |
| `<leader>ghR` | n | Reset buffer |
| `<leader>ghu` | n | Undo stage hunk |
| `<leader>ghp` | n | Preview hunk inline |
| `<leader>gb` | n | Toggle line blame |
| `<leader>gB` | n | Blame line (full) |
| `<leader>gd` | n | Diff against index |
| `<leader>gD` | n | Diff against last commit |
| `ih` | o/x | Select hunk (text object) |

### Fugitive

| Key | Action |
|-----|--------|
| `<leader>gg` | Git status |
| `<leader>gc` | Git commit |
| `<leader>gP` | Git push |
| `<leader>gp` | Git pull (rebase) |
| `<leader>gl` | Git log (last 20) |
| `<leader>gf` | Git fetch all |

### Diffview

| Key | Action |
|-----|--------|
| `<leader>gdo` | Open diff view |
| `<leader>gdc` | Close diff view |
| `<leader>gdh` | File history (current file) |
| `<leader>gdH` | Branch history |
| `<leader>gdt` | Toggle file panel |
| `<leader>gdv` | Toggle diff view (smart open/close) |

## Folding (`z`) — `custom/plugins/folding.lua`

| Key | Action |
|-----|--------|
| `za` / `zA` | Toggle fold / recursive |
| `zo` / `zO` | Open fold / recursive |
| `zc` / `zC` | Close fold / recursive |
| `zR` | Open all folds |
| `zM` | Close all folds |
| `zr` | Increase foldlevel |
| `zm` | Decrease foldlevel |
| `zx` | Recompute folds (fixes E490 after LSP attach / Telescope jump) |
| `[z` / `]z` | Go to fold start / end |
| `zj` / `zk` | Next / prev fold |
