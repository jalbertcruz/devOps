
alias ... "cd ../../"
alias g 'git --config-env=commit.gpgsign=SIG_COMMIT --config-env=gpg.ssh.allowedSignersFile=ALLOWED_SIGNERS_FILE --config-env=user.email=ACTIVE_EMAIL --config-env=user.signingKey=ACTIVE_SIGNING_KEY'
alias e 'exa -h -l'
alias b byobu
alias buffer 'code $BYOBU_RUN_DIR/printscreen'
alias bload 'byobu new-session tmuxp load --yes'
alias v 'nvim (fzf)'
alias js 'just'
alias galias 'git config --list | rg alias | fzf'
alias ktmux 'chkp 9005 ; tmux kill-session -t '
alias rlf 'source ~/.config/fish/config.fish'
alias pwdc 'pwd | xclip -sel clip'
alias bfg 'java -jar "/media/a/data/installers/Version-Control/history rewrite/bfg-1.14.0.jar"'
alias kubectl 'microk8s.kubectl'
