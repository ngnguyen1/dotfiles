-- lua/configs/conform.lua

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    graphql = { "prettier" },
    python = { "isort", "black" },
    rust = { "rustfmt" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    ["*"] = { "trim_whitespace" },
  },

  format_on_save = {
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  },

  formatters = {
    shfmt = { prepend_args = { "-i", "2" } },
    prettier = { prepend_args = { "--print-width", "100" } },
  },
})

vim.keymap.set({ "n", "v" }, "<leader>lf", function()
  require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 2000 })
end, { desc = "Format file or range" })
