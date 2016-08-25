#!/bin/bash

. dockercoins.env

# Use docker-compose to build and push the application to local registry
ssh -i key core@$w1 <<EOF
rm -rf docker-orchestration
git clone https://github.com/roicostas/docker-orchestration
cd docker-orchestration/dockercoins
curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > docker-compose
chmod +x docker-compose
export REGISTRY_DASH=$REGISTRY_DASH
./docker-compose -f docker-compose.yml-registry build
./docker-compose -f docker-compose.yml-registry push
docker tag ${REGISTRY_DASH}dockercoins_worker ${REGISTRY_DASH}dockercoins_worker:v2
docker push ${REGISTRY_DASH}dockercoins_worker:v2
EOF
