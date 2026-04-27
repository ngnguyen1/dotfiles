# Neovim Keymaps Reference

## General (`keymaps.lua`)

| Key | Action |
|-----|--------|
| `;` | Enter command mode |
| `<Esc>` | Clear search highlights |
| `]b` | Next buffer |
| `[b` | Previous buffer |
| `<C-h/j/k/l>` | Move focus between windows |

## Code (`<leader>c`) — LSP (`core/lsp.lua`)

| Key | Action |
|-----|--------|
| `<leader>ca` | Code actions |
| `<leader>cf` | Format buffer/selection |
| `<leader>cr` | Rename symbol |
| `<leader>cd` | Show diagnostic (line) |
| `<leader>cD` | Show diagnostics (buffer) |
| `<leader>ci` | Organize imports |
| `<leader>cs` | Document symbols |

> `<leader>cf` defined in `conform.lua`. Rest in `core/lsp.lua` LspAttach.

## File (`<leader>f`) — Telescope (`core/plugins/telescope.lua`)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fr` | Recent files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fd` | Find dotfiles (`~/personal/dotfiles`) |
| `<leader><leader>` | Buffers (quick) |

## LSP Go-to (`gr`) — `core/lsp.lua`

| Key | Action |
|-----|--------|
| `grn` | Rename |
| `gra` | Code action |
| `grD` | Declaration |
| `grr` | References |
| `gri` | Implementation |
| `grd` | Definition |
| `grt` | Type definition |
| `gO` | Document symbols |
| `gW` | Workspace symbols |

## Toggle (`<leader>t`) — `core/lsp.lua`

| Key | Action |
|-----|--------|
| `<leader>th` | Toggle inlay hints |

## Git (`<leader>h`) — `core/plugins/git.lua`

Gitsigns hunk actions — see `git.lua` for full list.
