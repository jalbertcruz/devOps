
set -x DIRENV_LOG_FORMAT ''

test -e ~/src/starship.toml && set -x STARSHIP_CONFIG ~/src/starship.toml

test -e ~/.ripgreprc && set -x RIPGREP_CONFIG_PATH $HOME/.ripgreprc

set -x ANSIBLE_HOST_KEY_CHECKING False

test -e ~/.fly && set -x FLYCTL_INSTALL $HOME/.fly

set -x PATH /opt/google/chrome $PATH

set -x PATH $HOME/src/devOps/architecture/tools/ $PATH
set -x PATH $HOME/src/devOps/architecture/tools/cli/ $PATH

set -x PATH $HOME/src/devOps/architecture/tools $HOME/appslnx/tools/jbake/bin/ $GROOVY_HOME/bin $HOME/appslnx/web/krakend $PATH

set -x PATH $HOME/.local/bin $PATH
set -x PATH /usr/local/bin $PATH

# set -x PATH $HOME/appslnx/movile/flutter/bin $PATH

set -x PATH $HOME/appslnx/tools/firecracker/ $PATH

set -x PATH $FLYCTL_INSTALL/bin $PATH

set -x PATH /usr/bin $PATH

set -x PATH ~/appslnx/bin $PATH
# set -x PATH ~/.local/bin:$PATH

set -x PATH $HOME/bin $PATH
set -x PATH $HOME/appslnx/monitoring/loki $PATH
set -x PATH $HOME/appslnx/monitoring/tempo $PATH
