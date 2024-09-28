# Installation Guide

## Prerequisites
Before you begin, ensure you have the following installed:
- [Docker](https://docs.docker.com/get-docker/)
- [K3s](https://k3s.io/) - Lightweight Kubernetes or [K8S](https://kubernetes.io/) - Full Kubernetes
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - Kubernetes CLI

## Step-by-Step Installation
1. Build and Push Docker Images
    - chmod +x 01_Docker-build_and_push.sh
    - ./01_Docker-build_and_push.sh

2. Set Up K3s/K8s:
    #### K3s
    - curl -sfL https://get.k3s.io | sh -
    - export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
    - [RTFM] follow: https://docs.k3s.io/installation/
    #### K8s
    - [Linux]   follow: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
    - [macOS]   follow: https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/
    - [Windows] follow: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/

3. Apply K8s/K3s for Deploy Radicale
    - chmod +x 02_K8S-apply configuration.sh
    - ./02_K8S-apply configuration.sh

4. Access Radicale by versions at:
    - Latest: http://localhost
    - Stable: http://localhost:90
    - Test: http://localhost:100



