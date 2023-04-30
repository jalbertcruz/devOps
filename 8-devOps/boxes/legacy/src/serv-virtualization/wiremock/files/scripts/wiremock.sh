#!/bin/bash

PORT=${NOMAD_PORT_port_server:-9999}

WIREMOCK_VERSION=2.31.0

java -cp /home/app/wiremock-jre8-standalone-$WIREMOCK_VERSION.jar:/home/app/wiremock-webhooks-extension-$WIREMOCK_VERSION.jar \
  com.github.tomakehurst.wiremock.standalone.WireMockServerRunner \
  --extensions org.wiremock.webhooks.Webhooks --port "${PORT}" --root-dir /files-and-mappings-root --verbose --global-response-templating

#java -jar /home/app/wiremock-standalone-2.26.0.jar
#--enable-browser-proxying
#--root-dir /files-and-mappings-root
#--port "${PORT}"
#--verbose
#--record-mappings
#--local-response-templating
