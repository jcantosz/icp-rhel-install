#!/bin/bash
# If using OpenStack, security groups must be added

# Get the variables
source 00-variables.sh

#https://www.ibm.com/support/knowledgecenter/SSBS6K_2.1.0/supported_system_config/required_ports.html
MASTER_PORTS=("8101" "179" "8500" "8743" "5044" "5046" "9200" "9300" "2380" "4001" "8082" "8084" "4500" "4300" "8600" "80" "443" "8181" "18080" "5000" "35357" "4194" "10248:10252" "30000:32767" "8001" "8888" "8080" "8443" "9235" "9443")
WORKER_PORTS=("179" "4300" "4194" "10248:10252" "30000:32767" "8001" "8888")
# Stop firewall
sudo systemctl stop firewalld.service

# Open required ports
for port in "${MASTER_PORTS[@]}"; do
  sudo iptables -A INPUT -p tcp -m tcp --sport $port -j ACCEPT
  sudo iptables -A OUTPUT -p tcp -m tcp --dport $port -j ACCEPT
done

# Do we need this?
sudo service iptables restart


for ((i=0; i < $NUM_WORKERS; i++)); do
  # Disable SELinux
  ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo systemctl stop firewalld.service
  for port in "${WORKER_PORTS[@]}"; do
    ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo iptables -A INPUT -p tcp -m tcp --sport $port -j ACCEPT
    ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo iptables -A OUTPUT -p tcp -m tcp --dport $port -j ACCEPT
  done

  # Do we need this?
  ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo service iptables restart
done
