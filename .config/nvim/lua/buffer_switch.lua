--- Track last buffer for back-and-forth switching.
--- Autocmd is registered in autocmds.lua; keymaps use M.toggle in mappings.lua.
local M = {}

M.last_bufnr = nil

function M.toggle()
  if M.last_bufnr
    and vim.api.nvim_buf_is_valid(M.last_bufnr)
    and vim.bo[M.last_bufnr].buflisted
  then
    vim.cmd("buffer " .. M.last_bufnr)
  else
    vim.cmd("b#")
  end
end

return M
