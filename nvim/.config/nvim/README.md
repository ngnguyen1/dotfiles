# Neovim Configuration

A modern Neovim setup focused on speed, clean UI, and maintainable Lua modules.

## Features

- Lazy-loaded plugin architecture with `lazy.nvim`
- Theme-driven statusline (arrow/round/block/none separators)
- Uses Neovim default start screen (no custom dashboard)
- LSP + completion + formatting + linting pipeline
- Mason-based auto-install for language servers and tools
- Well-structured `docs/` specifications for every subsystem

## Requirements

- Neovim `>= 0.11`
- Git
- A Nerd Font (for icons and separator glyphs)
- Optional CLI tools used by formatters/linters:
  - `stylua`, `prettier`, `black`, `isort`, `shfmt`
  - `eslint_d`, `ruff`, `shellcheck`, `markdownlint`

## Installation

1. Backup your current config:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

2. Clone this config:

```bash
git clone <your-repo-url> ~/.config/nvim
```

3. Start Neovim:

```bash
nvim
```

On first launch, plugins install automatically. LSP servers and tools are managed by Mason.

## Project Structure

```text
~/.config/nvim
├── init.lua
├── lua/
│   ├── core/        # options, mappings, highlights, autocmds, integrations
│   ├── configs/     # plugin runtime configs (lsp, cmp, conform, lint, ...)
│   ├── plugins/     # lazy.nvim plugin specs
│   ├── themes/      # palette + base16 + statusline style per theme
│   └── ui/          # statusline
└── docs/            # detailed module specs
```

## Screenshots

Add your screenshots later:

- `assets/screenshots/statusline-tokyonight.png`
- `assets/screenshots/lsp-completion.png`
- `assets/screenshots/telescope.png`

## Keymaps

Keymaps are documented in [KEYMAP.md](./KEYMAP.md) for quick reference.

## Customization

- User-facing settings: `lua/core/config.lua`
- Theme palettes: `lua/themes/*.lua`
- Statusline rendering: `lua/ui/statusline.lua`

## License

This project is licensed under the MIT License. See [LICENSE](./LICENSE).
