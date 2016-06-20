# Utilities for deploying a swarm cluster

By default with no parameters these scripts work with virtualbox nodes added with docker-machine as nodes and nodes named "*consul*" as consul cluster nodes.

Example of two nodes and two consul nodes:
```
NAME      ACTIVE      DRIVER       STATE     URL                         SWARM             DOCKER    ERRORS
consul0   -           virtualbox   Running   tcp://192.168.99.104:2376                     v1.11.2   
consul1   -           virtualbox   Running   tcp://192.168.99.105:2376                     v1.11.2   
node0     -           virtualbox   Running   tcp://192.168.99.101:2376                     v1.11.2   
node1     -           virtualbox   Running   tcp://192.168.99.100:2376                     v1.11.2 
```

Example using consul nodes:
```
bash create-cluster-ssh.sh
bash consul-deploy.sh -d 192.168.99.104
```

Example deplying consul in swarm nodes:
```
bash create-cluster-ssh.sh
bash consul-deploy.sh
```

Example with all parameters:
bash create-cluster-ssh.sh new-node0:192.168.99.101:eth1 new-node1:192.168.99.100:eth1
bash consul-deploy.sh -d 192.168.99.104 new-node0 new-node1

# Scripts docs

create-cluster-ssh.sh - Desploys swarm cluster with docker machine generic driver. Discovery service should be deployed with consul-deploy.sh.

consul-deploy.sh - Deploy consul in a swarm cluster, either with proxies to a foreing consul cluster or with consul containers in swarm

destroy.sh - Remove swarm, consul and consul proxy containers from swarm nodes

reset-consul-cluster.sh - Removes consul containers and volumes from the consul cluster (nodes named "*consul*" in docker-machine)

reset.sh - destroys, creates and deploys consul
