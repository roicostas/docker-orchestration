#!/bin/bash

# Setup swarm cluster
eval $(docker-machine env node-1)

docker swarm init \
    --advertise-addr $(docker-machine ip node-1) \
    --listen-addr $(docker-machine ip node-1):2377

# Get join token
TOKEN=$(docker swarm join-token -q worker)

# Join node-2 and node-3 to the cluster
for node in node-2 node-3; do
    eval $(docker-machine env $node)

    docker swarm join \
    --token $TOKEN \
    $(docker-machine ip node-1):2377
done
