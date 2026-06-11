# Minimal Zsh entrypoint. Real config lives in ~/.config/zsh.

ZSH_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

source "$ZSH_CONFIG_HOME/exports.zsh"
source "$ZSH_CONFIG_HOME/ssh-agent.zsh"
source "$ZSH_CONFIG_HOME/history.zsh"
source "$ZSH_CONFIG_HOME/omz.zsh"
source "$ZSH_CONFIG_HOME/langs.zsh"
source "$ZSH_CONFIG_HOME/aliases.zsh"
source "$ZSH_CONFIG_HOME/functions.zsh"
source "$ZSH_CONFIG_HOME/completions.zsh"
source "$ZSH_CONFIG_HOME/plugins.zsh"
source "$ZSH_CONFIG_HOME/prompt.zsh"

[[ -r "$ZSH_CONFIG_HOME/local.zsh" ]] && source "$ZSH_CONFIG_HOME/local.zsh"

# zoxide last, interactive shells only — avoids doctor false positives when AI tools
# spawn non-interactive zsh subprocesses that source ~/.zshrc.
if [[ -o interactive ]]; then
  command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd cd)"
fi
