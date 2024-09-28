# Radicale Calendar Application on K3s

## Overview
This project sets up an auto-scaled calendar application using Radicale, Docker, and Kubernetes (K3s/K8s). The app is configured to work with persistent volumes and external configuration. It includes the following features:
- Three versions of Radicale: latest, stable, and test
- Docker images are built and pushed to Docker Hub
- Kubernetes deployment with resource management, persistent volumes, and ingress for external access.

## Project Structure
- `Dockerfile`: Dynamic Dockerfile for different versions of Radicale
- `01_Docker-build_and_push.sh`: Script to build and push Docker images to Docker Hub
- `pvc.yaml`: Persistent Volume Claims for Radicale's storage and config
- `deployment.yaml`: Kubernetes deployment, service, and ingress configuration
- `INSTALLATION.md`: Detailed installation instructions for setting

### Project structure
```
k3s_radical
├── config
│   ├── htpasswd
│   └── radicale_config
├── k8s
│   ├── deployment.yaml
│   ├── ingress.yaml
│   ├── pvc.yaml
│   └── service.yaml
├── 01_Docker-build_and_push.sh
├── 02_K8S-run_pvc_and_deployment.sh
├── CONTRIBUTING.md
├── Dockerfile
├── dockerhub_token_encoded
├── INSTALLATION.md
├── README.md
└── TASK.md
```
