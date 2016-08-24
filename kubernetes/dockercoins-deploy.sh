#!/bin/bash

. dockercoins.env 

kubectl run worker --image=$REGISTRY/dockercoins_worker$VERSION 
kubectl run redis --image=redis --expose --port=6379 --replicas=1
kubectl run rng --image=$REGISTRY/dockercoins_rng$VERSION --expose --port=80
kubectl run hasher --image=$REGISTRY/dockercoins_hasher$VERSION --expose --port=80

# Kubectl run does not support all configuration flags e.g target-port=container port
# Create webui deployment 
kubectl run webui --image=$REGISTRY/dockercoins_webui$VERSION --replicas=1
# Create webui service
kubectl expose deployment webui --port=8000 --target-port=80 --name=webui --type=LoadBalancer
