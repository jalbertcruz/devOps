
set -gx VOLTA_HOME "$HOME/.volta"
set -x PATH "$VOLTA_HOME/bin" $PATH

status --is-interactive; and ~/.rbenv/bin/rbenv init - fish | source

source ~/.config/fish/conf.d/config.fish

set -x PATH /snap/bin/ $PATH

envsource ~/.env

test -e .venv/bin/activate.fish && source .venv/bin/activate.fish

set -gx DENV 1

# function ljava # --no-scope-shadowing
#     set val (eval (cat .cs-java))
#     echo $val
#     eval "$val"
# end

# test -e .cs-java && eval (eval (cat .cs-java))
