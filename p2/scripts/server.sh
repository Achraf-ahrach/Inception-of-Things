#!/bin/bash

BLUE='\033[0;34m'
RESET='\033[0m'

# Function
print() {
  echo -e "${BLUE}========================================${RESET}"
  echo -e "${BLUE}$1${RESET}"
  echo -e "${BLUE}========================================${RESET}"
}

print "Installing K3s"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip="192.168.56.110" --write-kubeconfig-mode 644" sh -

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Wait for a few seconds to ensure k3s is running
sleep 20

# Deploy Nginx Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.0/deploy/static/provider/cloud/deploy.yaml

# Step 1 — Wait for controller to be ready
kubectl wait --namespace ingress-nginx --for=condition=Available deployment/ingress-nginx-controller --timeout=180s

print "Waiting for the admission webhook job to finish..."
kubectl wait --for=condition=complete -n ingress-nginx job/ingress-nginx-admission-create --timeout=180s

print "Waiting for admission webhook endpoint to become available..."
timeout 180 bash -c '
  until kubectl get endpoints ingress-nginx-controller-admission -n ingress-nginx | grep -q ":8443"; do
    echo "... still waiting ..."
    sleep 5
  done
'

print "Applying deployment apps"
kubectl apply -f /vagrant/apps/


print "Script Complete"
echo -e "${GREEN}All manifests have been successfully applied${RESET}"
echo -e "${GREEN} You can Access The website by visiting ${YELLOW}http://192.168.56.110${RESET}"
echo -e "${GREEN} The Port IS BELOW "
var=$(sudo kubectl get svc -n kube-system --kubeconfig /etc/rancher/k3s/k3s.yaml)
echo -e "${GREEN} $var ${RESET}"