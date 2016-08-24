#!/bin/bash

. nodes.env
. dockercoins.env

# Use docker-compose to build and push the application to local registry
#ssh -i key core@$w1 <<EOF
#git clone https://github.com/roicostas/docker-orchestration
#cd docker-orchestration/dockercoins
#curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > docker-compose
#chmod +x docker-compose
export REGISTRY=172.17.4.201:"$REGISTRY_PORT"
export VERSION=$VERSION
docker-compose -f ../dockercoins/docker-compose.yml-registry build
docker-compose -f ../dockercoins/docker-compose.yml-registry push
#EOF
