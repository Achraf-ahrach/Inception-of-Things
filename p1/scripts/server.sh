#!/bin/bash

SERVER_IP=$1

# Update and install required packages
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y curl net-tools

echo "alias k='kubectl'" >> /home/vagrant/.bashrc

# Install K3s server with static IP
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=${SERVER_IP}" sh - && echo "K3s server installed successfully."

# Wait for k3s to be up
sleep 10

# Setup kubectl config for vagrant user
sudo mkdir -p /home/vagrant/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube
echo "export KUBECONFIG=/home/vagrant/.kube/config" >> /home/vagrant/.bashrc

# Share node token with agent
sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/node-token
