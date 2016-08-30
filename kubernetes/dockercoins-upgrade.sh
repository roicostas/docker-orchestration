#!/bin/bash

. dockercoins.env

# Create new dockercoins_worker version, use port forwarding again to reach kubernetes registry
docker tag localhost:5000/dockercoins_worker localhost:5000/dockercoins_worker:v2
docker push localhost:5000/dockercoins_worker:v2

# Update worker image
kubectl set image deployment/worker worker=${REGISTRY}/dockercoins_worker:v2

# Monitor update process
kubectl rollout status deployment/worker
