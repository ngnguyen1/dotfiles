-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",
  transparency = true,
  hl_override = {
    -- 	Comment = { italic = true },
    -- 	["@comment"] = { italic = true },
    St_cwd_bg = { fg = "one_bg", bg = "#cba6f7" },
    St_cwd_txt = { fg = "#cba6f7", bg = "#313244" },
    St_cwd_sep = { fg = "#cba6f7", bg = "statusline_bg" },
  },
  hl_add = {
    -- Minimal theme
    St_fp_bg_minimal = { fg = "one_bg", bg = "green" },
    St_fp_txt_minimal = { fg = "green", bg = "one_bg" },
    St_fp_sep_minimal = { fg = "green", bg = "statusline_bg" },

    -- Default theme
    St_fp_bg = { fg = "one_bg", bg = "yellow" },
    St_fp_txt = { fg = "yellow", bg = "one_bg" },
    St_fp_sep = { fg = "yellow", bg = "one_bg" },
  },
}

M.ui = {
  tabufline = {
    enabled = false,
  },
  statusline = {
    theme = "minimal", -- see more: :h nvui.statusline

    -- default, round, block, arrow
    -- Note: the style wont work for vscode themes
    separator_style = "round",

    -- order to remove lsp_msg
    -- TODO: need to figure out proper way to remove that function
    order = { "mode", "file", "git", "%=", "%=", "diagnostics", "lsp", "cwd", "cursor", "rocket" },
    modules = {
      -- cursor = function()
      --   local statusline_utils = require "configs.statusline"
      --   local icon = "󰓾 "
      --   return statusline_utils.gen_block(icon, "%l/%L", "%#St_pos_sep#", "%#St_pos_bg#", "%#St_pos_txt#")
      -- end,
      rocket = function()
        local statusline_utils = require "configs.statusline"

        local stl_theme = require("nvconfig").ui.statusline.theme

        local hl_map = {
          minimal = { sep = "%#St_fp_sep_minimal#", bg = "%#St_fp_bg_minimal#", txt = "%#St_fp_txt_minimal#" },
          default = { sep = "%#St_fp_sep#", bg = "%#St_fp_bg#", txt = "%#St_fp_txt#" },
          -- vscode, vscode_colored can be defined here later
        }

        -- fallback to "default" if theme is unknown
        local hl = hl_map[stl_theme] or hl_map["default"]

        local function file_progress()
          local curr_line = vim.fn.line "."
          local total_lines = vim.fn.line "$"

          if curr_line == 1 then
            return "Top"
          elseif curr_line == total_lines then
            return "Bot"
          else
            return math.floor(curr_line / total_lines * 100) .. "%%"
          end
        end
        -- return statusline_utils.gen_block("", file_progress(), "%#St_file_sep#", "%#St_file_bg#", "%#St_file_txt#")
        return statusline_utils.gen_block("", file_progress(), hl.sep, hl.bg, hl.txt)
      end,
    },
  },
}

M.nvdash = {
  load_on_startup = true,
  header = {
    " _______________             ",
    "< Hello, Nga! >              ",
    " --------------_             ",
    "     \\   ^__^               ",
    "     \\  (oo)\\_______       ",
    "        (__)\\       )\\/\\  ",
    "              ||----w |      ",
    "              ||     ||      ",
    "                             ",
  },
}

M.mason = {
  pkgs = {
    "typescript-language-server",
    "vue-language-server",
    "terraform-ls",
    "prettierd",
    "lua-language-server",
    "rust-analyzer",
    "codelldb",
    "xmlformatter",
    "eslint-lsp",
    "js-debug-adapter",
  },
}

return M
