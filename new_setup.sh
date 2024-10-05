#!/bin/bash

# Define colors for better visuals
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Dynamic versions with defaults
versions=("latest" "stable" "test")
build_versions=("${1:-3.2.3}" "${2:-3.2.2}" "${3:-master}")

# Docker Hub credentials
DOCKER_USERNAME="orinahum1982"
IMAGE_NAME="radicale"
DOCKER_TOKEN_BASE64="ZGNrcl9wYXRfaklkN3FNVGdKSzQ1dExWMHl2XzVjeG1FZjRnCg=="
DOCKER_TOKEN=$(echo $DOCKER_TOKEN_BASE64 | base64 --decode)

# Login Docker Hub
login_to_docker() {
    echo -e "${CYAN}Logging in to Docker Hub...${NC}"
    echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USERNAME" --password-stdin >> /dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}DockerHub login completed successfully!${NC}"
    else
        echo -e "${RED}DockerHub login failed! Please check your credentials.${NC}"
        exit 1
    fi
    sleep 2
}

# Function to display a professional banner
banner() {
    echo -e "${CYAN}"
    echo "############################################"
    echo "#                                          #"
    echo "#   RADICALE - AUTO-SCALED APPLICATION     #"
    echo "#          USING DOCKER & KUBERNETES       #"
    echo "#                                          #"
    echo "############################################"
    echo -e "${NC}"
}

# General function to find/replace and deploy K8s resources
find_replace_and_apply() {
    local version=$1
    local port=$2

    sed "s/V_PH/${version}/g" deployment_tmp.yaml > k8s/deployment.yaml
    sed "s/V_PH/${version}/g" service_tmp.yaml > k8s/service.yaml
    sed -i "s/V_PH/${port}/g" k8s/service.yaml

    echo -e "${CYAN}Applying Kubernetes resources for version ${YELLOW}${version}${NC} on port ${YELLOW}${port}${NC}..."
    kubectl apply -f ./k8s/pv.yaml
    kubectl apply -f ./k8s/pvc.yaml
    kubectl apply -f ./k8s/service.yaml
    kubectl apply -f ./k8s/ingress.yaml
    kubectl apply -f ./k8s/deployment.yaml

    echo -e "${GREEN}Kubernetes deployment completed for version ${YELLOW}${version}${NC}${GREEN}!${NC}"
}

find_replace_and_delete() {
    local version=$1
    local port=$2

    sed "s/V_PH/${version}/g" deployment_tmp.yaml > k8s/deployment.yaml
    sed "s/V_PH/${version}/g" service_tmp.yaml > k8s/service.yaml
    sed -i "s/V_PH/${port}/g" k8s/service.yaml

    echo -e "${CYAN}Deleting Kubernetes resources for version ${YELLOW}${version}${NC}..."
    kubectl delete -f ./k8s/deployment.yaml    
    kubectl delete -f ./k8s/service.yaml
    kubectl delete -f ./k8s/ingress.yaml
    kubectl delete -f ./k8s/pvc.yaml
    kubectl delete -f ./k8s/pv.yaml

    echo -e "${GREEN}Kubernetes cleanup completed for version ${YELLOW}${version}${NC}${GREEN}!${NC}"
}

# General function to build and push Docker image
build_and_push() {
    local version=$1
    local build_arg=$2

    echo -e "${CYAN}Building and pushing Docker image for version ${YELLOW}${version}${NC}..."
    docker build -f Dockerfile -t $DOCKER_USERNAME/$IMAGE_NAME:$version --build-arg VERSION=$build_arg . --no-cache
    if [ $? -eq 0 ]; then
        docker push $DOCKER_USERNAME/$IMAGE_NAME:$version
        echo -e "${GREEN}Docker image pushed successfully for version ${YELLOW}${version}${NC}${GREEN}!${NC}"
    else
        echo -e "${RED}Failed to build Docker image for version ${YELLOW}${version}${NC}${RED}!${NC}"
    fi
}

# Loop through the versions and perform actions
handle_version_operations() {
    local action=$1
    for i in "${!versions[@]}"; do
        version="${versions[$i]}"
        build_version="${build_versions[$i]}"

        if [ "$action" == "push" ]; then
            build_and_push "$version" "$build_version"
        elif [ "$action" == "apply" ]; then
            find_replace_and_apply ${versions[$i]} "$((80 + i * 10))"
        elif [ "$action" == "delete" ]; then
            find_replace_and_delete ${versions[$i]} "$((80 + i * 10))"
        fi
    done
}

# Menu logic with better user interaction
while true; do
    clear
    banner
    echo -e "${YELLOW}                      Configuring Docker Images${NC}"
    echo -e "[1] Build and Push version Latest         [2] Build and Push version Stable"
    echo -e "[3] Build and Push version Test           [4] Build and Push all versions"
    echo -e ""
    echo -e "${CYAN}                        Kubernetes Configuration${NC}"
    echo -e "[5] Apply version Latest                  [6] Apply version Stable"
    echo -e "[7] Apply version Test                    [8] Apply all versions"
    echo -e ""
    echo -e "${RED}                              Cleanup${NC}"
    echo -e "[9] Delete All Radicale Kubernetes Infrastructure"
    echo -e "[0] Exit Radicale Installation Script"

    read -p "Choose an option: " p
    clear
    case "$p" in
        1) build_and_push ${versions[0]} "${build_versions[0]}"; sleep 2;;
        2) build_and_push ${versions[1]} "${build_versions[1]}"; sleep 2;;
        3) build_and_push ${versions[2]} "${build_versions[2]}"; sleep 2;;
        4) handle_version_operations "push"; sleep 2;;
        5) find_replace_and_apply ${versions[0]} "80"; sleep 2;;
        6) find_replace_and_apply ${versions[1]} "90"; sleep 2;;
        7) find_replace_and_apply ${versions[2]} "100"; sleep 2;;
        8) handle_version_operations "apply"; sleep 2;;
        9) handle_version_operations "delete"; sleep 2;;
        0) docker logout >> /dev/null && echo -e "${GREEN}Logged out from DockerHub. Exiting...${NC}"; exit 0;;
        *) echo -e "${RED}Invalid option. Please choose a number between 0 and 9.${NC}"; sleep 2;;
    esac
done
