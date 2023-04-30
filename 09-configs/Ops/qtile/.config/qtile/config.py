import os
from libqtile.log_utils import logger
import re
import subprocess
import libqtile.resources
from libqtile import bar, extension, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen, KeyChord
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
# from qtile_extras.widget import PulseVolume, ALSAWidget
from libqtile.widget import KeyboardLayout
# out = subprocess.check_output(
#     ["xrandr | grep connected | grep -v disconnected | wc -l"], text=True, shell=True
# ).strip()
#
# monitorcount=int(out)
# "xrandr --output eDP-1 --off "
mod = "mod4"
# mod = "control"
# mod = "mod1"
personal_pc = os.environ['PERSONAL_PC']

myBrowser = "/usr/bin/google-chrome-stable"
terminal = "kitty"  # guess_terminal()
if not personal_pc or personal_pc == '1':
    myBrowser = "/usr/bin/google-chrome-stable --password-store=basic"  # My browser of choice


# A function for hide/show all the windows in a group
@lazy.function
def minimize_all(qtile):
    for win in qtile.current_group.windows:
        if hasattr(win, "toggle_minimize"):
            win.toggle_minimize()


# @lazy.function
# def log_screens_count(qtile):
#     if len(qtile.screens) > 1:
#         logger.warning(">>> More than one screen detected!")
#     else:
#         logger.warning(">>> Single screen detected!")


# A function for toggling between MAX and MONADTALL layouts
@lazy.function
def maximize_by_switching_layout(qtile):
    current_layout_name = qtile.current_group.layout.name
    if current_layout_name == 'monadtall':
        qtile.current_group.layout = 'max'
    elif current_layout_name == 'max':
        qtile.current_group.layout = 'monadtall'

keys = [
    Key([mod], "BackSpace", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "z", lazy.hide_show_bar(position='all'), desc="Toggles the bar to show/hide"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "b", lazy.spawn(myBrowser), desc='Web browser'),
    Key([mod], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "d", lazy.spawn("rofi -show drun -show-icons"), desc='Run Launcher'),
    Key(["mod1"], "Tab", lazy.spawn("rofi -show window -show-icons"), desc='Run window switcher'),
    # Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    Key([mod], "m", lazy.layout.maximize(), desc='Toggle between min and max sizes'),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod], "f", maximize_by_switching_layout(), lazy.window.toggle_fullscreen(), desc='toggle fullscreen'),

    Key([mod, "shift"], "m", minimize_all(), desc="Toggle hide/show all windows on current group"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "space", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h",
        lazy.layout.shuffle_left(),
        lazy.layout.move_left().when(layout=["treetab"]),
        desc="Move window to the left/move tab left in treetab"),
    Key([mod, "shift"], "l",
        lazy.layout.shuffle_right(),
        lazy.layout.move_right().when(layout=["treetab"]),
        desc="Move window to the right/move tab right in treetab"),
    Key([mod, "shift"], "j",
        lazy.layout.shuffle_down(),
        lazy.layout.section_down().when(layout=["treetab"]),
        desc="Move window down/move down a section in treetab"
        ),
    Key([mod, "shift"], "k",
        lazy.layout.shuffle_up(),
        lazy.layout.section_up().when(layout=["treetab"]),
        desc="Move window downup/move up a section in treetab"
        ),

    KeyChord([mod], "g", [
        Key([], "q", lazy.shutdown(), desc='Shutdown Qtile'),
        # Key([], "s", lazy.spawn("shutdown now"), desc='Shutdown the system'),
        # Key([], "r", lazy.spawn("shutdown -r now"), desc='Restart the system'),
        Key([], "e", lazy.spawn('/rofi/scripts/sys', shell=True), desc='rofi sys'),
        Key([], "l", lazy.spawn('rofi -show yzl -modes "yzl:/rofi/scripts/yazi-projects-load"', shell=True), desc='rofi ...'),
        Key([], "s", lazy.spawn('rofi -show yzs -modes "yzs:/rofi/scripts/yazi-projects-save"', shell=True), desc='rofi ...'),
        Key([], "b", lazy.spawn("xrandr --output eDP-1 --primary --mode 1920x1200 --output HDMI-1 --off"), desc=''),
        Key([], "h", lazy.spawn("xrandr --output HDMI-1 --primary --mode 3440x1440 --output eDP-1 --off"), desc=''),
        # Key([], "v", volume_toggle(), desc=''),
        # Key([], "l", log_screens_count(), desc='Start laptop screen'),
        # Key([], "l", lazy.spawn("xrandr --output eDP-1 --auto"), desc='Start laptop screen'),
        # Key([], "x", lazy.spawn("xrandr --output eDP-1 --off"), desc='Start laptop screen'),
        # Key([], "h", lazy.spawn("xrandr --output HDMI-1 --auto"), desc='Start HDMI screen'),
    ]),
    # KeyChord([mod], "s", [
    # ]),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.

    # Grow/shrink windows left/right.
    # This is mainly for the 'monadtall' and 'monadwide' layouts,
    # although it does also work in the 'bsp' and 'columns' layouts.
    Key([mod], "equal",
        lazy.layout.grow_left().when(layout=["bsp", "columns"]),
        lazy.layout.grow().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left"
        ),
    Key([mod], "minus",
        lazy.layout.grow_right().when(layout=["bsp", "columns"]),
        lazy.layout.shrink().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left"
        ),

    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    Key([mod], "s", lazy.widget["keyboardlayout"].next_keyboard(), desc="Next keyboard layout."),
]

def not_google():
    return False
    res = yes_google(client)
    res = not res
    if res:
        logger.warning("It's NOT google chrome!")
    return res

def yes_google(client):
    res = "google-chrome" in client.window.get_wm_class()
    if res:
        logger.warning("It's google chrome!")
    return res

groups = []
group_names  = ["1", "2", "3",  "4",  "5", ]
group_labels = ["", "", "👁", "🏫", "📷", ]
# group_labels =  ["DEV", "WWW", "SYS",  "STU", "VBOX", "CHAT", "MUS", "VID", "GFX", "MISC"]
matches = {
    "1": [
        # Match(wm_class="jetbrains-pycharm-ce"),
    ],
    "2": [
        # Match(func=not_google),
    ],
    "3": [
        # Match(func=not_google),
        Match(wm_class='google-chrome'), Match(wm_class='Google-chrome')
    ],
    "4": [
        # Match(title=re.compile(r'.*Google Chrome$')),
        # Match(wm_class=['google-chrome', 'Google-chrome']),
    ],
    "5": [
        Match(wm_class=['logseq', 'obsidian']),
    ],
}
# The default layout for each of the 10 workspaces
group_layouts = ["monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall",
                 "monadtall", "monadtall"]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
            matches=matches[group_names[i]]
        ))

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=False),
                desc="Move focused window to group {}".format(i.name),
            ),
        ]
    )

layouts = [
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    # layout.Max(),
    layout.MonadTall(),
    layout.MonadWide(),
    layout.Tile(),
    layout.Max(),
    layout.TreeTab(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

# logo = os.path.join(os.path.dirname(libqtile.resources.__file__), "logo.png")
screen1 = Screen(
    top=bar.Bar(
        [
            widget.CurrentLayout(),
            widget.GroupBox(),
            widget.Prompt(),
            # volume,
            widget.Volume(
                padding=8,
                fmt='🕫  Vol: {}',
            ),
            KeyboardLayout(
                configured_keyboards=["us", "es"]
            ),
            widget.WindowName(),
            widget.Chord(
                chords_colors={
                    "launch": ("#ff0000", "#ffffff"),
                },
                name_transform=lambda name: name.upper(),
            ),
            # widget.TextBox("default config", name="default"),
            # widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
            # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
            # widget.StatusNotifier(),
            widget.Systray(),
            widget.Clock(format="%d-%m *%a* %I:%M %p"),
            widget.QuickExit(),
        ],
        24,
        # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
        # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
    ),
    background="#000000",
    # wallpaper=logo,
    wallpaper_mode="center",
    # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
    # By default we handle these events delayed to already improve performance, however your system might still be struggling
    # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
    # x11_drag_polling_rate = 60,
)
screens = [
    screen1,
]

# @hook.subscribe.screens_reconfigured
# async def _():
#     if len(qtile.screens) > 1:
#         logger.warning("More than one screen detected!")
#     else:
#         logger.warning("Single screen detected!")

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
focus_previous_on_window_remove = False
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

# @hook.subscribe.client_new
# def modify_window(client):
#     logger.warning(client.window.get_wm_class())

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])
