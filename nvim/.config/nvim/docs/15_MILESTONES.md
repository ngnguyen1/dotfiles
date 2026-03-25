# Spec: Milestones — Build Order for Cursor
> Complete each phase fully before moving to the next.

---

## Phase 1 — Skeleton (Day 1)
**Goal:** Neovim opens with no errors. Lazy works. Theme compiles.

- [ ] `init.lua` — leaders + options + lazy bootstrap + lazy.setup + post-setup calls
- [ ] `lua/core/options.lua` — all vim.opt settings
- [ ] `lua/core/config.lua` — minimal: just theme + ui border
- [ ] `lua/core/icons.lua` — icon table (lsp, git, file kinds)
- [ ] `lua/core/highlights.lua` — theme loader + `apply_all()` + `load_integration()`
- [ ] `lua/themes/onedark.lua` — first palette
- [ ] `lua/plugins/init.lua` — empty: `return {}`
- [ ] `lua/core/autocmds.lua` — empty initially
- [ ] `lua/core/mappings.lua` — empty initially

**Validation:**
```
nvim          → opens, no errors
:lua print(vim.g.colors_name)   → should show something
:checkhealth  → no critical errors
```

---

## Phase 2 — Editor Behavior (Day 1-2)
**Goal:** Comfortable editing. Splits, clipboard, autopairs, indent guides, which-key.

- [ ] `lua/core/autocmds.lua` — yank highlight, cursor restore, auto-resize, CloseWithQ
- [ ] `lua/core/mappings.lua` — movement, buffers, splits, clipboard, editing
- [ ] `lua/plugins/init.lua` — autopairs, indent-blankline, which-key, comment, surround
- [ ] `lua/core/integrations/blankline.lua` — highlight integration

**Validation:**
```
<Tab> / <S-Tab>     → cycles buffers
<C-h/j/k/l>        → window navigation
yy + p              → yank highlights briefly
<leader>            → which-key popup appears
gcc                 → toggles comment
```

---

## Phase 3 — UI Modules (Day 2)
**Goal:** Custom statusline working with Neovim default startup screen.

- [ ] `lua/ui/statusline.lua` — full module with mode, file, git, diagnostics, lsp, fileprogress, cursor
- [ ] `lua/core/integrations/statusline.lua` — themed statusline highlights
- [ ] Add `require("ui.statusline").setup()` etc. to `init.lua` post-setup block

**Validation:**
```
nvim              → default Neovim intro screen shows on startup
:e somefile       → statusline shows filename + mode
:vsplit           → statusline stays stable across windows
```

---

## Phase 4 — File Navigation (Day 2-3)
**Goal:** nvim-tree + Telescope fully working.

- [ ] `lua/plugins/ui.lua` — nvim-tree, telescope + fzf-native + ui-select, todo-comments
- [ ] `lua/configs/nvimtree.lua` — nvim-tree options
- [ ] `lua/configs/telescope.lua` — telescope options
- [ ] `lua/core/integrations/nvimtree.lua` — nvimtree highlights
- [ ] `lua/core/integrations/telescope.lua` — telescope highlights

**Validation:**
```
<leader>e         → NvimTree opens/closes
<leader>ff        → Telescope find_files
<leader>fw        → live_grep (needs ripgrep installed)
<leader>fb        → buffer picker
<leader>ut        → theme toggle works
```

---

## Phase 5 — LSP (Day 3)
**Goal:** Go-to-definition, hover, rename, diagnostics for Lua + one more language.

- [ ] `lua/plugins/lsp.lua` — mason, mason-lspconfig, lspconfig, fidget
- [ ] `lua/configs/lspconfig.lua` — on_attach, capabilities, server list, overrides
- [ ] `lua/core/integrations/mason.lua` — mason highlights

**Validation:**
```
:Mason                → UI opens
gd                    → jump to definition (in a .lua file)
K                     → hover docs appear
<leader>ca            → code actions
[d / ]d               → navigate diagnostics
:MasonInstall lua-language-server
```

---

## Phase 6 — Completion (Day 3)
**Goal:** Full completion with snippets.

- [ ] `lua/plugins/completion.lua` — LuaSnip + nvim-cmp + sources
- [ ] `lua/configs/cmp.lua` — full cmp setup
- [ ] `lua/core/integrations/cmp.lua` — cmp menu highlights

**Validation:**
```
(insert mode, start typing)
<C-n>/<C-p>         → completion menu navigates
<Tab>               → expands snippet / jumps field
<CR>                → confirms selection
```

---

## Phase 7 — Treesitter (Day 3-4)

- [ ] `lua/plugins/treesitter.lua` — treesitter + context + textobjects
- [ ] `lua/configs/treesitter.lua` — parser list + all options
- [ ] `lua/core/integrations/treesitter.lua` — treesitter highlights

**Validation:**
```
:TSInstallAll
:InspectTree          → shows AST
af / if               → function text objects work
```

---

## Phase 8 — Formatting & Linting (Day 4)

- [ ] `lua/plugins/formatting.lua` — conform + nvim-lint
- [ ] `lua/configs/conform.lua`
- [ ] `lua/configs/lint.lua`

**Validation:**
```
(save a .lua file with trailing spaces)  → removed by stylua
(save a .js file with eslint error)      → virtual text appears
<leader>lf                               → manual format
<leader>ll                               → manual lint
```

---

## Phase 9 — Git (Day 4)

- [ ] `lua/plugins/git.lua` — gitsigns, lazygit, diffview (gitsigns moves from init.lua)
- [ ] `lua/configs/gitsigns.lua`
- [ ] `lua/core/integrations/gitsigns.lua`

**Validation:**
```
(in a git repo, edit a file)
gutter               → shows added/changed/removed signs
<leader>gg           → LazyGit opens
<leader>gv           → DiffView opens
]c / [c              → jump between hunks
```

---

## Phase 10 — Polish (Day 5+)

- [ ] Add remaining themes: `lua/themes/tokyonight.lua`, `catppuccin.lua`, `gruvbox.lua`
- [ ] `lua/ui/cheatsheet.lua` — auto-generated keymap popup
- [ ] `lua/core/integrations/whichkey.lua` — which-key highlights
- [ ] Tune `lua/core/config.lua` to taste
- [ ] Add personal snippets in `lua/snippets/`

---

## Common Pitfalls for Cursor

| Pitfall                                   | Fix                                                    |
|-------------------------------------------|--------------------------------------------------------|
| `require()` inside `ui/` at module load   | Only `require()` inside functions, never at top level  |
| Forgetting `load_integration()`           | Every plugin with UI needs its integration call        |
| LSP maps set globally                     | LSP maps are buffer-local inside `on_attach`           |
| `opts = {}` on treesitter                 | Treesitter needs `config = function()`, not `opts`     |
| Highlight groups defined in wrong order   | `highlights.apply_all()` must run after `colorscheme clear` |
| `cmp_nvim_lsp` loaded before lspconfig   | `capabilities` must be created before any `.setup()`   |
| `plugins/` file not returning a table     | Every file must end with `return { ... }`              |
