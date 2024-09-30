![My Image](./assets/k8s_docker.png)
# Radicale Calendar Application on K3s

## Overview
This project sets up an auto-scaled calendar application using Radicale, Docker, and Kubernetes (K3s/K8s). The app is configured to work with persistent volumes.
It includes the following features:
- Three versions of Radicale: latest, stable, and test
- Docker image are built and pushed to Docker Hub dynamicly base on the three version 
- Kubernetes deployment with resource management, persistent volumes, services, and ingress for external access.

## Project Structure
- [`Dockerfile`](Dockerfile): A Dynamic Dockerfile supporting multiple Radicale versions.
- [`setup.sh`](setup.sh): An interactive Bash script for installation.
- [`deployment_tmp.yaml`](deployment_tmp.yaml): Template for Kubernetes deployment configuration specific to Radicale versions.
- [`k8s/ingress.yaml`](k8s/ingress.yaml): Kubernetes ingress configuration for Radicale versions.
- [`k8s/pv.yaml`](k8s/pv.yaml): Kubernetes Persistent Volume configuration for Radicale versions.
- [`k8s/pvc.yaml`](k8s/pvc.yaml): Kubernetes Persistent Volume Claims configuration for Radicale versions.
- [`service_tmp.yaml`](service_tmp.yaml): Template for Kubernetes service configuration tailored to Radicale versions.
- [`INSTALLATION.md`](INSTALLATION.md): Comprehensive installation guide and setup instructions.
- [`TASK.md`](TASK.md): Detailed description of the assignment and required tasks.
- [`CONTRIBUTERS.md`](CONTRIBUTERS.md): List of contributors and project collaborators.
```
k8s_Radical
├── assets
│   ├── contribute.png
│   ├── installation.png
│   └── k8s_docker.png
├── config
│   ├── htpasswd
│   └── radicale.config
├── k8s
│   ├── ingress.yaml
|   ├── pv.yaml
│   └── pvc.yaml
├── .gitignore
├── CONTRIBUTERS.md
├── deployment_tmp.yaml
├── INSTALLATION.md
├── Dockerfile
├── README.md
├── service_tmp.yaml
├── setup.sh
└── TASK.md
```
