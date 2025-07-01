#!/bin/bash

echo "⚠️  WARNING: This will delete your K3D cluster, Docker containers, images, volumes, and kube config."
read -p "Are you sure? (y/n): " confirm

if [[ "$confirm" != "y" ]]; then
  echo "❌ Cancelled."
  exit 1
fi

echo "🧨 Deleting K3D clusters..."
k3d cluster delete --all

echo "🗑 Removing all Docker containers..."
docker rm -f $(docker ps -aq) 2>/dev/null

echo "🗑 Removing all Docker images..."
docker rmi -f $(docker images -aq) 2>/dev/null

echo "🗑 Removing all Docker volumes..."
docker volume rm $(docker volume ls -q) 2>/dev/null

echo "🧹 Removing all Docker networks (except default)..."
docker network prune -f

echo "🧼 Cleaning up dangling Docker build cache..."
docker builder prune -af

echo "🧾 Removing Kubernetes config..."
rm -rf ~/.kube/config

echo "✅ All cleaned up!"
