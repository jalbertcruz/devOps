sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y build-essential
sudo apt-get install -y python3-dev
sudo apt-get install -y python3-pip
sudo apt-get install -y git
sudo apt-get install -y curl

sudo apt install wlroots
sudo apt install python-pywlroots
sudo apt update
sudo apt install libwlroots-dev
sudo apt install labwc # A wlroots-based compositor
sudo apt install wayvnc # A VNC server for wlroots
sudo apt install wofi # A launcher for wlroots
sudo apt install wlrctl # 

sudo apt-get install python3-cffi python3-cairocffi libpangocairo-1.0-0
sudo apt-get install libiw-dev

sudo apt-get install -y libwayland-dev libwlroots-dev wayland-protocols


curl --proto '=https' --tlsv1.2 -LsSf https://github.com/astral-sh/uv/releases/download/0.9.5/uv-installer.sh | sh
loginctl show-session 8 -p Type 
uv tool install --with qtile-extras qtile[all]

chmod +x /home/z/Downloads/qtile.desktop 
sudo mv /home/z/Downloads/qtile.desktop /usr/share/xsessions/




-----------------------------


error:
sudo apt-get install -y ninja





sudo apt-get install -y cmake
sudo apt-get install -y libgio-2.0-dev
sudo apt-get install -y meson 
sudo apt-get install -y pkg-config
sudo apt-get install -y flex
sudo apt-get install -y bison
sudo apt-get install -y libpango1.0-dev


sudo apt-get install -y libx11-xcb-dev
sudo apt-get install -y check

sudo apt-get install -y libxkbcommon-dev
sudo apt-get install -y libxkbcommon-x11-dev
sudo apt-get install -y libgdk-pixbuf-2.0-dev
sudo apt-get install -y libmpdclient-dev

sudo apt-get install -y libstartup-notification0-dev
sudo apt-get install -y libnl-3-dev

sudo apt-get install -y libxcb-util-dev
sudo apt-get install -y libxcb-ewmh-dev
sudo apt-get install -y libxcb-icccm4-dev

sudo apt-get install -y libxcb-randr0-dev
sudo apt-get install -y libxcb-cursor-dev
sudo apt-get install -y libxcb-xinerama0-dev
sudo apt-get install -y libxcb-keysyms1-dev
sudo apt-get install -y libxcb-imdkit-dev

--

sudo apt-get install -y wayland-protocols



sudo apt-get install -y xcb-util-dev
sudo apt-get install -y xcb-util-cursor-dev
sudo apt-get install -y xcb-imdkit-dev

sudo apt-get install -y libxcb-dev

 (sometimes split, you need libxcb, libxcb-xkb and libxcb-randr libxcb-xinerama)


On debian based systems, the developer packages are in the form of: <package>-dev on rpm based <package>-devel.

For wayland support:

wayland
wayland-protocols >= 1.17



x11 deps for rofi
sudo apt-get install -y libxcb-composite0
sudo apt-get install -y libxcb-composite0-dev
sudo apt-get install -y libxcb-damage0
sudo apt-get install -y libxcb-damage0-dev
sudo apt-get install -y libxcb-doc
sudo apt-get install -y libxcb-dpms0
sudo apt-get install -y libxcb-dpms0-dev
sudo apt-get install -y libxcb-dri2-0
sudo apt-get install -y libxcb-dri2-0-dev
sudo apt-get install -y libxcb-dri3-0
sudo apt-get install -y libxcb-dri3-dev
sudo apt-get install -y libxcb-ewmh-dev
sudo apt-get install -y libxcb-ewmh2
sudo apt-get install -y libxcb-glx0
sudo apt-get install -y libxcb-glx0-dev
sudo apt-get install -y libxcb-icccm4
sudo apt-get install -y libxcb-icccm4-dev
sudo apt-get install -y libxcb-image0
sudo apt-get install -y libxcb-image0-dev
sudo apt-get install -y libxcb-keysyms1
sudo apt-get install -y libxcb-keysyms1-dev
sudo apt-get install -y libxcb-present-dev
sudo apt-get install -y libxcb-present0
sudo apt-get install -y libxcb-randr0
sudo apt-get install -y libxcb-randr0-dev
sudo apt-get install -y libxcb-record0
sudo apt-get install -y libxcb-record0-dev
sudo apt-get install -y libxcb-render-util0
sudo apt-get install -y libxcb-render-util0-dev
sudo apt-get install -y libxcb-render0
sudo apt-get install -y libxcb-render0-dev
sudo apt-get install -y libxcb-res0
sudo apt-get install -y libxcb-res0-dev
sudo apt-get install -y libxcb-screensaver0
sudo apt-get install -y libxcb-screensaver0-dev
sudo apt-get install -y libxcb-shape0
sudo apt-get install -y libxcb-shape0-dev
sudo apt-get install -y libxcb-shm0
sudo apt-get install -y libxcb-shm0-dev
sudo apt-get install -y libxcb-sync-dev
sudo apt-get install -y libxcb-sync1
sudo apt-get install -y libxcb-util-dev
sudo apt-get install -y libxcb-util0-dev
sudo apt-get install -y libxcb-util1
sudo apt-get install -y libxcb-xf86dri0
sudo apt-get install -y libxcb-xf86dri0-dev
sudo apt-get install -y libxcb-xfixes0
sudo apt-get install -y libxcb-xfixes0-dev
sudo apt-get install -y libxcb-xinerama0
sudo apt-get install -y libxcb-xinerama0-dev
sudo apt-get install -y libxcb-xinput-dev
sudo apt-get install -y libxcb-xinput0
sudo apt-get install -y libxcb-xkb-dev
sudo apt-get install -y libxcb-xkb1
sudo apt-get install -y libxcb-xtest0
sudo apt-get install -y libxcb-xtest0-dev
sudo apt-get install -y libxcb-xv0
sudo apt-get install -y libxcb-xv0-dev
sudo apt-get install -y libxcb-xvmc0
sudo apt-get install -y libxcb-xvmc0-dev
sudo apt-get install -y libxcb1
sudo apt-get install -y libxcb1-dev
sudo apt-get install -y libpthread-stubs0-dev
sudo apt-get install -y libxcb-cursor-dev
sudo apt-get install -y libxcb-cursor0
sudo apt-get install -y libxcb-errors-dev
sudo apt-get install -y libxcb-errors0
sudo apt-get install -y libxcb-imdkit-dev
sudo apt-get install -y libxcb-imdkit1
sudo apt-get install -y libxcb-xrm-dev
sudo apt-get install -y libxcb-xrm0
