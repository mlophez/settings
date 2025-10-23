#!/usr/bin/python3


from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from . import widgets

screens = [
    Screen(
        #top=bar.Bar(primary_widgets, 35, opacity=0.92)
        top=widgets.top_bar
        #top=bar.Bar(
        #    [
        #        #widget.TextBox(text=" ", fontsize=45, padding=-8, foreground=BLUE, background=DARK_BLUE),
        #        #widget.GroupBox(urgent_border=DARK_BLUE,
        #        #  disable_drag=True, highlight_method="block",
        #        #  this_screen_border=DARK_BLUE, other_screen_border=DARK_ORANGE,
        #        #  this_current_screen_border=BLUE, other_current_screen_border=ORANGE,
        #        #  background=DARK_BLUE,
        #        #),
        #        widget.WindowTabs(),
        #        widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
        #        widget.Chord(
        #            chords_colors={
        #                "launch": ("#ff0000", "#ffffff"),
        #            },
        #            name_transform=lambda name: name.upper(),
        #        ),
        #        widget.Systray(),
        #        widget.Battery(),
        #        widget.BatteryIcon(),
        #        #widget.QuickExit(),
        #        widget.CurrentLayoutIcon(),
        #    ],
        #    35,
        #    # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
        #    # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        #),
    ),
]


