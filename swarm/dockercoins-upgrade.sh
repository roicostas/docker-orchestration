#!/bin/bash

eval $(docker-machine env node-1)

# Create new dockercoins_worker version
REGISTRY=localhost:5000
docker tag $REGISTRY/dockercoins_worker $REGISTRY/dockercoins_worker:v2
docker push $REGISTRY/dockercoins_worker:v2

docker service update --image localhost:5000/dockercoins_worker:v2 worker
