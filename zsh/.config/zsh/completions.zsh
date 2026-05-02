# Completion setup. OMZ already runs compinit and bashcompinit.

if command -v vault >/dev/null; then
  complete -o nospace -C "$(command -v vault)" vault
fi

if command -v fzf >/dev/null; then
  source <(fzf --zsh)
fi

if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi
