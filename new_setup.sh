#!/bin/bash

# Define colors
RED='\033[1;91m'
GREEN='\033[1;32m'
YELLOW='\033[1;4;33m'
CYAN='\033[1;36m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Sleep time
SLEEP_DURATION=2

# Docker Hub credentials
DOCKER_USERNAME="orinahum1982"
IMAGE_NAME="radicale"
DOCKER_TOKEN_BASE64="ZGNrcl9wYXRfaklkN3FNVGdKSzQ1dExWMHl2XzVjeG1FZjRnCg=="
DOCKER_TOKEN=$(echo $DOCKER_TOKEN_BASE64 | base64 --decode)

# Dynamic versions with defaults
VERSIONS=("latest" "stable" "test")
BUILD_VERSIONS=("${1:-3.2.3}" "${2:-3.2.2}" "${3:-master}")

# DockerHub login
login_to_docker() {
    printf "${CYAN}Logging into Docker Hub...${NC}\n"
    echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USERNAME" --password-stdin >> /dev/null
    if [ $? -eq 0 ]; then
        printf "${GREEN}DockerHub login successful!${NC}\n"
    else
        printf "${RED}DockerHub login failed! Please check your credentials.${NC}\n"
        exit 1
    fi
    sleep $SLEEP_DURATION
}

# Function to find/replace and deploy Kubernetes resources
find_replace_and_apply() {
    local version=$1
    local port=$2

    sed "s/V_PH/${version}/g" deployment_tmp.yaml > k8s/deployment.yaml
    sed "s/V_PH/${version}/g" service_tmp.yaml > k8s/service.yaml
    sed -i "s/V_PH/${port}/g" k8s/service.yaml
    printf "${CYAN}Deploying version ${MAGENTA}${version}${NC} on port ${MAGENTA}${port}${NC}...\n"
    kubectl apply -f ./k8s/pv.yaml
    kubectl apply -f ./k8s/pvc.yaml
    kubectl apply -f ./k8s/service.yaml
    kubectl apply -f ./k8s/ingress.yaml
    kubectl apply -f ./k8s/deployment.yaml
    printf "${GREEN}Deployment of version ${version} completed!${NC}\n"
    rm -rf k8s/deployment.yaml k8s/service.yaml
}

# Function to delete Kubernetes resources
find_replace_and_delete() {
    local version=$1
    local port=$2

    sed "s/V_PH/${version}/g" deployment_tmp.yaml > k8s/deployment.yaml
    sed "s/V_PH/${version}/g" service_tmp.yaml > k8s/service.yaml
    sed -i "s/V_PH/${port}/g" k8s/service.yaml
    printf "${CYAN}Deleting version ${MAGENTA}${version}${NC}...\n"
    kubectl delete -f ./k8s/deployment.yaml    
    kubectl delete -f ./k8s/service.yaml
    kubectl delete -f ./k8s/ingress.yaml
    kubectl delete -f ./k8s/pvc.yaml
    kubectl delete -f ./k8s/pv.yaml
    printf "${GREEN}Cleanup of version ${version} completed!${NC}\n"
    rm -rf k8s/deployment.yaml k8s/service.yaml
}

# Function to build and push Docker images
build_and_push() {
    local version=$1
    local build_arg=$2

    printf "${CYAN}Building and pushing Docker image for version ${MAGENTA}${version}${NC}...\n"
    docker build -f Dockerfile -t $DOCKER_USERNAME/$IMAGE_NAME:$version --build-arg VERSION=$build_arg . --no-cache
    docker push $DOCKER_USERNAME/$IMAGE_NAME:$version
    if [ $? -eq 0 ]; then
        printf "${GREEN}Docker image ${version} built and pushed successfully!${NC}\n"
    else
        printf "${RED}Failed to build or push Docker image ${version}.${NC}\n"
    fi
}

# Function to handle version operations
handle_version_operations() {
    local action=$1
    for i in "${!VERSIONS[@]}"; do
        version="${VERSIONS[$i]}"
        build_version="${BUILD_VERSIONS[$i]}"

        if [ "$action" == "push" ]; then
            build_and_push "$version" "$build_version"
        elif [ "$action" == "apply" ]; then
            find_replace_and_apply ${version} "$((80 + i * 10))"
        elif [ "$action" == "delete" ]; then
            find_replace_and_delete ${version} "$((80 + i * 10))"
        fi
    done
}

# Menu logic with a clean, professional look
while true; do
    clear
    printf "${BLUE}\
         ███████████                 █████  ███                     ████              ██████████                     █████                            █████   ████  ████████    █████████ 
        ░░███░░░░░███               ░░███  ░░░                     ░░███             ░░███░░░░███                   ░░███                            ░░███   ███░  ███░░░░███  ███░░░░░███
         ░███    ░███   ██████    ███████  ████   ██████   ██████   ░███   ██████     ░███   ░░███  ██████   ██████  ░███ █████  ██████  ████████     ░███  ███   ░███   ░███ ░███    ░░░ 
         ░██████████   ░░░░░███  ███░░███ ░░███  ███░░███ ░░░░░███  ░███  ███░░███    ░███    ░███ ███░░███ ███░░███ ░███░░███  ███░░███░░███░░███    ░███████    ░░████████  ░░█████████ 
         ░███░░░░░███   ███████ ░███ ░███  ░███ ░███ ░░░   ███████  ░███ ░███████     ░███    ░███░███ ░███░███ ░░░  ░██████░  ░███████  ░███ ░░░     ░███░░███    ███░░░░███  ░░░░░░░░███
         ░███    ░███  ███░░███ ░███ ░███  ░███ ░███  ███ ███░░███  ░███ ░███░░░      ░███    ███ ░███ ░███░███  ███ ░███░░███ ░███░░░   ░███         ░███ ░░███  ░███   ░███  ███    ░███
         █████   █████░░████████░░████████ █████░░██████ ░░████████ █████░░██████     ██████████  ░░██████ ░░██████  ████ █████░░██████  █████        █████ ░░████░░████████  ░░█████████ 
        ░░░░░   ░░░░░  ░░░░░░░░  ░░░░░░░░ ░░░░░  ░░░░░░   ░░░░░░░░ ░░░░░  ░░░░░░     ░░░░░░░░░░    ░░░░░░   ░░░░░░  ░░░░ ░░░░░  ░░░░░░  ░░░░░        ░░░░░   ░░░░  ░░░░░░░░    ░░░░░░░░░${NC}

        ${YELLOW}SETUP AUTO-SCALED RADICALE USING DOCKER AND KUBERNETES${NC}\n
        ${WHITE}Latest:${BUILD_VERSIONS[0]} \t Stable:${BUILD_VERSIONS[1]} \t Test:${BUILD_VERSIONS[2]} ${NC}\n
        ${CYAN}Configuring Docker Images:${NC}
        [${RED}1${NC}] Build & Push Latest  [${RED}2${NC}] Build & Push Stable
        [${RED}3${NC}] Build & Push Test \t [${RED}4${NC}] Build & Push all versions\n
        ${GREEN}Kubernetes Configuration:${NC}
        [${RED}5${NC}] Apply Latest \t [${RED}6${NC}] Apply Stable
        [${RED}7${NC}] Apply Test \t\t [${RED}8${NC}] Apply all versions\n
        ${MAGENTA}Cleanup:${NC}
        [${RED}9${NC}] Delete All Radicale Kubernetes Infrastructure
        [${RED}0${NC}] Exit Script\n
        ${WHITE}Please enter your selection... ${NC}"

    read -n1 choice
    clear

    case "$choice" in
        1) build_and_push "${VERSIONS[0]}" "${BUILD_VERSIONS[0]}"; sleep $SLEEP_DURATION;;
        2) build_and_push "${VERSIONS[1]}" "${BUILD_VERSIONS[1]}"; sleep $SLEEP_DURATION;;
        3) build_and_push "${VERSIONS[2]}" "${BUILD_VERSIONS[2]}"; sleep $SLEEP_DURATION;;
        4) handle_version_operations "push"; sleep $SLEEP_DURATION;;
        5) find_replace_and_apply "${VERSIONS[0]}" "80"; sleep $SLEEP_DURATION;;
        6) find_replace_and_apply "${VERSIONS[1]}" "90"; sleep $SLEEP_DURATION;;
        7) find_replace_and_apply "${VERSIONS[2]}" "100"; sleep $SLEEP_DURATION;;
        8) handle_version_operations "apply"; sleep $SLEEP_DURATION;;
        9) handle_version_operations "delete"; sleep $SLEEP_DURATION;;
        0) docker logout >> /dev/null && printf "${GREEN}Logged out from DockerHub. Exiting...${NC}\n"; exit 0;;
        *) printf "${RED}Invalid option. Please choose a number between 0 and 9.${NC}\n"; sleep $SLEEP_DURATION;;
    esac
done
