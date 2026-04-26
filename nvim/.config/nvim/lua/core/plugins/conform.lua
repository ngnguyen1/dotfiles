---@module 'lazy'
---@type LazySpec
return {
  {
    'stevearc/conform.nvim',

    -- better lazy timing
    event = { 'BufReadPre', 'BufNewFile' },

    cmd = { 'ConformInfo' },

    keys = {
      {
        '<leader>f',
        function() require('conform').format { async = true } end,
        mode = { 'n', 'v' },
        desc = '[F]ormat buffer',
      },
    },

    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      notify_on_error = false,

      format_on_save = function(bufnr)
        local enabled = {
          lua = true,
          python = true,
        }

        if enabled[vim.bo[bufnr].filetype] then return { timeout_ms = 500 } end
      end,

      default_format_opts = {
        lsp_format = 'fallback',
      },

      formatters_by_ft = {
        lua = { 'stylua' },

        -- examples:
        -- python = { "isort", "black" },
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },
}
