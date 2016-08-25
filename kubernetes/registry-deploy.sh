#!/bin/bash

. dockercoins.env 

# Assign c1 a label to run the registry on it
kubectl label nodes $c1 role=master

kubectl create -f registry.yml

REGISTRY=localhost:$(kubectl describe service kube-registry | grep NodePort | grep -o "[0-9]*")
echo REGISTRY=$REGISTRY >> dockercoins.env
echo REGISTRY_DASH=$REGISTRY/ >> dockercoins.env
