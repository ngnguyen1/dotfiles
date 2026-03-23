# Spec: Autocommands — lua/core/autocmds.lua

---

## `lua/core/autocmds.lua`

```lua
-- lua/core/autocmds.lua

local autocmd = vim.api.nvim_create_autocmd
local augroup = function(name)
  return vim.api.nvim_create_augroup("MyNvim_" .. name, { clear = true })
end

-- ── YANK HIGHLIGHT ───────────────────────────────────────────────
autocmd("TextYankPost", {
  group    = augroup("YankHighlight"),
  callback = function() vim.hl.on_yank({ higroup = "Visual", timeout = 200 }) end,
})

-- ── RESTORE CURSOR ───────────────────────────────────────────────
autocmd("BufReadPost", {
  group    = augroup("RestoreCursor"),
  callback = function()
    local mark   = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ── AUTO-RESIZE SPLITS ───────────────────────────────────────────
autocmd("VimResized", {
  group    = augroup("AutoResize"),
  callback = function() vim.cmd("tabdo wincmd =") end,
})

-- ── CLOSE WITH Q ─────────────────────────────────────────────────
autocmd("FileType", {
  group   = augroup("CloseWithQ"),
  pattern = {
    "help", "lspinfo", "man", "notify", "qf",
    "query", "startuptime", "checkhealth", "trouble",
  },
  callback = function(e)
    vim.bo[e.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = e.buf, silent = true })
  end,
})

-- ── FILETYPE SETTINGS ────────────────────────────────────────────
autocmd("FileType", {
  group   = augroup("FileTypeSettings"),
  pattern = "python",
  callback = function()
    vim.opt_local.shiftwidth  = 4
    vim.opt_local.tabstop     = 4
    vim.opt_local.softtabstop = 4
  end,
})
autocmd("FileType", {
  group   = augroup("ProseFT"),
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.wrap      = true
    vim.opt_local.spell     = true
    vim.opt_local.linebreak = true
  end,
})

-- ── DIAGNOSTIC: HIDE IN INSERT MODE ─────────────────────────────
local diag_group = augroup("DiagnosticMode")
autocmd("InsertEnter", {
  group    = diag_group,
  callback = function() vim.diagnostic.config({ virtual_text = false }) end,
})
autocmd("InsertLeave", {
  group    = diag_group,
  callback = function()
    vim.diagnostic.config({ virtual_text = require("core.config").lsp.virtual_text })
  end,
})

-- ── AUTO-CREATE PARENT DIRS ──────────────────────────────────────
autocmd("BufWritePre", {
  group    = augroup("AutoMkdir"),
  callback = function(e)
    if e.match:match("^%w%w+://") then return end
    local file = vim.uv.fs_realpath(e.match) or e.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- ── RELOAD HIGHLIGHTS ON CONFIG SAVE ─────────────────────────────
autocmd("BufWritePost", {
  group   = augroup("ReloadHighlights"),
  pattern = { "*/core/config.lua", "*/themes/*.lua" },
  callback = function()
    vim.schedule(function()
      local cfg = require("core.config")
      require("core.highlights").load(cfg.theme.name)
    end)
  end,
})

-- ── TERMINAL: NO LINE NUMBERS ────────────────────────────────────
autocmd("TermOpen", {
  group    = augroup("Terminal"),
  callback = function()
    vim.opt_local.number         = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn     = "no"
    vim.cmd("startinsert")
  end,
})
```
