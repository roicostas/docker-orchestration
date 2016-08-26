#!/bin/bash

eval $(docker-machine env node-1)
docker service create -p 5000:5000 --constraint node.hostname==node-1 registry:2
