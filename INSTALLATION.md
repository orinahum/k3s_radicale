![My Image](./assets/installation.png)
# Installation Guide

## Prerequisites
Before you begin, ensure you have the following installed:
- [Docker](https://docs.docker.com/get-docker/) - Container platform.
- [K3s](https://k3s.io/) - Lightweight Kubernetes or [K8S](https://kubernetes.io/) - Full Kubernetes.
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - Kubernetes CLI.

# Step-by-Step Installation
## 1. Setup K3s/K8s:
### K3s
   - curl -L get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -
   - export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
   - [RTFM] follow: https://docs.k3s.io/installation/
### K8s
   - [Linux]   follow: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
   - [macOS]   follow: https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/
   - [Windows] follow: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/

## 2. Run setup instalation script:
[`Setup Documentation`](SETUP.md)
```bash
chmod +x setup.sh

./setup.sh
```
### Default versions:
 The script uses Bash strict mode (`Latest: 3.2.3`, `Stable: 3.2.2`, `Test: master`)
### To specify custom versions, use the following command:
```bash
./setup.sh "latest version" "stable version" "test version"
```
`If a field is left empty, the corresponding default version will be used.`

## 3. Access Radicale by versions at:
##### The application uses posts 80(latest), 90(stable), and 100(test) - these ports must be available
- Latest: http://localhost
- Stable: http://localhost:90
- Test: http://localhost:100
