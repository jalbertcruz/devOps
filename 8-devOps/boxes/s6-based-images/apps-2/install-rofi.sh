#!/usr/bin/env bash

cd /home/app/apps-2/rofi-2.0.0
pwd

apt-get install -y apt-utils
apt-get install -y python3 ninja-build meson

apt-get install -y pkg-config
apt-get install -y flex
apt-get install -y bison

apt-get install -y libpango1.0-dev
apt-get install -y libcairo2-dev libx11-xcb-dev

apt-get install -y libgdk-pixbuf-2.0-dev



meson setup build
ninja -C build
ninja -C build install
