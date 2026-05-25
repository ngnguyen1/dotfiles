# PATH and environment.

typeset -U path PATH

path=(
  "$HOME/.bin"
  "$HOME/Library/Python/3.9/bin"
  "$HOME/.lmstudio/bin"
  "$HOME/.local/bin"
  "$HOME/.bin/slt-cli"
  "$HOME/.antigravity/antigravity/bin"
  "/opt/homebrew/opt/libpq/bin"
  $path
)

export LANG=en_US.UTF-8
export GSDK="$HOME/silabs/gsdk"
export EZA_CONFIG_DIR="$HOME/.config/eza"
export TMUX_CONF="$HOME/.config/tmux/tmux.conf"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
[[ -t 0 ]] && export GPG_TTY="$(tty)"

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --strip-cwd-prefix --exclude .git'
export FZF_DEFAULT_OPTS="--height=40% --border=rounded --margin=5% --layout=reverse --info=default --prompt='❯ ' --pointer='▶' --header=' ' --header-first --multi"
export FZF_DEFAULT_OPTS_FILE="$HOME/.config/fzf/active.opts"
[[ -r "${ZSH_CONFIG_HOME:-$HOME/.config/zsh}/fzf-theme.zsh" ]] && \
  source "${ZSH_CONFIG_HOME:-$HOME/.config/zsh}/fzf-theme.zsh"
