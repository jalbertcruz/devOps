#!/usr/bin/env bash
#export LD_LIBRARY_PATH=/home/z/.tree-sitter/lib
eval "$(direnv dotenv bash $HOME/.env)"
#npath=$(rg fish_add_path $HOME/.config/fish/conf.d/env_vars --type=fish | choose 2 | xargs -I{} -n1 echo -n ":{}")
#export PATH="$PATH$npath"

#/usr/local/bin/emacsclient -c -a "emacs" # original from DistroTube
#/usr/local/bin/emacsclient -c -a "" # --alternate-editor="emacsd"
#/usr/local/bin/emacs --init-directory "$HOME/.config/emacs-dev" --debug-init

c1="elixir\nlsp scala\nbridge\ndoom"
#c1="bridge\nlsp scala\nwriter\ndoom"
case "$(printf "%b" "$c1" | rofi -dmenu)" in
	elixir)
    /usr/local/bin/emacs --init-directory "$HOME/.config/emacs-dev-eglot" --debug-init &
	  ;;
	"lsp scala")

      /usr/local/bin/emacs --init-directory "$HOME/.config/emacs-dev-lsp" # & # --debug-init
#      /usr/local/bin/emacsclient -c -a "" --socket-name=emacsd-lsp &
#      curl -X POST -H "Content-Type: application/json" -d '{"client": "emacsd-lsp"}' http://localhost:8099/api/v1/client-type > /dev/null 2>&1 || true
	  ;;
	bridge)
      /usr/local/bin/emacs --init-directory "$HOME/.config/emacs-dev-bridge" # & # --debug-init
#      /usr/local/bin/emacsclient -c -a "" --socket-name=emacsd-bridge &
#      curl -X POST -H "Content-Type: application/json" -d '{"client": "emacsd-bridge"}' http://localhost:8099/api/v1/client-type  > /dev/null 2>&1 || true
	  ;;
#	writer)
#    /usr/local/bin/emacs --init-directory "$HOME/.config/emacs-writer" &
#	  ;;
	doom)
    /usr/local/bin/emacs --init-directory "$HOME/.config/emacs-doom" --debug-init
	  ;;
	*) exit 1 ;;
esac

