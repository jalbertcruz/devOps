#!/bin/bash

PORT=${NOMAD_PORT_port_server:-9999}

sleep 5

# MIRROR_OUTPUT_PORT=$(curl -G http://172.17.0.2:8500/v1/agent/services --data-urlencode 'filter=Service == webhook-transformer'  | grep Port | tail -n 1 | awk '{print $2}')

# MIRROR_OUTPUT_PORT=$(curl "http://172.17.0.2:8500/v1/kv/service-port-webhook-transformer?raw")

if [ -z ${MIRROR_OUTPUT+x} ]; then
/usr/bin/gor --input-raw :"${PORT}" --output-stdout
 else
#/usr/bin/gor --input-raw :"${PORT}" --output-http "$MIRROR_OUTPUT:$MIRROR_OUTPUT_PORT"
/usr/bin/gor --input-raw :"${PORT}" --output-http "$MIRROR_OUTPUT"
fi

