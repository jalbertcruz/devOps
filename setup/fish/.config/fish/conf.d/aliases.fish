
alias ... "cd ../../"
alias g 'git --config-env=gpg.ssh.allowedSignersFile=ALLOWED_SIGNERS_FILE --config-env=user.email=ACTIVE_EMAIL --config-env=user.signingKey=ACTIVE_SIGNING_KEY'
alias e 'exa -h -l'
alias b byobu
alias buffer 'code $BYOBU_RUN_DIR/printscreen'
alias bload 'byobu new-session tmuxp load --yes'
alias v 'nvim (fzf)'
alias galias 'git config --list | rg alias | fzf'
alias ktmux 'tmux kill-session -t '
alias rlf 'source ~/.config/fish/config.fish'
