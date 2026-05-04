---@module 'lazy'
---@type LazySpec
return {
  {
    'stevearc/conform.nvim',

    -- better lazy timing
    event = { 'BufWritePre' },

    cmd = { 'ConformInfo' },

    keys = {
      {
        '<leader>cf',
        function() require('conform').format { async = true } end,
        mode = { 'n', 'v' },
        desc = '[C]ode [F]ormat',
      },
    },

    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      notify_on_error = false,

      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end

        local enabled = vim.tbl_extend('force', { lua = true, python = true }, vim.g.autoformat_filetypes or {})

        if enabled[vim.bo[bufnr].filetype] then return { timeout_ms = 500 } end
      end,

      default_format_opts = {
        lsp_format = 'fallback',
      },

      formatters_by_ft = {
        lua = { 'stylua' },
      },
    },
  },
}
