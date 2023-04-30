# alias g       'git --config-env=commit.gpgsign=SIG_COMMIT --config-env=gpg.ssh.allowedSignersFile=ALLOWED_SIGNERS_FILE --config-env=user.email=ACTIVE_EMAIL --config-env=user.signingKey=ACTIVE_SIGNING_KEY --config-env=core.hooksPath=HOOKS_PATH '
# alias g 'git --config-env=commit.gpgsign=SIG_COMMIT --config-env=gpg.ssh.allowedSignersFile=ALLOWED_SIGNERS_FILE --config-env=user.email=ACTIVE_EMAIL --config-env=user.signingKey=ACTIVE_SIGNING_KEY '
#alias g 'git --config-env=commit.gpgsign=SIG_COMMIT --config-env=gpg.ssh.allowedSignersFile=ALLOWED_SIGNERS_FILE --config-env=user.email=ACTIVE_EMAIL --config-env=user.signingKey=ACTIVE_SIGNING_KEY --config-env=core.hooksPath=HOOKS_PATH '
alias g git

alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'

# alias nm="nmap -sC -sV -oN nmap"
alias cl clear

alias pwdc 'pwd | tr -d "\n" | xclip -sel clip'

alias rlf 'source ~/.config/fish/config.fish'
alias bfg 'java -jar "/media/z/data/installers/Version-Control/history rewrite/bfg-1.14.0.jar"'
# alias kubectl 'microk8s.kubectl'
# installed
alias fdpkg 'dpkg -s (dpkg -l | fzf | hck -f2)'
# available
# apt-cache search rofi | fzf
# available with version
# apt list rofi

alias zr 'zellij -s (pwd | slugify --stdin) -l zellij-layout.kdl'
alias zj zellij
alias zd 'zellij delete-session (pwd | slugify --stdin)'
alias zat 'zellij attach (pwd | slugify --stdin)'
alias zsc _zellij-send-commands

# Custom projects setup
alias aplt _apply-templates
alias aplu '_apply-updates scala'

alias jardiff 'java -jar "/home/z/appslnx/tools/jardiff.jar"'

alias l 'eza -l --icons --git -a'
alias ll 'eza -lg --icons=always'
alias lt 'eza -lTg --icons=always'
alias lt2 'eza -lTg --level=2 --icons=always'
alias lt3 'eza -lTg --level=3 --icons=always'
alias lt4 'eza -lTg --level=4 --icons=always'
alias lta 'eza -lTag --icons=always'
alias lta2 'eza -lTag --level=2 --icons=always'
alias lta3 'eza -lTag --level=3 --icons=always'
alias lta4 'eza -lTag --level=4 --icons=always'
alias js 'just --choose'

alias lzg lazygit
alias lzd lazydocker
alias gui gitui

# alias g 'git'
alias galias 'git config --list | rg alias | fzf'
alias gca 'git commit -a -m'
alias gst 'git status'
alias gp 'git pull origin'
alias gpr 'git pull origin --rebase'
alias gd 'git diff'
alias gb 'git branch'
alias gba 'git branch -a'
alias gad 'git add'
alias ga 'git add -p'
alias gco 'git checkout'
alias gr 'git remote'
alias grv 'git remote -v'
alias gre 'git reset'
alias glcc 'git rev-parse HEAD | tr -d "\n" | xclip -sel clip'

#alias dps  'docker ps'
alias dpa 'docker ps -a'
alias dl 'docker ps -l -q'
alias dx 'docker exec -it'
alias dcu 'docker compose up -d'
alias dcd 'docker compose down'
alias dve 'docker volume ls | hck -f2 | fzf'
alias dcp 'docker container prune -f'
alias dvp 'docker volume prune -f'

alias ppa 'podman ps -a'
alias px 'podman exec -it'
alias pve 'podman volume ls | hck -f2 | fzf'
alias pcp 'podman container prune -f'
alias pvp 'podman volume prune -f'

alias b byobu
alias buffer 'code $BYOBU_RUN_DIR/printscreen'
alias bload 'byobu new-session tmuxp load --yes'
alias ktmux 'tmux kill-session -t '

#alias v 'NVIM_APPNAME=nvim-lazyvim nvim --listen /tmp/(pwd | slugify --stdin)'
# alias v 'NVIM_APPNAME=nvim-d nvim'
#alias v 'nvim --listen /tmp/(pwd | slugify --stdin)'
# alias v 'NVIM_APPNAME=nvim-tj nvim --listen /tmp/(pwd | slugify --stdin)'
# alias v 'NVIM_APPNAME=nvim-astronvim nvim --listen /tmp/(pwd | slugify --stdin)'
alias vv 'NVIM_APPNAME=nvim-dev nvim'
alias nvim-watcher-compile 'watchexec --no-discover-ignore --watch "$PROJECT_PATH/$PROJECT_SUBDIRECTORY_TO_WATCH" --filter "$PROJECT_FILE_TO_READ" --debounce "$DEBOUNCE_TIME" -r $COMMAND_TO_RUN'
alias proxy 'dns-proxy-server --server-port=5335'
# media find/search
alias ms 'gocatcli find'
alias nv navi
alias marks_exporter 'python3 marks_exporter.py "(pwd)" "$REMOTE_PROJECT_BASE_PATH"'

alias pclip 'echo (xclip -o -selection clipboard)'
alias llazy 'lnav /home/z/.local/state/nvim/'
alias pc process-compose

# mobi reader ebook
alias of 'gjs -m $HOME/appslnx/tools/Foliate/src/main.js'

alias po poetry
alias poi 'poetry lock && poetry install --all-groups --no-root'
# poetry env use 3.10
# uv venv --python 3.10

alias st-gapps 'cd $GLOBAL_APPS_COMPOSE_FILE && process-compose'

alias pn pnpm
alias pnrd 'pnpm run dev'
alias pni 'pnpm i'
alias nid 'npm install -D'
alias rmil 'rm -rf $HOME/.ivy2/local'
alias vpn 'forticlient gui &'
alias lsc losslesscut
alias svr 'ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of json'
alias vm virt-manager
alias sf spf
alias rch 'pc-hooks-private.sh && ruff format && ruff check --fix'
alias lggl 'echo $GITLAB_TOKEN | docker login $GITLAB_REGISTRY -u GITLAB_USER --password-stdin'
# DB vizualizacer
alias chartdb 'cd $HOME/appslnx/dbs/chartdb/ && npm run dev'
#alias ox       'oxker --host unix:///run/user/1000/docker.sock'
#alias ox        'oxker'
alias ox 'oxker --host $DOCKER_HOST'
alias mg-yazi 'merge-yazi-keymap ~/.config/yazi'
alias durl 'describe-url | jless'
# alias t         'cb edit999'
alias tldr tealdeer

alias sml "xrandr --output eDP-1 --primary --mode 1920x1200 --output HDMI-1 --off"
alias smh "xrandr --output HDMI-1 --primary --mode 3440x1440 --output eDP-1 --off"

# fish web interface
## fish_config
