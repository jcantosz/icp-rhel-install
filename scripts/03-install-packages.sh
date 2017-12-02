#!/bin/bash

# Get the variables
source 00-variables.sh

# Must have yum configured on all hosts prior to running this step

#TODO: Make theses steps run in parallel

# Install docker & python on master
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
if [ "$ARCH" == "ppc64le" ]; then
  # https://developer.ibm.com/linuxonpower/docker-on-power/
  echo -e "[docker]\nname=Docker\nbaseurl=http://ftp.unicamp.br/pub/ppc64el/rhel/7/docker-ppc64el/\nenabled=1\ngpgcheck=0\n" | sudo tee /etc/yum.repos.d/docker.repo
else
  sudo yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo
fi
sudo yum update -y
sudo yum install -y docker-ce

# Fall back to pinned version (no fallback for ppc)
if [ "$?" == "1" ]; then
  yum install --setopt=obsoletes=0 -y docker-ce-17.03.2.ce-1.el7.centos.x86_64 docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch
fi

sudo yum install -y python-setuptools
sudo easy_install pip


for ((i=0; i < $NUM_WORKERS; i++)); do
  # Install docker & python on worker
  ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo yum install -y yum-utils device-mapper-persistent-data lvm2
  if [ "$ARCH" == "ppc64le" ]; then
    ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} 'echo -e "[docker]\nname=Docker\nbaseurl=http://ftp.unicamp.br/pub/ppc64el/rhel/7/docker-ppc64el/\nenabled=1\ngpgcheck=0\n" | sudo tee /etc/yum.repos.d/docker.repo'
  else
    ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  fi
  
  ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo yum update -y
  ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo yum install -y docker-ce

  # Fall back to pinned version (no fallback for ppc)
  if [ "$?" == "1" ]; then
    ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} yum install --setopt=obsoletes=0 -y docker-ce-17.03.2.ce-1.el7.centos.x86_64 docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch
  fi

  ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo yum install -y python-setuptools
  ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo easy_install pip
done
