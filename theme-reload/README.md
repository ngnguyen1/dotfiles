# theme-reload

Hot-reload **tmux** Catppuccin status (via `theme.conf`) and **Neovim** Catppuccin when macOS switches light/dark.

## Layout (GNU Stow)

Package `theme-reload/` stows to:

- `~/.config/theme-reload/reload.sh` — run from tmux `prefix + T` or the LaunchAgent listener
- `~/.config/theme-reload/bootstrap.sh` — compile Swift listener + install LaunchAgent plist
- `~/.config/theme-reload/listener.swift` — source for `theme-listener`
- `~/.config/theme-reload/com.ngnguyen.theme-reload.plist.in` — template (`__HOME__` → expanded by bootstrap)

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
- Neovim: `:ThemeReload` or `<leader>tT` (see `nvim/KEYMAPS.md`).
