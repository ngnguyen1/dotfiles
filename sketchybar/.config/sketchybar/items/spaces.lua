local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local workspace_names = {
  [1] = "1-dev-core",
  [2] = "2-dev-secondary",
  [3] = "3-reference-web",
  [4] = "4-comms",
  [5] = "5-mail-planning",
  [6] = "6-chrome",
  [7] = "7-pr-review",
  [8] = "8-monitoring",
  [9] = "9-scratch",
  [10] = "10-meeting-share",
}

local workspace_titles = {
  [1] = "Dev Core",
  [2] = "Dev Sec",
  [3] = "Reference",
  [4] = "Comms",
  [5] = "Mail",
  [6] = "Chrome",
  [7] = "PR",
  [8] = "Monitor",
  [9] = "Scratch",
  [10] = "Meeting",
}

local spaces = {}
local space_brackets = {}
sbar.add("event", "aerospace_workspace_change")

local function set_space_style(space, bracket, selected)
  space:set({
    icon = {
      highlight = selected,
      color = selected and colors.mocha_text or colors.white,
    },
    label = {
      highlight = selected,
      color = selected and colors.mocha_text or colors.mocha_subtext0,
    },
    background = {
      color = selected and colors.with_alpha(colors.mocha_mauve, 0.32) or colors.mocha_surface0,
      border_width = 1,
      border_color = selected and colors.mocha_lavender or colors.mocha_surface1,
    }
  })

  bracket:set({
    background = {
      border_color = selected and colors.mocha_mauve or colors.mocha_surface1
    }
  })
end

local function get_focused_workspace(env)
  local focused = (env and env.AEROSPACE_FOCUSED_WORKSPACE) or ""
  focused = focused:gsub("^%s+", ""):gsub("%s+$", "")
  if focused ~= "" then
    return focused
  end

  local focused_handle = io.popen("aerospace list-workspaces --focused 2>/dev/null")
  if not focused_handle then
    return nil
  end
  local raw_focused = focused_handle:read("*a") or ""
  focused_handle:close()
  return raw_focused:gsub("^%s+", ""):gsub("%s+$", "")
end

local function apply_focused_workspace(env)
  local focused = get_focused_workspace(env)
  if not focused then
    return
  end

  for idx = 1, 10, 1 do
    local space = spaces[idx]
    local bracket = space_brackets[idx]
    if space and bracket then
      set_space_style(space, bracket, workspace_names[idx] == focused)
    end
  end
end

local monitor_count = 1
local monitors = io.popen("aerospace list-monitors --count 2>/dev/null")
if monitors then
  local raw_count = monitors:read("*a") or ""
  monitors:close()
  local parsed_count = tonumber((raw_count:gsub("%s+", "")))
  if parsed_count and parsed_count > 0 then
    monitor_count = parsed_count
  end
end

for i = 1, 10, 1 do
  local target_display = 1
  if monitor_count >= 2 then
    target_display = (i <= 5) and 1 or 2
  end

  local space = sbar.add("space", "space." .. i, {
    space = i,
    display = target_display,
    icon = {
      font = { family = settings.font.numbers },
      string = i,
      padding_left = 15,
      padding_right = 8,
      color = colors.mocha_text,
      highlight_color = colors.mocha_mauve,
    },
    label = {
      padding_right = 20,
      string = workspace_titles[i],
      color = colors.mocha_subtext0,
      highlight_color = colors.mocha_text,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = colors.mocha_surface0,
      border_width = 1,
      height = 26,
      border_color = colors.mocha_surface1,
    },
    popup = { background = { border_width = 5, border_color = colors.black } }
  })

  spaces[i] = space

  -- Single item bracket for space items to achieve double border on highlight
  local space_bracket = sbar.add("bracket", { space.name }, {
    background = {
      color = colors.transparent,
      border_color = colors.bg2,
      height = 28,
      border_width = 2
    }
  })
  space_brackets[i] = space_bracket

  -- Padding space
  sbar.add("space", "space.padding." .. i, {
    space = i,
    display = target_display,
    script = "",
    width = settings.group_paddings,
  })

  local space_popup = sbar.add("item", {
    position = "popup." .. space.name,
    padding_left= 5,
    padding_right= 0,
    background = {
      drawing = true,
      image = {
        corner_radius = 9,
        scale = 0.2
      }
    }
  })

  space:subscribe("space_change", function(env)
    apply_focused_workspace(env)
  end)

  space:subscribe("aerospace_workspace_change", function(env)
    apply_focused_workspace(env)
  end)

  space:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "other" then
      space_popup:set({ background = { image = "space." .. env.SID } })
      space:set({ popup = { drawing = "toggle" } })
    else
      sbar.exec("aerospace workspace " .. workspace_names[i] .. " && sketchybar --trigger aerospace_workspace_change")
    end
  end)

  space:subscribe("mouse.exited", function(_)
    space:set({ popup = { drawing = false } })
  end)
end

apply_focused_workspace()

local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

local spaces_indicator = sbar.add("item", {
  padding_left = -3,
  padding_right = 0,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.grey,
    string = icons.switch.on,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.bg1,
  },
  background = {
    color = colors.with_alpha(colors.grey, 0.0),
    border_color = colors.with_alpha(colors.bg1, 0.0),
  }
})

space_window_observer:subscribe("space_windows_change", function(env)
  local icon_line = ""
  local no_app = true
  for app, count in pairs(env.INFO.apps) do
    no_app = false
    local lookup = app_icons[app]
    local icon = ((lookup == nil) and app_icons["Default"] or lookup)
    icon_line = icon_line .. icon
  end

  if (no_app) then
    icon_line = "—"
  end

  local title = workspace_titles[env.INFO.space] or tostring(env.INFO.space)
  local label_text = title .. "  " .. icon_line
  sbar.animate("tanh", 10, function()
    spaces[env.INFO.space]:set({ label = label_text })
  end)
end)

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({
    icon = currently_on and icons.switch.off or icons.switch.on
  })
end)

spaces_indicator:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 1.0 },
        border_color = { alpha = 1.0 },
      },
      icon = { color = colors.bg1 },
      label = { width = "dynamic" }
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 0.0 },
        border_color = { alpha = 0.0 },
      },
      icon = { color = colors.grey },
      label = { width = 0, }
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
