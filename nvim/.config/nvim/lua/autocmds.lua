-- [[ Basic Autocommands ]]
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

local augroup = vim.api.nvim_create_augroup('dotfiles_autocmds', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup,
  desc = 'Highlight yanked text',
  callback = function()
    vim.hl.on_yank()
  end,
})

local skip_last_loc_ft = { gitcommit = true, gitrebase = true, xxd = true }

vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup,
  desc = 'Restore last cursor position in buffer (`:h \'")',
  callback = function(args)
    local buf = args.buf
    if skip_last_loc_ft[vim.bo[buf].filetype] then
      return
    end
    vim.schedule(function()
      if vim.api.nvim_get_current_buf() ~= buf then
        return
      end
      local mark = vim.api.nvim_buf_get_mark(buf, '"')
      local line, nlines = mark[1], vim.api.nvim_buf_line_count(buf)
      -- Line 1 is the default when ShaDa has no meaningful saved position.
      if line < 2 or line > nlines then
        return
      end
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end)
  end,
})

local cursorline_stash = 'dotfiles_cursorline'

local function cursorline_restore()
  local ok, had = pcall(vim.api.nvim_win_get_var, 0, cursorline_stash)
  if ok and had then
    vim.wo.cursorline = true
    pcall(vim.api.nvim_win_del_var, 0, cursorline_stash)
  end
end

local function cursorline_stash_and_hide()
  if vim.wo.cursorline then
    vim.api.nvim_win_set_var(0, cursorline_stash, true)
    vim.wo.cursorline = false
  end
end

vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
  group = augroup,
  desc = 'Restore cursorline after insert or when focusing window',
  callback = cursorline_restore,
})

vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
  group = augroup,
  desc = 'Hide cursorline in insert mode and unfocused windows',
  callback = cursorline_stash_and_hide,
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  desc = 'Ephemeral buffers: unlisted + q closes',
  pattern = {
    'OverseerForm',
    'OverseerList',
    'floggraph',
    'fugitive',
    'git',
    'help',
    'lspinfo',
    'man',
    'neotest-output',
    'neotest-summary',
    'qf',
    'query',
    'spectre_panel',
    'startuptime',
    'toggleterm',
    'tsplayground',
    'vim',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true, nowait = true })
  end,
})

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

-- vim: ts=2 sts=2 sw=2 et
