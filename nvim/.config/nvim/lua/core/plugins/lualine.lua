-- =============================================================================
-- lualine.nvim — Fast, extensible statusline for Neovim 0.12+
-- =============================================================================
-- Lazy-loaded via VeryLazy event. Uses globalstatus (single statusline).
-- Sections:
--   A: mode
--   B: branch
--   C: diagnostics → filetype icon → filename
--   X: diff (from gitsigns) → encoding (shown only if non-utf-8) → filetype
--   Y: progress + location
--   Z: clock (optional, remove if you prefer minimal)
--
-- Extensibility: drop custom components into lualine_x or lualine_c.
-- See examples at the bottom of this file.
-- =============================================================================

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',

  -- ── Startup trick (from LazyVim) ──────────────────────────────────────
  -- Show an empty statusline until lualine finishes loading so there's no
  -- flicker or ugly default bar on startup.
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = ' '
    else
      vim.o.laststatus = 0
    end
  end,

  opts = function()
    -- ── Performance: bypass lualine's custom require ────────────────────
    -- LazyVim discovered that lualine ships its own require() wrapper
    -- which is slower than Neovim's native one.  Override it.
    local lualine_require = require 'lualine_require'
    lualine_require.require = require

    -- Restore laststatus after the init trick above
    vim.o.laststatus = vim.g.lualine_laststatus

    return {
      options = {
        theme = 'auto', -- auto-detects your colorscheme
        globalstatus = true, -- single statusline at the bottom
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = { 'dashboard', 'alpha', 'ministarter', 'snacks_dashboard', 'nvim-tree' },
        },
      },

      sections = {
        -- ── A: Mode ────────────────────────────────────────────────────
        lualine_a = { 'mode' },

        -- ── B: Git branch + macro recording + DAP ─────────────────────
        lualine_b = {
          -- DAP status (only rendered when dap is loaded and active)
          {
            function() return require('dap').status() end,
            cond = function()
              return package.loaded['dap'] and require('dap').status() ~= ''
            end,
            color = { fg = '#e0af68' },
          },
          'branch',
          -- Macro recording indicator (empty string = hidden automatically)
          {
            function()
              local reg = vim.fn.reg_recording()
              if reg ~= '' then return '󰑋 @' .. reg end
              return ''
            end,
          },
        },

        -- ── C: Diagnostics + file info ─────────────────────────────────
        lualine_c = {
          {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            symbols = {
              error = ' ',
              warn = ' ',
              info = ' ',
              hint = ' ',
            },
          },
          { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
          {
            'filename',
            path = 1, -- 0 = just name, 1 = relative, 2 = absolute
            symbols = {
              modified = ' ●',
              readonly = ' ',
              unnamed = '[No Name]',
              newfile = '[New]',
            },
          },
        },

        -- ── X: Diff + encoding + LSP + lazy updates + filetype ────────
        lualine_x = {
          -- Lazy.nvim pending updates
          {
            require('lazy.status').updates,
            cond = require('lazy.status').has_updates,
            color = { fg = '#ff9e64' },
          },
          -- Active LSP clients for current buffer
          {
            function()
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              if #clients == 0 then return '' end
              local names = {}
              for _, c in ipairs(clients) do
                table.insert(names, c.name)
              end
              return ' ' .. table.concat(names, ', ')
            end,
            cond = function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end,
          },
          -- Git diff hunks (reads from gitsigns if available)
          {
            'diff',
            symbols = {
              added = ' ',
              modified = ' ',
              removed = ' ',
            },
            source = function()
              local gs = vim.b.gitsigns_status_dict
              if gs then
                return {
                  added = gs.added,
                  modified = gs.changed,
                  removed = gs.removed,
                }
              end
            end,
          },
          -- Only show encoding when it's NOT utf-8 (avoid clutter)
          {
            'encoding',
            cond = function() return vim.opt.fileencoding:get() ~= 'utf-8' end,
          },
          'filetype',
        },

        -- ── Y: Search count + Progress + Location ──────────────────────
        lualine_y = {
          { 'searchcount', maxcount = 999, timeout = 500 },
          { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
          { 'location', padding = { left = 0, right = 1 } },
        },

        -- ── Z: Clock (optional — delete if you prefer minimal) ─────────
        lualine_z = {
          function() return ' ' .. os.date '%R' end,
        },
      },

      -- Show filename on inactive windows
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },

      -- Auto-configure for known plugin windows
      extensions = { 'nvim-tree', 'lazy', 'fugitive', 'quickfix' },
    }
  end,
}
