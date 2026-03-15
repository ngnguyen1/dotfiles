local colors = require("colors")
local settings = require("settings")

local vpn = sbar.add("item", "widgets.vpn", {
  position = "right",
  icon = {
    string = "VPN",
    color = colors.grey,
    font = {
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    padding_right = 6,
  },
  label = {
    drawing = false,
    width = 0,
    font = { family = settings.font.numbers },
  },
  update_freq = 5,
  click_script = "open -a 'GlobalProtect'",
})

local function refresh_vpn_status()
  sbar.exec("LC_ALL=C tail -n 800 \"/Library/Logs/PaloAltoNetworks/GlobalProtect/pan_gp_event.log\" 2>/dev/null | awk 'BEGIN{IGNORECASE=1} /IPSec tunnel creation finished|VPN tunnel is connected/ {state=\"Connected\"} /Tunnel is down|logged out of Gateway/ {state=\"Disconnected\"} /Set state to Disconnecting/ {state=\"Disconnecting\"} /Set state to Connecting|Trying to create tunnel/ {state=\"Connecting\"} END{print state}'", function(output)
    local state = (output or ""):gsub("^%s+", ""):gsub("%s+$", "")

    if state == "Connected" then
      vpn:set({
        icon = { color = colors.green },
      })
    elseif state == "Connecting" or state == "Disconnecting" then
      vpn:set({
        icon = { color = colors.yellow },
      })
    else
      vpn:set({
        icon = { color = colors.red },
      })
    end
  end)
end

vpn:subscribe({ "routine", "forced", "system_woke", "wifi_change" }, refresh_vpn_status)
refresh_vpn_status()

sbar.add("bracket", "widgets.vpn.bracket", { vpn.name }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.vpn.padding", {
  position = "right",
  width = settings.group_paddings
})
