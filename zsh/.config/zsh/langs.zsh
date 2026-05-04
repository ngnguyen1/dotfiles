# Language runtimes. Keep heavy managers lazy.

# nvm: load on first use. .nvmrc auto-use runs on directory change.
export NVM_DIR="$HOME/.nvm"

_nvm_load() {
  unfunction nvm node npm npx yarn pnpm 2>/dev/null
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
