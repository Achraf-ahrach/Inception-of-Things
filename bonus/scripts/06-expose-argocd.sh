#!/bin/bash

source "$(dirname "$0")/lib.sh"
set -e

# Expose ArgoCD UI
nohup kubectl -n argocd port-forward svc/argocd-server 8080:443 > /dev/null 2>&1 &
PID_ARGOCD=$!

# Show access info
print_message $GREEN "🌐 Argo CD is accessible at: \c"
print_message $CYAN "https://localhost:8080"

print_message $YELLOW "Press [ENTER] to stop port-forwarding for ArgoCD..."
read

# Stop background processes
kill $PID_ARGOCD 2>/dev/null
echo -e "${RED}🛑 Port-forwarding for ArgoCD stopped.${NC}"