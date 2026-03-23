-- lua/core/compat.lua
-- Backward-compat shims for plugins that still call deprecated APIs.

local native_validate = vim.validate

---@diagnostic disable-next-line: duplicate-set-field
vim.validate = function(name, value, validator, optional_or_msg)
  -- Compatibility for deprecated table-style calls:
  -- vim.validate({ name = { value, validator, optional } })
  if type(name) == "table" and value == nil and validator == nil and optional_or_msg == nil then
    for param_name, spec in pairs(name) do
      if type(spec) == "table" then
        native_validate(param_name, spec[1], spec[2], spec[3])
      end
    end
    return
  end

  return native_validate(name, value, validator, optional_or_msg)
end
