# Completion setup. OMZ already runs compinit and bashcompinit.

if command -v vault >/dev/null; then
  complete -o nospace -C "$(command -v vault)" vault
fi

# Re-anchor to OMZ dump path (vault/bashcompinit can otherwise write broken ~/.zcompdump*).
# One-time cleanup if you see compdef errors: rm -f ~/.zcompdump*
[[ -n "$ZSH_COMPDUMP" ]] && {
  autoload -Uz compinit
  compinit -C -d "$ZSH_COMPDUMP"
}

if command -v fzf >/dev/null; then
  source <(fzf --zsh)
fi

if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi
