
set -x KERL_CONFIGURE_OPTIONS --with-microstate-accounting=extra --enable-vm-probes --with-dynamic-trace=dtrace --with-javac --enable-hipe --enable-kernel-poll --without-odbc --enable-threads --enable-sctp --enable-smp-support

. /home/a/kerl/26.0.2/activate.fish
source $HOME/.kiex/elixirs/.elixir-1.15.4.env.fish

set -x ERL_AFLAGS "-kernel shell_history enabled"
set -x HEX_UNSAFE_HTTPS true
set -x HEX_HTTP_TIMEOUT 1000
set -x HEX_HOME /media/a/data/repo/.hex/

# ------------------------------------------------
# FIXME: for some extrange reason this breaks the PATH config
# set -x PATH ~/.mix/escripts
# direnv: error can't find bash: exec: "bash": executable file not found in $PATH
# ------------------------------------------------

set -x PATH ~/.kiex/bin/ $PATH
