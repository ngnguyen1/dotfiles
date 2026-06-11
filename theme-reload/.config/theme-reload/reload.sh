#!/usr/bin/env bash
# Hot-reload fzf palette and refresh tmux clients when macOS light/dark changes.
set -euo pipefail

cfg_dir="${HOME}/.config"

# Resolve appearance once, then publish it for other tooling that reads the cache file.
if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
  appearance="dark"
else
  appearance="light"
fi
appearance_file="${cfg_dir}/theme-reload/appearance"
mkdir -p "$(dirname "$appearance_file")"
printf '%s\n' "$appearance" >"$appearance_file"

fzf_dir="${cfg_dir}/fzf"
if [[ -d "$fzf_dir" ]]; then
  if [[ "$appearance" == "dark" ]]; then
    ln -sfn "$fzf_dir/mocha.opts" "$fzf_dir/active.opts"
  else
    ln -sfn "$fzf_dir/latte.opts" "$fzf_dir/active.opts"
  fi
fi

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
  reload_cpu
  refresh_tmux_clients
fi
