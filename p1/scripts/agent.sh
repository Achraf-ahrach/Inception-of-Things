#!/bin/bash

SERVER_IP=$1
SERVER_PORT=6443
K3S_URL="https://${SERVER_IP}:${SERVER_PORT}"
TOKEN_FILE="/vagrant/node-token"

# Update and install required packages
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y curl net-tools

# Wait until token file is available
while [ ! -f "$TOKEN_FILE" ]; do
  echo "Waiting for K3s token file..."
  sleep 2
done

# Read the token from the file
K3S_TOKEN=$(cat "$TOKEN_FILE")

# Install K3s agent
curl -sfL https://get.k3s.io | K3S_URL=${K3S_URL} K3S_TOKEN=${K3S_TOKEN} INSTALL_K3S_EXEC="--flannel-iface=eth1" sh - && echo "K3s server installed successfully."
echo "export PATH=\$PATH:/sbin" >> /home/vagrant/.bashrc