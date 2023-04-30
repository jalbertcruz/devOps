#!/usr/bin/env python
# -*- coding: utf-8 -*-

# https://manpages.ubuntu.com/manpages/focal/man1/python-evdev.1.html

import evdev
from evdev import UInput
from evdev import ecodes as e
from evdev.events import *

# devices = [evdev.InputDevice(path) for path in evdev.list_devices()]
# for device in devices:
#     print(f"{device.path} -- {device.name} -- {device.phys}")

# ui = UInput()
ctrl = InputEvent(1334414993, 274296, e.EV_KEY, e.KEY_LEFTCTRL, 1)
f12 = InputEvent(1334414993, 274296, e.EV_KEY, e.KEY_F12, 1)
a = InputEvent(1334414998, 274296, e.EV_KEY, e.KEY_A, 1)
with UInput() as ui:
    ui.write_event(ctrl)
    ui.write_event(f12)
    ui.write_event(a)
    ui.syn()
