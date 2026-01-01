# TP 33: Deployment of a Spring Boot App on Kubernetes

## 📋 Project Overview

This project demonstrates deploying a Spring Boot application on Kubernetes using Minikube.

## 🏗️ Project Structure

```
demo-k8s/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/example/demok8s/
│       │       ├── DemoK8sApplication.java
│       │       └── HelloController.java
│       └── resources/
│           └── application.properties
├── k8s/
│   ├── k8s-configmap.yaml
│   ├── k8s-deployment.yaml
│   └── k8s-service.yaml
├── Dockerfile
├── deploy.sh
├── pom.xml
└── README.md
```

## 🔧 Prerequisites

- Java 17 (JDK)
- Maven 3.9+
- Docker
- Minikube
- kubectl

## 🚀 Quick Start

### Option 1: Automated Deployment (Linux/macOS)

```bash
# Make the script executable
chmod +x deploy.sh

# Run the deployment script
./deploy.sh
```

### Option 2: Manual Deployment

```bash
# 1. Build the JAR
./mvnw clean package -DskipTests

# 2. Configure Docker to use Minikube's daemon
eval $(minikube docker-env)

# 3. Build Docker image
docker build -t demo-k8s:1.0.0 .

# 4. Create namespace
kubectl create namespace lab-k8s

# 5. Apply Kubernetes manifests
kubectl apply -f k8s/k8s-configmap.yaml
kubectl apply -f k8s/k8s-deployment.yaml
kubectl apply -f k8s/k8s-service.yaml
```

## 🌐 Accessing the Application

```bash
# Get the Minikube service URL
minikube service demo-k8s-service -n lab-k8s --url

# Or access via NodePort directly
curl $(minikube ip):30080/api/hello
```

## 📡 API Endpoints

| Method | Endpoint     | Description                    |
|--------|--------------|--------------------------------|
| GET    | /api/hello   | Returns JSON with message      |

### Example Response

```json
{
  "message": "Hello from ConfigMap in Kubernetes",
  "status": "success"
}
```

## 🔍 Useful Commands

```bash
# Check pod status
kubectl get pods -n lab-k8s

# Check service status
kubectl get svc -n lab-k8s

# View pod logs
kubectl logs -l app=demo-k8s -n lab-k8s

# Describe deployment
kubectl describe deployment demo-k8s-deployment -n lab-k8s

# Scale deployment
kubectl scale deployment demo-k8s-deployment --replicas=3 -n lab-k8s

# Delete all resources
kubectl delete namespace lab-k8s
```

## 📦 Configuration

### ConfigMap Values

| Key           | Value                                  |
|---------------|----------------------------------------|
| app.message   | Hello from ConfigMap in Kubernetes     |

### Deployment Specs

| Spec            | Value          |
|-----------------|----------------|
| Replicas        | 2              |
| Image           | demo-k8s:1.0.0 |
| Container Port  | 8080           |
| NodePort        | 30080          |

## 🔒 Health Checks

- **Readiness Probe**: `/api/hello` (HTTP GET on port 8080)
- **Liveness Probe**: `/api/hello` (HTTP GET on port 8080)

## 📝 License

This project is for educational purposes - TP 33 Lab Exercise.
