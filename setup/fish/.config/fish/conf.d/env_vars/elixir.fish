
set -x KERL_CONFIGURE_OPTIONS --with-microstate-accounting=extra --enable-vm-probes --with-dynamic-trace=dtrace --with-javac --enable-hipe --enable-kernel-poll --without-odbc --enable-threads --enable-sctp --enable-smp-support

source $HOME/.kiex/elixirs/.elixir-1.14.1.env.fish
. /home/a/kerl/25.1.2/activate.fish

set -x ERL_AFLAGS "-kernel shell_history enabled"

set -x HEX_UNSAFE_HTTPS true
set -x HEX_HTTP_TIMEOUT 1000
set -x HEX_HOME /media/a/data/repo/.hex/

set -x PATH $HOME/.mix/escripts

set -x PATH ~/.kiex/bin/ $PATH
