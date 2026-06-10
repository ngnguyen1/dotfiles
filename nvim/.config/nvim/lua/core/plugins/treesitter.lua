---@module 'lazy'
---@type LazySpec
---
--- nvim-treesitter `main` uses a minimal |require('nvim-treesitter').setup()|; highlight/indent/textobjects
--- are wired explicitly (see upstream README).

local parsers = {
  'bash',
  'c',
  'diff',
  'html',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'query',
  'vim',
  'vimdoc',
}

--- Filetypes that should get |vim.treesitter.start()| and TS indent.
local ts_filetypes = {
  'bash',
  'sh',
  'c',
  'diff',
  'html',
  'lua',
  'luadoc',
  'markdown',
  'query',
  'vim',
  'help',
  'vimdoc',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',

    lazy = false,
    build = ':TSUpdate',

    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
      },
    },

    config = function()
      require('nvim-treesitter').setup {
        install_dir = vim.fn.stdpath 'data' .. '/site',
      }

      --- Best-effort async install of baseline parsers (no :wait on startup).
      vim.schedule(function() pcall(require('nvim-treesitter').install, parsers) end)

      require('nvim-treesitter-textobjects').setup {
        select = { lookahead = true },
        move = { set_jumps = true },
        swap = {},
      }

      local select = require 'nvim-treesitter-textobjects.select'
      local move = require 'nvim-treesitter-textobjects.move'
      local swap = require 'nvim-treesitter-textobjects.swap'

      for _, mode in ipairs { 'x', 'o' } do
        vim.keymap.set(mode, 'af', function() select.select_textobject('@function.outer', 'textobjects') end, { desc = 'TS: outer function' })
        vim.keymap.set(mode, 'if', function() select.select_textobject('@function.inner', 'textobjects') end, { desc = 'TS: inner function' })
        vim.keymap.set(mode, 'ac', function() select.select_textobject('@class.outer', 'textobjects') end, { desc = 'TS: outer class' })
        vim.keymap.set(mode, 'ic', function() select.select_textobject('@class.inner', 'textobjects') end, { desc = 'TS: inner class' })
        vim.keymap.set(mode, 'aa', function() select.select_textobject('@parameter.outer', 'textobjects') end, { desc = 'TS: outer parameter' })
        vim.keymap.set(mode, 'ia', function() select.select_textobject('@parameter.inner', 'textobjects') end, { desc = 'TS: inner parameter' })
      end

      for _, m in ipairs { 'n', 'x', 'o' } do
        vim.keymap.set(m, ']f', function() move.goto_next_start('@function.outer', 'textobjects') end, { desc = 'TS: next function' })
        vim.keymap.set(m, '[f', function() move.goto_previous_start('@function.outer', 'textobjects') end, { desc = 'TS: prev function' })
        --- Use `]O` / `[O` (not `]c`) to avoid clashing with diff |]c| / |[c| motions.
        vim.keymap.set(m, ']O', function() move.goto_next_start('@class.outer', 'textobjects') end, { desc = 'TS: next class' })
        vim.keymap.set(m, '[O', function() move.goto_previous_start('@class.outer', 'textobjects') end, { desc = 'TS: prev class' })
      end

      vim.keymap.set('n', ']a', function() swap.swap_next '@parameter.inner' end, { desc = 'TS: swap param with next' })
      vim.keymap.set('n', '[a', function() swap.swap_previous '@parameter.inner' end, { desc = 'TS: swap param with prev' })

      require('core.treesitter_incsel').setup()

      local function enable_ts(buf)
        pcall(vim.treesitter.start, buf)
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('dotfiles_treesitter', { clear = true }),
        pattern = ts_filetypes,
        callback = function(ev) enable_ts(ev.buf) end,
      })

      -- The file opened on the command line can fire FileType before this
      -- config() runs (treesitter is `lazy = false`, but load order isn't
      -- guaranteed), so back-fill any already-loaded matching buffers.
      local want_ft = {}
      for _, ft in ipairs(ts_filetypes) do
        want_ft[ft] = true
      end
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and want_ft[vim.bo[buf].filetype] then enable_ts(buf) end
      end
    end,
  },
}
