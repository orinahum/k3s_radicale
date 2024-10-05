![My Image](./assets/setup.png)
# Setup Documentation

## Overview
This setup script automates the deployment and management of **Radicale** using **Docker** and **Kubernetes**. It simplifies tasks such as building and pushing Docker images, and managing Kubernetes resources with a clean, interactive menu interface.

## Key Features
- **Strict Mode**: The script uses Bash strict mode (`set -o errexit`, `set -o nounset`, `set -o pipefail`, `set -o errtrace`) for improved error handling.
- **Docker Hub Authentication**: The script securely handles authentication using a base64-encoded DockerHub token, which is decoded at runtime.
- **Dynamic Versioning**: It accepts up to three arguments as build versions for Docker images, defaulting to predefined versions if no arguments are provided.
- **Interactive Menu**: The script provides a clean, user-friendly menu for managing Docker builds, Kubernetes deployments, and cleanup operations.

## Script Functions

### 1. `login_to_docker`
This function logs into DockerHub using the credentials and token stored in the script. The token is decoded on the fly, providing secure authentication for Docker actions.
- **Input**: Docker credentials and token (base64 encoded)
- **Output**: DockerHub login success or failure message

### 2. `find_replace_and_apply`
This function is responsible for replacing placeholders in Kubernetes resource files (deployment and service templates). It then applies the Kubernetes resources to deploy the corresponding Docker images.
- **Input**: Docker image version, Kubernetes port
- **Output**: Kubernetes resources applied

### 3. `find_replace_and_delete`
This function deletes the Kubernetes resources (deployments, services, ingress, PVC, and PV) for a specified Docker image version. It follows the same template as `find_replace_and_apply` but deletes instead of applying resources.
- **Input**: Docker image version, Kubernetes port
- **Output**: Kubernetes resources deleted

### 4. `build_and_push`
This function builds Docker images for the specified version using the provided build arguments. It then pushes the images to DockerHub. 
- **Input**: Docker image version, build arguments
- **Output**: Docker image built and pushed to DockerHub

### 5. `handle_version_operations`
This function is a wrapper that iterates over all available versions and performs actions (build, apply, delete) based on user input.
- **Input**: Desired action (push, apply, delete)
- **Output**: Performs actions across versions

## User Interface & Menu

The script provides a clean, professional menu interface that allows users to:
- Build and push specific Docker image versions (Latest, Stable, Test).
- Apply Kubernetes resources for specific Docker image versions.
- Delete all Kubernetes infrastructure related to the Radicale service.
- Exit the script after logging out of DockerHub.

#### Example Menu
```bash
SETUP AUTO-SCALED RADICALE USING DOCKER AND KUBERNETES

Latest: 3.2.3   Stable: 3.2.2   Test: master

Configuring Docker Images:
[1] Build & Push Latest       [2] Build & Push Stable
[3] Build & Push Test         [4] Build & Push all versions

Kubernetes Configuration:
[5] Apply Latest              [6] Apply Stable
[7] Apply Test                [8] Apply all versions

Cleanup:
[9] Delete All Radicale Kubernetes Infrastructure
[0] Exit Script

Please enter your selection...
```

## How to Use

1. **Login to DockerHub**:
   + The script automatically logs into DockerHub using the base64-encoded token and credentials.

2. **Build Docker Images**:
   + Select the appropriate option from the menu to build and push Docker images for the desired version (Latest, Stable, or Test).

3. **Apply Kubernetes Resources**:
   + Use the menu to apply Kubernetes resources for the selected version, deploying the Docker image to your Kubernetes cluster.

4. **Cleanup Kubernetes Infrastructure**:
   + You can clean up all Kubernetes resources related to the Radicale service by selecting the cleanup option.

5. **Exit**:
   + When you're done, simply select the exit option, and the script will log out from DockerHub and terminate.

## Example Command Usage
- **Run the script with default versions**:
```bash
   ./your_script.sh
```
- **Run the script with custom versions**:
```bash
   ./your_script.sh 4.0.1 4.0.0 custom_branch
```
If you want to call only the second version:
```bash
   ./your_script.sh "" 4.0.0 ""
```
This will use the default version for the first and third arguments while applying your custom version for the second argument.

## Conclusion
This script is designed to be a complete solution for building, deploying, and managing the Radicale service on Kubernetes using Docker images. The intuitive menu system and clear options make it easy to use while maintaining flexibility through command-line arguments.
