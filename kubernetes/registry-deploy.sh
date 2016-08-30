#!/bin/bash

. dockercoins.env 

# Assign c1 a label to run the registry on it
kubectl label --overwrite node $c1 role=master

kubectl create -f registry.yml

REGISTRY_PORT=$(kubectl describe service kube-registry | grep NodePort | grep -o "[0-9]*")

echo export REGISTRY_PORT=$REGISTRY_PORT >> dockercoins.env
echo export REGISTRY=localhost:$REGISTRY_PORT >> dockercoins.env
echo export REGISTRY_DASH=localhost:$REGISTRY/ >> dockercoins.env
