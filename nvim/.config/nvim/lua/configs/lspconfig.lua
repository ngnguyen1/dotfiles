-- Default on_attach and capabilities
require("nvchad.configs.lspconfig").defaults()

-- Path to vue language server for the TS plugin (installed via Mason v2)
local vue_language_server_path = vim.fn.stdpath("data")
  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

if not vim.uv.fs_stat(vue_language_server_path) then
  vim.notify("vue-language-server not installed via Mason. Run :MasonInstall vue-language-server", vim.log.levels.WARN)
  vue_language_server_path = ""
end

local servers = {
  ts_ls = {
    init_options = {
      plugins = {
        {
          name = "@vue/typescript-plugin",
          location = vue_language_server_path,
          languages = { "vue" },
          configNamespace = "typescript",
        },
      },
    },
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
    },
  },
  vue_ls = {},
  lua_ls = {
    filetypes = { "lua" },
    root_dir = require("lspconfig.util").root_pattern(".git", "lua"),
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT", -- Use LuaJIT runtime
        },
        diagnostics = {
          global = { "vim" },
        },
        telemetry = {
          enable = false, -- disable telemetry
        },
      },
    },
  },
}

for name, opts in pairs(servers) do
  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end

-- read :h vim.lsp.config for changing options of lsp servers
