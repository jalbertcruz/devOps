#!/usr/bin/env bash

cd ..

nomad run fabio.nomad
nomad run lum-app.nomad

nomad run wiremock.nomad
