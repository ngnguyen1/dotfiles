-- Extend core LSP at require-time.
-- This module is required in lazy-plugins.lua at startup, so M.servers is populated
-- before the first BufReadPre fires and M.setup() runs.
local lsp = require 'core.lsp'

lsp.servers.ts_ls = {
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
}

-- Vue 3 — vue_ls (@vue/language-server) for .vue SFCs; nvim-lspconfig hybrid mode
-- forwards TS requests to ts_ls (or vtsls / typescript-tools) on the same buffer.
-- For fuller TypeScript-in-.vue support, upstream recommends vtsls with
-- @vue/typescript-plugin instead of ts_ls alone; see vuejs/language-tools Neovim wiki.
lsp.servers.vue_ls = {
  filetypes = { 'vue' },
}

lsp.servers.astro = {}

lsp.servers.html = {
  filetypes = { 'html' },
}

lsp.servers.cssls = {}

lsp.servers.tailwindcss = {
  filetypes = {
    'html',
    'css',
    'scss',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
    'astro',
  },
}

-- ESLint LSP: real-time diagnostics + code actions (gra → eslint.fixAll)
lsp.servers.eslint = {
  settings = {
    workingDirectory = { mode = 'auto' },
  },
}

-- prettierd: daemon wrapper, much faster than plain prettier on each save
vim.list_extend(lsp.extra_tools, { 'prettierd' })

vim.g.autoformat_filetypes = vim.tbl_extend('force', vim.g.autoformat_filetypes or {}, {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
  vue = true,
  astro = true,
  html = true,
  css = true,
  scss = true,
  json = true,
  jsonc = true,
})

---@module 'lazy'
---@type LazySpec
return {
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      local prettier_fts = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'vue',
        'astro',
        'html',
        'css',
        'scss',
        'json',
        'jsonc',
      }
      for _, ft in ipairs(prettier_fts) do
        opts.formatters_by_ft[ft] = { 'prettierd' }
      end
      return opts
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
