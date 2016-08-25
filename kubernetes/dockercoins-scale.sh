#!/bin/bash

. dockercoins.env
kubectl scale deployments worker rng --replicas=5
