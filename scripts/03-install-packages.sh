#!/bin/bash

# Get the variables
source 00-variables.sh

# Must have yum configured on all hosts prior to running this step

#TODO: Make theses steps run in parallel

# Install docker & python on master
if [ "${OS}" == "rhel" ]; then
  sudo yum install -y yum-utils device-mapper-persistent-data lvm2
  sudo yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  sudo yum install -y docker-ce

  sudo yum install -y python-setuptools
  sudo easy_install pip
else # ubuntu
  # Check os support if >= 16 just use apt
  # https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-docker-ce
  sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
  sudo apt-get update
  sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update
  sudo apt-get install docker-ce

  sudo apt-get install -y python-setuptools
  sudo easy_install pip
fi

for ((i=0; i < $NUM_WORKERS; i++)); do
  # Install docker & python on worker
  if [ "${OS}" == "rhel" ]; then
    ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo yum install -y yum-utils device-mapper-persistent-data lvm2
    ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo yum install -y docker-ce

    ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo yum install -y python-setuptools
    ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo easy_install pip

  else # ubuntu
    ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
    ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo apt-get update
    ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo apt-get update
    ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo apt-get install docker-ce

    ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo apt-get install -y python-setuptools
    ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo easy_install pip
  fi
done
