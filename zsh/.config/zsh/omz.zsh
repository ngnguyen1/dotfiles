# Oh My Zsh.

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

zstyle ':omz:update' frequency 15
zstyle ':omz:plugins:eza' 'icons' yes
zstyle ':omz:plugins:eza' 'git-status' yes

plugins=(
  git
  gh
  terraform
  brew
  rsync
  aws
  eza
  s-plugin
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"
