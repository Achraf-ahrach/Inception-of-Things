#!/bin/bash

source "$(dirname "$0")/lib.sh"
source .env

# Create ArgoCD namespace
print_message $BLUE "Creating ArgoCD namespace..."
kubectl create namespace argocd 2>/dev/null || true

# Install ArgoCD
print_message $BLUE "Installing ArgoCD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml > /dev/null 2>&1

print_message $BLUE "Waiting for ArgoCD server to be ready..."
kubectl -n argocd rollout status deployment/argocd-server

# Port forward ArgoCD
print_message $BLUE "Exposing ArgoCD on localhost:8080..."
nohup kubectl -n argocd port-forward svc/argocd-server 8080:443 > /dev/null 2>&1 &

# Wait for port to be open
sleep 10

# Get ArgoCD admin password
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)
print_message $GREEN "✅ ArgoCD Admin Credentials:\nUsername: admin\nPassword: $ARGOCD_PASSWORD"

# Login to ArgoCD
print_message $BLUE "Logging into ArgoCD CLI..."
argocd login localhost:8080 \
  --username admin \
  --password "$ARGOCD_PASSWORD" \
  --insecure

# Add GitLab repo to ArgoCD
print_message $BLUE "Registering GitLab repository in ArgoCD..."
argocd repo add http://gitlab-webservice-default.gitlab.svc.cluster.local:8181/root/$PROJECT_NAME.git \
  --username oauth2 \
  --password $GITLAB_ACCESS_TOKEN \
  --insecure

# Apply the ArgoCD application
print_message $BLUE "Applying ArgoCD Playground app configuration..."
kubectl apply -f ../confs/argocd-application.yaml

print_message $GREEN "✅ Application successfully configured in ArgoCD"
