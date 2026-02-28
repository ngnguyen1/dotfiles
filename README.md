# Dotfiles

A minimal, reproducible setup for my development environment. Managed with [GNU Stow](https://www.gnu.org/software/stow/) for clean symlink-based installation.

---

## Contents

- **Shell** — Zsh configuration (`.zshrc`)
- **Terminal** — [Kitty](https://sw.kovidgoyal.net/kitty/) with themes and custom scripts
- **Editor** — [Neovim](https://neovim.io/) with [NvChad](https://nvchad.com/)-based config (LSP, formatting, keymaps)

---

## Prerequisites

- **macOS** (tested on this platform)
- [Homebrew](https://brew.sh)
- [Git](https://git-scm.com/)

---

## Installation

### 1. Install dependencies

Install Homebrew if needed, then:

```bash
brew install git stow
```

### 2. Clone and install

Clone this repo into your home directory and run Stow to create symlinks:

```bash
git clone git@github.com:ngnguyen1/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow .
```

This will link config files from `~/dotfiles` into your `$HOME` (and `~/.config` where applicable). Existing files are not overwritten; resolve any conflicts manually if needed.

### 3. (Optional) Install applications

- **Kitty**: `brew install kitty`
- **Neovim**: `brew install neovim`

---

## Structure

```
dotfiles/
├── .config/
│   ├── kitty/          # Terminal config, themes, scripts
│   └── nvim/           # Neovim / NvChad config
├── .zshrc              # Zsh config
└── README.md
```

---

## Customization

After installation, edit the cloned files in `~/dotfiles` and commit changes. Stow symlinks will point to the updated files automatically.

---

## License

See [LICENSE](LICENSE) in this repository.
