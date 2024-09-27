# Radicale Calendar Application on K3s

## Overview
This project sets up an auto-scaled calendar application using Radicale, Docker, and Kubernetes (K3s). The app is configured to work with persistent volumes and external configuration. It includes the following features:
- Three versions of Radicale: latest, stable, and test
- Docker images are built and pushed to Docker Hub
- Kubernetes deployment with resource management, secrets, persistent volumes, and ingress for external access.

## Project Structure
- `Dockerfile-latest`, `Dockerfile-stable`, `Dockerfile-test`: Dockerfiles for different versions of Radicale
- `build-and-push.sh`: Script to build and push Docker images to Docker Hub
- `pvc.yaml`: Persistent Volume Claims for Radicale's storage and config
- `deployment.yaml`: Kubernetes deployment, service, and ingress configuration
- `INSTALLATION.md`: Detailed installation instructions for setting

## Project structure
[k3s_radical](k3s_radical)/
├── [text](config)
    ├── [text](config/htpasswd)
    └── [text](config/radicale_config)
├── [k3s](k3s)/
    ├── [deployment.yaml](k3s/deployment.yaml)
    └── [pvc.yaml](k3s/pvc.yaml)
├── [build-and-push.sh](build-and-push.sh)
├── [Dockerfile](Dockerfile)
├── [dockerhub_token_encoded](dockerhub_token_encoded)
├── [INSTALLATION.md](INSTALLATION.md)
├── [CONTRIBUTING.md](README.md)
├── [TASK.md](TASK.md)