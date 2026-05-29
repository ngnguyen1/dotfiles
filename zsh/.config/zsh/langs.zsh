# Language runtimes.

# fnm - fast Node version manager (Homebrew). Reads .nvmrc / .node-version.
if (( $+commands[fnm] )); then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi
