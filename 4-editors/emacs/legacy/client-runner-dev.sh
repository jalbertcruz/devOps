#!/usr/bin/env bash
set -e
set -u
set -o pipefail

#export LD_LIBRARY_PATH=/home/z/.tree-sitter/lib
eval "$(direnv dotenv bash $HOME/.env)"
npath=$(rg fish_add_path $HOME/.config/fish/conf.d/env_vars | choose 2 | xargs -I{} -n1 echo -n ":{}")
#npath=$(/usr/local/bin/rg fish_add_path $HOME/.config/fish/conf.d/env_vars | choose 2 | xargs -I{} -n1 echo -n ":{}")
export PATH="$PATH$npath"
#/usr/local/bin/emacsclient -c -a "emacs" # original from DistroTube
#/usr/local/bin/emacsclient -c -a "" # --alternate-editor="emacsd"
#/usr/local/bin/emacs --init-directory "$HOME/.config/emacs-dev" --debug-init
/usr/local/bin/emacs --init-directory "$HOME/.config/emacs-dev"
