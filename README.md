# Docker orchestration

Hands on examples of docker orchestration swarm and kubernetes

Sample application: dockercoins by Jérôme Petazzoni

# Docker orchestration test chain

1. cluster-create.sh : create test cluster
2. cluster-setup.sh : setup orchestration engine if it has not been deployed already 
3. registry-deploy.sh : deploy a private registry
4. dockercoins-build.sh : build dockercoins application and push it to the registry
5. dockercoins-deploy.sh : deploy dockercoins
6. dockercoins-scale.sh : scale dockercoins workers
7. dockercoins-upgrade.sh : upgrade dockercoins worker to version 2
8. dockercoins-kill-worker.sh : kill a worker node
9. cluster-destroy.sh : destroy cluster
