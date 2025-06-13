#!/bin/bash

SERVER_IP=$1
TOKEN_PATH="/var/lib/rancher/k3s/server/node-token"

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y curl net-tools


# Install K3s server with static IP
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=${SERVER_IP}" sh - && echo "K3s server installed successfully."

while [ ! -f "$TOKEN_PATH" ]; do
  echo "Waiting for K3s token to be generated..."
  sleep 2
done  

sudo cp "$TOKEN_PATH" /vagrant/node-token

# Setup kubectl config for vagrant user
sudo mkdir -p /home/vagrant/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube

# Add environment config for vagrant user
echo "export KUBECONFIG=/home/vagrant/.kube/config" >> /home/vagrant/.bashrc
echo "alias k='kubectl'" >> /home/vagrant/.bashrc
echo "export PATH=\$PATH:/sbin" >> /home/vagrant/.bashrc