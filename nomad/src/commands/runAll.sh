#!/usr/bin/env bash


# sudo nomad agent -dev &
# sudo nomad agent -dev -config=config/server.conf

./rconsul.sh

cpwd=$(pwd)


google-chrome "http://localhost:4646/ui/jobs" &
google-chrome "http://localhost:8500/ui/#/dc1/services" &

# google-chrome "http://172.17.0.2:8500/ui/#/dc1/services" &


sleep 10

cd ./../../../resources/

python3 -m http.server  &

cd ${cpwd}

./rjobs.sh

sleep 50
# fabio UI
google-chrome "http://localhost:9998/api/routes" &
