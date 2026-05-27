-- islands-dark: Treesitter (@-prefixed) capture groups
-- Mapped directly from the bwya77 tokenColors scope -> capture equivalents.

local M = {}

function M.get(c, opts)
  opts = opts or {}
  local italic_comments = opts.italic_comments ~= false

  return {
    -- ── Variables ────────────────────────────────────────────────────────
    -- bwya77 [13] variable -> #bcbec4 (fg)
    -- bwya77 [7]  variable.parameter -> #bcbec4 (fg)
    ["@variable"]                  = { fg = c.fg },
    ["@variable.builtin"]          = { fg = c.orange, italic = true }, -- variable.language (this/self) italic
    ["@variable.parameter"]        = { fg = c.fg },
    ["@variable.parameter.builtin"]= { fg = c.fg },
    ["@variable.member"]           = { fg = c.magenta }, -- variable.other.property → magenta

    -- ── Constants ────────────────────────────────────────────────────────
    -- bwya77 [12] variable.other.constant / enummember -> #c77dbb (magenta)
    -- bwya77 [11] constant.language -> #cf8e6d (orange)
    ["@constant"]                  = { fg = c.magenta },
    ["@constant.builtin"]          = { fg = c.orange },
    ["@constant.macro"]            = { fg = c.magenta },

    -- ── Modules / namespaces ─────────────────────────────────────────────
    -- bwya77 [53] entity.name.namespace -> #c77dbb (magenta)
    ["@module"]                    = { fg = c.magenta },
    ["@module.builtin"]            = { fg = c.magenta },
    ["@label"]                     = { fg = c.orange },

    -- ── Strings ──────────────────────────────────────────────────────────
    -- bwya77 [2] string -> #6aab73 (green)
    -- bwya77 [3] punctuation.definition.template-expression -> #cf8e6d (orange)
    -- bwya77 [28] constant.character.escape -> #cf8e6d (orange)
    ["@string"]                    = { fg = c.green },
    ["@string.documentation"]      = { fg = c.green },
    ["@string.regexp"]             = { fg = c.cyan }, -- string.regexp → cyan
    ["@string.escape"]             = { fg = c.orange },
    ["@string.special"]            = { fg = c.orange },
    ["@string.special.symbol"]     = { fg = c.magenta },
    ["@string.special.url"]        = { fg = c.blue, underline = true },
    ["@string.special.path"]       = { fg = c.green },
    ["@character"]                 = { fg = c.green },
    ["@character.special"]         = { fg = c.orange },

    -- ── Numbers / booleans ───────────────────────────────────────────────
    -- bwya77 [10] constant.numeric -> #2aacb8 (cyan)
    ["@number"]                    = { fg = c.cyan },
    ["@number.float"]              = { fg = c.cyan },
    ["@boolean"]                   = { fg = c.orange }, -- constant.language.boolean → orange

    -- ── Functions / methods ──────────────────────────────────────────────
    -- bwya77 [6] entity.name.function / support.function -> #56a8f5 (blue_fn)
    -- bwya77 [50] Rust macros -> #56a8f5 bold
    ["@function"]                  = { fg = c.blue_fn },
    ["@function.builtin"]          = { fg = c.blue_fn },
    ["@function.call"]             = { fg = c.blue_fn },
    ["@function.macro"]            = { fg = c.blue_fn, bold = true },
    ["@function.method"]           = { fg = c.blue_fn },
    ["@function.method.call"]      = { fg = c.blue_fn },
    ["@constructor"]               = { fg = c.magenta }, -- type-like

    -- bwya77 [16] keyword.operator -> #bcbec4 (fg)
    ["@operator"]                  = { fg = c.fg },

    -- ── Keywords ─────────────────────────────────────────────────────────
    -- bwya77 [4][5] keyword / storage -> #cf8e6d (orange)
    ["@keyword"]                   = { fg = c.orange },
    ["@keyword.coroutine"]         = { fg = c.orange },
    ["@keyword.function"]          = { fg = c.orange },
    ["@keyword.operator"]          = { fg = c.orange }, -- typeof, instanceof, etc.
    ["@keyword.import"]            = { fg = c.orange },
    ["@keyword.type"]              = { fg = c.orange }, -- storage.type
    ["@keyword.modifier"]          = { fg = c.orange }, -- storage.modifier
    ["@keyword.repeat"]            = { fg = c.orange },
    ["@keyword.return"]            = { fg = c.orange },
    ["@keyword.debug"]             = { fg = c.orange },
    ["@keyword.exception"]         = { fg = c.orange },
    ["@keyword.conditional"]       = { fg = c.orange },
    ["@keyword.conditional.ternary"]= { fg = c.fg },     -- keyword.operator.ternary → fg
    ["@keyword.directive"]         = { fg = c.orange },
    ["@keyword.directive.define"]  = { fg = c.orange },

    -- ── Punctuation ──────────────────────────────────────────────────────
    -- bwya77 [17] punctuation -> #bcbec4 (fg)
    ["@punctuation.delimiter"]     = { fg = c.fg },
    ["@punctuation.bracket"]       = { fg = c.fg },
    ["@punctuation.special"]       = { fg = c.orange },

    -- ── Comments ─────────────────────────────────────────────────────────
    -- bwya77 [0][1] comment -> #7a7e85 italic
    ["@comment"]                   = { link = "Comment" },
    ["@comment.documentation"]     = { fg = c.fg_dim, italic = italic_comments },
    ["@comment.error"]             = { fg = c.bg, bg = c.error },
    ["@comment.warning"]           = { fg = c.bg, bg = c.warning },
    ["@comment.todo"]              = { fg = c.bg, bg = c.warning, bold = true },
    ["@comment.note"]              = { fg = c.bg, bg = c.info },

    -- ── Types ────────────────────────────────────────────────────────────
    -- bwya77 [8][9] entity.name.type / type.parameter -> #c77dbb (magenta)
    -- bwya77 [29] decorator -> #bbb529 (yellow)
    -- bwya77 [15] variable.other.property -> #c77dbb (magenta)
    ["@type"]                      = { fg = c.magenta },
    ["@type.builtin"]              = { fg = c.magenta },
    ["@type.definition"]           = { fg = c.magenta },
    ["@type.qualifier"]            = { fg = c.orange },
    ["@attribute"]                 = { fg = c.yellow }, -- decorators / annotations
    ["@attribute.builtin"]         = { fg = c.yellow },
    ["@property"]                  = { fg = c.magenta },

    -- ── Markup (markdown etc.) ───────────────────────────────────────────
    -- bwya77 [35] heading -> orange bold
    -- bwya77 [37] markup.bold -> #bcbec4 bold
    -- bwya77 [38] markup.italic -> #bcbec4 italic
    -- bwya77 [39] markup.inline.raw -> #6aab73
    -- bwya77 [40] markup.underline.link -> #548af7
    -- bwya77 [41] string.other.link.title -> #56a8f5
    -- bwya77 [42] list markers -> #cf8e6d
    -- bwya77 [43] markup.quote -> #7a7e85 italic
    ["@markup.strong"]             = { fg = c.fg, bold = true },
    ["@markup.italic"]             = { fg = c.fg, italic = true },
    ["@markup.strikethrough"]      = { strikethrough = true },
    ["@markup.underline"]          = { underline = true },
    ["@markup.heading"]            = { fg = c.orange, bold = true },
    ["@markup.heading.1"]          = { fg = c.orange, bold = true },
    ["@markup.heading.2"]          = { fg = c.orange, bold = true },
    ["@markup.heading.3"]          = { fg = c.orange, bold = true },
    ["@markup.heading.4"]          = { fg = c.orange, bold = true },
    ["@markup.heading.5"]          = { fg = c.orange, bold = true },
    ["@markup.heading.6"]          = { fg = c.orange, bold = true },
    ["@markup.quote"]              = { fg = c.fg_dim, italic = true },
    ["@markup.math"]               = { fg = c.cyan },
    ["@markup.link"]               = { fg = c.blue, underline = true },
    ["@markup.link.label"]         = { fg = c.blue_fn },
    ["@markup.link.url"]           = { fg = c.blue, underline = true },
    ["@markup.raw"]                = { fg = c.green },
    ["@markup.raw.block"]          = { fg = c.green },
    ["@markup.list"]               = { fg = c.orange },
    ["@markup.list.checked"]       = { fg = c.green_vivid },
    ["@markup.list.unchecked"]     = { fg = c.fg_dim },

    -- ── Diff captures ────────────────────────────────────────────────────
    -- bwya77 [55][56][57] markup.inserted/deleted/changed
    ["@diff.plus"]                 = { fg = c.green_vivid },
    ["@diff.minus"]                = { fg = c.error },
    ["@diff.delta"]                = { fg = c.blue },

    -- ── Tags (HTML/JSX) ──────────────────────────────────────────────────
    -- bwya77 [18] HTML tags -> #cf8e6d (orange)
    -- bwya77 [19] HTML attributes -> #bababa (fg_alt)
    -- bwya77 [20] JSX component tags -> #56a8f5 (blue_fn)
    ["@tag"]                       = { fg = c.orange },
    ["@tag.builtin"]               = { fg = c.orange },
    ["@tag.attribute"]             = { fg = c.fg_alt },
    ["@tag.delimiter"]             = { fg = c.fg },
    ["@tag.tsx"]                   = { fg = c.blue_fn }, -- JSX components

    -- ── CSS ──────────────────────────────────────────────────────────────
    -- bwya77 [21] selectors -> orange
    -- bwya77 [22] properties -> #bcbec4 (fg)
    -- bwya77 [23] values -> fg
    -- bwya77 [24] units / colors -> cyan
    -- bwya77 [25] at-rules -> orange
    ["@type.css"]                  = { fg = c.orange },        -- selectors
    ["@property.css"]              = { fg = c.fg },            -- property name
    ["@property.id.css"]           = { fg = c.orange },
    ["@property.class.css"]        = { fg = c.orange },
    ["@string.plain.css"]          = { fg = c.fg },            -- value
    ["@number.css"]                = { fg = c.cyan },          -- units
    ["@constant.css"]              = { fg = c.cyan },          -- colors
    ["@keyword.directive.css"]     = { fg = c.orange },        -- @media / @import

    -- ── JSON / YAML ──────────────────────────────────────────────────────
    -- bwya77 [30] JSON property names -> #c77dbb (magenta)
    -- bwya77 [31] JSON strings -> #6aab73 (green)
    -- bwya77 [32] YAML keys -> #cf8e6d (orange)
    -- bwya77 [34] YAML anchors -> #2aacb8 (cyan)
    ["@property.json"]             = { fg = c.magenta },
    ["@string.json"]               = { fg = c.green },
    ["@property.yaml"]             = { fg = c.orange },
    ["@field.yaml"]                = { fg = c.orange },
    ["@string.yaml"]               = { fg = c.fg },            -- plain values → fg
    ["@type.yaml"]                 = { fg = c.cyan },          -- anchors

    -- ── Python specifics ─────────────────────────────────────────────────
    -- bwya77 [44] decorators -> yellow
    -- bwya77 [45] magic methods -> blue_fn
    ["@function.builtin.python"]   = { fg = c.blue_fn },
    ["@attribute.python"]          = { fg = c.yellow },

    -- ── Rust specifics ───────────────────────────────────────────────────
    -- bwya77 [49] lifetimes -> cyan
    -- bwya77 [50] macros -> blue_fn bold
    -- bwya77 [51] attributes -> yellow
    ["@label.rust"]                = { fg = c.cyan },          -- lifetimes
    ["@type.rust"]                 = { fg = c.magenta },
    ["@function.macro.rust"]       = { fg = c.blue_fn, bold = true },
    ["@attribute.rust"]            = { fg = c.yellow },
  }
end

return M
