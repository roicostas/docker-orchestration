#!/bin/bash

docker-machine rm -f node-3

sleep 5

docker service ps worker
