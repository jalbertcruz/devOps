
base-image = "debian:buster-slim"
docker-tag = "1.12-otp-24.0-buster-slim"
erlang-version = "24.0"
erts-version = "12.0"
elixir-version = "1.12.0"
kerl-configure-options = "--with-microstate-accounting=extra --enable-vm-probes --with-dynamic-trace=dtrace --enable-hipe --enable-kernel-poll --without-odbc --enable-threads --enable-sctp --enable-smp-support"
default-erlang-configure-options = ""
