local colors = require("colors")
local settings = require("settings")

local gpu = sbar.add("item", "widgets.gpu", {
  position = "right",
  icon = {
    string = "GPU",
    color = colors.mocha_mauve,
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
  update_freq = 10,
  click_script = "open -a 'Activity Monitor'",
})

gpu:subscribe({ "routine", "forced", "system_woke" }, function()
  sbar.exec("ioreg -r -d1 -w0 -c IOAccelerator | awk '/PerformanceStatistics/ {print; exit}'", function(output)
    local util = output:match('Device Utilization %%\"=(%d+)')
    if not util then
      gpu:set({ label = { string = "--" } })
      return
    end

    local percent = tonumber(util) or 0
    local color = colors.blue
    if percent >= 60 then
      color = colors.yellow
    end
    if percent >= 85 then
      color = colors.red
    end

    gpu:set({
      icon = { color = color },
      label = { string = util .. "%" },
    })
  end)
end)

sbar.add("bracket", "widgets.gpu.bracket", { gpu.name }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.gpu.padding", {
  position = "right",
  width = settings.group_paddings
})
