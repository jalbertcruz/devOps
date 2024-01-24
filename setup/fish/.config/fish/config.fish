
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


# Created by `userpath` on 2024-01-23 23:51:51
set PATH $PATH /home/a/.local/share/hatch/pythons/3.7/python/install/bin

# Created by `userpath` on 2024-01-23 23:51:56
set PATH $PATH /home/a/.local/share/hatch/pythons/3.8/python/bin

# Created by `userpath` on 2024-01-23 23:52:02
set PATH $PATH /home/a/.local/share/hatch/pythons/3.9/python/bin

# Created by `userpath` on 2024-01-23 23:52:07
set PATH $PATH /home/a/.local/share/hatch/pythons/3.10/python/bin

# Created by `userpath` on 2024-01-23 23:52:13
set PATH $PATH /home/a/.local/share/hatch/pythons/3.11/python/bin

# Created by `userpath` on 2024-01-23 23:52:20
set PATH $PATH /home/a/.local/share/hatch/pythons/3.12/python/bin

# Created by `userpath` on 2024-01-23 23:52:28
set PATH $PATH /home/a/.local/share/hatch/pythons/pypy2.7/pypy2.7-v7.3.12-linux64/bin

# Created by `userpath` on 2024-01-23 23:52:36
set PATH $PATH /home/a/.local/share/hatch/pythons/pypy3.9/pypy3.9-v7.3.12-linux64/bin

# Created by `userpath` on 2024-01-23 23:52:45
set PATH $PATH /home/a/.local/share/hatch/pythons/pypy3.10/pypy3.10-v7.3.12-linux64/bin
