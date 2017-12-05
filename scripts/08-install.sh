#!/bin/bash

# Get the variables
source 00-variables.sh

cd /opt/ibm-cloud-private-2.1.0/cluster

sudo docker run -e LICENSE=accept --net=host -t -v "$(pwd)":/installer/cluster ibmcom/icp-inception${INCEPTION_TAG}:2.1.0 install
