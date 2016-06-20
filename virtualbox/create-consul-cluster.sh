#!/bin/bash

# Usage
if [ "$1" == "-h" -o "$1" == "--help" ]; then
    echo usage: $0 [node-number]
    echo "      node-number: number of nodes in the cluster"
    exit
fi

# Configure sshkey
sshkey="$HOME/.ssh/id_rsa.pub"
if [ ! -f "$sshkey" ]; then
    ssh-keygen -f "$sshkey" -N ""
fi

# Parse arguments
n="1"
if [ "$1" ]; then
    n="$1"
fi

node0="consul0"
for i in `seq 0 $((n-1))`; do 
    node="consul$i"

    # Create consul machine
    echo "Create consul$i machine with virtualbox"
    docker-machine create -d virtualbox --virtualbox-memory=512 $node

    # Create consul container
    eval $(docker-machine env $node)
    docker run -d --restart=always --name $node \
        -e CONSUL_BIND_INTERFACE=eth1 --net host consul \
        agent -server -retry-join $(docker-machine ip $node0) \
        -bootstrap-expect $n -ui -client 0.0.0.0

    # Configure ssh_key
    cat $sshkey | docker-machine ssh $node 'tee -a .ssh/authorized_keys &> /dev/null' 
done
