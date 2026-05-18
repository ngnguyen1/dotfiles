# SSH agent bootstrap for interactive shells.

[[ -o interactive ]] || return

_SSH_AGENT_ENV_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/ssh-agent.env"
mkdir -p "${_SSH_AGENT_ENV_FILE:h}"

_ssh_agent_env_valid() {
  [[ -n "$SSH_AUTH_SOCK" && -S "$SSH_AUTH_SOCK" ]] || return 1

  if command -v ssh-add >/dev/null; then
    ssh-add -l >/dev/null 2>&1
    [[ $? -le 1 ]] || return 1
  fi

  if [[ -n "$SSH_AGENT_PID" ]]; then
    kill -0 "$SSH_AGENT_PID" >/dev/null 2>&1 || return 1
  fi
}

_ssh_agent_load_env() {
  [[ -r "$_SSH_AGENT_ENV_FILE" ]] || return 1
  source "$_SSH_AGENT_ENV_FILE" >/dev/null 2>&1
  _ssh_agent_env_valid
}

_ssh_agent_save_env() {
  [[ -n "$SSH_AUTH_SOCK" && -n "$SSH_AGENT_PID" ]] || return
  {
    echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK"
    echo "export SSH_AGENT_PID=$SSH_AGENT_PID"
  } >| "$_SSH_AGENT_ENV_FILE"
}

if _ssh_agent_env_valid; then
  _ssh_agent_save_env
elif _ssh_agent_load_env; then
  :
elif command -v ssh-agent >/dev/null; then
  eval "$(ssh-agent -s)" >/dev/null
  _ssh_agent_save_env
fi

# Lazy key add on first ssh/scp/sftp — avoids blocking shell startup (e.g. Cursor agent + passphrase prompts).
_ssh_add_default_key() {
  command -v ssh-add >/dev/null || return
  ssh-add -l >/dev/null 2>&1 && return
  local key
  for key in "$HOME/.ssh/id_ed25519" "$HOME/.ssh/id_rsa"; do
    [[ -f "$key" ]] || continue
    ssh-add --apple-use-keychain "$key" 2>/dev/null || ssh-add "$key"
    return
  done
}

ssh() {
  _ssh_add_default_key
  command ssh "$@"
}

scp() {
  _ssh_add_default_key
  command scp "$@"
}

sftp() {
  _ssh_add_default_key
  command sftp "$@"
}

unset _SSH_AGENT_ENV_FILE
