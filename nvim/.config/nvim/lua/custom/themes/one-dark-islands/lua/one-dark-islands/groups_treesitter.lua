-- one-dark-islands: Treesitter (@-prefixed) capture groups
-- Mapped from the JetBrains token semantics in one_dark.xml so that the
-- modern tree-sitter highlighting matches the original theme's intent.

local M = {}

function M.get(c, italic_params)
  return {
    -- Identifiers / variables  (DEFAULT_LOCAL_VARIABLE / INSTANCE_FIELD = coral)
    ["@variable"]                = { fg = c.coral },
    ["@variable.builtin"]        = { fg = c.fountain_blue },
    ["@variable.parameter"]      = { fg = c.coral, italic = italic_params }, -- DEFAULT_PARAMETER font=2
    ["@variable.parameter.builtin"] = { fg = c.coral, italic = italic_params },
    ["@variable.member"]         = { fg = c.coral }, -- INSTANCE_FIELD

    -- Constants  (DEFAULT_CONSTANT / PREDEFINED_SYMBOL = fountainBlue)
    ["@constant"]                = { fg = c.fountain_blue },
    ["@constant.builtin"]        = { fg = c.fountain_blue },
    ["@constant.macro"]          = { fg = c.fountain_blue },

    -- Modules / namespaces  (TS.MODULE_NAME / JS.MODULE_NAME = coral)
    ["@module"]                  = { fg = c.coral },
    ["@module.builtin"]          = { fg = c.coral },
    ["@label"]                   = { fg = c.coral }, -- DEFAULT_LABEL

    -- Strings  (DEFAULT_STRING = green; escapes = fountainBlue)
    ["@string"]                  = { fg = c.green },
    ["@string.documentation"]    = { fg = c.green },
    ["@string.regexp"]           = { fg = c.fountain_blue }, -- JS.REGEXP
    ["@string.escape"]           = { fg = c.fountain_blue }, -- VALID_STRING_ESCAPE
    ["@string.special"]          = { fg = c.fountain_blue },
    ["@string.special.symbol"]   = { fg = c.fountain_blue },
    ["@string.special.url"]      = { fg = c.green, underline = true },
    ["@string.special.path"]     = { fg = c.green },
    ["@character"]               = { fg = c.green },
    ["@character.special"]       = { fg = c.fountain_blue },

    -- Numbers / booleans  (DEFAULT_NUMBER = whiskey)
    ["@number"]                  = { fg = c.whiskey },
    ["@number.float"]            = { fg = c.whiskey },
    ["@boolean"]                 = { fg = c.fountain_blue },

    -- Functions / methods  (DEFAULT_FUNCTION_* / INSTANCE_METHOD = malibu)
    ["@function"]                = { fg = c.malibu },
    ["@function.builtin"]        = { fg = c.malibu },
    ["@function.call"]           = { fg = c.malibu },
    ["@function.macro"]          = { fg = c.fountain_blue },
    ["@function.method"]         = { fg = c.malibu },
    ["@function.method.call"]    = { fg = c.malibu },
    ["@constructor"]             = { fg = c.chalky },  -- treated as class name
    ["@operator"]                = { fg = c.fountain_blue }, -- OPERATION_SIGN

    -- Keywords  (DEFAULT_KEYWORD = purple)
    ["@keyword"]                 = { fg = c.purple },
    ["@keyword.coroutine"]       = { fg = c.purple },
    ["@keyword.function"]        = { fg = c.purple },
    ["@keyword.operator"]        = { fg = c.purple },
    ["@keyword.import"]          = { fg = c.purple },
    ["@keyword.type"]            = { fg = c.purple },
    ["@keyword.modifier"]        = { fg = c.purple },
    ["@keyword.repeat"]          = { fg = c.purple },
    ["@keyword.return"]          = { fg = c.purple },
    ["@keyword.debug"]           = { fg = c.purple },
    ["@keyword.exception"]       = { fg = c.purple },
    ["@keyword.conditional"]     = { fg = c.purple },
    ["@keyword.conditional.ternary"] = { fg = c.fountain_blue },
    ["@keyword.directive"]       = { fg = c.purple },
    ["@keyword.directive.define"]= { fg = c.purple },

    -- Punctuation  (DEFAULT_BRACES / DOT / COMMA / PARENTHS = fg)
    ["@punctuation.delimiter"]   = { fg = c.fg },
    ["@punctuation.bracket"]     = { fg = c.fg },
    ["@punctuation.special"]     = { fg = c.fountain_blue },

    -- Comments  (DEFAULT_*_COMMENT = fg_dim, italic)
    ["@comment"]                 = { link = "Comment" },
    ["@comment.documentation"]   = { fg = c.fg_dim, italic = true },
    ["@comment.error"]           = { fg = c.bg, bg = c.error },
    ["@comment.warning"]         = { fg = c.bg, bg = c.chalky },
    ["@comment.todo"]            = { fg = c.bg, bg = c.chalky, bold = true },
    ["@comment.note"]            = { fg = c.bg, bg = c.fountain_blue },

    -- Types  (DEFAULT_CLASS_NAME / INTERFACE / TYPE_PARAMETER = chalky)
    ["@type"]                    = { fg = c.chalky },
    ["@type.builtin"]            = { fg = c.chalky },
    ["@type.definition"]         = { fg = c.chalky },
    ["@type.qualifier"]          = { fg = c.purple },
    ["@attribute"]               = { fg = c.chalky }, -- ANNOTATION_NAME
    ["@attribute.builtin"]       = { fg = c.chalky },
    ["@property"]                = { fg = c.coral },  -- INSTANCE_FIELD

    -- Markup (markdown etc.)
    ["@markup.strong"]           = { bold = true },
    ["@markup.italic"]           = { italic = true },
    ["@markup.strikethrough"]    = { strikethrough = true },
    ["@markup.underline"]        = { underline = true },
    ["@markup.heading"]          = { fg = c.coral, bold = true },
    ["@markup.heading.1"]        = { fg = c.coral, bold = true },
    ["@markup.heading.2"]        = { fg = c.whiskey, bold = true },
    ["@markup.heading.3"]        = { fg = c.chalky, bold = true },
    ["@markup.heading.4"]        = { fg = c.green, bold = true },
    ["@markup.heading.5"]        = { fg = c.fountain_blue, bold = true },
    ["@markup.heading.6"]        = { fg = c.purple, bold = true },
    ["@markup.quote"]            = { fg = c.fg_dim, italic = true },
    ["@markup.math"]             = { fg = c.fountain_blue },
    ["@markup.link"]             = { fg = c.accent },
    ["@markup.link.label"]       = { fg = c.fountain_blue },
    ["@markup.link.url"]         = { fg = c.accent, underline = true }, -- MARKDOWN_LINK_DESTINATION
    ["@markup.raw"]              = { fg = c.fountain_blue }, -- CODE_SPAN
    ["@markup.raw.block"]        = { fg = c.fg },
    ["@markup.list"]             = { fg = c.coral },
    ["@markup.list.checked"]     = { fg = c.green },
    ["@markup.list.unchecked"]   = { fg = c.fg_dim },

    -- Diff capture
    ["@diff.plus"]               = { fg = c.git_add },
    ["@diff.minus"]              = { fg = c.git_delete },
    ["@diff.delta"]              = { fg = c.git_change },

    -- Tags (HTML/JSX)  (HTML_TAG_NAME = coral; attr name = whiskey; value = green)
    ["@tag"]                     = { fg = c.coral },
    ["@tag.builtin"]             = { fg = c.coral },
    ["@tag.attribute"]           = { fg = c.whiskey },
    ["@tag.delimiter"]           = { fg = c.fg },

    -- Language-specific niceties
    ["@property.css"]            = { fg = c.fountain_blue }, -- CSS.PROPERTY_NAME
    ["@property.id.css"]         = { fg = c.accent },        -- CSS.HASH
    ["@type.css"]                = { fg = c.coral },         -- CSS.TAG_NAME
    ["@string.plain.css"]        = { fg = c.whiskey },       -- CSS.PROPERTY_VALUE
    ["@constant.css"]            = { fg = c.whiskey },       -- CSS.COLOR
    ["@property.json"]           = { fg = c.coral },         -- JSON.PROPERTY_KEY
    ["@label.json"]              = { fg = c.coral },
    ["@field.yaml"]              = { fg = c.coral },         -- YAML_SCALAR_KEY
    ["@property.yaml"]           = { fg = c.coral },
  }
end

return M
