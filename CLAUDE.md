# CLAUDE.md — Dotfiles

Personal development environment managed with [GNU Stow](https://www.gnu.org/software/stow/). Symlinks from this repo into `$HOME` / `~/.config`. macOS-first (tested on macOS; paths and some tool flags are mac-specific).

## Repository layout

```
dotfiles/
├── eza/
│   └── .config/eza/theme.yml           # eza color theme
├── kitty/
│   └── .config/kitty/                  # GPU terminal config + kittens
├── nvim/
│   ├── KEYMAPS.md                      # keymap cheatsheet (canonical reference)
│   ├── SPEC.md                         # full plugin/option audit
│   └── .config/nvim/                   # Neovim config (see §Neovim)
├── starship/
│   └── .config/starship/starship.toml  # cross-shell prompt
├── zsh/
│   └── .zshrc                          # shell config
└── README.md
```

Applying symlinks:
```bash
cd ~/personal/dotfiles
stow */          # stow all at once
stow nvim        # or target a single package
```

If a target file already exists stow will not overwrite it — resolve the conflict first.

---

## Neovim (`nvim/`)

### Entry point — `init.lua`

```
leader / localleader = <Space>
vim.g.have_nerd_font  = true
require 'options' → 'autocmds' → 'keymaps' → 'lazy-bootstrap' → 'lazy-plugins'
```

### `options.lua`

| Option | Value | Notes |
|---|---|---|
| `number` / `relativenumber` | true | hybrid line numbers |
| `mouse` | `'a'` | all modes |
| `showmode` | false | lualine shows it |
| `undofile` | true | persistent undo |
| `ignorecase` + `smartcase` | true | smart-case search |
| `signcolumn` | `'yes'` | no jitter |
| `updatetime` | 250 ms | fast CursorHold |
| `timeoutlen` | 300 ms | mapped-sequence timeout |
| `splitright` / `splitbelow` | true | natural splits |
| `clipboard` | `'unnamedplus'` (scheduled post-UiEnter) | OS sync, deferred for startup speed |
| `list` + `listchars` | tab `» ` trail `·` nbsp `␣` | invisible chars |
| `inccommand` | `'split'` | live `:s/…` preview |
| `cursorline` | true (toggled in autocmds) | |
| `scrolloff` | 15 | context around cursor |
| `confirm` | true | prompt instead of fail on `:q` with changes |
| `cmdheight` | 0 | hides cmdline when idle |
| `conceallevel` | 0 | no concealment |
| `wildmode` | `'longest:full,full'` | bash-ish completion |
| `pumheight` | 13 | popup menu max items |
| `termguicolors` | true | 24-bit RGB |
| `splitkeep` | `'screen'` | steady text on split |
| Indent | `tabstop=2 softtabstop=2 shiftwidth=2 shiftround autoindent smartindent expandtab` | 2-space everywhere |
| `grepprg` | `rg --vimgrep` | ripgrep |
| `grepformat` | `%f:%l:%c:%m` | |

### `autocmds.lua`

- `TextYankPost` → `vim.hl.on_yank()`.
- `InsertEnter` / `WinLeave`: hide `cursorline`; `InsertLeave` / `WinEnter`: restore it.
- `FileType` ephemeral list (`fugitive`, `git`, `help`, `qf`, `lspinfo`, `man`, `toggleterm`, …): `buflisted = false`, `q` → close.

### `keymaps.lua`

| Key | Mode | Action |
|---|---|---|
| `;` | n | Enter command line |
| `<Esc>` | n | Clear search highlight |
| `]b` / `[b` | n | Next / prev buffer |
| `<C-h/j/k/l>` | n | Window focus |
| `<C-d>` / `<C-u>` | n | Scroll centered |
| `n` / `N` | n | Search result centered |
| `J` | n | Join line, keep cursor |
| `<C-a>` | n | Select all |
| `<leader>d` | n/v | Delete without yanking |
| `J` / `K` | v | Move selection down/up |
| `p` | v | Paste without clobbering register |
| `<` / `>` | v | Indent (keep selection) |
| `<leader>wv/wh/we/wx` | n | Split vertical/horizontal/equal/close |
| `<leader>w+/-` | n | Window height +2/-2 |
| `<leader>w>/<` | n | Window width +2/-2 |

### `lazy-plugins.lua`

Plugin specs loaded (in order):

```
NMAC427/guess-indent.nvim
core.plugins.colorscheme
core.plugins.lsp
core.plugins.nvim-tree
core.plugins.conform
core.plugins.telescope
core.plugins.treesitter
core.plugins.autopairs
core.plugins.surround
core.plugins.git
core.plugins.lualine
core.plugins.which-key
core.plugins.ibl
custom.plugins.blink-cmp
custom.plugins.folding
```

Lazy options: `checker.enabled = false`. Disabled built-ins: `gzip matchit matchparen netrwPlugin tarPlugin tohtml tutor zipPlugin`.

---

### Plugin reference

#### `colorscheme.lua` — `folke/tokyonight.nvim`
- `priority = 1000`. Loaded before everything.
- `comments.italic = false`.
- Active variant: `tokyonight-night`.

#### `lsp.lua` + `core/lsp.lua` — `neovim/nvim-lspconfig`
- Event: `BufReadPre`, `BufNewFile`.
- Deps: `mason-org/mason.nvim` (cmd `Mason`), `mason-org/mason-lspconfig.nvim`, `WhoIsSethDaniel/mason-tool-installer.nvim`, `j-hui/fidget.nvim`.
- Uses **Neovim 0.11+ API**: `vim.lsp.config(name, cfg)` + `vim.lsp.enable(name)`.
- Capabilities augmented via `require('blink.cmp').get_lsp_capabilities`.
- `mason-lspconfig.ensure_installed` = LSP server names, `automatic_enable = false`.
- `mason-tool-installer.ensure_installed = { 'stylua' }` (non-LSP tools).
- Only configured server: `lua_ls` — formatting disabled (stylua handles it), LuaJIT runtime, detects `.luarc.json` to skip nvim-specific workspace setup.

**Diagnostics config:**
- `severity_sort = true`, `update_in_insert = false`.
- Underline: ERROR only.
- Signs: ` ` / ` ` / ` ` / ` `.
- Virtual text: `source = 'if_many'`, prefix `●`.
- Float: `border = 'rounded'`, `source = 'if_many'`.

**LspAttach keymaps (buffer-local):**

| Key | Mode | Action |
|---|---|---|
| `grn` | n | Rename |
| `gra` | n/x | Code action |
| `grD` | n | Declaration |
| `grr` | n | References (Telescope) |
| `gri` | n | Implementation (Telescope) |
| `grd` | n | Definition (Telescope) |
| `gO` | n | Document symbols (Telescope) |
| `gW` | n | Workspace symbols (Telescope) |
| `grt` | n | Type definition (Telescope) |
| `<leader>ca` | n/x | Code action |
| `<leader>cr` | n | Rename |
| `<leader>cd` | n | Diagnostic float |
| `<leader>cD` | n | Diagnostics list (buffer) |
| `<leader>ci` | n | Organize imports |
| `<leader>cs` | n | Document symbols |
| `<leader>th` | n | Toggle inlay hints (when supported) |

Document highlight on `CursorHold`/`CursorHoldI`, cleared on `CursorMoved`/`LspDetach`. Augroups: `core-lsp-highlight`, `core-lsp-detach`, `core-lsp-attach`.

#### `conform.lua` — `stevearc/conform.nvim`
- Event: `BufReadPre`, `BufNewFile`. Cmd: `ConformInfo`.
- `<leader>cf` → `format({ async = true })` (n/v).
- Auto-format on save: `lua` + `python` only (500 ms timeout). Other filetypes: explicit only.
- Global opt-out: `vim.g.disable_autoformat`; buffer opt-out: `vim.b.disable_autoformat`.
- User commands: `:FormatDisable` (global), `:FormatDisable!` (buffer), `:FormatEnable`.
- `default_format_opts.lsp_format = 'fallback'`.
- `formatters_by_ft.lua = { 'stylua' }`.

#### `telescope.lua` — `nvim-telescope/telescope.nvim`
- Lazy on cmd `Telescope` + eager keys.
- Deps: `plenary.nvim`, `telescope-fzf-native` (built with `make` when available), `telescope-ui-select`, `nvim-web-devicons`.
- Insert-mode `<esc>` → close picker.
- `ui-select` uses `dropdown` theme.

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fr` | Recent files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fd` | Find in `~/personal/dotfiles` |
| `<leader><leader>` | Buffers (quick) |

#### `treesitter.lua` — `nvim-treesitter/nvim-treesitter`
- `lazy = false`, `build = ':TSUpdate'`.
- Dep: `nvim-treesitter-textobjects` (`branch = 'main'`).
- `ensure_installed`: bash, c, diff, html, lua, luadoc, markdown, markdown_inline, query, vim, vimdoc.
- `auto_install = true`. Highlight + indent enabled.
- Incremental selection: `<CR>` init + node extend, `<BS>` shrink, scope disabled.
- Textobject **select** (lookahead): `af/if` function, `ac/ic` class, `aa/ia` parameter.
- Textobject **move**: `]f/[f` function, `]c/[c` class.
- Textobject **swap**: `<leader>a` next param, `<leader>A` prev param.

#### `autopairs.lua` — `windwp/nvim-autopairs`
- Event: `InsertEnter`. `check_ts = true`.
- Disabled in `TelescopePrompt`, `spectre_panel`.
- Fast-wrap: `<M-e>`.

#### `surround.lua` — `kylechui/nvim-surround`
- Event: `VeryLazy`. Default mappings (`ys`, `cs`, `ds`, etc.).

#### `nvim-tree.lua` — `nvim-tree/nvim-tree.lua`
- Lazy on cmd + keys. Disables netrw (`vim.g.loaded_netrw = 1`).
- `view.width = 30`, `renderer.group_empty = true`, `filters.dotfiles = false`.

| Key | Action |
|---|---|
| `<leader>ee` | Toggle explorer |
| `<leader>ef` | Find current file |
| `<leader>er` | Refresh |
| `<leader>ec` | Collapse |

#### `git.lua` — gitsigns + vim-fugitive + diffview.nvim
Three plugins under `<leader>g`.

**gitsigns** (`BufReadPre`/`BufNewFile`):
- Signs: `▎` add/change/changedelete/untracked; `_` delete/topdelete. Staged variants enabled.
- Blame off by default. Blame format: `<author>, <date> — <summary>`.
- Keymaps: `]h/[h` hunks, `<leader>gh{s,r,S,R,u,p}` hunk ops, `<leader>g{b,B,d,D}` blame/diff, `ih` text object.

**fugitive** (cmd-loaded):
| Key | Action |
|---|---|
| `<leader>gg` | Git status |
| `<leader>gc` | Git commit |
| `<leader>gP` | Git push |
| `<leader>gp` | Git pull --rebase |
| `<leader>gl` | Git log (last 20) |
| `<leader>gf` | Git fetch --all |

**diffview** (cmd-loaded):
- `enhanced_diff_hl = true`. Merge tool layout: `diff3_mixed`.
- File panel: left 35 cols.

| Key | Action |
|---|---|
| `<leader>gdo` | Open diff view |
| `<leader>gdc` | Close diff view |
| `<leader>gdh` | File history (current file) |
| `<leader>gdH` | Branch history |
| `<leader>gdt` | Toggle file panel |
| `<leader>gdv` | Smart toggle (open if closed, close if open) |

#### `lualine.lua` — `nvim-lualine/lualine.nvim`
- Event: `VeryLazy`. `globalstatus = true`. Powerline separators.
- Init trick: empty statusline until loaded (no flicker).
- Performance: `lualine_require.require = require` (bypass lualine's slow shim).
- Disabled for: `dashboard alpha ministarter snacks_dashboard nvim-tree`.

Sections:
- **A**: mode
- **B**: DAP status (when active) + branch + macro recording indicator (`󰑋 @{reg}`)
- **C**: diagnostics + filetype icon + relative filename (modified `●` / readonly `` )
- **X**: lazy.nvim pending updates + active LSP clients + git diff (from gitsigns) + encoding (non-utf-8 only) + filetype
- **Y**: search count + progress + location
- **Z**: clock (`os.date('%R')`)
- Inactive: relative filename + location.
- Extensions: `nvim-tree`, `lazy`, `fugitive`, `quickfix`.

#### `which-key.lua` — `folke/which-key.nvim`
- Event: `VimEnter`. `delay = 0`.
- Groups: `<leader>c` Code, `<leader>f` File, `<leader>s` Search, `<leader>t` Toggle, `<leader>h` Git Hunk, `<leader>e` Explorer, `<leader>w` Window, `gr` LSP Actions.

#### `ibl.lua` — `lukas-reineke/indent-blankline.nvim`
- Event: `BufReadPre`. Main module: `ibl`.
- Indent char: `│`. Scope enabled, start/end markers off.
- Excluded filetypes: `help dashboard NvimTree Trouble lazy mason notify toggleterm lazyterm`.

#### `blink-cmp.lua` — `saghen/blink.cmp` (custom/)
- Event: `InsertEnter`. Version `1.*`.
- Dep: `L3MON4D3/LuaSnip 2.*` (`make install_jsregexp`).
- Keymap preset: `default` (`<C-y>` accept, `<C-n/p>` navigate, `<C-e>` hide, `<C-k>` signature).
- Nerd-font variant: `mono`. `docs.auto_show = false`.
- Sources: `lsp path snippets buffer`. `snippets.preset = 'luasnip'`.
- `fuzzy.implementation = 'lua'` — pure-Lua matcher, faster cold start, no binary.
- `signature.enabled = true`.

#### `folding.lua` (custom/) — no external plugin
- **Default**: `foldmethod=expr` + `vim.treesitter.foldexpr()`.
- **LSP upgrade**: `LspAttach` → switches window to `vim.lsp.foldexpr()` when server advertises `textDocument/foldingRange`.
- **Auto-fold imports**: `LspNotify` on `textDocument/didOpen` → `pcall(vim.lsp.foldclose, 'imports', …)`.
- **Python override**: `FileType python` → `foldmethod=indent`.
- Options: `foldlevel=99 foldlevelstart=99 foldnestmax=4 foldtext=''` `fillchars+=fold: `.

| Key | Action |
|---|---|
| `za/zo/zc` | Toggle / open / close fold |
| `zA/zO/zC` | Toggle / open / close recursive |
| `zR/zM` | Open all / close all |
| `zr/zm` | Increase / decrease foldlevel |
| `zx` | Recompute folds (fixes E490 after LSP attach / Telescope jump) |
| `[z/]z` | Fold start / end |
| `zj/zk` | Next / prev fold |

### `.stylua.toml`

```
column_width = 160
line_endings  = "Unix"
indent_type   = "Spaces"
indent_width  = 2
quote_style   = "AutoPreferSingle"
call_parentheses = "None"
collapse_simple_statement = "Always"
```

### External tool requirements (nvim)

`git`, `make`, `ripgrep`, `stylua` (auto-installed by mason), C compiler (treesitter parsers), Nerd Font.

---

## Zsh (`zsh/`)

Single file: `zsh/.zshrc` → stows to `~/.zshrc`.

**Frameworks / tools loaded:**

| Tool | Role | How |
|---|---|---|
| Oh My Zsh | plugin manager | `source $ZSH/oh-my-zsh.sh` |
| Starship | prompt | `eval "$(starship init zsh)"` |
| zoxide | smarter cd | `eval "$(zoxide init zsh --cmd cd)"` |
| pyenv | Python versions | `eval "$(pyenv init - zsh)"` |
| nvm | Node versions | `source $NVM_DIR/nvm.sh` (eager — adds ~100–500 ms startup) |
| fzf | fuzzy finder | `source <(fzf --zsh)` |

**OMZ plugins:** `git gh terraform brew rsync aws eza s-plugin zsh-autosuggestions zsh-syntax-highlighting`

eza plugin: `icons yes` + `git-status yes`.

**History:** `HISTSIZE=1000000`, `SAVEHIST=1000000`. Options: `EXTENDED_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_FIND_NO_DUPS SHARE_HISTORY INC_APPEND_HISTORY`.

**Key env vars:**

| Var | Value |
|---|---|
| `EZA_CONFIG_DIR` | `~/.config/eza` |
| `FZF_DEFAULT_COMMAND` | `fd --type f --strip-cwd-prefix --hidden --follow --exclude .git` |
| `FZF_DEFAULT_OPTS` | Catppuccin-Mocha palette + `--height=40% --border=rounded --margin=5% --reverse --multi` |
| `PYENV_ROOT` | `~/.pyenv` |
| `NVM_DIR` | `~/.nvm` |
| `GPG_TTY` | `$(tty)` |
| `GSDK` | `~/silabs/gsdk` (Silicon Labs SDK) |

**Key aliases:** `cat → bat`, `rm/mv → interactive`, `lg → lazygit`, `f → fzf`, `cdf` fuzzy zoxide cd, `catf` fuzzy bat view.

**Functions:** `git_clean_merged` (prune merged branches), `killport <port>`, `extract <archive>`, `findin <word>` (rg wrapper), `vv` (fuzzy NVIM_APPNAME picker).

**Known issues:**
- `CLOUDSWPASSWD` plaintext password in version control — rotate + remove from history.
- `STARSHIP_CONFIG` not exported (config at non-default path, won't load).
- `CONFIG_DIR` for lazygit does nothing; lazygit reads `XDG_CONFIG_HOME`.
- Duplicate `compinit` calls (startup latency).
- nvm sourced eagerly (slow startup).

---

## Kitty (`kitty/`)

Stows to `~/.config/kitty/`. macOS-only (`macos_*` keys).

**Key settings:**
- Font: `DankMono Nerd Font Mono`, size 18. Ligatures disabled (`font_features none`).
- Theme: `include themes/cyberdream.conf` (active). Others: catppuccin-mocha, cyberdream-transparent, tokyo-night.moon.
- `term xterm-256color` (broad compat; forfeits `xterm-kitty` terminfo).
- `macos_option_as_alt yes`. `hide_window_decorations titlebar-only`.
- Scrollback: 50 000 lines, 50 MB pager history.
- Cursor: underline, trail effect (`cursor_trail 3`).
- `copy_on_select clipboard`. Full clipboard read+write.
- Layouts: `splits stack tall fat grid`. Primary: `splits`.
- `allow_remote_control yes` + `listen_on unix:/tmp/kitty` — control socket (local only).

**Key bindings:**

| Binding | Action |
|---|---|
| `cmd+d` / `cmd+shift+d` | vsplit / hsplit |
| `cmd+w` | close window |
| `cmd+t` | new tab in cwd |
| `ctrl+shift+h/j/k/l` | window nav (nvim-aware via `pass_keys.py`) |
| `alt+arrow` | smart resize (`relative_resize.py`) |
| `ctrl+f` | fzf scrollback search |
| `cmd+shift+e` | hint line numbers → open in nvim |
| `ctrl+.` | bias split to 80% |
| `f7>…` | session jump / picker |

**Python kittens:**
- `pass_keys.py` — detects nvim foreground process, passes keys through to it; otherwise navigates kitty windows. Powers `ctrl+shift+h/j/k/l`.
- `relative_resize.py` — smart resize accounting for neighbor layout; tmux-aware.
- `tab_bar.py` — custom tab-bar drawer (currently inactive; `kitty.conf` uses `powerline` style).

**Known issues:**
- `kitty.conf.bak` committed alongside live config.
- `tab_bar.py` inactive but README claims otherwise.
- Session files referenced by keymaps (`f7>c>m`, `f7>s`) not in repo.

---

## Starship (`starship/`)

`starship/.config/starship/starship.toml` → stows to `~/.config/starship/starship.toml`.

**Important:** Default lookup is `~/.config/starship.toml`. Must export `STARSHIP_CONFIG=$HOME/.config/starship/starship.toml` in `.zshrc` (currently missing).

- Palette: `catppuccin_mocha`.
- `add_newline = false`. `command_timeout = 30000` (high — consider 500–1000 ms).
- Left prompt: `➜ $directory ${custom.giturl} $git_branch $git_state $git_status \n $character`
- Right prompt: `$all`.
- `[custom.giturl]`: runs `git ls-remote --get-url`, maps host to Nerd-Font remote icon.
- Language modules: nodejs, c, rust, golang, php, java, kotlin, haskell, python, docker_context.
- `character.success_symbol`: green `𝘹`. `error_symbol`: red `𝘹`. Vim-mode variants defined.
- Known typo: `vimcmd_symbol = '[](bold fg:creen)'` — `creen` invalid color, should be `green`.

---

## Eza (`eza/`)

`eza/.config/eza/theme.yml` → stows to `~/.config/eza/theme.yml`.

Tokyo-Night palette YAML theme. Sections: `filekinds perms size users links git git_repo security_context file_type` + misc top-level keys. `colourful: true`.

Anchor colors: directory `#7aa2f7`, symlink `#2ac3de`, executable `#9ece6a`, modified `#bb9af7`, warnings `#e0af68 #ff9e64`, errors `#ff007c #db4b4b`.

Requires `EZA_CONFIG_DIR=$HOME/.config/eza` exported in `.zshrc` (present).

---

## Conventions

- **Lua style**: 2-space indent, spaces not tabs, `AutoPreferSingle` quotes, `column_width = 160`. Enforced by stylua via conform on save.
- **Plugin files**: each plugin in its own file under `core/plugins/` or `custom/plugins/`. Return a lazy spec table (or `{}`). Always annotate with `---@module 'lazy'` + `---@type LazySpec`.
- **Keymaps**: grouped by namespace (`<leader>c` code, `<leader>f` file, `<leader>g` git, `<leader>e` explorer, `<leader>w` window, `<leader>t` toggle, `gr` LSP). Document additions in `nvim/KEYMAPS.md`.
- **Spec docs**: `nvim/SPEC.md` is the canonical audit doc — update when adding/changing plugins or options.
- **No auto-update**: `checker = { enabled = false }` in lazy opts. Update manually with `:Lazy update`.
- **Stow**: every tool is its own stow package (directory at repo root). `stow */` links all. New configs go under `<pkg>/.config/<tool>/` or `<pkg>/.<dotfile>` to match the stow target.
