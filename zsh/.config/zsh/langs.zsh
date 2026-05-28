# Language runtimes. Keep heavy managers lazy.

# NVM_SYMLINK_CURRENT: nvm keeps $NVM_DIR/current → active version dir.
# Must be exported before nvm.sh is sourced so nvm honours it on first load.
export NVM_DIR="$HOME/.nvm"
export NVM_SYMLINK_CURRENT=true

# Pre-add current symlink's bin to PATH — one [[ -d ]] check, zero forks.
# When this path resolves, node/npm/npx/etc work directly via PATH (no stub
# functions shadowing them), so `which node` returns the real binary.
_nvm_has_current=0
[[ -d "$NVM_DIR/current/bin" ]] && { path=("$NVM_DIR/current/bin" $path); _nvm_has_current=1; }

_nvm_load() {
  unfunction nvm node npm npx yarn pnpm 2>/dev/null
  typeset _nvm_brew_prefix

  [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && _nvm_brew_prefix="/opt/homebrew/opt/nvm"
  [[ -z "$_nvm_brew_prefix" && -s "/usr/local/opt/nvm/nvm.sh" ]] && _nvm_brew_prefix="/usr/local/opt/nvm"

  if [[ -n "$_nvm_brew_prefix" && -s "$_nvm_brew_prefix/nvm.sh" ]]; then
    source "$_nvm_brew_prefix/nvm.sh"
    [[ -s "$_nvm_brew_prefix/etc/bash_completion.d/nvm" ]] && source "$_nvm_brew_prefix/etc/bash_completion.d/nvm"
    return
  fi

  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
}

# `nvm` itself always needs the stub (nvm.sh defines it).
nvm() { _nvm_load; nvm "$@"; }

# Only stub node/npm/... when current symlink missing — otherwise PATH wins
# and `which node` returns real binary.
if (( ! _nvm_has_current )); then
  node() { _nvm_load; node "$@"; }
  npm()  { _nvm_load; npm "$@"; }
  npx()  { _nvm_load; npx "$@"; }
  yarn() { _nvm_load; yarn "$@"; }
  pnpm() { _nvm_load; pnpm "$@"; }
fi
unset _nvm_has_current

_nvm_auto_use() {
  [[ -f .nvmrc ]] || return
  _nvm_load
  nvm use --silent
}

autoload -U add-zsh-hook
add-zsh-hook chpwd _nvm_auto_use
