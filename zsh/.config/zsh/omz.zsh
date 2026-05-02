# Oh My Zsh.

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
mkdir -p "${ZSH_COMPDUMP:h}"

zstyle ':omz:update' mode disabled
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
