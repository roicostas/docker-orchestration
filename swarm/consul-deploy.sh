#!/bin/bash

# Usage
if [ "$1" == "-h" -o "$1" == "--help" ]; then
    echo "usage: $0 [-d|--discovery-ip <consul-ip>] [node0-name] [node1-name] ..."
    echo '      Creates consul cluster in the given nodes (all nodes are master) using eth1 for discovery'
    echo '      If no nodes are specified, generic driver nodes allocated with docker machine are used'
    echo '      -d|--discovery-ip: instead of creating consul, deploys ambassadors to consul in the given nodes'
    exit
fi


if [ "$1" == "-d" -o "$1" == "--discovery-ip" ]; then
    
    # Check discovery service
    if [ -z "$(curl http://$2:8500/v1/status/leader 2> /dev/null)" ]; then
        echo "Discovery service cannot be reached at $2:8500"
        exit
    fi
    ip="$2"

    # Get nodes
    if [ "$3" ]; then
        nodes=${@:3}
    else
        nodes=$(docker-machine ls --filter driver=generic --format {{.Name}})
    fi

    # Deploy consul ambassadors
    for n in $nodes; do
        echo "Create consul proxy in $n"
        eval $(docker-machine env $n)
        docker run -d --restart=always --name hconsul_$n -p 8500:8500 \
            jpetazzo/hamba 8500 $ip:8500
    done

else
    # Get nodes
    if [ "$1" ]; then
        nodes=$@
        join_ip=$(docker-machine ip $1)
        quorum="$#"
    else
        nodes=$(docker-machine ls --filter driver=generic --format {{.Name}})
        # Get first node
        join_ip=$(docker-machine ip $(echo $nodes | awk '{print $1}'))
        quorum=$(echo $nodes | wc -w)
    fi

    iface="eth1"

    # Deploy consul
    for n in $nodes; do
        eval $(docker-machine env $n)
        docker run -d --restart=always --name consul_$n \
            -e CONSUL_BIND_INTERFACE=$iface --net host consul \
            agent -server -retry-join $join_ip \
            -bootstrap-expect $quorum -ui -client 0.0.0.0
    done

fi

eval $(docker-machine env --unset)
