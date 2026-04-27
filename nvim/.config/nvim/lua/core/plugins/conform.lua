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
      },
    },

    init = function()
      vim.api.nvim_create_user_command('FormatDisable', function(args)
        if args.bang then
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, { desc = 'Disable autoformat-on-save', bang = true })

      vim.api.nvim_create_user_command('FormatEnable', function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, { desc = 'Re-enable autoformat-on-save' })
    end,
  },
}
