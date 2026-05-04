# Neovim Startup And Keymap Review

Generated: 2026-05-04

Scope: `nvim/.config/nvim` on `NVIM v0.12.1`. Review used static Lua inspection, `:verbose map`, and headless startup timing with this repo as `XDG_CONFIG_HOME`.

## Summary

- Empty headless startup loads cleanly. Measured end: about `75 ms`; `LazyDone`: about `60 ms`; lazy saw `27` plugins and `5` loaded plugins.
- Opening `nvim/.config/nvim/init.lua` exposed correctness problems before pure performance tuning: missing Tree-sitter parsers and Mason install checks trying to write during startup.
- Biggest startup costs are first-buffer costs, not empty startup: TypeScript module startup work, Mason/LSP/Fidget setup, Blink/LuaSnip pulled in by LSP capabilities, Gitsigns, and indent-blankline.
- No direct duplicate global keymaps were found in `:verbose map`, but there are important overlaps with Neovim 0.12 default LSP maps, stale docs, and intended Tree-sitter maps that are not active with the current Tree-sitter API.

## High Impact Fixes

### 1. Fix `nvim-treesitter` API mismatch

Current file: `nvim/.config/nvim/lua/core/plugins/treesitter.lua`

The config uses the older module-style API:

- `ensure_installed`
- `auto_install`
- `highlight`
- `indent`
- `incremental_selection`
- `textobjects`

But the installed pinned `nvim-treesitter` `main` branch only accepts install settings like `install_dir`. Its local README also says the plugin does not support lazy-loading. This means much of `treesitter.lua` is likely ignored, including intended textobject and incremental-selection mappings.

Improve:

- Keep `lazy = false` for current `main` branch, because local plugin docs say no lazy-loading.
- Change setup to only valid options, for example `require('nvim-treesitter').setup { install_dir = vim.fn.stdpath('data') .. '/site' }`.
- Enable Tree-sitter features through `FileType` autocmds or ftplugins:
  - `vim.treesitter.start()` for chosen filetypes.
  - window-local `foldexpr` / `foldmethod`.
  - buffer-local `indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"` only for filetypes where it behaves well.
- Configure `nvim-treesitter-textobjects` with its own API, not inside `nvim-treesitter.setup`.
- Or pin an older compatible `nvim-treesitter` revision if you want the old `ensure_installed`/module table style.

### 2. Install Tree-sitter parsers before tuning startup

Runtime check found no parser `.so` files under `~/.local/share/nvim/site/parser`, and opening a Lua file failed:

```text
Parser could not be created for buffer 1 and language "lua"
```

Neovim 0.12's runtime `ftplugin/lua.lua` calls `vim.treesitter.start()` for Lua, so missing parsers are now a runtime error, not just missing highlight.

Improve:

- Run `:TSInstall lua vim vimdoc query bash c diff html markdown markdown_inline` or `:TSUpdate` after fixing the API mismatch.
- Prefer preinstalling parsers over on-demand install for startup speed.
- If you keep automatic parser installation later, expect first open of a new filetype to block or start network/compiler work.

### 3. Move TypeScript Node check out of startup

Current file: `nvim/.config/nvim/lua/custom/languages/typescript.lua`

This module is required during `lazy-plugins.lua` startup. It synchronously runs:

```lua
vim.fn.systemlist { node_exe, '-p', 'process.versions.node' }
```

Measured cost in startup log: about `38 ms` inside `require('custom.languages.typescript')`.

Improve:

- Defer `get_node_runtime()` until an ESLint-capable filetype is opened.
- Or run the check inside the ESLint server config path, not at module top level.
- If the check remains top-level, cache the result in `vim.g` or a module local after first run.

### 4. Stop Mason install checks from running on first buffer

Current files:

- `nvim/.config/nvim/lua/core/plugins/lsp.lua`
- `nvim/.config/nvim/lua/core/lsp.lua`

Opening the first file loads Mason, Mason registry, `mason-lspconfig`, `mason-tool-installer`, and Fidget. The sandboxed run hit `EPERM` because Mason tried to write to the data directory. In normal Neovim this should not be a permission error, but it still means install/check work is on the first-buffer path.

Improve:

- Keep LSP runtime separate from installer management.
- Put Mason UI/install management behind `cmd = 'Mason'` or a manual command.
- For `mason-tool-installer`, consider:

```lua
require('mason-tool-installer').setup {
  ensure_installed = vim.list_extend({ 'stylua' }, M.extra_tools),
  run_on_start = false,
  start_delay = 3000,
  debounce_hours = 24,
}
```

- For `mason-lspconfig`, consider avoiding `ensure_installed = vim.tbl_keys(M.servers)` on startup. Run install/update explicitly when changing config.

### 5. Blink and LuaSnip are not really `InsertEnter` lazy

Current files:

- `nvim/.config/nvim/lua/custom/plugins/blink-cmp.lua`
- `nvim/.config/nvim/lua/core/lsp.lua`

`blink.cmp` is configured with `event = 'InsertEnter'`, but `core/lsp.lua` calls:

```lua
require('blink.cmp').get_lsp_capabilities(config.capabilities)
```

inside LSP setup. That pulls Blink into first-buffer startup before Insert mode. Since Blink depends on LuaSnip here, LuaSnip is pulled in too. In the profiled first-file startup, Blink/LuaSnip showed a large visible cost.

Improve:

- Decide whether completion should be part of LSP startup. If yes, make that explicit and stop expecting `InsertEnter` savings.
- If you do not need LuaSnip-specific snippets, switch Blink to native snippets:

```lua
snippets = { preset = 'default' }
```

Then remove the LuaSnip dependency.

### 6. Avoid loading Telescope during every LSP attach

Current file: `nvim/.config/nvim/lua/core/lsp.lua`

Inside `LspAttach`, this runs immediately:

```lua
local tb = require 'telescope.builtin'
```

That means the first LSP attach can load Telescope even if no Telescope-backed LSP key is pressed.

Improve:

- Lazy-require Telescope inside each mapping callback:

```lua
map('grr', function() require('telescope.builtin').lsp_references() end, '[R]eferences')
```

- Or use Neovim's built-in LSP default maps for `grr`, `gri`, `grt`, `gO` and reserve Telescope for leader mappings.

## Medium Impact Startup Improvements

### 7. Make `guess-indent.nvim` file-lazy

Current file: `nvim/.config/nvim/lua/lazy-plugins.lua`

`guess-indent.nvim` has `opts = {}` but no `event`, `cmd`, or `keys`, so it is a start plugin.

Improve:

```lua
{ 'NMAC427/guess-indent.nvim', event = { 'BufReadPre', 'BufNewFile' }, opts = {} }
```

### 8. Move Conform off `BufReadPre`

Current file: `nvim/.config/nvim/lua/core/plugins/conform.lua`

Conform is mostly needed on save, command, and `<leader>cf`. Loading it on `BufReadPre` puts it on first-buffer startup.

Improve:

- Use `event = 'BufWritePre'`, plus existing `cmd = 'ConformInfo'` and key mapping.
- Keep user commands in `init` so `:FormatDisable` and `:FormatEnable` exist before plugin load.

### 9. Consider moving Gitsigns to `BufReadPost`

Current file: `nvim/.config/nvim/lua/core/plugins/git.lua`

Gitsigns loaded on `BufReadPre` and cost about `43 ms` in the profiled first-file run.

Improve:

- Try `event = { 'BufReadPost', 'BufNewFile' }`.
- If large repos feel slow, consider a big-file guard and disabling expensive attach features for large/generated files.

### 10. Consider moving indent-blankline to `BufReadPost`

Current file: `nvim/.config/nvim/lua/core/plugins/ibl.lua`

`ibl` cost about `13 ms` in the first-file profile.

Improve:

- Try `event = { 'BufReadPost', 'BufNewFile' }`.
- Add a big-file guard if large files feel slow.
- Disable `scope.enabled` for filetypes where scope guides are not worth the redraw cost.

### 11. Move folding setup to filetype/window scope

Current file: `nvim/.config/nvim/lua/custom/plugins/folding.lua`

This file returns `{}`, but all setup runs at require time during startup. It also sets global `foldexpr` to Tree-sitter for all buffers.

Improve:

- Make folding setup a normal config module required from `init.lua`, or a real lazy spec with `init`.
- Prefer `FileType` autocmds and window-local settings:
  - `vim.wo[0][0].foldexpr`
  - `vim.wo[0][0].foldmethod`
- Keep the Python indent-fold override.

## Keymap And Conflict Review

### No direct duplicate global maps found

`:verbose map` did not show direct duplicate global mappings from your config. Lazy key handlers are registered correctly for Telescope, NvimTree, Fugitive, Diffview, and Conform.

### Neovim 0.12 already defines many `gr` LSP maps

Neovim 0.12 defaults include:

- `grn` rename
- `gra` code action
- `grr` references
- `gri` implementation
- `grt` type definition
- `gO` document symbols
- `grx` code lens

Your `core/lsp.lua` remaps most of these buffer-locally on `LspAttach`, replacing default behavior with Telescope-backed behavior for some keys.

Improve:

- Keep remaps if you prefer Telescope, but document that they intentionally override Neovim 0.12 defaults.
- Add `grx` to `KEYMAPS.md`, or remap/code it if you do not want the default.
- Remove redundant `grn` and `gra` buffer-local maps if default behavior is enough.

### `gD` changes native meaning in TypeScript buffers

`gD` is a built-in Vim/Neovim motion for global declaration. Your vtsls attach maps it to TypeScript source definition.

Improve:

- Keep it if source definition is more useful for TS.
- Otherwise move vtsls source definition to a less overloaded key, for example `grs` or `<leader>cs`.

### Tree-sitter intended maps are not active

Because current `nvim-treesitter` `main` no longer uses the old nested module tables, these intended maps did not appear in `:verbose map`:

- incremental selection `<CR>` / `<BS>`
- textobjects `af`, `if`, `ac`, `ic`, `aa`, `ia`
- movement `]f`, `[f`, `]c`, `[c`
- swap `<leader>a`, `<leader>A`

Improve when porting to the new textobjects API:

- Avoid `]c` / `[c` for class navigation; they conflict with Vim diff-change motions.
- Avoid `<CR>` as normal-mode incremental selection; it overrides a common built-in movement habit.
- Use explicit `vim.keymap.set` calls from `nvim-treesitter-textobjects` docs so maps are visible in `:verbose map`.

### Folding keymaps are redundant

Current file: `nvim/.config/nvim/lua/custom/plugins/folding.lua`

The config maps native fold keys to themselves:

- `za`, `zo`, `zc`
- `zA`, `zO`, `zC`
- `zR`, `zM`
- `zr`, `zm`
- `zx`
- `[z`, `]z`, `zj`, `zk`

This is not a runtime conflict, but it overrides mapping metadata and adds startup work without changing behavior.

Improve:

- Remove those mappings.
- Keep the fold section in `KEYMAPS.md` as documentation.

### Which-key groups are stale

Current file: `nvim/.config/nvim/lua/core/plugins/which-key.lua`

Issues:

- `<leader>h` is labeled `Git [H]unk`, but actual hunk maps live under `<leader>gh`.
- `<leader>s` is labeled `[S]earch`, but no search maps exist under `<leader>s`.
- `<leader>g` has no group even though it is the main Git namespace.

Improve:

- Add `{ '<leader>g', group = '[G]it' }`.
- Remove or repurpose `<leader>h` and `<leader>s`.
- Add subgroups like `<leader>gh` for hunk and `<leader>gd` for diffview if you keep that structure.

### Docs drift from actual config

Files:

- `nvim/SPEC.md`
- `nvim/KEYMAPS.md`

Drift found:

- `SPEC.md` says Telescope has `<leader>fh`; actual config does not.
- `SPEC.md` says NvimTree key is `<leader>e`; actual config uses `<leader>ee`, `<leader>ef`, `<leader>er`, `<leader>ec`.
- `SPEC.md` describes old Tree-sitter incremental keys (`<C-space>`, `<C-s>`, `<C-bs>`), but actual config has `<CR>` and `<BS>`, and those maps are not active anyway.
- `KEYMAPS.md` omits Neovim 0.12 default `grx`.

Improve:

- Update docs after fixing Tree-sitter and LSP map decisions.
- Treat `:verbose map` as the source of truth for generated/keymap docs.

## Lower Priority Performance Cleanups

- Add a big-file guard to disable Tree-sitter start, LSP, IBL scope, Gitsigns, diagnostics virtual text, and format-on-save for very large files.
- Consider disabling `cursorline` by default in huge files; it can cost redraw time.
- `lualine` calls `vim.lsp.get_clients { bufnr = 0 }` in statusline refresh. Fine for normal use, but cache if redraws feel slow.
- If Nerd Font is always true, devicons are expected. If using machines without Nerd Font, gate all `nvim-web-devicons` dependencies consistently.

## Verification Commands Used

```sh
env XDG_CONFIG_HOME=/home/ngnguyen/personal/dotfiles/nvim/.config XDG_DATA_HOME=/home/ngnguyen/.local/share XDG_STATE_HOME=/tmp/dotfiles-nvim-state XDG_CACHE_HOME=/tmp/dotfiles-nvim-cache nvim --headless '+qa'
env XDG_CONFIG_HOME=/home/ngnguyen/personal/dotfiles/nvim/.config XDG_DATA_HOME=/home/ngnguyen/.local/share XDG_STATE_HOME=/tmp/dotfiles-nvim-state XDG_CACHE_HOME=/tmp/dotfiles-nvim-cache nvim --headless --startuptime /tmp/dotfiles-nvim-startup-empty.log '+qa'
env XDG_CONFIG_HOME=/home/ngnguyen/personal/dotfiles/nvim/.config XDG_DATA_HOME=/home/ngnguyen/.local/share XDG_STATE_HOME=/tmp/dotfiles-nvim-state XDG_CACHE_HOME=/tmp/dotfiles-nvim-cache nvim --headless --startuptime /tmp/dotfiles-nvim-startup-file.log nvim/.config/nvim/init.lua '+qa'
env XDG_CONFIG_HOME=/home/ngnguyen/personal/dotfiles/nvim/.config XDG_DATA_HOME=/home/ngnguyen/.local/share XDG_STATE_HOME=/tmp/dotfiles-nvim-state XDG_CACHE_HOME=/tmp/dotfiles-nvim-cache nvim --headless nvim/.config/nvim/init.lua '+redir! > /tmp/dotfiles-nvim-maps.txt' '+silent verbose map' '+redir END' '+qa'
```

Notes:

- Empty headless load passed.
- Opening a Lua file failed in this sandboxed run because Tree-sitter parser `lua` was missing and Mason attempted a write that returned `EPERM`.
- Those failures are useful review findings, but re-run on a normal writable Neovim session after installing parsers to get cleaner first-buffer timing.
