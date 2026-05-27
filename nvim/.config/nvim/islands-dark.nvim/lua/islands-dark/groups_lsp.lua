-- islands-dark: LSP semantic token groups (@lsp.type.* / @lsp.typemod.*)
-- Mapped directly from semanticTokenColors in themes/islands-dark.json.

local M = {}

function M.get(c, opts)
  opts = opts or {}

  return {
    -- ── Standard semantic token TYPES (from semanticTokenColors) ─────────
    ["@lsp.type.namespace"]     = { fg = c.magenta },  -- namespace: #c77dbb
    ["@lsp.type.type"]          = { fg = c.magenta },  -- type: #c77dbb
    ["@lsp.type.class"]         = { fg = c.magenta },  -- class
    ["@lsp.type.enum"]          = { fg = c.magenta },  -- enum
    ["@lsp.type.interface"]     = { fg = c.magenta },  -- interface
    ["@lsp.type.struct"]        = { fg = c.magenta },
    ["@lsp.type.typeParameter"] = { fg = c.magenta },  -- typeParameter
    ["@lsp.type.parameter"]     = { fg = c.fg },       -- parameter: #bcbec4
    ["@lsp.type.variable"]      = { fg = c.fg },       -- variable: #bcbec4
    ["@lsp.type.property"]      = { fg = c.magenta },  -- property: #c77dbb
    ["@lsp.type.enumMember"]    = { fg = c.magenta },  -- enumMember: #c77dbb
    ["@lsp.type.event"]         = { fg = c.magenta },
    ["@lsp.type.function"]      = { fg = c.blue_fn },  -- function: #56a8f5
    ["@lsp.type.method"]        = { fg = c.blue_fn },  -- method: #56a8f5
    ["@lsp.type.macro"]         = { fg = c.blue_fn, bold = true }, -- macro bold
    ["@lsp.type.keyword"]       = { fg = c.orange },   -- keyword: #cf8e6d
    ["@lsp.type.modifier"]      = { fg = c.orange },
    ["@lsp.type.comment"]       = { link = "Comment" },
    ["@lsp.type.string"]        = { fg = c.green },    -- string: #6aab73
    ["@lsp.type.number"]        = { fg = c.cyan },     -- number: #2aacb8
    ["@lsp.type.regexp"]        = { fg = c.cyan },     -- regexp: #2aacb8
    ["@lsp.type.operator"]      = { fg = c.fg },
    ["@lsp.type.decorator"]     = { fg = c.yellow },   -- decorator: #bbb529
    ["@lsp.type.escapeSequence"]= { fg = c.orange },
    ["@lsp.type.formatSpecifier"] = { fg = c.orange },
    ["@lsp.type.builtinType"]   = { fg = c.magenta },
    ["@lsp.type.selfKeyword"]   = { fg = c.orange, italic = true },
    ["@lsp.type.selfTypeKeyword"] = { fg = c.orange, italic = true },
    ["@lsp.type.unresolvedReference"] = { sp = c.error, undercurl = true },

    -- ── Standard semantic token MODIFIERS ────────────────────────────────
    ["@lsp.mod.readonly"]       = { fg = c.magenta },  -- readonly variants → magenta
    ["@lsp.mod.deprecated"]     = { fg = c.warning, strikethrough = true },
    ["@lsp.mod.declaration"]    = {},
    ["@lsp.mod.definition"]     = {},
    ["@lsp.mod.static"]         = {},

    -- ── Type+Modifier combos (more specific wins in Neovim) ──────────────
    -- variable.readonly: #c77dbb in semanticTokenColors → magenta
    ["@lsp.typemod.variable.readonly"]      = { fg = c.magenta },
    ["@lsp.typemod.variable.global"]        = { fg = c.fg },
    ["@lsp.typemod.variable.static"]        = { fg = c.fg, italic = true },
    ["@lsp.typemod.variable.declaration"]   = { fg = c.fg },
    -- property.readonly: magenta (already covered by base)
    ["@lsp.typemod.property.readonly"]      = { fg = c.magenta },
    ["@lsp.typemod.property.declaration"]   = { fg = c.magenta },
    -- function/method default-library fall through to base
    ["@lsp.typemod.function.defaultLibrary"]= { fg = c.blue_fn },
    ["@lsp.typemod.method.defaultLibrary"]  = { fg = c.blue_fn },
    ["@lsp.typemod.function.declaration"]   = { fg = c.blue_fn },
    ["@lsp.typemod.method.declaration"]     = { fg = c.blue_fn },
    ["@lsp.typemod.variable.defaultLibrary"]= { fg = c.fg },
    ["@lsp.typemod.type.defaultLibrary"]    = { fg = c.magenta },
    ["@lsp.typemod.class.defaultLibrary"]   = { fg = c.magenta },
    ["@lsp.typemod.keyword.documentation"]  = { fg = c.orange },
    ["@lsp.typemod.parameter.declaration"]  = { fg = c.fg },
    ["@lsp.typemod.macro.declaration"]      = { fg = c.blue_fn, bold = true },
  }
end

return M
