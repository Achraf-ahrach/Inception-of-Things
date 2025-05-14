#!/bin/bash

# Update and install required packages
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y curl

# Wait for the token file to be available
while [ ! -f /vagrant/node-token ]; do
    sleep 1
done

# Get the token
NODE_TOKEN=$(cat /vagrant/node-token)

# Install K3s agent
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=${NODE_TOKEN} sh -

# mkdir -p ~/.kube
# sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
# sudo chown $USER:$USER /etc/rancher/k3s/k3s.yaml