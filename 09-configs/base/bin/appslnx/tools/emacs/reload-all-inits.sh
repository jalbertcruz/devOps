#!/usr/bin/env bash
eval "$(direnv dotenv bash $HOME/.env)"

#/usr/local/bin/emacsclient -c -a "" --socket-name=emacsd-lsp
#/usr/local/bin/emacsclient -c -a "" --socket-name=emacsd-bridge
#$HOME/.config/emacs-dev-lsp
emacsclient --socket-name=emacsd-lsp -e '(load-file (expand-file-name "~/.config/emacs-dev-lsp/init.el"))'
emacsclient --socket-name=emacsd-bridge -e '(load-file (expand-file-name "~/.config/emacs-dev-bridge/init.el"))'
