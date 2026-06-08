-- Prisma support. Required in lazy-plugins.lua at startup, so M.servers is populated
-- before the first BufReadPre fires and core.lsp.setup() runs.
--
-- - prismals (mason: prisma-language-server) → completion + diagnostics + formatting.
-- - prisma/vim-prisma → filetype detection, syntax highlighting, indentation.
local lsp = require 'core.lsp'

-- prismals default filetypes already include `prisma`; no override needed.
lsp.servers.prismals = {}

-- prismals provides `textDocument/formatting`; conform has no prisma formatter, so
-- `default_format_opts.lsp_format = 'fallback'` routes formatting through prismals.
vim.g.autoformat_filetypes = vim.tbl_extend('force', vim.g.autoformat_filetypes or {}, {
  prisma = true,
})

---@module 'lazy'
---@type LazySpec
return {
  -- Syntax highlighting + indentation + ftdetect (lazy.nvim reads ftdetect for `ft`).
  {
    'prisma/vim-prisma',
    ft = 'prisma',
  },
}

-- vim: ts=2 sts=2 sw=2 et
