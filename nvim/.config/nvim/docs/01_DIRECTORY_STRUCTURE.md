# Spec: Directory Structure
> Complete file tree — every file, its role, and its convention

---

## Full File Tree

```
~/.config/nvim/
├── init.lua                          ← Entry point: sets leaders, bootstraps lazy.nvim
├── lazy-lock.json                    ← Auto-generated lockfile (commit this)
├── .stylua.toml                      ← Lua formatter config
├── .gitignore
│
└── lua/
    │
    ├── core/                         ── Core engine (no plugin dependencies)
    │   ├── config.lua                ← User control panel (theme, UI prefs, options)
    │   ├── options.lua               ← All vim.opt settings
    │   ├── autocmds.lua              ← Augroups and autocmds
    │   ├── mappings.lua              ← Global keymaps
    │   ├── highlights.lua            ← Theme compiler: reads palette → writes highlight groups
    │   └── icons.lua                 ← Centralized icon definitions (LSP, git, UI)
    │
    ├── themes/                       ── Theme palettes (NvChad base46-style)
    │   ├── onedark.lua
    │   ├── tokyonight.lua
    │   ├── catppuccin.lua
    │   ├── gruvbox.lua
    │   └── rosepine.lua
    │
    ├── ui/                           ── Hand-rolled UI modules (no plugin)
    │   ├── statusline.lua            ← Statusline renderer
    │
    ├── plugins/                      ── lazy.nvim plugin specs (one file per domain)
    │   ├── init.lua                  ← Core plugins (autopairs, indent, gitsigns, which-key, surround)
    │   ├── ui.lua                    ← nvim-tree, telescope, devicons
    │   ├── lsp.lua                   ← mason, mason-lspconfig, nvim-lspconfig
    │   ├── completion.lua            ← nvim-cmp, LuaSnip, sources
    │   ├── treesitter.lua            ← nvim-treesitter, treesitter-context
    │   ├── formatting.lua            ← conform.nvim, nvim-lint
    │   └── git.lua                   ← gitsigns, lazygit, diffview
    │
    └── configs/                      ── Plugin setup functions (called by plugin specs)
        ├── lspconfig.lua             ← Server list + on_attach + capabilities
        ├── cmp.lua                   ← nvim-cmp setup
        ├── treesitter.lua            ← Treesitter options
        ├── telescope.lua             ← Telescope options
        ├── nvimtree.lua              ← nvim-tree options
        ├── conform.lua               ← Formatter-per-filetype map
        ├── lint.lua                  ← Linter-per-filetype map + autocmd
        └── gitsigns.lua              ← Gitsigns options + hunk keymaps
```

---

## File Convention Rules

### `lua/core/` — No plugin dependencies allowed
Every file in `core/` must work with zero plugins loaded. These run before lazy.nvim
has initialized anything. If a file needs a plugin, it goes in `configs/` instead.

### `lua/themes/<n>.lua` — Must return a palette table
```lua
-- Pattern every theme file must follow:
local M = {}
M.palette = { ... }   -- 30 named colors
M.type    = "dark"    -- or "light"
return M
```

### `lua/ui/*.lua` — Pure Lua UI, no plugin deps
Statusline is implemented using only `vim.api`, `vim.fn`,
and `vim.opt`.

### `lua/plugins/*.lua` — Must return a table
```lua
-- Every file in plugins/ must look like this:
return {
  { "author/plugin", ... },
  { "author/plugin2", ... },
}
```
lazy.nvim auto-discovers and merges all files in `lua/plugins/`.

### `lua/configs/*.lua` — Call `.setup()`, return nothing
```lua
-- configs/ files call setup directly, return nothing
require("some-plugin").setup({ ... })
```
They are called from plugin specs via `config = function() require("configs.X") end`.

---

## `.stylua.toml`

```toml
column_width = 120
line_endings = "Unix"
indent_type = "Spaces"
indent_width = 2
quote_style = "AutoPreferDouble"
call_parentheses = "Always"
```

---

## `.gitignore`

```gitignore
# Ignore lazy plugin cache directory
.DS_Store

# Don't ignore lazy-lock.json — commit it for reproducible installs
```

---

## Load Order (critical for Cursor)

```
init.lua
  ├── vim.g.mapleader = " "          (1) leaders must be first
  ├── require("core.options")         (2) editor settings before plugins
  ├── [lazy bootstrap]                (3) clone lazy if missing
  ├── require("lazy").setup(...)      (4) loads all plugins
  │     └── { import = "plugins" }   (5) discovers lua/plugins/*.lua
  └── require("core.autocmds")        (6) autocmds after plugins
      require("core.mappings")        (7) global mappings after plugins
      require("core.highlights")      (8) compile + apply theme
      require("ui.statusline").setup() (9) mount UI modules
```
