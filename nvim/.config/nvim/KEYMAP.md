# Keymaps

Leader key: `<Space>`

## Core

| Key | Mode | Action |
| --- | --- | --- |
| `<Esc>` | `n` | Clear search highlight |
| `<C-s>` | `n,i` | Save file |
| `<leader>q` | `n` | Quit all |
| `<leader>Q` | `n` | Force quit all |
| `n` / `N` | `n` | Next/prev search result (centered) |
| `<C-d>` / `<C-u>` | `n` | Scroll half page (centered) |
| `<C-h/j/k/l>` | `n` | Window navigation |

## Buffers and Splits

| Key | Mode | Action |
| --- | --- | --- |
| `<Tab>` / `<S-Tab>` | `n` | Next/prev buffer |
| `<leader>x` | `n` | Close current buffer |
| `<leader>X` | `n` | Close all other buffers |
| `<leader>sv` / `<leader>sh` | `n` | Vertical/horizontal split |
| `<leader>se` | `n` | Equalize split sizes |
| `<leader>sc` | `n` | Close split |
| `<C-Up/Down/Left/Right>` | `n` | Resize split |

## Editing and Clipboard

| Key | Mode | Action |
| --- | --- | --- |
| `J` / `K` | `v` | Move selected lines down/up |
| `<leader>p` | `x` | Paste without clobbering register |
| `<leader>y` | `n,v` | Yank to system clipboard |
| `<leader>Y` | `n` | Yank line to system clipboard |
| `<leader>D` | `n,v` | Delete to void register |
| `<` / `>` | `v` | Indent and keep selection |
| `J` | `n` | Join line without moving cursor |

## Explorer and Search

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>e` | `n` | Toggle file explorer |
| `<leader>fe` | `n` | Focus explorer |
| `<leader>fr` | `n` | Reveal current file |
| `<leader>ff` | `n` | Telescope find files |
| `<leader>fw` | `n` | Telescope live grep |
| `<leader>fb` | `n` | Telescope buffers |
| `<leader>fh` | `n` | Telescope help tags |
| `<leader>fo` | `n` | Telescope recent files |
| `<leader>fm` | `n` | Telescope marks |
| `<leader>fz` | `n` | Telescope fuzzy in current buffer |
| `<leader>fk` | `n` | Telescope keymaps |
| `<leader>fc` | `n` | Telescope commands |
| `<leader>ft` | `n` | Telescope TODOs |

## Diagnostics and LSP

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>dl` | `n` | Diagnostic float |
| `[d` / `]d` | `n` | Prev/next diagnostic |
| `<leader>dq` | `n` | Diagnostics to location list |
| `<leader>dt` / `<leader>ds` | `n` | Trouble diagnostics/symbols |
| `gd` / `gD` / `gi` / `gt` | `n` | LSP definition/declaration/impl/type |
| `gr` | `n` | LSP references (Telescope) |
| `K` / `<C-k>` | `n` | LSP hover/signature help |
| `<leader>ca` / `<leader>rn` | `n` | LSP code action/rename |
| `<leader>wa` / `<leader>wr` / `<leader>wl` | `n` | LSP workspace folder ops |
| `<leader>lf` | `n` | Format buffer |

## Git

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>gg` / `<leader>gf` | `n` | LazyGit / current file |
| `<leader>gv` / `<leader>gh` | `n` | Diffview open / file history |
| `[c` / `]c` | `n` | Prev/next hunk |
| `<leader>gs` / `<leader>gr` | `n,v` | Stage/reset hunk |
| `<leader>gS` / `<leader>gR` | `n` | Stage/reset buffer |
| `<leader>gu` | `n` | Undo stage hunk |
| `<leader>gp` | `n` | Preview hunk |
| `<leader>gB` | `n` | Blame line |
| `<leader>gd` | `n` | Diff this |
| `ih` | `o,x` | Select hunk text object |

## UI, Terminal, and Lint

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>ut` / `<leader>up` / `<leader>uz` | `n` | Toggle theme / pick theme / toggle transparency |
| `<leader>;` | `n` | Open dashboard |
| `<A-i>` | `n,t` | Toggle floating terminal |
| `<Esc>` | `t` | Exit terminal mode |
| `<leader>th` / `<leader>tv` | `n` | Horizontal/vertical terminal |
| `<leader>ll` | `n` | Run available linters |
