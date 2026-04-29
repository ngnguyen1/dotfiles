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
export CONFIG_DIR="$HOME/.config/lazygit"
export GPG_TTY="$(tty)"

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --strip-cwd-prefix --exclude .git'
export FZF_DEFAULT_OPTS="--height=40% --border=rounded --margin=5% --layout=reverse --info=default --prompt='❯ ' --pointer='▶' --header=' ' --header-first \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"
