local M = {}

function M.setup()
  -- =========================
  -- LSP ATTACH (keymaps, etc.)
  -- =========================
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('core-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, {
          buffer = event.buf,
          desc = 'LSP: ' .. desc,
        })
      end

      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      local tb = require 'telescope.builtin'

      map('grr', tb.lsp_references, '[R]eferences')
      map('gri', tb.lsp_implementations, '[I]mplementation')
      map('grd', tb.lsp_definitions, '[D]efinition')
      map('gO', tb.lsp_document_symbols, 'Document Symbols')
      map('gW', tb.lsp_dynamic_workspace_symbols, 'Workspace Symbols')
      map('grt', tb.lsp_type_definitions, '[T]ype Definition')

      local client = vim.lsp.get_client_by_id(event.data.client_id)

      -- document highlight
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local group = vim.api.nvim_create_augroup('core-lsp-highlight', { clear = false })

        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = group,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = group,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('core-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds {
              group = 'core-lsp-highlight',
              buffer = event2.buf,
            }
          end,
        })
      end

      -- inlay hints toggle
      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  -- ========================
  -- DIAGNOSTICS
  -- ========================
  vim.diagnostic.config {
    severity_sort = true,
    update_in_insert = false,
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = ' ',
        [vim.diagnostic.severity.WARN] = ' ',
        [vim.diagnostic.severity.INFO] = ' ',
        [vim.diagnostic.severity.HINT] = ' ',
      },
    },
    virtual_text = {
      source = 'if_many',
      spacing = 2,
      prefix = '●',
    },
    float = {
      border = 'rounded',
      source = 'if_many',
    },
  }

  -- =========================
  -- SERVERS CONFIG
  -- =========================
  local servers = {
    lua_ls = {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false

        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua' },
          },
          workspace = {
            checkThirdParty = false,
            library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
              '${3rd}/luv/library',
              '${3rd}/busted/library',
            }),
          },
        })
      end,
      settings = {
        Lua = {
          format = { enable = false },
        },
      },
    },
  }

  -- =========================
  -- MASON INSTALL
  -- =========================
  -- Non-LSP tools (formatters, linters) → mason-tool-installer
  require('mason-tool-installer').setup {
    ensure_installed = { 'stylua' },
  }

  -- LSP servers → mason-lspconfig (auto-installs on startup)
  local server_names = vim.tbl_keys(servers)
  require('mason-lspconfig').setup {
    ensure_installed = server_names,
    automatic_enable = false, -- we wire vim.lsp.enable manually below
  }

  -- =========================
  -- NEW API (Neovim 0.11+)
  -- =========================
  for name, config in pairs(servers) do
    config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)

    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  end
end

return M

-- vim: ts=2 sts=2 sw=2 et
