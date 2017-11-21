#!/bin/bash

set -e

cd /opt/ibm-cloud-private-2.1.0

# Get kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Make config directory
mkdir -p ~/.kube
sudo cp cluster/cfc-certs/kubecfg.* ~/.kube/
sudo chown -R $USER  ~/.kube/

#Set kube config
kubectl config set-cluster cfc-cluster --server=https://mycluster.icp:8001 --insecure-skip-tls-verify=true
kubectl config set-context kubectl --cluster=cfc-cluster
kubectl config set-credentials user --client-certificate=$HOME/.kube/kubecfg.crt --client-key=$HOME/.kube/kubecfg.key
kubectl config set-context kubectl --user=user
kubectl config use-context kubectl
