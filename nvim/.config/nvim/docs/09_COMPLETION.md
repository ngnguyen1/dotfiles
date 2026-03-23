# Spec: Completion Pipeline

> lua/configs/cmp.lua — nvim-cmp + LuaSnip + sources + scoping control

---

## Completion Scoping — The 3-Layer Model

```
Layer 1: enabled()           ← global gate — should cmp even run here?
Layer 2: cmp.setup.filetype  ← per-filetype source overrides
Layer 3: cmp.setup.cmdline   ← dedicated setup for : and / modes
```

This prevents cmp from popping up in Telescope, NvimTree, plain text, comments, etc.

---

## `lua/configs/cmp.lua`

```lua
-- lua/configs/cmp.lua

local cmp     = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

-- ================================================================
-- FILETYPES WHERE COMPLETION IS COMPLETELY DISABLED
-- ================================================================
local disabled_filetypes = {
  "TelescopePrompt",    -- Telescope search input  ← fixes your screenshot
  "TelescopeResults",   -- Telescope results pane
  "NvimTree",           -- File explorer
  "dashboard",          -- Startup dashboard
  "lazy",               -- lazy.nvim UI
  "mason",              -- Mason UI
  "help",               -- Vim help pages
  "checkhealth",
  "qf",                 -- Quickfix list
  "text",               -- Plain text files
  "gitcommit",          -- Git commit messages
  "gitrebase",
}

-- ================================================================
-- FILETYPES WHERE ONLY BUFFER WORDS ARE COMPLETED (no LSP/snippets)
-- ================================================================
local buffer_only_filetypes = {
  "markdown",
  "txt",
}

-- ================================================================
-- GLOBAL ENABLED GATE
-- Called on every keystroke in insert mode — keep it fast.
-- ================================================================
local function should_enable()
  local mode     = vim.api.nvim_get_mode().mode
  local buftype  = vim.bo.buftype
  local filetype = vim.bo.filetype

  -- Always enable in command-line mode (: / ?)
  if mode == "c" then return true end

  -- Kill in any prompt buffer — catches Telescope + other pickers
  if buftype == "prompt" then return false end

  -- Kill for explicitly disabled filetypes
  for _, ft in ipairs(disabled_filetypes) do
    if filetype == ft then return false end
  end

  -- Kill inside comments (treesitter-aware)
  local ok, ctx = pcall(require, "cmp.config.context")
  if ok then
    if ctx.in_treesitter_capture("comment") then return false end
    if ctx.in_syntax_group("Comment")       then return false end
  end

  -- Only run in normal file buffers
  -- buftype "" = regular file, "acwrite" = special writable buffer
  if buftype ~= "" and buftype ~= "acwrite" then return false end

  return true
end

-- ================================================================
-- SNIPPET HELPER
-- ================================================================
local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- ================================================================
-- MAIN SETUP
-- ================================================================
cmp.setup({

  enabled = should_enable,

  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },

  window = {
    completion = {
      border       = require("core.config").ui.border,
      scrollbar    = false,
      winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
    },
    documentation = {
      border       = require("core.config").ui.border,
      winhighlight = "Normal:CmpDoc",
    },
  },

  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = lspkind.cmp_format({
      mode          = "symbol_text",
      maxwidth      = 50,
      ellipsis_char = "...",
      menu = {
        nvim_lsp = "[LSP]",
        luasnip  = "[Snip]",
        buffer   = "[Buf]",
        path     = "[Path]",
      },
    }),
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"]  = cmp.mapping.confirm({ select = true }),

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

  -- Default sources for all code filetypes
  sources = cmp.config.sources({
    { name = "nvim_lsp", priority = 1000 },
    { name = "luasnip",  priority = 750 },
    { name = "path",     priority = 500 },
    {
      name     = "buffer",
      priority = 250,
      option   = {
        -- Complete from all visible buffers, not just current
        get_bufnrs = function()
          return vim.tbl_map(vim.api.nvim_win_get_buf, vim.api.nvim_list_wins())
        end,
      },
    },
  }),
})

-- ================================================================
-- PER-FILETYPE OVERRIDES
-- ================================================================

-- Markdown / plain text: buffer words only (no LSP, no snippets)
for _, ft in ipairs(buffer_only_filetypes) do
  cmp.setup.filetype(ft, {
    sources = cmp.config.sources({
      { name = "buffer", priority = 1000 },
      { name = "path",   priority = 500 },
    }),
  })
end

-- ================================================================
-- COMMAND-LINE COMPLETIONS
-- ================================================================

-- / and ? search: complete from buffer words
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- : commands: complete commands and paths
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    { { name = "path" } },
    { { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } } }
  ),
})

-- ================================================================
-- AUTOPAIRS INTEGRATION
-- ================================================================
local ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if ok then
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end
```

---

## How to Tune Scoping

**Disable completion in another filetype:**

```lua
-- Add to disabled_filetypes at the top
"yourfiletype",
```

**Limit a filetype to buffer words only:**

```lua
-- Add to buffer_only_filetypes at the top
"yourfiletype",
```

**Give a filetype its own custom source list:**

```lua
-- Add after the main cmp.setup() block
cmp.setup.filetype("go", {
  sources = cmp.config.sources({
    { name = "nvim_lsp", priority = 1000 },
    { name = "luasnip",  priority = 750 },
    -- no buffer source — LSP is sufficient for Go
  }),
})
```

---

## Why Telescope Was Getting Completions

Two root causes:

| Cause                                                        | Fix                                                  |
| ------------------------------------------------------------ | ---------------------------------------------------- |
| Telescope prompt has `buftype = "prompt"` — cmp ignored this | Added `if buftype == "prompt" then return false end` |
| Filetype `"TelescopePrompt"` not in disabled list            | Added both `TelescopePrompt` and `TelescopeResults`  |

The `buftype == "prompt"` check is the more reliable one — it catches **any** picker
(fzf-lua, vim.ui.select, dressing.nvim, etc.) not just Telescope specifically.

---

## Cursor Instructions

- `enabled` is called on every keystroke — no blocking calls, no `require()` of heavy modules
- `cmp.setup.filetype()` must come **after** `cmp.setup()` — order is mandatory
- `cmp.setup.cmdline()` is fully independent of `enabled()` — it activates via its own path
- Never write `enabled = false` as a static value — use the function form so it evaluates per buffer
- The `buffer_only_filetypes` loop also suppresses snippets in prose buffers — this is intentional
