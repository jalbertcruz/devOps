#!/usr/bin/env bash

# ( -p 8080:80 ) Map TCP port 80 in the container to port 8080 on the Docker host.

# docker run -d --rm --name=dev-consul -e CONSUL_UI_BETA=true consul:1.1.0
# docker run -d --rm --name=dev-consul --net host -e CONSUL_UI_BETA=true consul:1.1.0

docker run -d --rm --name=consul-dev --net host -enable-script-checks consul:1.6.1

docker build -t custom_consul:v1.6.1 .

consul agent -dev -join=172.17.0.2 -bind=172.17.0.1


# http PUT http://localhost:8500/v1/agent/service/register < wiremock-service.json
