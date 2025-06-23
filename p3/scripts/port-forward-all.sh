#!/bin/bash

source "$(dirname "$0")/lib.sh"
set -e

# Expose ArgoCD UI
print_message $BLUE "🔄 Starting port-forwarding for ArgoCD UI (https://localhost:8080)..."
kubectl port-forward svc/argocd-server -n argocd 8080:443 > /dev/null 2>&1 &
PID_ARGOCD=$!

# Expose the Playground App
print_message $BLUE "🔄 Starting port-forwarding for the Playground App (http://localhost:8888)..."
kubectl port-forward svc/wil-playground -n dev 8888:80 > /dev/null 2>&1 &
PID_APP=$!

# Show access info
print_message $GREEN "✅ Argo CD is accessible at: \c"
print_message $CYAN "https://localhost:8080"

print_message $GREEN "✅ Playground App is accessible at: \c"
print_message $CYAN "http://localhost:8888"

print_message $YELLOW "Press [ENTER] to stop port-forwarding..."
read

# Stop background processes
kill $PID_ARGOCD $PID_APP
echo -e "${RED}🛑 Port-forwarding stopped.${NC}"
