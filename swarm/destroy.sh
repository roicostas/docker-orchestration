#!/bin/bash

# Select all generic machines
nodes=$(docker-machine ls --filter driver=generic -f {{.Name}})

# Eliminate swarm and consul nodes
for n in $nodes; do
    eval $(docker-machine env $n)
    docker rm -f swarm-agent-master swarm-agent
    docker rm -f $(docker ps --filter name=consul -q)
    docker-machine rm -f $n
done
