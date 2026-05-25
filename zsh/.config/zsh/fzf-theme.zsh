# Keep ~/.config/fzf/active.opts aligned with macOS light/dark (mocha/latte).
# Works without the theme-reload LaunchAgent; reload.sh still updates the symlink for other tools.

_fzf_sync_theme() {
  local fzf_dir="$HOME/.config/fzf"
  [[ -d "$fzf_dir" ]] || return 0
  if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
    ln -sfn "$fzf_dir/mocha.opts" "$fzf_dir/active.opts"
  else
    ln -sfn "$fzf_dir/latte.opts" "$fzf_dir/active.opts"
  fi
}

# fzf key bindings inline opts via __fzf_defaults (cats active.opts once per invocation).
_fzf_wrap_key_bindings() {
  (( $+functions[__fzf_defaults] )) || return 0
  [[ -n "${__fzf_defaults_synced:-}" ]] && return 0
  __fzf_defaults_synced=1
  functions[_fzf_defaults_orig]=$functions[__fzf_defaults]
  __fzf_defaults() {
    _fzf_sync_theme
    _fzf_defaults_orig "$@"
  }
}

if [[ -o interactive ]]; then
  autoload -Uz add-zsh-hook
  _fzf_sync_theme_precmd() {
    local style
    style=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo Light)
    [[ "$style" == "${_FZF_APPEARANCE_CACHE:-}" ]] && return 0
    _FZF_APPEARANCE_CACHE=$style
    _fzf_sync_theme
  }
  add-zsh-hook precmd _fzf_sync_theme_precmd
fi

fzf() {
  _fzf_sync_theme
  command fzf "$@"
}

_fzf_sync_theme
