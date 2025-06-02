#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
RESET='\033[0m'

print() {
  echo -e "${BLUE}========================================${RESET}"
  echo -e "${BLUE}$1${RESET}"
  echo -e "${BLUE}========================================${RESET}"
}

# Function to handle errors
handle_error() {
  echo -e "${RED}Error: $1${RESET}"
  exit 1
}

info() {
  echo -e "${YELLOW}Info: $1${RESET}"
}

# Update and install required packages
# sudo apt-get update && sudo apt-get upgrade -y
print "Checking if curl is installed"
command -v curl
if [ $? -eq 0 ]; then
  info "curl is already installed"
else
  sudo apt install curl -y || handle_error "Failed to install curl"
fi

print "Installing K3s"
curl -sfL https://get.k3s.io | sh -s - --flannel-iface eth1 || handle_error "Failed to install k3s"

# Wait for a few seconds to ensure k3s is running
sleep 10s

# Add alias for kubectl
print "Adding alias for kubectl"
echo "alias k='kubectl'" >> /home/vagrant/.bashrc

# Setup kubeconfig for vagrant user
sudo mkdir -p /home/vagrant/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube
echo "export KUBECONFIG=/home/vagrant/.kube/config" >> /home/vagrant/.bashrc

# Apply deployment manifests
print "Applying deployment manifests"
sudo kubectl apply -f /tmp/deployment/apps.yaml || handle_error "Failed to apply deployment manifests"
print "Deployment manifests applied successfully"

# # Wait for all pods to be in running state
# print "Waiting for all pods to be in running state"
# sleep 10s ; sudo kubectl wait --for=condition=Ready pods --all --timeout=300s || handle_error "Not all pods are in running state"
# # sleep 10s

# # if [ $? -eq 0 ]; then
# #   info "All pods are in running state"
# # else
# #   handle_error "Not all pods are in running state"
# # fi

# # Apply service manifests
print "Applying service manifests"
sudo kubectl apply -f /tmp/services/apps-service.yaml || handle_error "Failed to apply service manifests"
print "Service manifests applied successfully"

# # Wait for all services to be in running state
# print "Waiting for all services to be in running state"
# sudo  kubectl wait --for=jsonpath='{.spec.selector.app}' -f /tmp/services/ --timeout=300s || handle_error "Not all services are in running state"
# # kubectl wait --for=condition=available --timeout=60s deployment/app1


print "Applying ingress manifests"
sudo kubectl apply -f /tmp/ingress/ingress-config.yaml || handle_error "Failed to apply ingress manifests"
print "Ingress manifests applied successfully"

print "Script Complete"
echo -e "${GREEN}All manifests have been successfully applied${RESET}"
echo -e "${GREEN} You can Access The website by visiting ${YELLOW}http://192.168.56.110${RESET}"
echo -e "${GREEN} The Port IS BELOW "
var=$(sudo kubectl get svc -n kube-system --kubeconfig /etc/rancher/k3s/k3s.yaml)
echo -e "${GREEN} $var ${RESET}"