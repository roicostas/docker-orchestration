#!/bin/bash

docker service update --image localhost:5000/dockercoins_worker:v2 worker
