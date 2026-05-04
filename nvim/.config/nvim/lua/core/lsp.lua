local M = {}

-- Extend these tables from language files before M.setup() fires.
-- Language files are required in lazy-plugins.lua at startup, before any BufReadPre.
M.servers = {}
M.extra_tools = {} -- non-LSP mason tools (formatters, linters); stylua added in setup()

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
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      local tb = require 'telescope.builtin'

      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

      local function get_vtsls_client()
        local clients = vim.lsp.get_clients { bufnr = event.buf, name = 'vtsls' }
        return clients[1]
      end

      local function show_vtsls_locations(title, locations, source_client, opts)
        opts = opts or {}
        if not locations then
          vim.notify(('No results for %s.'):format(title), vim.log.levels.INFO, { title = 'LSP: vtsls' })
          return
        end

        if type(locations) ~= 'table' then
          vim.notify(('Unexpected vtsls response for %s (expected locations list).'):format(title), vim.log.levels.WARN, { title = 'LSP: vtsls' })
          return
        end

        if vim.tbl_isempty(locations) then
          vim.notify(('No results for %s.'):format(title), vim.log.levels.INFO, { title = 'LSP: vtsls' })
          return
        end

        if #locations == 1 then
          vim.lsp.util.show_document(locations[1], source_client.offset_encoding, { reuse_win = opts.reuse_win, focus = true })
          return
        end

        local items = vim.lsp.util.locations_to_items(locations, source_client.offset_encoding)
        vim.fn.setqflist({}, ' ', { title = title, items = items })
        vim.cmd 'botright copen'
      end

      local function vtsls_execute(command, args_builder, on_success)
        local vtsls_client = get_vtsls_client()
        if not vtsls_client then
          vim.notify('vtsls is not attached in this buffer.', vim.log.levels.INFO, { title = 'LSP: vtsls' })
          return
        end

        local ok, args = pcall(args_builder, vtsls_client)
        if not ok then
          vim.notify(('Failed to build args for `%s`: %s'):format(command, args), vim.log.levels.ERROR, { title = 'LSP: vtsls' })
          return
        end

        vtsls_client:request('workspace/executeCommand', { command = command, arguments = args }, function(err, result)
          if err then
            vim.schedule(function()
              vim.notify(('vtsls `%s` failed: %s'):format(command, err.message or tostring(err)), vim.log.levels.ERROR, { title = 'LSP: vtsls' })
            end)
            return
          end

          vim.schedule(function() on_success(result, vtsls_client) end)
        end, event.buf)
      end

      if client and client.name == 'vtsls' then
        map('gD', function()
          vtsls_execute(
            'typescript.goToSourceDefinition',
            function(vtsls_client)
              local params = vim.lsp.util.make_position_params(0, vtsls_client.offset_encoding)
              return { params.textDocument.uri, params.position }
            end,
            function(result, vtsls_client)
              show_vtsls_locations('TS Source Definitions', result, vtsls_client, { reuse_win = true })
            end
          )
        end, 'Source definition (vtsls)')

        map('grf', function()
          vtsls_execute(
            'typescript.findAllFileReferences',
            function()
              local params = vim.lsp.util.make_text_document_params(event.buf)
              return { params.uri }
            end,
            function(result, vtsls_client)
              show_vtsls_locations('TS File References', result, vtsls_client)
            end
          )
        end, '[F]ile references (vtsls)')
      end

      map('grr', tb.lsp_references, '[R]eferences')
      map('gri', tb.lsp_implementations, '[I]mplementation')
      map('grd', tb.lsp_definitions, '[D]efinition')
      map('gO', tb.lsp_document_symbols, 'Document Symbols')
      map('gW', tb.lsp_dynamic_workspace_symbols, 'Workspace Symbols')
      map('grt', tb.lsp_type_definitions, '[T]ype Definition')

      -- <leader>c code group
      map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
      map('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')
      map('<leader>cd', vim.diagnostic.open_float, '[C]ode [D]iagnostic line')
      map('<leader>cD', function() tb.diagnostics { bufnr = 0 } end, '[C]ode [D]iagnostic buffer')
      map(
        '<leader>ci',
        function()
          vim.lsp.buf.code_action {
            apply = true,
            context = { only = { 'source.organizeImports' }, diagnostics = {} },
          }
        end,
        '[C]ode [I]mports'
      )
      map('<leader>cs', tb.lsp_document_symbols, '[C]ode [S]ymbols')

      -- document highlight
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local group = vim.api.nvim_create_augroup('core-lsp-highlight', { clear = false })

        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = group,
          callback = function()
            local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
            client:request('textDocument/documentHighlight', params, nil, event.buf)
          end,
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
  M.servers = vim.tbl_deep_extend('force', M.servers, {
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
  })

  -- =========================
  -- MASON INSTALL
  -- =========================
  -- Non-LSP tools (formatters, linters) → mason-tool-installer
  require('mason-tool-installer').setup {
    ensure_installed = vim.list_extend({ 'stylua' }, M.extra_tools),
  }

  -- LSP servers → mason-lspconfig (auto-installs on startup)
  require('mason-lspconfig').setup {
    ensure_installed = vim.tbl_keys(M.servers),
    automatic_enable = false, -- we wire vim.lsp.enable manually below
  }

  -- =========================
  -- NEW API (Neovim 0.11+)
  -- =========================
  for name, config in pairs(M.servers) do
    config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)

    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  end
end

return M

-- vim: ts=2 sts=2 sw=2 et
