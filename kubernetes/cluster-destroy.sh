#!/bin/bash

BASE_PWD=$PWD
cd coreos-kubernetes/multi-node/vagrant
vagrant destroy -f

cd $BASE_PWD
rm -rf coreos-kubernetes
rm key key.pub
rm kubectl
rm dockercoins.env
