# Neovim Config — Project Overview

> Inspired by NvChad 2.5 design philosophy · 100% custom · Package manager: lazy.nvim

---

## Goal

Build a blazing-fast, beautiful Neovim configuration **from scratch** — no NvChad dependency.
We borrow NvChad's _ideas_, not its code:

| NvChad Idea We Adopt              | How We Implement It Ourselves                 |
| --------------------------------- | --------------------------------------------- |
| Compiled theme / highlight system | `lua/core/highlights.lua` — cached per theme  |
| base46-style theme table format   | `lua/themes/<name>.lua` returns palette table |
| Statusline with 4 styles          | `lua/ui/statusline.lua` — hand-rolled         |
| Dashboard (custom cowsay)         | `lua/ui/dashboard.lua`                        |
| `chadrc`-style single config      | `lua/core/config.lua` — user's control panel  |
| Per-integration lazy highlights   | `dofile(cache .. "integration")` pattern      |
| Mason auto-install (LSP + tools)  | `lua/plugins/lsp.lua` with mason installers   |

---

## Core Philosophy

| Principle                    | Detail                                                      |
| ---------------------------- | ----------------------------------------------------------- |
| **Zero third-party UI deps** | Statusline, dashboard written in pure Lua                   |
| **Lazy loading**             | 90%+ of plugins lazy-loaded by event, cmd, ft, or keys      |
| **Fast startup**             | Target < 80ms cold start                                    |
| **Single config**            | All user preferences in `lua/core/config.lua`               |
| **Theme system**             | Own palette-based theming that compiles to highlight groups |
| **Modular**                  | Each concern is a separate file; nothing is a monolith      |

---

## Technology Stack

| Layer          | Tool                                  |
| -------------- | ------------------------------------- |
| Plugin manager | `folke/lazy.nvim`                     |
| Icons          | `nvim-tree/nvim-web-devicons`         |
| LSP            | `neovim/nvim-lspconfig`               |
| LSP installer  | `williamboman/mason.nvim`             |
| Completion     | `hrsh7th/nvim-cmp`                    |
| Snippets       | `L3MON4D3/LuaSnip`                    |
| Syntax         | `nvim-treesitter/nvim-treesitter`     |
| Fuzzy finder   | `nvim-telescope/telescope.nvim`       |
| File explorer  | `nvim-tree/nvim-tree.lua`             |
| Formatter      | `stevearc/conform.nvim`               |
| Linter         | `mfussenegger/nvim-lint`              |
| Git signs      | `lewis6991/gitsigns.nvim`             |
| Autopairs      | `windwp/nvim-autopairs`               |
| Which-key      | `folke/which-key.nvim`                |
| Indent guides  | `lukas-reineke/indent-blankline.nvim` |
| Surround       | `kylechui/nvim-surround`              |

---

## Spec Files Index

| File                        | Covers                                            |
| --------------------------- | ------------------------------------------------- |
| `01_DIRECTORY_STRUCTURE.md` | Full file tree with every file explained          |
| `02_BOOTSTRAP.md`           | init.lua + lazy.nvim bootstrap                    |
| `03_CONFIG.md`              | lua/core/config.lua — user control panel          |
| `04_OPTIONS.md`             | lua/core/options.lua — vim.opt settings           |
| `05_THEMING.md`             | Theme system: palettes, highlight compiler, cache |
| `06_UI.md`                  | Statusline, dashboard, cheatsheet                 |
| `07_PLUGINS.md`             | All lazy.nvim plugin specs split by domain        |
| `08_LSP.md`                 | LSP setup: lspconfig + mason + on_attach          |
| `09_COMPLETION.md`          | nvim-cmp + LuaSnip pipeline                       |
| `10_TREESITTER.md`          | Treesitter parsers + highlights                   |
| `11_KEYMAPS.md`             | All keybindings                                   |
| `12_AUTOCMDS.md`            | Autocommands and augroups                         |
| `13_FORMATTING_LINTING.md`  | conform.nvim + nvim-lint                          |
| `14_GIT.md`                 | gitsigns + lazygit + diffview                     |
| `15_MILESTONES.md`          | Ordered build phases for Cursor                   |
