#!/bin/bash

# Select all consul machines
nodes=$(docker-machine ls -f {{.Name}} | grep consul)
node0=$(echo $nodes | awk '{print $1}')
quorum=$(echo $nodes | wc -w)

# Eliminate consul nodes and volumes
for n in $nodes; do
    eval $(docker-machine env $n)
    docker rm -f $(docker ps --filter name=consul -qa) 
    docker volume rm $(docker volume ls -q)
done

# Create consul nodes again
for n in $nodes; do
    eval $(docker-machine env $n)
    docker run -d --restart=always --name $n \
        -e CONSUL_BIND_INTERFACE=eth1 --net host consul \
        agent -server -retry-join $(docker-machine ip $node0) \
        -bootstrap-expect $quorum -ui -client 0.0.0.0
done
