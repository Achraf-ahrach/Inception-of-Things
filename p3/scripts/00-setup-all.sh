#!/bin/bash

source "$(dirname "$0")/lib.sh"

print_section "🚀 K3D + ArgoCD Complete Setup"

print_message $BLUE "This script will:"
print_message $CYAN "  1. Install Docker and kubectl"
print_message $CYAN "  2. Create K3d cluster"
print_message $CYAN "  3. Setup ArgoCD"
print_message $CYAN "  4. Deploy playground application"

read -p "Press Enter to continue or Ctrl+C to cancel..."

# Step 1: Install dependencies
print_section "Step 1: Installing Dependencies"
./01-install-dependencies.sh

# Step 2: Create K3d cluster
print_section "Step 2: Creating K3d Cluster"
./02-create-k3d-cluster.sh

# Step 3: Setup ArgoCD
print_section "Step 3: Setting up ArgoCD"
./03-setup-argocd.sh

print_section "✅ Setup Complete!"

print_message $GREEN "🎮 Playground App is accessible at: \c"
print_message $CYAN "http://localhost:8888"

print_message $GREEN "Services are ready! Use the following commands:"
print_message $CYAN "  • ./04-expose-argocd.sh - Access to ArgoCD UI"
print_message $CYAN "  • ./cleanup.sh - Clean everything"