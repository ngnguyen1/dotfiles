-- lua/configs/lint.lua

local lint = require("lint")

lint.linters_by_ft = {
  javascript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescript = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  python = { "ruff" },
  sh = { "shellcheck" },
  bash = { "shellcheck" },
  lua = { "luacheck" },
  markdown = { "markdownlint" },
}

local function is_linter_available(name)
  local linter = lint.linters[name]
  if not linter then
    return false
  end

  local cmd = linter.cmd
  if type(cmd) == "function" then
    local ok, resolved = pcall(cmd)
    cmd = ok and resolved or nil
  end

  if type(cmd) ~= "string" or cmd == "" then
    return true
  end

  return vim.fn.executable(cmd) == 1
end

local function try_lint_available()
  local ft = vim.bo.filetype
  local linters = lint.linters_by_ft[ft]
  if not linters then
    return
  end

  if type(linters) == "string" then
    linters = { linters }
  end

  local available = {}
  for _, name in ipairs(linters) do
    if is_linter_available(name) then
      table.insert(available, name)
    end
  end

  if #available > 0 then
    lint.try_lint(available)
  end
end

local group = vim.api.nvim_create_augroup("AutoLint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = group,
  callback = function()
    try_lint_available()
  end,
})

vim.keymap.set("n", "<leader>ll", function()
  try_lint_available()
end, { desc = "Trigger lint" })
