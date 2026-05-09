# Language runtimes. Keep heavy managers lazy.

# nvm: load on first use. .nvmrc auto-use runs on directory change.
# Installed by Homebrew; runtime versions still live in $NVM_DIR.
export NVM_DIR="$HOME/.nvm"

_nvm_load() {
  unfunction nvm node npm npx yarn pnpm 2>/dev/null
  typeset _nvm_brew_prefix

  if command -v brew >/dev/null; then
    _nvm_brew_prefix="$(brew --prefix nvm 2>/dev/null)"
  fi

  [[ -z "$_nvm_brew_prefix" && -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && _nvm_brew_prefix="/opt/homebrew/opt/nvm"
  [[ -z "$_nvm_brew_prefix" && -s "/usr/local/opt/nvm/nvm.sh" ]] && _nvm_brew_prefix="/usr/local/opt/nvm"

  if [[ -n "$_nvm_brew_prefix" && -s "$_nvm_brew_prefix/nvm.sh" ]]; then
    source "$_nvm_brew_prefix/nvm.sh"
    [[ -s "$_nvm_brew_prefix/etc/bash_completion.d/nvm" ]] && source "$_nvm_brew_prefix/etc/bash_completion.d/nvm"
    return
  fi

  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
}

nvm()  { _nvm_load; nvm "$@"; }
node() { _nvm_load; node "$@"; }
npm()  { _nvm_load; npm "$@"; }
npx()  { _nvm_load; npx "$@"; }
yarn() { _nvm_load; yarn "$@"; }
pnpm() { _nvm_load; pnpm "$@"; }

_nvm_auto_use() {
  [[ -f .nvmrc ]] || return
  _nvm_load
  nvm use --silent
}

autoload -U add-zsh-hook
add-zsh-hook chpwd _nvm_auto_use
