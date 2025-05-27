#!/bin/bash

# Update and install required packages
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y curl

echo "alias k='kubectl'" >> /home/vagrant/.bashrc

# Install K3s server with static IP
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.110" sh -

# Wait for a few seconds to ensure k3s is running
sleep 10

# Allow the vagrant user to run kubectl without sudo
sudo mkdir -p /home/vagrant/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube

# Set KUBECONFIG environment variable in .bashrc
echo "export KUBECONFIG=/home/vagrant/.kube/config" >> /home/vagrant/.bashrc
