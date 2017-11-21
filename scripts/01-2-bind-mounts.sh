#!/bin/bash

# Recommended folder sizes:
# /var/lib/docker: > 40GB
# /var/lib/etcd: > 1GB
# /var/lib/registry: Based on user's image in ICP image manager (let's assume 10GB here)
# /opt/ibm/cfc/: > 100GB
# /var/lib/kubelet: > 10GB

export MOUNT_DIR=ibmcloud
#Check sizing, this must be >= 40 GB
sudo mkdir -p /${MOUNT_DIR}/docker
sudo mkdir -p /var/lib/docker
sudo mount -o bind /${MOUNT_DIR}/docker /var/lib/docker

export MOUNT_DIR=ibmcloud
# Check sizing, this must be >= 1GB
sudo mkdir -p /${MOUNT_DIR}/etcd
sudo mkdir -p /var/lib/etcd
sudo mount -o bind /${MOUNT_DIR}/etcd /var/lib/etcd

export MOUNT_DIR=ibmcloud
# Check sizing, this must be >= 10GB
sudo mkdir -p /${MOUNT_DIR}/registry
sudo mkdir -p /var/lib/registry
sudo mount -o bind /${MOUNT_DIR}/registry /var/lib/registry

export MOUNT_DIR=ibmcloud
# Check sizing, this must be >= 100GB
sudo mkdir -p /${MOUNT_DIR}/cfc
sudo mkdir -p /opt/ibm/cfc
sudo mount -o bind /${MOUNT_DIR}/cfc /opt/ibm/cfc

export MOUNT_DIR=ibmcloud
# Check sizing, this must be >= 10GB
sudo mkdir -p /${MOUNT_DIR}/kubelet
sudo mkdir -p /var/lib/kubelet
sudo mount -o bind /${MOUNT_DIR}/kubelet /var/lib/kubelet
