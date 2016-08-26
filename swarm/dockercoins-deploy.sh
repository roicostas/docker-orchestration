#!/bin/bash

eval $(docker-machine env node-1)

export REGISTRY=localhost:5000

docker network create --driver overlay dockercoins

docker service create --name redis \
  -p 6379 \
  --network dockercoins \
  redis

docker service create --name webui \
  -p 8000:80 \
  --network dockercoins \
  --network ingress \
  $REGISTRY/dockercoins_webui

docker service create --name rng \
  -p 80 \
  --network dockercoins \
  $REGISTRY/dockercoins_rng

docker service create --name hasher \
  -p 80 \
  --network dockercoins \
  $REGISTRY/dockercoins_hasher

docker service create --name worker \
  --network dockercoins \
  $REGISTRY/dockercoins_worker
