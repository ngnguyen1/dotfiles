local colors = require("colors")
local settings = require("settings")

local disk = sbar.add("item", "widgets.disk", {
  position = "right",
  icon = {
    string = "DSK",
    color = colors.green,
    font = {
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    padding_right = 6,
  },
  label = {
    string = "??%",
    font = { family = settings.font.numbers },
  },
  update_freq = 120,
  click_script = "open -a 'Disk Utility'",
})

disk:subscribe({ "routine", "forced", "system_woke" }, function()
  sbar.exec("df -h / | awk 'NR==2 {print}'", function(output)
    local percent = output:match("/dev/%S+%s+%S+%s+%S+%s+%S+%s+(%d+)%%")
    if not percent then
      return
    end

    local used_percent = tonumber(percent) or 0
    local color = colors.green
    if used_percent >= 80 then
      color = colors.yellow
    end
    if used_percent >= 90 then
      color = colors.red
    end

    disk:set({
      icon = { color = color },
      label = { string = percent .. "%" },
    })
  end)
end)

sbar.add("bracket", "widgets.disk.bracket", { disk.name }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.disk.padding", {
  position = "right",
  width = settings.group_paddings
})
