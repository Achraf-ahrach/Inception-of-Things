#!/bin/bash

source "$(dirname "$0")/lib.sh"

# Create a namespace for ArgoCD
print_message $BLUE "Creating ArgoCD namespace..."
kubectl create namespace argocd 2>/dev/null

# Install Argo CD components
print_message $BLUE "Installing ArgoCD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for the server to be ready
print_message $BLUE "Waiting for ArgoCD server to be ready..."
kubectl -n argocd rollout status deployment/argocd-server

# Apply your app configuration
print_message $BLUE "Applying ArgoCD Playground app configuration..."
kubectl apply -f ../config/argocd-application.yaml
print_message $GREEN "Application configuration applied successfully."

# Function to get ArgoCD admin password
get_argocd_password() {
    local namespace="argocd"
    local secret_name="argocd-initial-admin-secret"

    local password=$(kubectl get secret -n "$namespace" "$secret_name" -o jsonpath="{.data.password}" | base64 --decode 2>/dev/null)

    if [ -z "$password" ]; then
        print_message $RED "❌ Error: Secret $secret_name or key 'password' not found."
    else
        print_message $GREEN "✅ ArgoCD Admin Credentials:\nUsername: admin\nPassword: $password"
    fi
}

# Get the password
print_message $BLUE "Retrieving ArgoCD Admin Credentials..."
get_argocd_password
