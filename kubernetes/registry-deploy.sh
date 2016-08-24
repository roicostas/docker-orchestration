#!/bin/bash

# Deploy local registry
kubectl create -f registry.yml

# Deploy registry proxy workaroud, HostPort does not work with CoreOS flannel
REGISTRY_IP=$(kubectl get service kube-registry --namespace kube-system --no-headers | awk '{print $2}')
for n in $(cat nodes.env); do
    ip=$(echo $n | cut -f2 -d=)
    ssh -i key -o StrictHostKeyChecking=no core@$ip docker run -d --restart=always -p 5000:5000 jpetazzo/hamba 5000 $REGISTRY_IP:5000
done
