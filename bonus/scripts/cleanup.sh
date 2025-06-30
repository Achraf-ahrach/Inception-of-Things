#!/bin/bash
source "$(dirname "$0")/lib.sh"

print_message $YELLOW "🧹 Starting cleanup process..."

# Stop any running port-forwards
print_message $BLUE "Stopping any running port-forwards..."
pkill -f "kubectl.*port-forward" 2>/dev/null || true

# Delete ArgoCD application
print_message $BLUE "Removing ArgoCD application..."
kubectl delete application playground-app -n argocd 2>/dev/null || true

# Delete ArgoCD namespace (this will remove all ArgoCD components)
print_message $BLUE "Removing ArgoCD namespace..."
kubectl delete namespace argocd 2>/dev/null || true

# Delete dev namespace
print_message $BLUE "Removing dev namespace..."
kubectl delete namespace dev 2>/dev/null || true

# Delete k3d cluster
print_message $BLUE "Removing k3d cluster..."
k3d cluster delete mycluster 2>/dev/null || true

print_message $GREEN "✅ Cleanup completed!"
print_message $CYAN "You can now run ./00-setup-all.sh to start fresh."