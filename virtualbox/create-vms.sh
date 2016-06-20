#!/bin/bash

# Parse options
while [ "$1" ] ; do
    case "$1" in
        -h | --help)
            echo $0: [number of nodes:default=2]
            exit
            ;;
        [0123456789]*)
            n="$1"
            shift
            ;;
        *) 
            echo $0: [number of nodes:default=2]
            exit
            ;;

    esac
done

[ -z "$n" ] && n="2"

# Generate sshkey if it doesn't exist
sshkey="$HOME/.ssh/id_rsa.pub"
if [ ! -f "$sshkey" ]; then
    ssh-keygen -f "$sshkey" -N ""
fi

# Add nodes to docker machine and configure ssh key authentication
for i in `seq 0 $(($n-1))`; do
    docker-machine create --driver virtualbox \
        --virtualbox-memory=512 nodo$i
    cat $sshkey | docker-machine ssh nodo$i tee -a .ssh/authorized_keys
done

