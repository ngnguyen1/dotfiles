# Minimal Zsh entrypoint. Real config lives in ~/.config/zsh.

ZSH_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

source "$ZSH_CONFIG_HOME/exports.zsh"
source "$ZSH_CONFIG_HOME/history.zsh"
source "$ZSH_CONFIG_HOME/omz.zsh"
source "$ZSH_CONFIG_HOME/langs.zsh"
source "$ZSH_CONFIG_HOME/aliases.zsh"
source "$ZSH_CONFIG_HOME/functions.zsh"
source "$ZSH_CONFIG_HOME/completions.zsh"
source "$ZSH_CONFIG_HOME/prompt.zsh"

[[ -r "$ZSH_CONFIG_HOME/local.zsh" ]] && source "$ZSH_CONFIG_HOME/local.zsh"
