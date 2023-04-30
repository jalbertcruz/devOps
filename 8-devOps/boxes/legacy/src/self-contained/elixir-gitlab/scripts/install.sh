#!/usr/bin/env bash

# Exit the script immediately with an error if any of the commands fail
set -e

mix local.hex --force
mix local.rebar --force
#source ./library.sh
apt-get update
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
apt-get install git-lfs
git lfs install
#export PATH="$PATH:$HOME/.local/bin:$HOME/.mix/escripts"
apt-get install -y python3-pip
pip3 install jinja2 typer toposort python-slugify --user
