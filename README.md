# Dotfiles

This repository contains the source of truth for my local development environment configuration.  
Its goal is to provide a clean, reproducible, and version-controlled setup for shell, terminal, and editor preferences.

Configurations are managed with [GNU Stow](https://www.gnu.org/software/stow/), which creates symlinks from this repository into `$HOME` and `~/.config`.

## What This Project Covers

- **Shell**: Zsh configuration via `.zshrc`
- **Terminal**: [Kitty](https://sw.kovidgoyal.net/kitty/) themes and custom behavior
- **Editor**: [Neovim](https://neovim.io/) hand-rolled config — `lazy.nvim`, `blink.cmp`, `nvim-lspconfig` + `mason.nvim`, treesitter, telescope (LSP, formatting, keymaps)

## Why This Exists

- Keep all personal developer settings in one place
- Rebuild a machine quickly with consistent tooling
- Track configuration changes over time with Git
- Reduce setup drift across environments

## Prerequisites

- **macOS** (currently tested platform)
- [Homebrew](https://brew.sh)
- [Git](https://git-scm.com/)
- [GNU Stow](https://www.gnu.org/software/stow/)

## Installation

### 1) Install required tools

```bash
brew install git stow
```

### 2) Clone and apply symlinks

```bash
git clone git@github.com:ngnguyen1/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow */
```

Stow links files from `~/dotfiles` into your home directory. If a target file already exists, Stow will not overwrite it; resolve conflicts before retrying.

### 3) Install optional applications

```bash
brew install kitty neovim
```

## Repository Structure

```text
dotfiles/
├── .config/
│   ├── kitty/          # Kitty configuration
│   └── nvim/           # Neovim configuration (lazy.nvim, hand-rolled)
├── .zshrc              # Zsh configuration
└── README.md
```

## Customization Workflow

Update files directly inside `~/dotfiles`, then commit your changes. Because your system uses symlinks, updates apply immediately without copying files.

## License

See [LICENSE](LICENSE).
