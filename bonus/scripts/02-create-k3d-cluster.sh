#!/bin/bash
source "$(dirname "$0")/lib.sh"

# Check if k3d is installed
if ! command -v k3d > /dev/null 2>&1; then
    print_message $BLUE "k3d is not installed! Installing..."
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash > /dev/null 2>&1
else
   print_message $GREEN "k3d is already installed. Skipping installation."
fi

# Create a K3D cluster
print_message $BLUE "Creating K3D cluster..."
k3d cluster create mycluster --port "8888:9090@loadbalancer" --wait > /dev/null 2>&1
print_message $BLUE "Waiting for the load balancer port (8888:9090) to be ready..."
sleep 20

print_message $GREEN "Cluster Created !"