#!/bin/bash

# Get the variables
source 00-variables.sh

sudo docker pull ibmcom/icp-inception${INCEPTION_TAG}:2.1.0

sudo mkdir /opt/ibm-cloud-private-2.1.0
sudo chown $USER /opt/ibm-cloud-private-2.1.0
cd /opt/ibm-cloud-private-2.1.0

sudo docker run -v $(pwd):/data -e LICENSE=accept ibmcom/icp-inception${INCEPTION_TAG}:2.1.0 cp -r cluster /data
