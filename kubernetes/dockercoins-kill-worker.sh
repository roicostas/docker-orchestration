#!/bin/bash

. dockercoins.env

echo $(cd coreos-kubernetes/multi-node/vagrant \
    && vagrant halt -f w2)

echo Waiting for state updates ...

sleep 15

kubectl get pods

echo Waiting for state updates ...
sleep 16

# Check application status
kubectl get pods
