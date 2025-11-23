# set -x KERL_CONFIGURE_OPTIONS --with-microstate-accounting=extra --enable-vm-probes --with-dynamic-trace=dtrace --with-javac --enable-hipe --enable-kernel-poll --without-odbc --enable-threads --enable-sctp --enable-smp-support
# set -x KERL_CONFIGURE_OPTIONS "--disable-hipe --enable-smp-support --enable-threads --enable-kernel-poll --without-odbc --enable-darwin-64bit"

# TODO: check why this is called twice
# set kerl_activate $HOME/kerl/28.1/activate.fish
# test -e $kerl_activate && source $kerl_activate
fish_add_path --global ~/appslnx/elixir/erlang/bin
fish_add_path --global ~/src/elixir/ex_packages/expert/apps/expert/_build/prod/rel/plain/bin

# test -f ~/.kiex/scripts/kiex.fish && source ~/.kiex/scripts/kiex.fish

# TODO: use better way of modify PATH var for Elixir
# set kiex_activate $HOME/.kiex/elixirs/.elixir-1.18.4-28.env.fish
# test -e $kiex_activate && source $kiex_activate
fish_add_path --global ~/appslnx/elixir/elixir/bin

set -x ERL_AFLAGS "-kernel shell_history enabled"
set -x HEX_UNSAFE_HTTPS true
set -x HEX_HTTP_TIMEOUT 1000
set -x HEX_HOME /media/z/data/repo/.hex/

# fish_add_path --global ~/.kiex/bin
