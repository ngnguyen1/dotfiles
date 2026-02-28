# pyright: reportMissingImports=false
from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer, get_options
from kitty.utils import color_as_int
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_attributed_string,
    draw_title,
)

opts = get_options()
# icon_fg = as_rgb(color_as_int(opts.color1))
icon_fg = as_rgb(int("ff9a00", 16))
# CLOCK_FG = as_rgb(int("ffffff", 16))
icon_bg = as_rgb(color_as_int(opts.color8))
SEPARATOR_SYMBOL, SOFT_SEPARATOR_SYMBOL = ("\uE0B8", "\uE0B9")
RIGHT_MARGIN = 1
REFRESH_TIME = 1
ICON = "  "
SESSION_FG = as_rgb(int("ffffff", 16))
SESSION_BG = as_rgb(int("7c4dff", 16))  # purple like screenshot
SESSION_ICON = " \uF06D "  # Nerd Font fire icon (fa-fire)


def _get_session_width() -> int:
    """Return the width in cells that the session name would occupy (for layout)."""
    tm = get_boss().active_tab_manager
    if tm is None or not tm.session_name:
        return 0
    return len(SESSION_ICON) + len(tm.session_name) + 1


def _draw_icon(screen: Screen, index: int) -> int:
    if index != 1:
        return screen.cursor.x
    fg, bg = screen.cursor.fg, screen.cursor.bg
    screen.cursor.fg = icon_fg
    screen.cursor.bg = icon_bg
    screen.draw(ICON)
    screen.cursor.fg, screen.cursor.bg = fg, bg
    return screen.cursor.x


def _draw_session_name(screen: Screen, index: int) -> int:
    if index != 1:
        return screen.cursor.x

    tm = get_boss().active_tab_manager
    if tm is None or not tm.session_name:
        return screen.cursor.x

    name = tm.session_name

    fg, bg = screen.cursor.fg, screen.cursor.bg
    screen.cursor.fg = SESSION_FG
    screen.cursor.bg = SESSION_BG

    screen.draw(f"{SESSION_ICON}{name} ")

    screen.cursor.fg, screen.cursor.bg = fg, bg
    return screen.cursor.x


def _draw_left_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    if screen.cursor.x >= screen.columns - right_status_length:
        return screen.cursor.x
    tab_bg = screen.cursor.bg
    tab_fg = screen.cursor.fg
    default_bg = as_rgb(int(draw_data.default_bg))
    if extra_data.next_tab:
        next_tab_bg = as_rgb(draw_data.tab_bg(extra_data.next_tab))
        needs_soft_separator = next_tab_bg == tab_bg
    else:
        next_tab_bg = default_bg
        needs_soft_separator = False
    # Ensure we don't draw tab content on top of icon/session (only for first tab)
    left_margin = len(ICON) + (_get_session_width() if index == 1 else 0)
    if screen.cursor.x < left_margin:
        screen.cursor.x = left_margin
    screen.draw(" ")
    screen.cursor.bg = tab_bg
    draw_title(draw_data, screen, tab, index)
    if not needs_soft_separator:
        screen.draw(" ")
        screen.cursor.fg = tab_bg
        screen.cursor.bg = next_tab_bg
        screen.draw(SEPARATOR_SYMBOL)
    else:
        prev_fg = screen.cursor.fg
        if tab_bg == tab_fg:
            screen.cursor.fg = default_bg
        elif tab_bg != default_bg:
            c1 = draw_data.inactive_bg.contrast(draw_data.default_bg)
            c2 = draw_data.inactive_bg.contrast(draw_data.inactive_fg)
            if c1 < c2:
                screen.cursor.fg = default_bg
        screen.draw(" " + SOFT_SEPARATOR_SYMBOL)
        screen.cursor.fg = prev_fg
    end = screen.cursor.x
    return end

def _redraw_tab_bar(_):
    tm = get_boss().active_tab_manager
    if tm is not None:
        tm.mark_tab_bar_dirty()

timer_id = None
right_status_length = -1

def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    global timer_id
    global right_status_length
    if timer_id is None:
        timer_id = add_timer(_redraw_tab_bar, REFRESH_TIME, True)
    right_status_length = RIGHT_MARGIN

    # Draw order: icon first, then session name, then tab titles (so nothing overwrites)
    _draw_icon(screen, index)
    _draw_session_name(screen, index)
    _draw_left_status(
        draw_data,
        screen,
        tab,
        before,
        max_title_length,
        index,
        is_last,
        extra_data,
    )
    return screen.cursor.x
