-- Extend core LSP at require-time.
-- This module is required in lazy-plugins.lua at startup, so M.servers is populated
-- before the first BufReadPre fires and M.setup() runs.
local lsp = require 'core.lsp'

local mason_pkgs = vim.fn.stdpath 'data' .. '/mason/packages'
local vue_plugin_path = mason_pkgs .. '/vue-language-server/node_modules/@vue/language-server'
local astro_plugin_path = mason_pkgs .. '/astro-language-server/node_modules/@astrojs/ts-plugin'

lsp.servers.vtsls = {
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = '@vue/typescript-plugin',
            location = vue_plugin_path,
            languages = { 'vue' },
            configNamespace = 'typescript',
          },
          {
            name = '@astrojs/ts-plugin',
            location = astro_plugin_path,
            languages = { 'astro' },
          },
        },
      },
    },
  },
}

-- Vue 3 — vue_ls (@vue/language-server) for .vue SFCs; hybrid mode forwards TS
-- requests to vtsls on the same buffer (see vuejs/language-tools Neovim wiki).
lsp.servers.vue_ls = {
  filetypes = { 'vue' },
}

lsp.servers.astro = {}

lsp.servers.html = {
  filetypes = { 'html' },
}

lsp.servers.cssls = {}

lsp.servers.tailwindcss = {
  filetypes = {
    'html',
    'css',
    'scss',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
    'astro',
  },
}

local function get_node_runtime()
  local node_exe = vim.fn.exepath 'node'
  if node_exe == '' then return nil, nil, nil, 'node executable not found in PATH seen by Neovim' end

  local node_version = vim.fn.systemlist { node_exe, '-p', 'process.versions.node' }[1]
  if vim.v.shell_error ~= 0 then return nil, nil, node_exe, 'failed to execute node from Neovim runtime PATH' end

  local major = tonumber((node_version or ''):match '^(%d+)')
  if not major then return nil, node_version, node_exe, 'unable to parse Node version from `node -p process.versions.node`' end

  return major, node_version, node_exe, nil
end

-- ESLint LSP: real-time diagnostics + code actions (gra → eslint.fixAll)
-- Fail fast when Node is too old. ESLint 9+ needs structuredClone (Node >= 17),
-- and Node 18+ is the safer baseline for editor tooling.
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

-- prettierd: daemon wrapper, much faster than plain prettier on each save
vim.list_extend(lsp.extra_tools, { 'prettierd' })

vim.g.autoformat_filetypes = vim.tbl_extend('force', vim.g.autoformat_filetypes or {}, {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
  vue = true,
  astro = true,
  html = true,
  css = true,
  scss = true,
  json = true,
  jsonc = true,
})

---@module 'lazy'
---@type LazySpec
return {
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      local prettier_fts = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'vue',
        'astro',
        'html',
        'css',
        'scss',
        'json',
        'jsonc',
      }
      for _, ft in ipairs(prettier_fts) do
        opts.formatters_by_ft[ft] = { 'prettierd' }
      end
      return opts
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
