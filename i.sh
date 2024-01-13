#!/usr/bin/env bash

sudo add-apt-repository ppa:jgmath2000/et
sudo apt-get install -y software-properties-common

sudo apt-get update
#sudo apt-get install -y net-tools et meld tree basez libheif-examples curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev python3-pip zeal vlc vim python3-venv tumx feedgnuplot
sudo apt-get install -y net-tools meld tree basez libheif-examples curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev python3-pip zeal vlc vim python3-venv tumx feedgnuplot
# OJO: not in use dnsmasq (I am using systemd-resolved)

sudo apt-add-repository ppa:fish-shell/release-3
sudo apt-get update
sudo apt-get install fish powerline

# compile Erlang:
# https://riptutorial.com/erlang/example/2791/build-and-install-erlang-otp-on-ubuntu
sudo apt-get install autoconf libncurses5-dev build-essential
sudo apt-get install libwxgtk3.0-gtk3-dev libglu-dev
# Note, selecting 'libglu1-mesa-dev' instead of 'libglu-dev'
# dtrace
sudo apt-get install systemtap-sdt-dev

# install tmux manually: version 3 is not in the repos

sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get install -y git gitk

# For AsciidocFX (pide confirmacion!)
sudo apt-get install -y ttf-mscorefonts-installer

sudo apt-get install -y graphviz
sudo apt-get install -y snmp


# pref
sudo apt-get install linux-tools-common linux-tools-generic linux-tools-`uname -r` logwatch tilix

# sudo apt-get install network-manager-openvpn 
sudo apt-get install network-manager-openvpn-gnome


sudo apt-get install apt-transport-https ca-certificates curl software-properties-common

sudo apt-get install emacs25
sudo apt-get install p7zip-full p7zip-rar uget calibre sysstat iftop htop ack silversearcher-ag xchm cmake nmap portaudio19-dev ffmpeg

sudo apt-get install xclip


# dns cache
sudo apt-get install nscd
# cli command
#sudo apt-get install tree

# disk analysis
sudo apt-get install smartmontools

sudo apt-get install inotify-tools

# pdf printer (The pdf printer provided by that package will "print" the resulting PDFs into the /home/[user]/PDF directory)
sudo apt-get install printer-driver-cups-pdf

sudo apt-get install rlwrap

sudo apt install resolvconf

# urlencode
sudo apt-get install gridsite-clients

# kvm
sudo apt install -y libvirt-bin
# Android
sudo adduser a kvm

sudo add-apt-repository ppa:wireshark-dev/stable
sudo apt-get install -y wireshark

# https://askubuntu.com/questions/229352/how-to-record-output-to-speakers
sudo apt-get install pavucontrol audacity

# sudo apt-get install libgconf-2-4

sudo apt-get install -y stow
sudo apt-get install -y libbz2-dev lzma liblzma-dev libbz2-dev
