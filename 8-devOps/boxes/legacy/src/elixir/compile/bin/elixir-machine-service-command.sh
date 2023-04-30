#!/usr/bin/env bash

if [ "$CLEAN_COMPILATION_DIRS" = "yes" ]
then
  rm -Rf deps
  rm -Rf _build
fi

ssh-agent

mix local.rebar --force
mix local.hex --force

eval "${CONTAINER_COMMAND}"

#MIX_QUIET=1 MIX_ENV=prod mix deps.get
#MIX_QUIET=1 MIX_ENV=prod mix release
