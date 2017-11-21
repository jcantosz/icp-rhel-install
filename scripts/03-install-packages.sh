#!/bin/bash

# Get the variables
source 00-variables.sh

# Must have yum configured on all hosts prior to running this step

#TODO: Make theses steps run in parallel

# Install docker & python on master
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce

sudo yum install -y python-setuptools
sudo easy_install pip


for ((i=0; i < $NUM_WORKERS; i++)); do
  # Install docker & python on worker
  ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo yum install -y yum-utils device-mapper-persistent-data lvm2
  ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo yum install -y docker-ce

  ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo yum install -y python-setuptools
  ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo easy_install pip
done
