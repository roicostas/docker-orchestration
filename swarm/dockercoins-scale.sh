#!/bin/bash

eval $(docker-machine env node-1)
docker service update --replicas 3 worker 
