#!/bin/bash

# Allocate three machines
for node in node-1 node-2 node-3; do
    docker-machine create -d virtualbox --virtualbox-memory=512 $node
done
