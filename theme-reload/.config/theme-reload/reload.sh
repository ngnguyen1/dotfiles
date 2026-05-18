#!/usr/bin/env bash
# Hot-reload tmux status theme + all local Neovim GUIs when macOS light/dark changes.
set -euo pipefail

cfg_dir="${HOME}/.config"
tmux_theme="${cfg_dir}/tmux/theme.conf"
reload_cpu() {
  local f="${HOME}/.tmux/plugins/tmux-cpu/cpu.tmux"
  if [[ ! -r "$f" ]]; then
    f="${cfg_dir}/tmux/plugins/tmux-cpu/cpu.tmux"
  fi
  if [[ -r "$f" ]]; then
    tmux run-shell "bash \"$f\"; exit 0"
  fi
}

refresh_tmux_clients() {
  local client
  while IFS= read -r client; do
    [[ -z "$client" ]] && continue
    tmux refresh-client -S -t "$client"
  done < <(tmux list-clients -F '#{client_name}' 2>/dev/null || true)
}

if tmux list-sessions >/dev/null 2>&1; then
  if [[ -r "$tmux_theme" ]]; then
    tmux source-file "$tmux_theme"
  fi
  reload_cpu
  refresh_tmux_clients
fi

# headless `nvim --remote-expr` requires a Vim expression; luaeval returns a string.
remote_expr='luaeval("return tostring(require([[core.theme]]).apply())")'
tmp="${TMPDIR:-/tmp}"
while IFS= read -r sock; do
  [[ -z "$sock" ]] && continue
  nvim --server "$sock" --remote-expr "$remote_expr" >/dev/null 2>&1 || true
done < <(find "$tmp" -type s -path '*nvim*' 2>/dev/null)
