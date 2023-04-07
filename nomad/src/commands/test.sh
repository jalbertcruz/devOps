#!/usr/bin/env bash

while true; do curl -H "Host: main-app.com" "http://localhost:9999/crawler/info" ; echo ""; sleep 1; done

# http http://localhost:9999/__admin/ Host:wiremock.com

# http http://localhost/__admin/ Host:wiremock.com
"""
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 56
Content-Type: application/json
Date: Mon, 03 Jun 2019 16:48:52 GMT
Server: nginx/1.14.0 (Ubuntu)

{
    "mappings": [],
    "meta": {
        "total": 0
    }
}
"""
