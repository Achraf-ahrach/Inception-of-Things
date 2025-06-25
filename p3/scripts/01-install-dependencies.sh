#!/bin/bash
source "$(dirname "$0")/lib.sh"

# Update system
print_message $BLUE "Updating system packages..."
sudo apt-get update > /dev/null 2>&1

# Install Docker if not present
if ! command -v docker > /dev/null 2>&1; then
    print_message $BLUE "Installing Docker..."
    sudo apt-get install -y docker.io > /dev/null 2>&1
    sudo systemctl start docker > /dev/null 2>&1
    sudo systemctl enable docker > /dev/null 2>&1
    sudo groupadd docker > /dev/null 2>&1
    sudo usermod -aG docker $USER > /dev/null 2>&1
else
    print_message $GREEN "Docker is already installed. Skipping..."
fi

# Install kubectl if not present
if ! command -v kubectl > /dev/null 2>&1; then
    print_message $BLUE "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
else
    print_message $GREEN "kubectl is already installed. Skipping..."
fi

