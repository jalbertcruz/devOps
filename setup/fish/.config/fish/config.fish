
set -gx VOLTA_HOME "$HOME/.volta"
set -x PATH "$VOLTA_HOME/bin" $PATH

status --is-interactive; and ~/.rbenv/bin/rbenv init - fish | source

source ~/.config/fish/conf.d/config.fish

set -x PATH /snap/bin/ $PATH
