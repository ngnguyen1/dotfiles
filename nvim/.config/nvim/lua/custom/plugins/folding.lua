-- ── options ───────────────────────────────────────────────────────────────────
vim.opt.foldmethod     = 'expr'
vim.opt.foldexpr       = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldtext       = ''          -- transparent: keeps first-line syntax highlight
vim.opt.foldlevel      = 99
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax    = 4           -- avoid excessive nesting in deep Lua tables / TSX
vim.opt.fillchars:append('fold: ')

-- ── LSP upgrade: prefer LSP fold ranges when the server supports them ─────────
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local c = vim.lsp.get_client_by_id(ev.data.client_id)
    if c and c:supports_method('textDocument/foldingRange') then
      vim.wo[0][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end
  end,
})

-- ── auto-fold imports on open ─────────────────────────────────────────────────
vim.api.nvim_create_autocmd('LspNotify', {
  callback = function(ev)
    if ev.data.method == 'textDocument/didOpen' then
      pcall(vim.lsp.foldclose, 'imports', vim.fn.bufwinid(ev.buf))
    end
  end,
})

-- ── Python: indent folds are more reliable than treesitter for Python ─────────
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function() vim.opt_local.foldmethod = 'indent' end,
})

-- ── keymaps ───────────────────────────────────────────────────────────────────
local map = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc, silent = true })
end

-- Toggle / open / close (most used)
map('za', 'za',  'fold: toggle')
map('zo', 'zo',  'fold: open')
map('zc', 'zc',  'fold: close')

-- Recursive variants (whole subtree)
map('zA', 'zA',  'fold: toggle recursive')
map('zO', 'zO',  'fold: open recursive')
map('zC', 'zC',  'fold: close recursive')

-- Global open / close
map('zR', 'zR',  'fold: open all')
map('zM', 'zM',  'fold: close all')

-- Step through levels one at a time (handy for progressive reveal)
map('zr', 'zr',  'fold: increase foldlevel')
map('zm', 'zm',  'fold: decrease foldlevel')

-- Recompute (fixes E490 after LSP attach or Telescope jump)
map('zx', 'zx',  'fold: recompute')

-- Navigation  (native [z / ]z are hard to type; remap to ] / [ variants)
map('[z', '[z',  'fold: go to fold start')
map(']z', ']z',  'fold: go to fold end')
map('zj', 'zj',  'fold: next fold')
map('zk', 'zk',  'fold: prev fold')

return {}
