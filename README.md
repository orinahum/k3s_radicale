![My Image](./assets/k8s_docker.png)
# Radicale Calendar Application on K3s

## Overview
This project sets up an auto-scaled calendar application using Radicale, Docker, and Kubernetes (K3s/K8s). The app is configured to work with persistent volumes.
It includes the following features:
- Three versions of Radicale: latest, stable, and test
- Docker image are built and pushed to Docker Hub dynamicly base on the three version 
- Kubernetes deployment with resource management, persistent volumes, services, and ingress for external access.

## Project Structure
- `Dockerfile`: Dynamic Dockerfile for different versions of Radicale
- `01_Docker-build_and_push.sh`: Script to build and push Docker images to Docker Hub
- `02_K8S-apply_configuration.sh`: Script to apply Kubernetes configuration
- `03_K8S-delete_configuration.sh`: Script to apply Kubernetes configuration
- `deployment.yaml`: Kubernetes deployment configuration for Radicale's version
- `ingress.yaml`: Kubernetes ingress configuration for Radicale's version
- `pvc.yaml`: Kubernetes Persistent Volume Claims for Radicale's version
- `service.yaml`: Kubernetes service configuration for Radicale's version
- `INSTALLATION.md`: Detailed installation instructions for setting
```
k8s_Radical
├── config
│   ├── htpasswd
│   └── radicale_config
├── k8s
│   ├── deployment.yaml
│   ├── ingress.yaml
│   ├── pvc.yaml
│   └── service.yaml
├── 01_Docker-build_and_push.sh
├── 02_K8S-apply_configuration.sh
├── 03_K8S-delete_configuration.sh
├── CONTRIBUTING.md
├── Dockerfile
├── dockerhub_token_encoded
├── INSTALLATION.md
├── README.md
└── TASK.md
```
