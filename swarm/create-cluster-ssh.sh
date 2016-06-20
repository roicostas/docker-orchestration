#!/bin/bash

# Usage
if [ "$1" == "-h" -o "$1" == "--help" ]; then
    echo usage: $0 [node_name:node_ip[:interface]] ...
    echo "      by default it takes virtualbox images from docker-machine"
    echo "      and creates a swarm cluster with generic driver"
    exit
fi

# Configure sshkey
sshkey="$HOME/.ssh/id_rsa.pub"
if [ ! -f "$sshkey" ]; then
    ssh-keygen -f "$sshkey" -N ""
fi

# Parse arguments
if [ -z "$1" ]; then
    # Get node ips from docker machine virtualbox driver and configure ssh
    nodes=`docker-machine ls --filter driver=virtualbox --format {{.Name}} | grep -v consul`
    node_ips=`for node in $nodes; do 
                echo s$node:$(docker-machine ip $node)
                cat $sshkey | docker-machine ssh $node 'tee -a .ssh/authorized_keys &> /dev/null' 
              done`
    iface=eth1
else
    node_ips="$@"
    iface=eth0
fi

# Deploy docker and swarm with docker-machine
for node_ip in $node_ips; do
    # Split node_ip by :
    IFS=":"
    set -- $node_ip

    # Get interface or use default interface
    if [ "$3" ]; then
        interface="$3"
    else
        interface="$iface"
    fi

    docker-machine create --driver generic \
        --engine-opt cluster-store=consul://localhost:8500 \
        --engine-opt cluster-advertise=$interface:2376 \
        --swarm --swarm-master --swarm-opt replication \
        --swarm-discovery consul://localhost:8500 \
        --generic-ssh-key $sshkey \
        --generic-ssh-user docker --generic-ip-address $2 $1
done
