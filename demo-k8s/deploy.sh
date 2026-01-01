#!/bin/bash

# ============================================================
# deploy.sh - Deployment Script for demo-k8s on Kubernetes
# TP 33: Deployment of a Spring Boot app on Kubernetes
# ============================================================

set -e  # Exit on any error

echo "=============================================="
echo "  TP 33: Spring Boot Kubernetes Deployment"
echo "=============================================="
echo ""

# Step 1: Clean and build the Maven JAR
echo "[Step 1/6] Cleaning and building Maven JAR..."
./mvnw clean package -DskipTests
echo "✓ Maven build completed successfully"
echo ""

# Step 2: Set Minikube Docker environment
echo "[Step 2/6] Setting Minikube Docker environment..."
eval $(minikube docker-env)
echo "✓ Minikube Docker environment configured"
echo ""

# Step 3: Build Docker image
echo "[Step 3/6] Building Docker image: demo-k8s:1.0.0..."
docker build -t demo-k8s:1.0.0 .
echo "✓ Docker image built successfully"
echo ""

# Step 4: Create Kubernetes namespace
echo "[Step 4/6] Creating namespace 'lab-k8s'..."
kubectl create namespace lab-k8s --dry-run=client -o yaml | kubectl apply -f -
echo "✓ Namespace 'lab-k8s' ready"
echo ""

# Step 5: Apply Kubernetes manifests
echo "[Step 5/6] Applying Kubernetes manifests..."
kubectl apply -f k8s/k8s-configmap.yaml
kubectl apply -f k8s/k8s-deployment.yaml
kubectl apply -f k8s/k8s-service.yaml
echo "✓ All manifests applied successfully"
echo ""

# Step 6: Display status and URL
echo "[Step 6/6] Deployment Status..."
echo ""
echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=demo-k8s -n lab-k8s --timeout=120s || true

echo ""
echo "=============================================="
echo "  Deployment Complete!"
echo "=============================================="
echo ""
echo "Pod Status:"
kubectl get pods -n lab-k8s
echo ""
echo "Service Status:"
kubectl get svc -n lab-k8s
echo ""
echo "=============================================="
echo "  To access the application, run:"
echo "=============================================="
echo ""
echo "  minikube service demo-k8s-service -n lab-k8s --url"
echo ""
echo "  Or access directly via NodePort:"
echo "  curl \$(minikube ip):30080/api/hello"
echo ""
echo "=============================================="
