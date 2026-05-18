# Oh My Zsh.

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"

ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
mkdir -p "${ZSH_COMPDUMP:h}"

zstyle ':omz:update' mode disabled
zstyle ':omz:plugins:eza' 'icons' yes

plugins=(
  git
  gh
  terraform
  brew
  rsync
  aws
  eza
)

# Local OMZ overrides (machine-specific plugins/options).
OMZ_LOCAL_CONFIG="${ZSH_CONFIG_HOME:-$HOME/.config/zsh}/omz.local.zsh"
[[ -r "$OMZ_LOCAL_CONFIG" ]] && source "$OMZ_LOCAL_CONFIG"

source "$ZSH/oh-my-zsh.sh"
