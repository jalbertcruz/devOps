set -x DIRENV_LOG_FORMAT ''

test -e ~/src/starship.toml && set -x STARSHIP_CONFIG ~/src/starship.toml

test -e ~/.ripgreprc && set -x RIPGREP_CONFIG_PATH $HOME/.ripgreprc

set -x ANSIBLE_HOST_KEY_CHECKING False

test -e ~/.fly && set -x FLYCTL_INSTALL $HOME/.fly && fish_add_path --global $FLYCTL_INSTALL/bin

# fish_add_path --global /opt/google/chrome

# https://fishshell.com/docs/4.1/cmds/fish_add_path.html
fish_add_path --global $HOME/src/devOps/architecture/tools
fish_add_path --global $HOME/src/devOps/architecture/tools/cli

fish_add_path --global $HOME/src/devOps/architecture/tools
fish_add_path --global $HOME/appslnx/tools/jbake/bin
fish_add_path --global $GROOVY_HOME/bin
fish_add_path --global $HOME/appslnx/web/krakend

fish_add_path --global $HOME/.local/bin
fish_add_path --global /usr/local/bin

# set -x PATH $HOME/appslnx/mobile/flutter/bin
# fish_add_path --global $HOME/appslnx/tools/firecracker

fish_add_path --global /usr/bin

fish_add_path --global ~/appslnx/bin
fish_add_path --global ~/.local/bin

fish_add_path --global $HOME/appslnx/bin/tools/apis
# set -x PATH $HOME/appslnx/bin/tools/aws
fish_add_path --global $HOME/appslnx/bin/tools/data
fish_add_path --global $HOME/appslnx/bin/tools/devops
fish_add_path --global $HOME/appslnx/bin/tools/git
fish_add_path --global $HOME/appslnx/bin/tools/git/lfs
fish_add_path --global $HOME/appslnx/bin/tools/images
fish_add_path --global $HOME/appslnx/bin/tools/lnx
fish_add_path --global $HOME/appslnx/bin/tools/lnx/bash
fish_add_path --global $HOME/appslnx/bin/tools/lnx/searchers
fish_add_path --global $HOME/appslnx/bin/tools/lnx/TUIs

fish_add_path --global $HOME/appslnx/bin/tools/lnx/utils
fish_add_path --global $HOME/appslnx/bin/tools/lnx-process
fish_add_path --global $HOME/appslnx/bin/tools/network
fish_add_path --global $HOME/appslnx/bin/tools/performance
fish_add_path --global $HOME/appslnx/bin/tools/performance/tracing
fish_add_path --global $HOME/appslnx/bin/tools/pls
fish_add_path --global $HOME/appslnx/bin/tools/pls/clojure-lang
fish_add_path --global $HOME/appslnx/bin/tools/pls/lua-lang
fish_add_path --global $HOME/appslnx/bin/tools/pls/lua-lang/lua-language-server/bin
fish_add_path --global $HOME/appslnx/bin/tools/pls/python-lang
fish_add_path --global $HOME/appslnx/bin/tools/pls/scala-lang
fish_add_path --global $HOME/appslnx/bin/tools/pls/refactoring
fish_add_path --global $HOME/appslnx/bin/tools/pls/js
fish_add_path --global $HOME/appslnx/bin/tools/pls/cpp/bin
fish_add_path --global $HOME/appslnx/bin/tools/process
fish_add_path --global $HOME/appslnx/bin/tools/qpdf/bin
fish_add_path --global $HOME/appslnx/bin/tools/security
fish_add_path --global $HOME/appslnx/bin/tools/writing
fish_add_path --global $HOME/appslnx/bin/tools/writing/link-checkers
fish_add_path --global $HOME/appslnx/bin/tools
fish_add_path --global $HOME/appslnx/tools/edition/quarto/bin
fish_add_path --global $HOME/appslnx/tools/edition
fish_add_path --global $HOME/appslnx/tools/kitty/bin

set -x PRIVATE_TOOLS $HOME/appslnx/bin/tools/private
fish_add_path --global $PRIVATE_TOOLS
fish_add_path --global $HOME/appslnx/tools/language/ltex-ls-plus/bin
fish_add_path --global $HOME/appslnx/tools/haskell-language-server/bin

fish_add_path --global $HOME/bin
fish_add_path --global $HOME/appslnx/monitoring/loki
fish_add_path --global $HOME/appslnx/monitoring/grafana-tools
fish_add_path --global $HOME/appslnx/monitoring/tempo
fish_add_path --global $HOME/appslnx/monitoring/vector/bin
fish_add_path --global $HOME/appslnx/monitoring/tempo
fish_add_path --global $HOME/appslnx/monitoring/victoria-metrics
fish_add_path --global $HOME/appslnx/tools/nushell
fish_add_path --global $HOME/appslnx/tools/nvim/bin
fish_add_path --global $HOME/appslnx/tools/edition/LosslessCut/bin
fish_add_path --global $HOME/appslnx/dbs/minio
fish_add_path --global $HOME/appslnx/dbs
fish_add_path --global $HOME/appslnx/dbs/mongodb/mongosh/bin
fish_add_path --global $HOME/appslnx/dbs/mongodb/mongodb/bin
fish_add_path --global $HOME/appslnx/dbs/postgres
fish_add_path --global $HOME/appslnx/monitoring/jaeger
# set -x NUSHELL_HOME $HOME/appslnx/tools/nushell
fish_add_path --global /snap/bin
fish_add_path --global $HOME/appslnx/tools/PKI/cfssl
# set -x NU_RES /media/z/data/installers/Unix/CLI-tools/nushell
set -x DOCS_HOME /media/z/data/docs
fish_add_path --global $HOME/appslnx/tools/ollama/bin
set -x OLLAMA_MODELS /media/z/Local data/ollama/models
fish_add_path --global $HOME/appslnx/tools/offline-tools/git/gitea

fish_add_path --global $HOME/appslnx/tools/linux/clipboard/bin

# set -gx POD_NAME usertools-albert-cruz-0
# set -x QT_QPA_PLATFORM wayland
# set -x QT_QPA_PLATFORM xcb

# https://docs.docker.com/engine/security/rootless/
# set -x DOCKER_HOST unix:///run/user/1000/docker.sock

## --------------------------------------------->>>
# https://java.testcontainers.org/supported_docker_environment/
#set -gx TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE "/run/user/$(id -u)/docker.sock"
#set -gx TESTCONTAINERS_RYUK_DISABLED true

#set -gx DOCKER_HOST "unix://"$XDG_RUNTIME_DIR"/podman/podman.sock"
## <<<---------------------------------------------

# set -x DOCKER_HOST unix://$XDG_RUNTIME_DIR/docker.sock
set -x LOKI_ADDR http://0.0.0.0:3100
# https://github.com/tree-sitter-grammars/tree-sitter-markdown?tab=readme-ov-file
set -x ALL_EXTENSIONS 1

# set -x PROXY_HTTP "http://localhost:8501"
# set -x PROXYS_HTTP "http://localhost:8501"

# gor --input-tcp :8084 --output-http "http://localhost:8083"  --output-stdout

# set -gx MANPAGER "ov --section-delimiter '^[^\s]' --section-header"
set -gx BAT_PAGER "ov -F -H3"

set -gx MANPATH $HOME/src/devOps/1-cli/local-man-pages
# For some reason I have this env variable set
# set -ug MANPATH
set -xg MANPAGER "nvim +Man!"
