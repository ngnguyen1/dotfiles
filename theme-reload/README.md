# theme-reload

Hot-reload **tmux** Catppuccin status (via `theme.conf`) and **fzf** palette (`~/.config/fzf/active.opts`) when macOS switches light/dark.

## Layout (GNU Stow)

Package `theme-reload/` stows to:

- `~/.config/theme-reload/reload.sh` — run from tmux `prefix + T` or the LaunchAgent listener
- `~/.config/theme-reload/bootstrap.sh` — compile Swift listener + install LaunchAgent plist
- `~/.config/theme-reload/listener.swift` — source for `theme-listener`
- `~/.config/theme-reload/com.ngnguyen.theme-reload.plist.in` — template (`__HOME__` → expanded by bootstrap)
- `~/.config/theme-reload/appearance` — runtime cache (`dark`/`light`) written by `reload.sh`; **gitignored**, not tracked

## Appearance cache

`reload.sh` resolves the macOS appearance once (via `defaults read -g AppleInterfaceStyle`) and writes `dark`/`light` to `~/.config/theme-reload/appearance`. `bootstrap.sh` seeds the file at install time. Neovim uses a fixed `tokyonight-night` colorscheme and is not reloaded by this package.

## One-time setup

```bash
cd ~/personal/dotfiles   # or your clone
stow theme-reload
chmod +x ~/.config/theme-reload/reload.sh ~/.config/theme-reload/bootstrap.sh
~/.config/theme-reload/bootstrap.sh
```

`bootstrap.sh` writes `~/.config/theme-reload/theme-listener`, materializes `~/Library/LaunchAgents/com.ngnguyen.theme-reload.plist`, and runs `launchctl bootstrap`.

### Uninstall service

```bash
launchctl bootout "gui/$(id -u)/com.ngnguyen.theme-reload"
rm -f ~/Library/LaunchAgents/com.ngnguyen.theme-reload.plist
```

## Related dotfiles

- TMUX: `prefix + T` runs `reload.sh` (see `tmux/.config/tmux/tmux.conf`).
- fzf: `FZF_DEFAULT_OPTS_FILE` points at `active.opts`; `reload.sh` swaps the symlink to `mocha.opts` or `latte.opts` (see `fzf/.config/fzf/`). Zsh also syncs via `zsh/.config/zsh/fzf-theme.zsh` (on startup, precmd when appearance changes, and before Ctrl-T / plain `fzf`) so fzf tracks the system theme even without the LaunchAgent.
