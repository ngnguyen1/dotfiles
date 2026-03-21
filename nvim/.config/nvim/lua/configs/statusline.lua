local M = {}

local function get_separators()
  local config = require("nvconfig").ui.statusline
  local sep_style = config.separator_style
  local stl_utils = require "nvchad.stl.utils"

  -- Keep existing behavior: anything except "round" or "block" falls back to "block".
  sep_style = (sep_style ~= "round" and sep_style ~= "block") and "block" or sep_style

  local sep_icons = stl_utils.separators
  return (type(sep_style) == "table" and sep_style) or sep_icons[sep_style]
end

function M.gen_block(icon, txt, sep_l_hlgroup, icon_hl_group, txt_hl_group)
  local separators = get_separators()
  local sep_l = separators.left
  local sep_r = "%#St_sep_r#" .. separators.right .. " %#ST_EmptySpace#"

  return sep_l_hlgroup .. sep_l .. icon_hl_group .. icon .. " " .. txt_hl_group .. " " .. txt .. sep_r
end

return M
