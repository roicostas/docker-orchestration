#!/bin/bash

eval $(docker-machine env node-1)

# Build and push images to a remote registry through an ambassador
export REGISTRY_DASH=localhost:5000/
docker-compose -f ../dockercoins/docker-compose.yml-registry build
docker-compose -f ../dockercoins/docker-compose.yml-registry push
docker tag localhost:5000/dockercoins_worker localhost:5000/dockercoins_worker:v2
docker push localhost:5000/dockercoins_worker:v2
