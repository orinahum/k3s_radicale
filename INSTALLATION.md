# Installation Guide

## Prerequisites
Before you begin, ensure you have the following installed:
- [Docker](https://docs.docker.com/get-docker/)
- [K3s](https://k3s.io/) - Lightweight Kubernetes
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - Kubernetes CLI

## Step-by-Step Installation
1. Build and Push Docker Images
    - chmod +x build-and-push.sh
    - ./build-and-push.sh

2. Set Up K3s:
    - curl -sfL https://get.k3s.io | sh -
    - export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

3. Create Persistent Volumes
    - kubectl apply -f pvc.yaml

4. Create Kubernetes Secret
    - kubectl create secret generic radicale-secret --from-literal=user=admin --from-literal=password=admin

5. Deploy Radicale
    - kubectl apply -f deployment.yaml

6. Access the Application
    - kubectl port-forward svc/radicale-service 8080:80

7. Access Radicale at:
    - http://radicale.local


