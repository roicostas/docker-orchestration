#!/bin/bash

. dockercoins.env

# Update worker image
kubectl set image deployment/worker worker=${REGISTRY}/dockercoins_worker:v2

# Monitor update process
kubectl rollout status deployment/worker

kubectl get deployment worker

kubectl describe deployment worker
