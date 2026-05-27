-- one-dark-islands: LSP semantic token groups (@lsp.type.* / @lsp.mod.*)
-- These refine Treesitter highlighting when a language server emits semantic
-- tokens. Colors follow the same JetBrains-derived mapping.

local M = {}

function M.get(c, italic_params)
  return {
    -- Standard semantic token TYPES
    ["@lsp.type.namespace"]     = { fg = c.coral },
    ["@lsp.type.type"]          = { fg = c.chalky },
    ["@lsp.type.class"]         = { fg = c.chalky },   -- DEFAULT_CLASS_NAME
    ["@lsp.type.enum"]          = { fg = c.chalky },
    ["@lsp.type.interface"]     = { fg = c.chalky },   -- DEFAULT_INTERFACE_NAME
    ["@lsp.type.struct"]        = { fg = c.chalky },
    ["@lsp.type.typeParameter"] = { fg = c.chalky },   -- TYPE_PARAMETER_NAME
    ["@lsp.type.parameter"]     = { fg = c.coral, italic = italic_params },
    ["@lsp.type.variable"]      = { fg = c.coral },    -- DEFAULT_LOCAL_VARIABLE
    ["@lsp.type.property"]      = { fg = c.coral },    -- DEFAULT_INSTANCE_FIELD
    ["@lsp.type.enumMember"]    = { fg = c.fountain_blue }, -- constant-like
    ["@lsp.type.event"]         = { fg = c.coral },
    ["@lsp.type.function"]      = { fg = c.malibu },
    ["@lsp.type.method"]        = { fg = c.malibu },   -- DEFAULT_INSTANCE_METHOD
    ["@lsp.type.macro"]         = { fg = c.fountain_blue },
    ["@lsp.type.keyword"]       = { fg = c.purple },
    ["@lsp.type.modifier"]      = { fg = c.purple },
    ["@lsp.type.comment"]       = { link = "Comment" },
    ["@lsp.type.string"]        = { fg = c.green },
    ["@lsp.type.number"]        = { fg = c.whiskey },
    ["@lsp.type.regexp"]        = { fg = c.fountain_blue },
    ["@lsp.type.operator"]      = { fg = c.fountain_blue },
    ["@lsp.type.decorator"]     = { fg = c.chalky },   -- ANNOTATION
    ["@lsp.type.escapeSequence"]= { fg = c.fountain_blue },
    ["@lsp.type.formatSpecifier"] = { fg = c.fountain_blue },
    ["@lsp.type.builtinType"]   = { fg = c.chalky },
    ["@lsp.type.selfKeyword"]   = { fg = c.fountain_blue },
    ["@lsp.type.selfTypeKeyword"] = { fg = c.fountain_blue },
    ["@lsp.type.unresolvedReference"] = { fg = c.error, undercurl = true, sp = c.error },

    -- Standard semantic token MODIFIERS (combine via dotted groups)
    ["@lsp.mod.readonly"]       = { fg = c.fountain_blue }, -- consts read-only
    ["@lsp.mod.deprecated"]     = { fg = c.fg_dim, strikethrough = true },
    ["@lsp.typemod.variable.readonly"]     = { fg = c.fountain_blue },
    ["@lsp.typemod.variable.global"]       = { fg = c.coral }, -- GLOBAL_VARIABLE
    ["@lsp.typemod.variable.static"]       = { fg = c.coral, italic = true },
    ["@lsp.typemod.property.readonly"]     = { fg = c.coral },
    ["@lsp.typemod.function.defaultLibrary"] = { fg = c.malibu },
    ["@lsp.typemod.method.defaultLibrary"]   = { fg = c.malibu },
    ["@lsp.typemod.variable.defaultLibrary"] = { fg = c.fountain_blue },
    ["@lsp.typemod.type.defaultLibrary"]     = { fg = c.chalky },
    ["@lsp.typemod.class.defaultLibrary"]    = { fg = c.chalky },
    ["@lsp.typemod.keyword.documentation"]   = { fg = c.purple }, -- DOC_COMMENT_TAG
    ["@lsp.typemod.parameter.declaration"]   = { fg = c.coral, italic = italic_params },

    -- a couple of token types we deliberately let fall through to Treesitter
    ["@lsp.type.decorator.rust"] = { fg = c.chalky },
  }
end

return M
