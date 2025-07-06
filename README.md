# Inception of Things (IoT) 🚀

A comprehensive DevOps project implementing Kubernetes clusters, CI/CD pipelines, and GitOps practices using K3s, ArgoCD, and GitLab.

## 📋 Table of Contents

* [Overview](https://claude.ai/chat/683c1d83-7414-4b96-9bf0-312dc002513d#overview)
* [Project Structure](https://claude.ai/chat/683c1d83-7414-4b96-9bf0-312dc002513d#project-structure)
* [Prerequisites](https://claude.ai/chat/683c1d83-7414-4b96-9bf0-312dc002513d#prerequisites)
* [Part 1: K3s Cluster Setup](https://claude.ai/chat/683c1d83-7414-4b96-9bf0-312dc002513d#part-1-k3s-cluster-setup)
* [Part 2: K3s with Ingress Controller](https://claude.ai/chat/683c1d83-7414-4b96-9bf0-312dc002513d#part-2-k3s-with-ingress-controller)
* [Part 3: K3d + ArgoCD](https://claude.ai/chat/683c1d83-7414-4b96-9bf0-312dc002513d#part-3-k3d--argocd)
* [Bonus: GitLab + ArgoCD Integration](https://claude.ai/chat/683c1d83-7414-4b96-9bf0-312dc002513d#bonus-gitlab--argocd-integration)
* [Usage](https://claude.ai/chat/683c1d83-7414-4b96-9bf0-312dc002513d#usage)
* [Troubleshooting](https://claude.ai/chat/683c1d83-7414-4b96-9bf0-312dc002513d#troubleshooting)
* [Contributing](https://claude.ai/chat/683c1d83-7414-4b96-9bf0-312dc002513d#contributing)

## 🎯 Overview

This project demonstrates modern DevOps practices by implementing:

* **K3s Kubernetes clusters** with master-worker node architecture
* **Ingress routing** for multiple applications
* **GitOps workflows** using ArgoCD
* **CI/CD pipelines** with GitLab integration
* **Infrastructure as Code** using Vagrant and shell scripts

## 📁 Project Structure

```
Inception-of-Things/
├── p1/                     # Part 1: Basic K3s cluster
│   ├── scripts/
│   │   ├── server.sh       # K3s server setup
│   │   └── agent.sh        # K3s agent setup
│   └── Vagrantfile         # VM configuration
├── p2/                     # Part 2: K3s with Ingress
│   ├── apps/               # Application manifests
│   │   ├── app-one.yaml
│   │   ├── app-two.yaml
│   │   ├── app-three.yaml
│   │   └── ingress.yaml
│   ├── scripts/
│   │   └── server.sh       # Setup with Ingress controller
│   └── Vagrantfile
├── p3/                     # Part 3: K3d + ArgoCD
│   ├── confs/
│   │   └── argocd-application.yaml
│   └── scripts/            # Automated setup scripts
├── bonus/                  # Bonus: GitLab + ArgoCD
│   ├── confs/
│   │   └── argocd-application.yaml
│   ├── scripts/
│   │   └── app/            # Application manifests
│   └── .env.example        # Environment variables template
└── README.md
```

## 🔧 Prerequisites

* **VirtualBox** (for Parts 1 & 2)
* **Vagrant** (for Parts 1 & 2)
* **Docker** (for Parts 3 & Bonus)
* **kubectl** (Kubernetes CLI)
* **k3d** (will be installed automatically)
* **Helm** (for Bonus part)
* **Git**

### System Requirements

* **RAM** : Minimum 4GB (8GB recommended)
* **CPU** : 2+ cores
* **Disk** : 10GB free space
* **OS** : Linux/macOS (Windows with WSL2)

## 🏗️ Part 1: K3s Cluster Setup

Creates a basic K3s cluster with one server and one agent node.

### Architecture

* **Server Node** (`aahrachS`): `192.168.56.110`
* **Worker Node** (`aahrachSW`): `192.168.56.111`

### Deployment

```bash
cd p1
vagrant up
```

### Verification

```bash
# SSH into server node
vagrant ssh aahrachS

# Check cluster status
kubectl get nodes
kubectl get pods -A
```

## 🌐 Part 2: K3s with Ingress Controller

Extends Part 1 with NGINX Ingress Controller and multiple applications.

### Applications

* **app-one** : Single replica, accessible via `app1.com`
* **app-two** : 3 replicas, accessible via `app2.com`
* **app-three** : Single replica, default route and `app3.com`

### Deployment

```bash
cd p2
vagrant up
```

### Access Applications

Add to your `/etc/hosts`:

```
192.168.56.110 app1.com app2.com app3.com
```

Access via:

* http://app1.com
* http://app2.com
* http://app3.com
* http://192.168.56.110 (default - app-three)

## 🔄 Part 3: K3d + ArgoCD

Implements GitOps using K3d and ArgoCD for continuous deployment.

### Features

* **K3d cluster** with load balancer
* **ArgoCD** for GitOps
* **Automated deployment** from GitHub repository
* **Self-healing** applications

### Deployment

```bash
cd p3/scripts
./00-setup-all.sh
```

### Access Services

* **Application** : http://localhost:8888
* **ArgoCD UI** : Run `./04-expose-argocd.sh` then visit https://localhost:8080

### ArgoCD Credentials

The setup script will display the admin credentials automatically.

## 🎁 Bonus: GitLab + ArgoCD Integration

Complete CI/CD pipeline with local GitLab instance and ArgoCD.

### Features

* **Local GitLab** instance
* **Automated repository** creation and code push
* **ArgoCD integration** with GitLab
* **Full GitOps workflow**

### Setup

1. **Create environment file** :

```bash
cd bonus
cp .env.example .env
# Edit .env with your GitLab access token and project name
```

2. **Run setup** :

```bash
./scripts/00-setup-all.sh
```

3. **Access services** :

* **GitLab** : http://localhost:8181
* **Application** : http://localhost:8888
* **ArgoCD** : Run `./06-expose-argocd.sh`

### Environment Variables

```bash
# .env file
GITLAB_ACCESS_TOKEN=your_gitlab_token_here
PROJECT_NAME=playground-app
```

## 🚀 Usage

### Quick Start

1. **Choose your part** :

```bash
   # For basic K3s cluster
   cd p1 && vagrant up

   # For K3s with Ingress
   cd p2 && vagrant up

   # For K3d + ArgoCD
   cd p3/scripts && ./00-setup-all.sh

   # For GitLab + ArgoCD
   cd bonus && ./scripts/00-setup-all.sh
```

1. **Monitor deployments** :

```bash
   # Check pods
   kubectl get pods -A

   # Check services
   kubectl get svc -A

   # Check ingress
   kubectl get ingress -A
```

### Cleanup

```bash
# For Vagrant parts (p1, p2)
vagrant destroy -f

# For K3d parts (p3, bonus)
./cleanup.sh

# For complete cleanup (bonus)
./destroy-all.sh
```

## 🔧 Troubleshooting

### Common Issues

1. **Port conflicts** :

```bash
   # Check if ports are in use
   lsof -i :8888
   lsof -i :8080
   lsof -i :8181
```

1. **Docker permissions** :

```bash
   sudo usermod -aG docker $USER
   # Logout and login again
```

1. **K3d cluster issues** :

```bash
   k3d cluster delete mycluster
   k3d cluster create mycluster --port "8888:9090@loadbalancer"
```

1. **ArgoCD not accessible** :

```bash
   kubectl -n argocd get pods
   kubectl -n argocd port-forward svc/argocd-server 8080:443
```

### Logs

```bash
# Vagrant logs
vagrant ssh aahrachS -c "sudo journalctl -u k3s -f"

# K3d logs
k3d cluster list
kubectl logs -n argocd deployment/argocd-server

# GitLab logs
kubectl logs -n gitlab -l app=webservice
```

## 🎯 Learning Outcomes

This project demonstrates:

* **Infrastructure as Code** with Vagrant
* **Container orchestration** with Kubernetes
* **Service mesh** and ingress management
* **GitOps practices** with ArgoCD
* **CI/CD pipelines** with GitLab
* **Automated deployment** strategies
* **Monitoring and troubleshooting** techniques

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 License

This project is for educational purposes. Feel free to use and modify as needed.

## 📚 Additional Resources

* [K3s Documentation](https://docs.k3s.io/)
* [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
* [Vagrant Documentation](https://www.vagrantup.com/docs)
* [Kubernetes Documentation](https://kubernetes.io/docs/)
* [GitLab Documentation](https://docs.gitlab.com/)

## 🏷️ Tags

`kubernetes` `k3s` `k3d` `argocd` `gitlab` `gitops` `devops` `ci-cd` `vagrant` `docker` `ingress` `helm`
