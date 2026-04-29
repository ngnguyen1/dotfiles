# Repository Guidelines

## Project Structure & Module Organization

This is a GNU Stow-managed dotfiles tree. Each top-level directory is a stow package that mirrors paths under `$HOME`.

- `zsh/` contains shell configuration, mainly `zsh/.zshrc`.
- `kitty/` contains Kitty config, helper Python scripts, and terminal docs under `kitty/.config/kitty/`.
- `nvim/` contains the Neovim Lua config under `nvim/.config/nvim/`, with modules in `lua/`.
- `starship/` and `eza/` contain TOML/YAML tool configuration.
- `*/SPEC.md`, `nvim/KEYMAPS.md`, and `README.md` document expected behavior.

There is no conventional `src/` or `tests/` tree; validate with formatting checks, config reloads, and smoke tests.

## Build, Test, and Development Commands

- `stow -n -v */` previews symlinks without changing the home directory.
- `stow */` applies all packages after conflicts are resolved.
- `stow -R nvim` restows one package after file moves or renames.
- `stylua --config-path nvim/.config/nvim/.stylua.toml nvim/.config/nvim` formats Neovim Lua files.
- `nvim --headless "+Lazy! sync" +qa` checks Neovim plugin resolution and lockfile consistency.
- `kitty --debug-config` validates Kitty configuration when Kitty is installed.

Run checks relevant to the files changed, and note unavailable local tools in the PR.

## Coding Style & Naming Conventions

Use two-space indentation for Lua, following `nvim/.config/nvim/.stylua.toml`: Unix line endings, single quotes where possible, and omitted call parentheses where Stylua permits. Keep Lua module names lowercase and descriptive, such as `lua/core/lsp.lua`.

Prefer simple, declarative config in TOML/YAML files. Keep shell changes POSIX-aware where practical, but this repo targets Zsh on macOS.

## Testing Guidelines

There is no automated coverage requirement. For config changes, smoke test the owning application: open Neovim, reload Kitty, source Zsh, or render the prompt. For symlink changes, run `stow -n -v <package>` before applying.

Document manual verification in the PR, for example: `Verified with nvim --headless "+Lazy! sync" +qa`.

## Commit & Pull Request Guidelines

Recent commits use short, imperative, lowercase summaries, such as `add ibl` and `update folding configuration for nvim`.

Pull requests should include a brief description, affected packages, validation commands, and screenshots only for visual changes. Link related issues when applicable.

## Agent-Specific Instructions

Do not overwrite local-only secrets or machine-specific files. Preserve the Stow package layout, avoid unrelated formatting churn, and update nearby `SPEC.md` or keymap docs when behavior changes.
