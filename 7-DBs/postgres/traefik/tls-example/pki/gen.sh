#!/usr/bin/env bash

mkcert personal.local "*.personal.local" example.test localhost 127.0.0.1 ::1

exit 0

mkdir -p certs/{ca,traefik}
# Create CA certificates
openssl genrsa -out certs/ca/rootCA.key 4096
openssl req -x509 -new \
    -nodes \
    -sha256 \
    -days 3650 \
    -key certs/ca/rootCA.key \
    -subj "/C=GR/L=Athens/O=Karvounis Tutorials, Inc./CN=Karvounis Root CA/OU=CA department" \
    -out certs/ca/rootCA.pem
# Create Traefik wildcard certificates
openssl genrsa -out certs/traefik/traefik.key 4096
openssl req -new \
    -key certs/traefik/traefik.key \
    -subj "/C=GR/L=Athens/O=Karvounis Tutorials, Inc./CN=*.personal.local/OU=Dev.to" \
    -out certs/traefik/traefik.csr
openssl x509 -req \
    -sha256 \
    -days 365 \
    -CA certs/ca/rootCA.pem \
    -CAkey certs/ca/rootCA.key \
    -CAcreateserial \
    -in certs/traefik/traefik.csr \
    -out certs/traefik/traefik.crt
