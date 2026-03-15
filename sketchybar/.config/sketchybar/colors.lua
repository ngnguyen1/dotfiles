return {
  black = 0xff1e1e2e,
  white = 0xffcdd6f4,
  red = 0xfff38ba8,
  green = 0xffa6e3a1,
  blue = 0xff89b4fa,
  yellow = 0xfff9e2af,
  orange = 0xfffab387,
  magenta = 0xfff5c2e7,
  grey = 0xff7f849c,
  transparent = 0x00000000,

  -- Catppuccin Mocha accents (used for active space styling)
  mocha_text = 0xffcdd6f4,
  mocha_subtext0 = 0xffa6adc8,
  mocha_subtext1 = 0xffbac2de,
  mocha_surface0 = 0xff313244,
  mocha_surface1 = 0xff45475a,
  mocha_surface2 = 0xff585b70,
  mocha_mauve = 0xffcba6f7,
  mocha_lavender = 0xffb4befe,
  mocha_base = 0xff1e1e2e,
  mocha_mantle = 0xff181825,
  mocha_crust = 0xff11111b,

  bar = {
    bg = 0xff1e1e2e,
    border = 0xff45475a,
  },
  popup = {
    bg = 0xff181825,
    border = 0xff585b70
  },
  bg1 = 0xff313244,
  bg2 = 0xff45475a,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
