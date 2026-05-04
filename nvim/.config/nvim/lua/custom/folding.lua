local M = {}

function M.setup()
  vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.opt.foldtext = '' -- transparent: keeps first-line syntax highlight
  vim.opt.foldlevel = 99
  vim.opt.foldlevelstart = 99
  vim.opt.foldnestmax = 4 -- avoid excessive nesting in deep Lua tables / TSX
  vim.opt.fillchars:append('fold: ')

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      local c = vim.lsp.get_client_by_id(ev.data.client_id)
      if c and c:supports_method('textDocument/foldingRange') then
        vim.wo[0][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
      end
    end,
  })

  vim.api.nvim_create_autocmd('LspNotify', {
    callback = function(ev)
      if ev.data.method == 'textDocument/didOpen' then
        pcall(vim.lsp.foldclose, 'imports', vim.fn.bufwinid(ev.buf))
      end
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function() vim.opt_local.foldmethod = 'indent' end,
  })
end

return M
