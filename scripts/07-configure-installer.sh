#!/bin/bash

# Get the variables
source 00-variables.sh

# Move SSH key
sudo cp ~/.ssh/master.id_rsa /opt/ibm-cloud-private-2.1.0/cluster/ssh_key

# Configure hosts
echo "[master]" | sudo tee /opt/ibm-cloud-private-2.1.0/cluster/hosts
echo "${MASTER_IP}" | sudo tee -a /opt/ibm-cloud-private-2.1.0/cluster/hosts
echo "" | sudo tee -a /opt/ibm-cloud-private-2.1.0/cluster/hosts

echo "[worker]" | sudo tee -a /opt/ibm-cloud-private-2.1.0/cluster/hosts
for ((i=0; i < $NUM_WORKERS; i++)); do
  echo ${WORKER_IPS[i]} | sudo tee -a /opt/ibm-cloud-private-2.1.0/cluster/hosts
done
echo "" | sudo tee -a /opt/ibm-cloud-private-2.1.0/cluster/hosts

echo "[proxy]" | sudo tee -a /opt/ibm-cloud-private-2.1.0/cluster/hosts
echo "${MASTER_IP}" | sudo tee -a /opt/ibm-cloud-private-2.1.0/cluster/hosts

# Add line for external IP in config
echo "cluster_access_ip: ${PUBLIC_IP}" | sudo tee -a /opt/ibm-cloud-private-2.1.0/cluster/config.yaml
echo "proxy_access_ip: ${PUBLIC_IP}" | sudo tee -a /opt/ibm-cloud-private-2.1.0/cluster/config.yaml
