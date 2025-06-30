#!/bin/bash

source "$(dirname "$0")/lib.sh"

# Addin gitlab helm repository
print_message $BLUE "🔄 Adding GitLab Helm repository..."
helm repo add gitlab https://charts.gitlab.io > /dev/null 2>&1
helm repo update > /dev/null 2>&1
print_message $GREEN "✅ GitLab Helm repository added successfully!"

print_message $BLUE "🔄 Creating Gitlab namespace..."
kubectl create namespace gitlab > /dev/null 2>&1

# Install GitLab using Helm
print_message $BLUE "🚀 Installing GitLab..."
helm upgrade --install gitlab gitlab/gitlab \
    --namespace gitlab \
    --set global.hosts.domain=aahrach.com \
    --set global.hosts.externalIP=localhost \
    --set global.hosts.https=false \
    --set certmanager-issuer.email=me@example.com \
    --set gitlab.gitlab-runner.enabled=false > /dev/null 2>&1

print_message $BLUE "Waiting for GitLab to be ready..."
kubectl wait --for=condition=Ready pod -l app=webservice -n gitlab --timeout=500s > /dev/null 2>&1
print_message $GREEN "GitLab installed successfully!"

# Expose GitLab externally
kubectl patch service gitlab-webservice-default -n gitlab -p '{"spec": {"type": "NodePort"}}' > /dev/null 2>&1

if [ $? -eq 0 ]; then
  print_message $BLUE "🔄 Starting port-forwarding for GitLab..."

  nohup kubectl port-forward svc/gitlab-webservice-default 8181:8181 -n gitlab > /dev/null 2>&1 &

  print_message $GREEN "✅ Port-forwarding for GitLab started on: \c"
  print_message $CYAN "http://localhost:8181/admin/users/root/impersonation_tokens"

  # Show GitLab root password
  print_message $BLUE "🔐 Retrieving GitLab root password..."
  ROOT_PASSWORD=$(kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode 2>/dev/null)

  if [ -n "$ROOT_PASSWORD" ]; then
    print_message $GREEN "🎉 GitLab Admin Credentials:"
    print_message $CYAN "   • Username: root"
    print_message $CYAN "   • Password: $ROOT_PASSWORD"
  else
    print_message $RED "❌ Could not retrieve the GitLab root password."
  fi

else
  print_message $RED "❌ Timed out waiting for service gitlab-webservice-default to be ready."
  print_message $YELLOW "Please check the GitLab installation logs for more details."
  exit 1
fi