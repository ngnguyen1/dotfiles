---@module 'lazy'
---@type LazySpec
return {
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    cmd = 'Copilot',
    keys = {
      { '<leader>ae', '<cmd>Copilot enable<CR>', desc = 'Copilot [E]nable' },
      { '<leader>ad', '<cmd>Copilot disable<CR>', desc = 'Copilot [D]isable' },
      { '<leader>as', '<cmd>Copilot status<CR>', desc = 'Copilot [S]tatus' },
      { '<leader>ap', '<cmd>Copilot panel<CR>', desc = 'Copilot [P]anel' },
    },
    init = function()
      vim.g.copilot_enabled = false
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true

      vim.g.copilot_filetypes = {
        ['*'] = false,
        typescript = true,
        typescriptreact = true,
        javascript = true,
        javascriptreact = true,
        vue = true,
        astro = true,
        svelte = true,
        html = true,
        css = true,
        scss = true,
        json = true,
        jsonc = true,
        yaml = true,
        toml = true,
        rust = true,
        go = true,
        gomod = true,
        python = true,
        lua = true,
        sh = true,
        zsh = true,
        bash = true,
        dockerfile = true,
        sql = true,
        markdown = true,
        gitcommit = true,
      }

      vim.g.copilot_workspace_folders = { vim.fn.expand '~/workspace' }
    end,
    config = function()
      local map = vim.keymap.set

      map('i', '<M-l>', 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false, silent = true, desc = 'Copilot accept suggestion' })
      map('i', '<M-w>', '<Plug>(copilot-accept-word)', { desc = 'Copilot accept word' })
      map('i', '<M-j>', '<Plug>(copilot-accept-line)', { desc = 'Copilot accept line' })
      map('i', '<M-]>', '<Plug>(copilot-next)', { desc = 'Copilot next suggestion' })
      map('i', '<M-[>', '<Plug>(copilot-previous)', { desc = 'Copilot previous suggestion' })
      map('i', '<C-]>', '<Plug>(copilot-dismiss)', { desc = 'Copilot dismiss suggestion' })
      map('i', '<M-\\>', '<Plug>(copilot-suggest)', { desc = 'Copilot request suggestion' })

      map('n', '<leader>at', function()
        local current = vim.b.copilot_enabled
        if current == nil then current = vim.g.copilot_enabled ~= false end
        vim.b.copilot_enabled = not current
        vim.notify('Copilot ' .. (vim.b.copilot_enabled and 'enabled' or 'disabled') .. ' (buffer)')
      end, { desc = 'Copilot [T]oggle (buffer)' })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
