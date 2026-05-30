# Prompt.

command -v starship >/dev/null && eval "$(starship init zsh)"

# zoxide initialized last (after OMZ, plugins, and starship) so its chpwd/precmd
# hooks register cleanly — avoids the zoxide doctor "initialize at the end" warning.
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd cd)"
