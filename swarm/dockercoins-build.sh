#!/bin/bash

eval $(docker-machine env node-1)

# Build and push images with docker compose
export REGISTRY_DASH=localhost:5000/
docker-compose -f ../dockercoins/docker-compose.yml-registry build
docker-compose -f ../dockercoins/docker-compose.yml-registry push
