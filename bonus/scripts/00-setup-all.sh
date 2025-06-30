#!/bin/bash

source "$(dirname "$0")/lib.sh"

# Check for .env file
if [ ! -f .env ]; then
    print_message $RED "❌ Error: .env file not found!"
    print_message $YELLOW "Please create a .env file with your GITLAB_ACCESS_TOKEN and PROJECT_NAME"
    exit 1
fi

print_section "🚀 K3D + Gitlab + ArgoCD Complete Setup"
print_message $BLUE "This script will:"
print_message $CYAN "  1. Install Docker and kubectl"
print_message $CYAN "  2. Create K3d cluster"
print_message $CYAN "  3. Setup Gitlab"
print_message $CYAN "  4. Push playground application to Gitlab"
print_message $CYAN "  5. Setup ArgoCD"

read -p "Press Enter to continue or Ctrl+C to cancel..."

# Step 1: Install dependencies
print_section "Step 1: Installing Dependencies"
./01-install-dependencies.sh

# Step 2: Create K3d cluster
print_section "Step 2: Creating K3d Cluster"
./02-create-k3d-cluster.sh

# Step 3: Setup Gitlab
print_section "Step 3: Setting up Gitlab"
./03-setup-gitlab.sh

# Prompt user to insert GitLab token
print_message $YELLOW "🛑 Please make sure your GITLAB_ACCESS_TOKEN is set in the .env file."
read -p "Press Enter to continue after verifying the .env file..."

# Step 4: Push playground app to Gitlab
print_section "Step 4: Pushing Playground App to Gitlab"
./04-push-playground-app.sh

# Step 3: Setup ArgoCD
print_section "Step 5: Setting up ArgoCD"
./05-setup-argocd.sh

print_section "✅ Setup Complete!"

print_message $GREEN "🎮 Playground App is accessible at: \c"
print_message $CYAN "http://localhost:8888"

print_message $GREEN "Services are ready! Use the following commands:"
print_message $CYAN "  • ./06-expose-argocd.sh - Access to ArgoCD UI"
print_message $CYAN "  • ./cleanup.sh - Clean everything"