# nvim/ — Spec

Personal Neovim configuration, hand-rolled. Plugin manager: `lazy.nvim`. Completion: `blink.cmp`. LSP: `nvim-lspconfig` + `mason.nvim` + `mason-lspconfig`. Formatter: `conform.nvim` + `mason-tool-installer`.

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
            │   ├── treesitter_incsel.lua  # TS incremental selection keymaps
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
            │       ├── which-key.lua      # leader-key hints
            │       └── ibl.lua            # indent guides
            └── custom/
                ├── folding.lua            # treesitter/LSP fold options (from init.lua)
                ├── languages/
                │   ├── eslint.lua         # eslint LSP + Node version gate
                │   └── typescript.lua     # vtsls, vue_ls, astro, web stack, conform fts
                └── plugins/
                    └── blink-cmp.lua      # completion
```

## init.lua

1. Sets `<leader>` and `<localleader>` to space.
2. `vim.g.have_nerd_font = true`.
3. `require 'options'`, `'autocmds'`, `'keymaps'`, `'lazy-bootstrap'`, `'lazy-plugins'`, then `require('custom.folding').setup()`.

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
| `pumheight` | `13` | max items in popup menu |
| `termguicolors` | `true` | 24-bit RGB |
| `splitkeep` | `'screen'` | keep text steady on split |
| Indent | `tabstop=2`, `softtabstop=2`, `shiftwidth=2`, `shiftround`, `autoindent`, `smartindent`, `expandtab` | 2-space indent |
| `grepprg` | `rg --vimgrep` | use ripgrep for `:grep` |
| `grepformat` | `%f:%l:%c:%m` | match ripgrep output |

## autocmds.lua

- `TextYankPost` → `vim.hl.on_yank()` (highlight yanked region).
- `BufReadPost` restore last cursor position (skip selected git/hex ft).
- `InsertEnter`/`WinLeave` + `InsertLeave`/`WinEnter` pair: hides `cursorline` while typing or in inactive split, restores on exit.
- `FileType` for ephemeral buffers (`OverseerForm`, `OverseerList`, `floggraph`, `fugitive`, `git`, `help`, `lspinfo`, `man`, `neotest-output`, `neotest-summary`, `qf`, `query`, `spectre_panel`, `startuptime`, `toggleterm`, `tsplayground`, `vim`): unset `buflisted`, map `q` to close.
- User commands `FormatDisable` / `FormatDisable!` / `FormatEnable` for conform autoformat (always defined; Conform may lazy-load on `BufWritePre`).

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
- `NMAC427/guess-indent.nvim` (`BufReadPre` / `BufNewFile`)
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
- `core.plugins.which-key`
- `core.plugins.ibl`
- `custom.plugins.blink-cmp`
- `custom.languages.typescript` — extends `core.lsp.servers`, format-on-save filetypes, prettierd fts

(`custom/folding.lua` is loaded from `init.lua`, not as a lazy plugin.)

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
    - `grn` rename, `gra` code action (n+x).
    - `gD` vtsls source-definition command, `grf` vtsls file-references command (direct `workspace/executeCommand`, no extra plugin).
    - Telescope-backed: `grr` references, `gri` impl, `grd` def, `gO` doc symbols, `gW` workspace symbols, `grt` type def.
    - `<leader>th` toggle inlay hints (when supported).
    - Document highlight under cursor (CursorHold), cleared on CursorMoved/LspDetach, with augroups `core-lsp-highlight` / `core-lsp-detach`.
  - Diagnostic config set via `vim.diagnostic.config`: severity-sorted, signs (error/warn/info/hint glyphs), virtual_text with `if_many` source + `●` prefix, rounded float border, no in-insert updates, underline only for ERROR.
  - Server table `core.lsp.servers`: extended before setup by `custom/languages/typescript.lua`. Base merge in `core/lsp.lua`: `lua_ls` (project-local `.luarc.json` detection, runtime `LuaJIT`, library path includes nvim runtime + `${3rd}/luv/library` + `${3rd}/busted/library`, formatting disabled for stylua/conform).
  - Extended servers (see below): `vtsls`, `vue_ls`, `astro`, `html`, `cssls`, `tailwindcss`, `eslint`.
  - **Uses Neovim 0.11+ API**: `vim.lsp.config(name, config)` + `vim.lsp.enable(name)`.
  - Capabilities augmented via `require('blink.cmp').get_lsp_capabilities`.
  - Auto-install: `mason-lspconfig.ensure_installed = vim.tbl_keys(M.servers)` (`automatic_enable = false`). Mason packages map nvim-lspconfig names (e.g. `vue_ls` → `vue-language-server`, `vtsls` → `vtsls`). `mason-tool-installer.ensure_installed = { 'stylua' }` plus `M.extra_tools` (e.g. `prettierd`); **`run_on_start = false`** so installs are manual / deferred (`:Mason`).

### custom/languages/typescript.lua — JS/TS/Vue/Astro toolchain
- **`vtsls`**: filetypes `javascript`, `javascriptreact`, `typescript`, `typescriptreact`, **`vue`** — VS Code–aligned TypeScript service. Registers `@vue/typescript-plugin` and `@astrojs/ts-plugin` via `settings.vtsls.tsserver.globalPlugins` (paths under Mason’s `vue-language-server` and `astro-language-server` packages) so `.vue` SFCs and `.astro` imports resolve from TS/JS buffers.
- **`vue_ls`**: filetypes `vue` — `@vue/language-server` (Vue 3). Upstream nvim-lspconfig wires hybrid mode: Vue LS coordinates SFCs and forwards TS-related traffic to **`vtsls`** on the **same buffer** (see [Vue language-tools Neovim wiki](https://github.com/vuejs/language-tools/wiki/Neovim)).
- Also registers: `astro`, `html`, `cssls`, `tailwindcss`; adds `prettierd` to `mason-tool-installer`; extends `vim.g.autoformat_filetypes` and conform `formatters_by_ft` for web stacks.
- **`eslint`**: registered from `custom/languages/eslint.lua` inside `core.lsp.setup()` — probes runtime `node` and only adds `eslint` to `M.servers` when Node major >= 18; otherwise one scheduled warning with fix guidance (same intent as previous guard, without synchronous `node -p` during lazy-plugins `require`).

#### Vue LSP verification (local checklist)
1. **Mason**: `:Mason` — ensure **`vtsls`**, **`vue-language-server`**, and **`astro-language-server`** are installed (Astro package supplies `@astrojs/ts-plugin` for vtsls).
2. **Two clients on `.vue`**: `:LspInfo` with a `.vue` buffer open — expect **`vue_ls`** and **`vtsls`** both attached (hybrid depends on both).
3. **Project deps**: open Neovim from the **project root** (`package.json`). The app should list **`typescript`** in `dependencies` / `devDependencies` so `node_modules/typescript` resolves (avoids server init errors around TS resolution).
4. **Astro from TS**: in a `.ts` buffer, confirm `import "./Foo.astro"` resolves after Mason packages are present.

### conform.lua — `stevearc/conform.nvim`
- Lazy: `BufWritePre` (also loads via `cmd` / `<leader>cf` keys). Cmd `ConformInfo`.
- `<leader>cf` → `format({ async = true })` (n+v).
- Format-on-save: always `lua` and `python`; additional filetypes come from `vim.g.autoformat_filetypes` (extended by `custom/languages/typescript.lua` for vue, astro, html, css, json, etc.) — 500 ms timeout when enabled.
- Opt-out: `vim.g.disable_autoformat` (global) and `vim.b.disable_autoformat` (buffer) short-circuit `format_on_save`. User commands `:FormatDisable` / `:FormatDisable!` / `:FormatEnable` are defined in **`autocmds.lua`** (available before Conform loads).
- `default_format_opts.lsp_format = 'fallback'` — LSP formats only if no formatter is configured.
- Base `formatters_by_ft`: `lua → stylua`. `custom/languages/typescript.lua` merges `prettierd` for vue, astro, html, css, json, etc.

### telescope.lua — `nvim-telescope/telescope.nvim`
- Lazy on `:Telescope`, with eager keys.
- Deps: `plenary.nvim`, `telescope-fzf-native` (built with `make` if available), `telescope-ui-select`, `nvim-web-devicons` (gated on Nerd Font).
- Keys: `<leader>ff` files, `<leader>fr` recent, `<leader>fg` live grep, `<leader>fb` buffers, `<leader>fd` dotfiles, `<leader><leader>` buffers.
- Insert mode `<esc>` → close picker.
- `ui-select` extension uses `dropdown` theme.
- Loads `fzf` and `ui-select` extensions via `pcall`.

### treesitter.lua — `nvim-treesitter/nvim-treesitter`
- `lazy = false`, `build = ':TSUpdate'` (upstream README: do not lazy-load).
- Dep: `nvim-treesitter-textobjects` on `branch = 'main'`.
- **Main rewrite**: `setup { install_dir }` only; `install()` schedules baseline parsers; `FileType` autocmd runs `vim.treesitter.start()` + experimental TS `indentexpr` for listed filetypes.
- Textobjects: explicit keymaps via `nvim-treesitter-textobjects` — select `af/if`, `ac/ic`, `aa/ia`; move `]f`/`[f`, **`]O`/`[O`** for class (not `]c`/`[c`); swap `<leader>a` / `<leader>A`.
- Incremental selection: `core/treesitter_incsel.lua` — `<leader>v` (normal), `<CR>` / `<BS>` (visual).

### autopairs.lua — `windwp/nvim-autopairs`
- Lazy: `InsertEnter`.
- `check_ts = true` (treesitter-aware).
- Disabled in `TelescopePrompt`, `spectre_panel`.
- `fast_wrap` mapped to `<M-e>`.

### surround.lua — `kylechui/nvim-surround`
- Lazy: `VeryLazy`.
- Defaults (`ys`, `cs`, `ds`, etc.).

### nvim-tree.lua — `nvim-tree/nvim-tree.lua`
- Lazy on cmd + keys (`<leader>ee`, …).
- Disables netrw via `vim.g.loaded_netrw{,Plugin}`.
- `view.width = 30`, `renderer.group_empty = true`, `filters.dotfiles = false` (dotfiles shown).

### git.lua — `gitsigns.nvim` + `vim-fugitive` + `diffview.nvim`
Three plugins under one `<leader>g` namespace. Detailed keymap cheatsheet lives at the bottom of the file.

- **gitsigns** (`BufReadPost`/`BufNewFile`):
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
- Extensions: `nvim-tree`, `lazy`, `fugitive`, `quickfix`.

### which-key.lua — `folke/which-key.nvim`
- Spec: groups for `<leader>c`, `<leader>f`, `<leader>t`, `<leader>g`, `<leader>gh`, `<leader>gd`, `<leader>e`, `<leader>w`, and `gr`.

### ibl.lua — `indent-blankline.nvim`
- Lazy: `BufReadPost` / `BufNewFile`. Indent char `│`, scope guides enabled.

### folding (`custom/folding.lua`)
No external plugin — required from `init.lua` after `lazy-plugins`.

- **Fold method**: `expr` + `vim.treesitter.foldexpr()` by default.
- **LSP upgrade**: `LspAttach` autocmd switches window to `vim.lsp.foldexpr()` when server advertises `textDocument/foldingRange`.
- **Auto-fold imports**: `LspNotify` on `textDocument/didOpen` calls `vim.lsp.foldclose('imports', …)` via `pcall`.
- **Python override**: `FileType python` → `foldmethod = indent` (treesitter folds unreliable for Python).
- Options: `foldlevel = 99`, `foldlevelstart = 99` (open by default), `foldnestmax = 4`, `foldtext = ''` (transparent — preserves first-line syntax highlight), `fillchars += fold:·`.
- No buffer-local fold **remaps** — native `z` commands only (see `nvim/KEYMAPS.md`).

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
- **Vue/TS projects**: install **`typescript`** (and other tooling) in the **application repo** — Mason supplies editors’ language servers, not your app’s `node_modules`.

## Issues / smells

- Operational: Vue hybrid LSP needs **`vue_ls` + `vtsls`** on the buffer and a local **`typescript`** package — see **Vue LSP verification** under `custom/languages/typescript.lua` in this spec.
