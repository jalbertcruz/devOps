
set -gx VOLTA_HOME "$HOME/.volta"
set -x PATH "$VOLTA_HOME/bin" $PATH

status --is-interactive; and ~/.rbenv/bin/rbenv init - fish | source

test -e .cs-java && set jsJava (cat .cs-java) && eval "$(cs java --jvm  $jsJava --env)"
if not test -e .cs-java
    test -d ~/appslnx/jdk-17 && set -x JAVA_HOME ~/appslnx/jdk-17
end

source ~/.config/fish/conf.d/config.fish

# test -d code && wezterm cli spawn --cwd code --

set -x PATH /snap/bin/ $PATH
set -x PATH "$HOME/appslnx/tools/PKI/cfssl/" $PATH

envsource ~/.env

test -e .venv/bin/activate.fish && source .venv/bin/activate.fish

set -gx DENV 1

# function ljava # --no-scope-shadowing
#     set val (eval (cat .cs-java))
#     echo $val
#     eval "$val"
# end

