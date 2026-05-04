-- ESLint LSP registration (called from |core.lsp.setup|, not at lazy-plugins require time).
-- Avoids synchronous `node -p` during startup from |custom.languages.typescript|.

local M = {}

---@param lsp { servers: table }
function M.register(lsp)
  local function get_node_runtime()
    local node_exe = vim.fn.exepath 'node'
    if node_exe == '' then return nil, nil, nil, 'node executable not found in PATH seen by Neovim' end

    local node_version = vim.fn.systemlist { node_exe, '-p', 'process.versions.node' }[1]
    if vim.v.shell_error ~= 0 then return nil, nil, node_exe, 'failed to execute node from Neovim runtime PATH' end

    local major = tonumber((node_version or ''):match '^(%d+)')
    if not major then return nil, node_version, node_exe, 'unable to parse Node version from `node -p process.versions.node`' end

    return major, node_version, node_exe, nil
  end

  local node_major, node_version, node_exe, node_error = get_node_runtime()
  if node_major and node_major >= 18 then
    lsp.servers.eslint = {
      settings = {
        workingDirectory = { mode = 'auto' },
      },
    }
  else
    local detected_node = node_version and ('v' .. node_version) or 'unknown'
    local detected_path = node_exe ~= nil and node_exe or 'not found'
    local reason = node_error and ('Reason: ' .. node_error .. '. ') or ''

    vim.schedule(function()
      vim.notify(
        reason
          .. ('ESLint LSP disabled: requires Node >= 18 to avoid runtime errors like `structuredClone is not defined` (detected %s at %s).')
            :format(detected_node, detected_path)
          .. ' Fix: launch Neovim with a newer Node in PATH (nvm/asdf/Volta), then restart.',
        vim.log.levels.WARN,
        { title = 'LSP: eslint' }
      )
    end)
  end
end

return M
