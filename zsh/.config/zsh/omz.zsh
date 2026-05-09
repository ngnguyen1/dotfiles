# Oh My Zsh.

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"

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
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Local OMZ overrides (machine-specific plugins/options).
OMZ_LOCAL_CONFIG="${ZSH_CONFIG_HOME:-$HOME/.config/zsh}/omz.local.zsh"
[[ -r "$OMZ_LOCAL_CONFIG" ]] && source "$OMZ_LOCAL_CONFIG"

# Bridge Homebrew plugin installs into OMZ's expected plugin paths.
if command -v brew >/dev/null; then
  typeset _plugin_name _brew_dir _target_dir
  for _plugin_name in zsh-autosuggestions zsh-syntax-highlighting; do
    _brew_dir="/opt/homebrew/share/${_plugin_name}"
    _target_dir="${ZSH_CUSTOM}/plugins/${_plugin_name}"
    if [[ -d "$_brew_dir" && ! -e "$_target_dir" ]]; then
      mkdir -p "${ZSH_CUSTOM}/plugins"
      ln -s "$_brew_dir" "$_target_dir" 2>/dev/null
    fi
  done
fi

source "$ZSH/oh-my-zsh.sh"
