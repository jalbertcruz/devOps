#!/usr/bin/env bash

apt-get update
apt-get upgrade
apt-get install -y build-essential
apt-get install -y python3-dev
apt-get install -y python3-pip
apt-get install -y git
apt-get install -y curl

# esto es para wayland
#apt install -y libwlroots-dev
#wlroots
#apt install -y python-pywlroots

#exit 0
apt install -y labwc # A wlroots-based compositor
apt install -y wayvnc # A VNC server for wlroots
apt install -y wofi # A launcher for wlroots
apt install -y wlrctl #

apt-get install -y python3-cffi python3-cairocffi libpangocairo-1.0-0
apt-get install -y libiw-dev

apt-get install -y libwayland-dev libwlroots-dev wayland-protocols


#curl --proto '=https' --tlsv1.2 -LsSf https://github.com/astral-sh/uv/releases/download/0.9.5/uv-installer.sh | sh
#loginctl show-session 8 -p Type
#uv tool install --with qtile-extras qtile[all]

