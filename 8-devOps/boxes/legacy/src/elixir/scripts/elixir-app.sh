#!/bin/bash

export MIX_ENV=dev && envconsul -log-level=err -consul-addr=172.17.0.2:8500 -prefix common- \
 -exec-kill-signal=SIGTERM -exec-kill-timeout=10m elixir -S mix phx.server
