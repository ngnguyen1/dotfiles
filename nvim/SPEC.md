# nvim/ — Spec

Personal Neovim configuration. Built from scratch (the README's NvChad reference is stale — current code is hand-rolled, not NvChad). Plugin manager: `lazy.nvim`. Completion: `blink.cmp`. LSP: `nvim-lspconfig` + `mason.nvim`.

## Layout

```
nvim/
└── .config/
    └── nvim/
        ├── init.lua                       # entry point
        ├── .stylua.toml                   # lua formatter config
        ├── lazy-lock.json                 # lazy plugin pin file
        └── lua/
            ├── options.lua                # vim.opt / vim.o settings
            ├── autocmds.lua               # generic autocmds
            ├── keymaps.lua                # leader / window keymaps
            ├── lazy-bootstrap.lua         # clone lazy.nvim if missing
            ├── lazy-plugins.lua           # require all plugin specs
            ├── core/
            │   ├── lsp.lua                # LspAttach handler + servers
            │   └── plugins/
            │       ├── colorscheme.lua    # tokyonight
            │       ├── lsp.lua            # lspconfig + mason wiring
            │       ├── nvim-tree.lua      # file tree
            │       ├── conform.lua        # formatter
            │       ├── telescope.lua      # fuzzy finder
            │       ├── treesitter.lua     # parsers + textobjects
            │       ├── autopairs.lua      # bracket pairing
            │       ├── surround.lua       # surround text-object
            │       ├── git.lua            # gitsigns + fugitive + diffview
            │       ├── lualine.lua        # statusline
            │       └── which-key.lua      # leader-key hints (NOT REGISTERED)
            └── custom/
                └── plugins/
                    └── blink-cmp.lua      # completion
```

## init.lua

1. Sets `<leader>` and `<localleader>` to space.
2. `vim.g.have_nerd_font = true`.
3. `require 'options'`, `'autocmds'`, `'keymaps'`, `'lazy-bootstrap'`, `'lazy-plugins'`.

## options.lua

| Setting | Value | Notes |
|---|---|---|
| `number`, `relativenumber` | `true` | hybrid line numbers |
| `breakindent` | `true` | preserve indent on wrap |
| `mouse` | `'a'` | mouse in all modes |
| `completeopt` | `'menuone,noselect'` | always show menu, never preselect |
| `showmode` | `false` | lualine shows mode instead |
| `undofile` | `true` | persistent undo |
| `ignorecase` + `smartcase` | `true` | smart case search |
| `signcolumn` | `'yes'` | always shown — prevents jitter |
| `updatetime` | `250` ms | fast CursorHold (LSP doc highlight) |
| `timeoutlen` | `300` ms | mapped sequence timeout |
| `splitright`, `splitbelow` | `true` | natural split direction |
| `clipboard` | `'unnamedplus'` (scheduled post-UiEnter) | OS clipboard sync, deferred for startup speed |
| `list` + `listchars` | tab `» `, trail `·`, nbsp `␣` | invisible char hints |
| `inccommand` | `'split'` | live `:s/...` preview |
| `cursorline` | `true` | (toggled per-window in autocmds) |
| `scrolloff` | `15` | keep 15 lines around cursor |
| `confirm` | `true` | prompt instead of fail on `:q` with changes |
| `cmdheight` | `0` | hide cmdline when idle |
| `conceallevel` | `0` | no concealment |
| `wildmode` | `'longest:full,full'` | bash-ish completion |
| `pumheight` | `13` | (typo: `vim.pumheight` instead of `vim.opt.pumheight`/`vim.o.pumheight` — has no effect) |
| `termguicolors` | `true` | (same typo: `vim.termguicolors`) |
| `splitkeep` | `'screen'` | (same typo: `vim.splitkeep`) |
| Indent | `tabstop=2`, `softtabstop=2`, `shiftwidth=2`, `shiftround`, `autoindent`, `smartindent`, `expandtab` | 2-space indent |
| `grepprg` | `rg --vimgrep` | use ripgrep for `:grep` |
| `grepformat` | `%f:%l:%c:%m` | match ripgrep output |

⚠ Three options are misspelled (`vim.pumheight`, `vim.termguicolors`, `vim.splitkeep`). Should be `vim.opt.*` or `vim.o.*`. Currently they create global Lua variables and silently no-op.

## autocmds.lua

- `TextYankPost` → `vim.hl.on_yank()` (highlight yanked region).
- `InsertEnter`/`WinLeave` + `InsertLeave`/`WinEnter` pair: hides `cursorline` while typing or in inactive split, restores on exit.
- `FileType` for ephemeral buffers (`OverseerForm`, `OverseerList`, `floggraph`, `fugitive`, `git`, `help`, `lspinfo`, `man`, `neotest-output`, `neotest-summary`, `qf`, `query`, `spectre_panel`, `startuptime`, `toggleterm`, `tsplayground`, `vim`): unset `buflisted`, map `q` to close.

## keymaps.lua

| Key | Mode | Action |
|---|---|---|
| `;` | n | `:` (enter command line without shift) |
| `<Esc>` | n | clear search highlight |
| `<C-h/j/k/l>` | n | window navigation |

## lazy-bootstrap.lua

Clones `folke/lazy.nvim` (stable branch) into `stdpath('data')/lazy/lazy.nvim` if missing, then prepends to `runtimepath`.

## lazy-plugins.lua

Calls `require('lazy').setup({...}, opts)`. Specs loaded:
- `NMAC427/guess-indent.nvim`
- `core.plugins.colorscheme`
- `core.plugins.lsp`
- `core.plugins.nvim-tree`
- `core.plugins.conform`
- `core.plugins.telescope`
- `core.plugins.treesitter`
- `core.plugins.autopairs`
- `core.plugins.surround`
- `core.plugins.git`
- `core.plugins.lualine`
- `custom.plugins.blink-cmp`

❗ `core.plugins.which-key` is **not** in the require list — `which-key.nvim` is never loaded despite the spec file existing.

Lazy options:
- `checker = { enabled = false }` — no auto-update check.
- `performance.rtp.disabled_plugins`: gzip, matchit, matchparen, netrwPlugin, tarPlugin, tohtml, tutor, zipPlugin.
- `ui.icons` toggled by `vim.g.have_nerd_font`.

## Plugins (per file)

### colorscheme.lua — `folke/tokyonight.nvim`
- `priority = 1000` (loaded first).
- `comments = { italic = false }`.
- Sets `tokyonight-night`.

### lsp.lua + core/lsp.lua — `neovim/nvim-lspconfig`
- Lazy event: `BufReadPre`, `BufNewFile`.
- Deps: `mason.nvim` (`cmd = 'Mason'`), `mason-lspconfig.nvim`, `mason-tool-installer.nvim`, `j-hui/fidget.nvim`.
- `core.lsp.setup()`:
  - `LspAttach` autocmd defines buffer-local keymaps:
    - `grn` rename, `gra` code action (n+x), `grD` declaration.
    - Telescope-backed: `grr` references, `gri` impl, `grd` def, `gO` doc symbols, `gW` workspace symbols, `grt` type def.
    - `<leader>th` toggle inlay hints (when supported).
    - Document highlight under cursor (CursorHold), cleared on CursorMoved/LspDetach, with augroups `core-lsp-highlight` / `core-lsp-detach`.
  - Servers configured: `stylua` (formatter only — installed via mason-tool-installer, not actually an LSP) and `lua_ls` (with project-local `.luarc.json` detection, runtime `LuaJIT`, library path includes nvim runtime + `${3rd}/luv/library` + `${3rd}/busted/library`, formatting disabled to defer to stylua via conform).
  - **Uses Neovim 0.11+ API**: `vim.lsp.config(name, config)` + `vim.lsp.enable(name)`.
  - Capabilities augmented via `require('blink.cmp').get_lsp_capabilities`.

### conform.lua — `stevearc/conform.nvim`
- Lazy: `BufReadPre`/`BufNewFile`, cmd `ConformInfo`.
- `<leader>f` → `format({ async = true })` (n+v).
- Format-on-save: only `lua` and `python` (500 ms timeout). Other filetypes are explicit-only.
- `default_format_opts.lsp_format = 'fallback'` — LSP formats only if no formatter is configured.
- `formatters_by_ft.lua = { 'stylua' }`.

### telescope.lua — `nvim-telescope/telescope.nvim`
- Lazy on `:Telescope`, with eager keys.
- Deps: `plenary.nvim`, `telescope-fzf-native` (built with `make` if available), `telescope-ui-select`, `nvim-web-devicons` (gated on Nerd Font).
- Keys: `<leader>ff` files, `<leader>fg` live grep, `<leader>fb` buffers, `<leader>fh` help, `<leader><leader>` buffers.
- Insert mode `<esc>` → close picker.
- `ui-select` extension uses `dropdown` theme.
- Loads `fzf` and `ui-select` extensions via `pcall`.

### treesitter.lua — `nvim-treesitter/nvim-treesitter`
- `lazy = false`, `build = ':TSUpdate'`.
- Dep: `nvim-treesitter-textobjects` on `branch = 'main'`.
- `ensure_installed`: bash, c, diff, html, lua, luadoc, markdown, markdown_inline, query, vim, vimdoc.
- `auto_install = true`. Highlight + indent enabled.
- Incremental selection: `gnn` init, `grn`/`grc` extend, `grm` shrink. **`grn` clashes with the LSP rename keymap** (LSP wins on attach since it's buffer-local, but in non-LSP buffers treesitter takes it).
- Textobjects:
  - select: `af`/`if` function, `ac`/`ic` class, `aa`/`ia` parameter (lookahead).
  - move: `]f`/`[f` function, `]c`/`[c` class.
  - swap: `<leader>a` next param, `<leader>A` previous param.

### autopairs.lua — `windwp/nvim-autopairs`
- Lazy: `InsertEnter`.
- `check_ts = true` (treesitter-aware).
- Disabled in `TelescopePrompt`, `spectre_panel`.
- `fast_wrap` mapped to `<M-e>`.

### surround.lua — `kylechui/nvim-surround`
- Lazy: `VeryLazy`.
- Defaults (`ys`, `cs`, `ds`, etc.).

### nvim-tree.lua — `nvim-tree/nvim-tree.lua`
- Lazy: cmd `NvimTreeToggle`/`NvimTreeFindFile`, key `<leader>e`.
- Disables netrw via `vim.g.loaded_netrw{,Plugin}`.
- `view.width = 30`, `renderer.group_empty = true`, `filters.dotfiles = false` (dotfiles shown).

### git.lua — `gitsigns.nvim` + `vim-fugitive` + `diffview.nvim`
Three plugins under one `<leader>g` namespace. Detailed keymap cheatsheet lives at the bottom of the file.

- **gitsigns** (`BufReadPre`/`BufNewFile`):
  - Custom signs (`▎` for add/change/changedelete/untracked, `_` for delete/topdelete).
  - `signs_staged_enable = true`.
  - Blame off by default; `<leader>gb` toggles.
  - `on_attach` keymaps: `]h`/`[h` next/prev hunk (diff-aware), `<leader>gh{s,r,S,R,u,p}` hunk ops, `<leader>g{b,B,d,D}` blame/diff, `ih` text object.
- **fugitive** (cmd-loaded `Git`/`G`/`Gdiffsplit`/...):
  - Keymaps: `<leader>gg` status, `<leader>gc` commit, `<leader>gP` push, `<leader>gp` pull --rebase, `<leader>gl` log -20, `<leader>gf` fetch --all.
- **diffview** (cmd-loaded):
  - Keymaps: `<leader>gd{o,c,h,H,t,v}` open/close/file-history/branch-history/toggle-files/toggle.
  - `enhanced_diff_hl`, `merge_tool.layout = 'diff3_mixed'`, file panel left @ 35 cols, diff buffers strip wrap/list/colorcolumn.

### lualine.lua — `nvim-lualine/lualine.nvim`
- Lazy: `VeryLazy`.
- Init trick: empty statusline until lualine loads (no flicker).
- LazyVim trick: `lualine_require.require = require` (skip lualine's slow shim).
- `globalstatus = true`. Powerline separators.
- Sections: A mode → B branch → C diagnostics + ft icon + filename(rel, with modified `●`/RO icons) → X diff (sourced from `vim.b.gitsigns_status_dict`) + encoding (only when not utf-8) + filetype → Y progress + location → Z `os.date('%R')` (clock).
- Inactive: just relative filename + location.
- Extensions: `neo-tree`, `lazy`, `fugitive`, `quickfix`. `neo-tree` listed but **neo-tree is not installed** (this config uses nvim-tree).

### which-key.lua — `folke/which-key.nvim`
- Spec: groups for `<leader>s`, `<leader>t`, `<leader>h`, `<leader>f`, `<leader>e`, and `gr`.
- ⚠ Not registered in `lazy-plugins.lua` → currently dead code.

### blink-cmp.lua — `saghen/blink.cmp` (custom/)
- Lazy: `InsertEnter`. Version `1.*`.
- Dep: `LuaSnip 2.*` (`make install_jsregexp`).
- Keymap preset: `default`. Nerd-font variant: `mono`. Docs `auto_show = false`.
- Sources default: `lsp`, `path`, `snippets`, `buffer`.
- `snippets.preset = 'luasnip'`.
- `fuzzy.implementation = 'lua'` — pure-Lua matcher (no native binary, faster cold start).
- `signature.enabled = true`.

## .stylua.toml

```
column_width = 160
line_endings = "Unix"
indent_type = "Spaces"
indent_width = 2
quote_style = "AutoPreferSingle"
call_parentheses = "None"
collapse_simple_statement = "Always"
```

## lazy-lock.json

Pinned plugin commits. **Should be checked in** (it is). Reproducibility comes from this file.

## Required external tools

- `git`, `make` (for `telescope-fzf-native`).
- `ripgrep` (for `grepprg`).
- `stylua` (auto-installed via mason-tool-installer).
- A C compiler (for treesitter parser builds).
- A Nerd Font.

## Issues / smells

2. `treesitter.incremental_selection.node_incremental = 'grn'` collides conceptually with LSP rename; LSP attach overrides it buffer-locally, but document or rebind to avoid surprise.
4. `stylua = {}` listed alongside `lua_ls` in the `servers` table inside `core/lsp.lua`. Stylua isn't an LSP server — it gets ensure-installed via mason-tool-installer (which is the actual intent), but the loop calls `vim.lsp.config('stylua', {})` and `vim.lsp.enable('stylua')` which is a no-op at best. Move stylua out of `servers` and ensure_install it separately, or use a dedicated `mason-tool-installer.ensure_installed` list.
5. README at repo root says nvim is "based on NvChad" — code is custom. Update.
6. `format_on_save` only covers `lua` + `python`; consider opt-out via `b:disable_autoformat` for project-by-project control.
7. No diagnostic configuration (signs, virtual_text, severity_sort, float window). Defaults are noisy — consider `vim.diagnostic.config({...})`.
8. No `mason-lspconfig` `ensure_installed` populated — if Mason hasn't installed `lua-language-server` interactively, LSP won't start. The pattern usually is `mason-lspconfig.ensure_installed = vim.tbl_keys(servers)`.
