-- lua/configs/cmp.lua
---@diagnostic disable: undefined-field

local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")
local ok_ctx, cmp_context = pcall(require, "cmp.config.context")

local disabled_filetypes = {
  TelescopePrompt = true,
  TelescopeResults = true,
  NvimTree = true,
  dashboard = true,
  lazy = true,
  mason = true,
  help = true,
  checkhealth = true,
  qf = true,
  text = true,
  gitcommit = true,
  gitrebase = true,
}

local buffer_only_filetypes = {
  markdown = true,
  txt = true,
}

local function should_enable()
  local mode = vim.api.nvim_get_mode().mode
  local buftype = vim.bo.buftype
  local filetype = vim.bo.filetype

  if mode == "c" then
    return true
  end

  if buftype == "prompt" then
    return false
  end

  if disabled_filetypes[filetype] then
    return false
  end

  if ok_ctx and cmp_context then
    if cmp_context.in_treesitter_capture("comment") then
      return false
    end
    if cmp_context.in_syntax_group("Comment") then
      return false
    end
  end

  if buftype ~= "" and buftype ~= "acwrite" then
    return false
  end

  return true
end

local function has_words_before()
  local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  enabled = should_enable,

  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  window = {
    completion = {
      border = require("core.config").ui.border,
      scrollbar = false,
      winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
    },
    documentation = {
      border = require("core.config").ui.border,
      winhighlight = "Normal:CmpDoc",
    },
  },

  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = lspkind.cmp_format({
      mode = "symbol_text",
      maxwidth = 50,
      ellipsis_char = "...",
      menu = {
        nvim_lsp = "[LSP]",
        luasnip = "[Snip]",
        buffer = "[Buf]",
        path = "[Path]",
      },
    }),
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),

  sources = cmp.config.sources({
    { name = "nvim_lsp", priority = 1000 },
    { name = "luasnip", priority = 750 },
    { name = "path", priority = 500 },
    {
      name = "buffer",
      priority = 250,
      option = {
        get_bufnrs = function()
          return vim.tbl_map(vim.api.nvim_win_get_buf, vim.api.nvim_list_wins())
        end,
      },
    },
  }),
})

for ft, _ in pairs(buffer_only_filetypes) do
  cmp.setup.filetype(ft, {
    sources = cmp.config.sources({
      { name = "buffer", priority = 1000 },
      { name = "path", priority = 500 },
    }),
  })
end

cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    { { name = "path" } },
    { { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } } }
  ),
})

local ok_autopairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if ok_autopairs then
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end
