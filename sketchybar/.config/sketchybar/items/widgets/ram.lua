local colors = require("colors")
local settings = require("settings")

local ram = sbar.add("item", "widgets.ram", {
  position = "right",
  icon = {
    string = "MEM",
    color = colors.blue,
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
  update_freq = 20,
  click_script = "open -a 'Activity Monitor'",
})

ram:subscribe({ "routine", "forced", "system_woke" }, function()
  sbar.exec("vm_stat", function(output)
    local function page_count(label)
      local value = output:match(label .. ":%s+(%d+)%.")
      return tonumber(value) or 0
    end

    local free = page_count("Pages free")
    local active = page_count("Pages active")
    local inactive = page_count("Pages inactive")
    local speculative = page_count("Pages speculative")
    local wired = page_count("Pages wired down")
    local compressed = page_count("Pages occupied by compressor")

    local total = free + active + inactive + speculative + wired + compressed
    if total <= 0 then
      return
    end

    -- Approximate "real" memory pressure better than top's used/unused:
    -- active + wired + compressed, while inactive/speculative stay reclaimable.
    local used = active + wired + compressed
    local percent = math.floor((used / total) * 100 + 0.5)
    local color = colors.blue
    if percent >= 70 then
      color = colors.yellow
    end
    if percent >= 85 then
      color = colors.red
    end

    ram:set({
      icon = { color = color },
      label = { string = tostring(percent) .. "%" },
    })
  end)
end)

sbar.add("bracket", "widgets.ram.bracket", { ram.name }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.ram.padding", {
  position = "right",
  width = settings.group_paddings
})
