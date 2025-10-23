#!/usr/bin/python3

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.log_utils import logger
from .theme import colors

def base(fg='text', bg='dark'): 
    return {
        'foreground': colors[fg],
        'background': colors[bg]
    }

def separator():
    return widget.Sep(**base(), linewidth=0, padding=5)


def icon(fg='text', bg='dark', fontsize=16, text="?"):
    return widget.TextBox(
        **base(fg, bg),
        fontsize=fontsize,
        text=text,
        padding=3
    )


def powerline(fg="light", bg="dark"):
    return widget.TextBox(
        **base(fg, bg),
        text="", # Icon: nf-oct-triangle_left
        fontsize=37,
        padding=-2
    )

def workspaces(): 
    return [
        separator(),
        widget.GroupBox(
            **base(fg='light'),
            font='UbuntuMono Nerd Font',
            fontsize=19,
            margin_y=3,
            margin_x=0,
            padding_y=8,
            padding_x=5,
            borderwidth=1,
            active=colors['active'],
            inactive=colors['inactive'],
            rounded=False,
            highlight_method='block',
            urgent_alert_method='block',
            urgent_border=colors['urgent'],
            this_current_screen_border=colors['focus'],
            this_screen_border=colors['grey'],
            other_current_screen_border=colors['dark'],
            other_screen_border=colors['dark'],
            disable_drag=True
        ),
        separator(),
        widget.WindowName(**base(fg='focus'), fontsize=14, padding=5),
        separator(),
    ]

widget_defaults = {
    'font': 'UbuntuMono Nerd Font Bold',
    'fontsize': 18,
    'padding': 6,
}
extension_defaults = widget_defaults.copy()

#widget_defaults = dict(
#    font="sans",
#    fontsize=12,
#    padding=3,
#)
#extension_defaults = widget_defaults.copy()

workspaces = [Group(i) for i in ["   ", "   ", "   ", "   ", "   ", "   ", "   "]]

top_bar = bar.Bar([
    widget.Sep(
        linewidth=0,
        padding=6
    ),
    widget.GroupBox(
        active="#ffffff",
        rounded=False,
        highlight_color="#c4a7e7",
        highlight_method="line",
        borderwidth=0
    ),
    widget.WindowTabs(),
    widget.TextBox(
        text='',
        background="#232136",
        foreground="#f6c177",
        padding=0,
        fontsize=30
    ),
    widget.TextBox(
        text=' ',
        background="#f6c177",
        foreground="#191724",
        padding=7
    ),
    widget.CurrentLayout(
        background="#f6c177",
        foreground="#191724"
    ),
    widget.TextBox(
        text='',
        background="#f6c177",
        foreground="#e0def4",
        padding=0,
        fontsize=30
    ),
    widget.ThermalZone(
        format=" {temp}°C",
        fgcolor_normal="#191724",
        background="#e0def4",
        zone="/sys/class/thermal/thermal_zone0/temp"
    ),
    widget.TextBox(
        text='',
        foreground="#eb6f92",
        background="#e0def4",
        padding=0,
        fontsize=30
    ),
    widget.Memory(
        format="溜{MemUsed: .0f}{mm}",
        background="#eb6f92",
        foreground="#191724",
        interval=1.0
    ),
    widget.TextBox(
        text='',
        background="#eb6f92",
        foreground="#9ccfd8",
        padding=0,
        fontsize=30
    ),
    widget.TextBox(
        text='',
        background="#9ccfd8",
        foreground="#c4a7e7",
        padding=0,
        fontsize=30
    ),
    widget.TextBox(
        text='',
        background="#c4a7e7",
        foreground="#191724",
        padding=7
    ),
    widget.Clock(
        background="#c4a7e7",
        foreground="#191724",
        format="%H:%M - %d/%m/%Y",
        update_interval=60.0
    ),
    widget.TextBox(
        text='',
        background="#c4a7e7",
        foreground="#232136",
        padding=0,
        fontsize=30
    ),
    widget.Systray(),
    widget.QuickExit(
        default_text="拉",
        fontsize=20,
        foreground="#e0def4",
        timer_interval=0,
        countdown_format="拉"
    )
], 40, background="#232136")
