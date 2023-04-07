#!/usr/bin/env bash

./kjobs.sh
./kconsul.sh

kill -9 $(ps aux | ag "python3 -m http.server" | head -n 1 | awk '{ print $2 }')
