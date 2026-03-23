# Spec: Formatting & Linting
> lua/configs/conform.lua + lua/configs/lint.lua

---

## `lua/configs/conform.lua`

```lua
-- lua/configs/conform.lua

require("conform").setup({
  formatters_by_ft = {
    lua             = { "stylua" },
    javascript      = { "prettier" },
    javascriptreact = { "prettier" },
    typescript      = { "prettier" },
    typescriptreact = { "prettier" },
    html            = { "prettier" },
    css             = { "prettier" },
    scss            = { "prettier" },
    json            = { "prettier" },
    jsonc           = { "prettier" },
    yaml            = { "prettier" },
    markdown        = { "prettier" },
    graphql         = { "prettier" },
    python          = { "isort", "black" },
    rust            = { "rustfmt" },
    sh              = { "shfmt" },
    bash            = { "shfmt" },
    ["*"]           = { "trim_whitespace" },
  },

  format_on_save = {
    lsp_fallback = true,
    async        = false,
    timeout_ms   = 1000,
  },

  formatters = {
    shfmt   = { prepend_args = { "-i", "2" } },
    prettier = { prepend_args = { "--print-width", "100" } },
  },
})

vim.keymap.set({ "n", "v" }, "<leader>lf", function()
  require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 2000 })
end, { desc = "Format file or range" })
```

---

## `lua/configs/lint.lua`

```lua
-- lua/configs/lint.lua

local lint = require("lint")

lint.linters_by_ft = {
  javascript      = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescript      = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  python          = { "ruff" },
  sh              = { "shellcheck" },
  bash            = { "shellcheck" },
  lua             = { "luacheck" },
  markdown        = { "markdownlint" },
}

local group = vim.api.nvim_create_augroup("AutoLint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group    = group,
  callback = function() lint.try_lint() end,
})

vim.keymap.set("n", "<leader>ll", function() lint.try_lint() end, { desc = "Trigger lint" })
```

---

## Mason Packages Required

```
stylua  prettier  black  isort
rustfmt  shfmt
eslint_d  ruff  shellcheck  markdownlint
```
