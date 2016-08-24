#!/bin/bash

BASE_PWD=$PWD
rm dockercoins.env

# -- Setup CoreOS-kubernetes cluster --
#git clone https://github.com/coreos/coreos-kubernetes.git
cd coreos-kubernetes/multi-node/vagrant

# Condigure two controllers
#sed 's/#$controller_count=1/$controller_count=2/g' < config.rb.sample > config.rb

# Create cluster
#vagrant up

# -- Configure kubernetes client kubectl --
curl -O https://storage.googleapis.com/kubernetes-release/release/v1.3.4/bin/linux/amd64/kubectl > $BASE_PWD/kubectl
chmod +x $BASE_PWD/kubectl
echo 'export PATH=$PATH:$BASE_PWD' > $BASE_PWD/dockercoins.env
export PATH=$PATH:$BASE_PWD

echo 'export KUBECONFIG="${KUBECONFIG}:$PWD/kubeconfig"' >> $BASE_PWD/dockercoins.env
export KUBECONFIG="${KUBECONFIG}:$PWD/kubeconfig"
kubectl config set-cluster vagrant-multi-cluster \
    --server=https://172.17.4.101:443 \
    --certificate-authority=${PWD}/ssl/ca.pem
kubectl config set-credentials vagrant-multi-admin \
    --certificate-authority=${PWD}/ssl/ca.pem \
    --client-key=${PWD}/ssl/admin-key.pem \
    --client-certificate=${PWD}/ssl/admin.pem
kubectl config set-context vagrant-multi \
    --cluster=vagrant-multi-cluster \
    --user=vagrant-multi-admin
kubectl config use-context vagrant-multi

# -- Configure ssh authentication --
ssh-keygen -f $BASE_PWD/key -t rsa -N ""
for node in $(vagrant status | grep running | awk '{print $1}'); do
    cat $BASE_PWD/key.pub | vagrant ssh -c "mkdir -p .ssh && cat ->> .ssh/authorized_keys" $node 2>/dev/null
    node_ip=$(vagrant ssh -c "ip address show eth1 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'" $node | tr -d '\r')
    echo export $node=$node_ip >> $BASE_PWD/dockercoins.env
    echo $node=$node_ip
done
echo Enviroment information saved at dockercoins.env

cd $BASE_PWD
. $BASE_PWD/dockercoins.env
# Wait for kubernetes cluster to be up
while ! curl $c1:443 ; do
    echo Waiting for kubernetes to be up
    sleep 1
done

# -- Allow scheduling in master nodes --
for node in $(kubectl get nodes --no-headers | grep SchedulingDisabled | awk '{print $1}'); do
    kubectl uncordon $node
done
