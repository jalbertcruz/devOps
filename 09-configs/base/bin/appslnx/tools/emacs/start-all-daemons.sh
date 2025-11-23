#!/usr/bin/env bash
#export LD_LIBRARY_PATH=/home/z/.tree-sitter/lib
eval "$(direnv dotenv bash $HOME/.env)"
#npath=$(rg fish_add_path $HOME/.config/fish/conf.d/env_vars --type=fish | choose 2 | xargs -I{} -n1 echo -n ":{}")
#export PATH="$PATH$npath"

#/usr/local/bin/emacsclient -c -a "emacs" # original from DistroTube
#/usr/local/bin/emacsclient -c -a "" # --alternate-editor="emacsd"
#/usr/local/bin/emacs --init-directory "$HOME/.config/emacs-dev" --debug-init

/usr/local/bin/emacs --bg-daemon=emacsd-lsp --init-directory "$HOME/.config/emacs-dev-lsp" # & # --debug-init
/usr/local/bin/emacs --bg-daemon=emacsd-eglot --init-directory "$HOME/.config/emacs-dev-eglot" # & # --debug-init
/usr/local/bin/emacs --bg-daemon=emacsd-bridge --init-directory "$HOME/.config/emacs-dev-bridge" # & # --debug-init
