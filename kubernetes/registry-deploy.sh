#!/bin/bash

. dockercoins.env 

# Create registry  deployment 
kubectl run kube-registry --image=registry:2 --replicas=1
# Create registry service
kubectl expose deployment kube-registry --port=5000 --target-port=5000 --name=kube-registry --type=NodePort

echo REGISTRY_DASH=localhost:$(kubectl describe service kube-registry | grep NodePort | grep -o "[0-9]*")/ >> dockercoins.env
