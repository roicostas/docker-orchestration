#!/bin/bash

. dockercoins.env
kubectl scale deployments worker --replicas=3
