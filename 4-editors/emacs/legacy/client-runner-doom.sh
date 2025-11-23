#!/usr/bin/env bash
set -e
set -u
set -o pipefail

#export LD_LIBRARY_PATH=/home/z/.tree-sitter/lib
eval "$(direnv dotenv bash $HOME/.env)"
#/usr/local/bin/emacsclient -c -a "emacs" # original from DistroTube
#/usr/local/bin/emacsclient -c -a "" # --alternate-editor="emacsd"
/usr/local/bin/emacs --init-directory "$HOME/.config/emacs-doom"
