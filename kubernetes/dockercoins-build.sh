#!/bin/bash

. dockercoins.env

# Redirect registry url localhost:5000 to kubernetes registry service
socat TCP-LISTEN:5000,fork TCP:$c1:$REGISTRY_PORT &

export REGISTRY_DASH=localhost:5000/
docker-compose -f ../dockercoins/docker-compose.yml-registry build
docker-compose -f ../dockercoins/docker-compose.yml-registry push
