#!/bin/bash

# Build Docker images
echo "Building backend Docker image..."
cd backend
docker build -t todolist-backend:latest .

echo "Building frontend Docker image..."
cd ../frontend
docker build -t todolist-frontend:latest .

cd ..

# Deploy to Kubernetes
echo "Deploying to Kubernetes..."
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/mongodb.yaml
kubectl apply -f k8s/backend.yaml
kubectl apply -f k8s/frontend.yaml
kubectl apply -f k8s/ingress.yaml

echo "Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/backend -n todolist
kubectl wait --for=condition=available --timeout=300s deployment/frontend -n todolist
kubectl wait --for=condition=available --timeout=300s deployment/mongodb -n todolist

echo "Deployment completed!"
echo "Frontend: http://todolist.local"
echo "Backend API: http://todolist.local/api"
echo ""
echo "To check status: kubectl get all -n todolist"