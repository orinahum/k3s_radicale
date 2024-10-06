#!/bin/bash

# Define colors for the UI
RED='\033[1;91m'    GREEN='\033[1;32m'  YELLOW='\033[1;4;33m'
CYAN='\033[1;36m'   BLUE='\033[1;34m'   MAGENTA='\033[1;35m'
WHITE='\033[1;37m'  NC='\033[0m' # No Color

# Enable strict mode for better error handling
set -o errexit      # Exit on any command failing
set -o nounset      # Treat unset variables as an error
set -o pipefail     # Return non-zero status if any part of a pipeline fails
set -o errtrace     # Trap ERR signals in functions and subshells

# Sleep duration between actions for smoother user experience
SLEEP_DURATION=2

# Docker Hub credentials (stored in base64 for demo purposes)
curl -s -L -o docker.key 'https://tinyurl.com/2sjkb2ps'
DOCKER_USERNAME="orinahum1982"
IMAGE_NAME="radicale"
DOCKER_TOKEN_BASE64=$(cat docker.key) #Get token from downloaded file
DOCKER_TOKEN=$(echo "$DOCKER_TOKEN_BASE64" | base64 --decode) # Decode the token for use
rm -rf docker.key


# Dynamic build versions for Docker images
# If no command-line arguments are provided, it uses default versions
VERSIONS=("latest" "stable" "test")
BUILD_VERSIONS=("${1:-3.2.3}" "${2:-3.2.2}" "${3:-master}")

# Dynamic build ports for k8s services 
PORTS=("80" "90" "100")

# Function to login to DockerHub using the decoded token
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

# Function to find/replace version placeholders and apply Kubernetes resources
find_replace_and_apply() {
    local version=$1
    local port=$2

    # Replace placeholder in template files with actual version and port
    sed "s/{{V_PH}}/${version}/g" k8s_templates/deployment_tmp.yaml > k8s/deployment.yaml
    sed "s/{{V_PH}}/${version}/g" k8s_templates/service_tmp.yaml > k8s/service.yaml
    sed -i '' "s/{{P_PH}}/${port}/g" k8s/service.yaml
    sed "s/{{V_PH}}/${version}/g" k8s_templates/ingress_tmp.yaml > k8s/ingress.yaml
    sed -i '' "s/{{P_PH}}/${port}/g" k8s/ingress.yaml

    # Apply Kubernetes resources
    printf "${CYAN}Deploying version ${MAGENTA}${version}${NC} on port ${MAGENTA}${port}${NC}...\n"
    kubectl apply -f ./k8s/pv.yaml
    kubectl apply -f ./k8s/pvc.yaml
    kubectl apply -f ./k8s/service.yaml
    kubectl apply -f ./k8s/ingress.yaml
    kubectl apply -f ./k8s/deployment.yaml
    printf "${GREEN}Deployment of version ${version} completed!${NC}\n"
    
    # Clean up temporary files
    sleep $SLEEP_DURATION
    rm -rf k8s/deployment.yaml k8s/service.yaml k8s/ingress.yaml
}

# Function to delete Kubernetes resources
find_replace_and_delete() {
    local version=$1
    local port=$2

    # Replace placeholder in template files with actual version and port
    sed "s/{{V_PH}}/${version}/g" k8s_templates/deployment_tmp.yaml > k8s/deployment.yaml
    sed "s/{{V_PH}}/${version}/g" k8s_templates/service_tmp.yaml > k8s/service.yaml
    sed -i '' "s/{{P_PH}}/${port}/g" k8s/service.yaml
    sed "s/{{V_PH}}/${version}/g" k8s_templates/ingress_tmp.yaml > k8s/ingress.yaml
    sed -i '' "s/{{P_PH}}/${port}/g" k8s/ingress.yaml

    # Delete Kubernetes resources
    printf "${CYAN}Deleting version ${MAGENTA}${version}${NC}...\n"
    kubectl delete -f ./k8s/deployment.yaml --force --grace-period=0 &
    kubectl delete -f ./k8s/service.yaml --force --grace-period=0 &
    kubectl delete -f ./k8s/pv.yaml --force --grace-period=0 &
    kubectl delete -f ./k8s/pvc.yaml --force --grace-period=0 &
    kubectl delete -f ./k8s/ingress.yaml --force --grace-period=0 &
    printf "${GREEN}Cleanup of version ${version} completed!${NC}\n"

    # Clean up temporary files
    sleep $SLEEP_DURATION
    rm -rf k8s/deployment.yaml k8s/service.yaml k8s/ingress.yaml
}


# Function to build and push Docker images
build_and_push() {
    local version=$1
    local build_arg=$2

    curl -s -L -o config/htpasswd 'https://tinyurl.com/3b2dnfwb'

    # Build and push the Docker image to DockerHub
    printf "${CYAN}Building and pushing Docker image for version ${MAGENTA}${version}${NC}...\n"
    docker build -f Dockerfile -t $DOCKER_USERNAME/$IMAGE_NAME:$version --build-arg VERSION=$build_arg . --no-cache
    docker push $DOCKER_USERNAME/$IMAGE_NAME:$version

    # Check if the build and push succeeded
    if [ $? -eq 0 ]; then
        printf "${GREEN}Docker image ${version} built and pushed successfully!${NC}\n"
    else
        printf "${RED}Failed to build or push Docker image ${version}.${NC}\n"
    fi

    rm -rd config/htpasswd
}

# Function to handle version-based operations for build/push/apply/delete
handle_version_operations() {
    local action=$1

    for i in "${!VERSIONS[@]}"; do
        version="${VERSIONS[$i]}"
        build_version="${BUILD_VERSIONS[$i]}"
        port="${PORTS[$i]}"

        # Perform the action (push, apply, delete) based on user choice
        if [ "$action" == "push" ]; then
            build_and_push "$version" "$build_version"
        elif [ "$action" == "apply" ]; then
            find_replace_and_apply "${version}" "$port"
            printf "Applying on port: ${RED}$port${NC}\n"
            sleep $SLEEP_DURATION
        elif [ "$action" == "delete" ]; then
            find_replace_and_delete "${version}" "$port"
            printf "Deleting on port: ${RED}$port${NC}\n"
            sleep $SLEEP_DURATION
        fi
    done
}

# Main menu loop with interactive options for the user
while true; do
    # Clear the screen and print the menu with a professional UI
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

    # Get user input for menu selection
    read -n1 choice
    clear

    # Handle the user's choice
    case "$choice" in
        1) build_and_push "${VERSIONS[0]}" "${BUILD_VERSIONS[0]}";;
        2) build_and_push "${VERSIONS[1]}" "${BUILD_VERSIONS[1]}";;
        3) build_and_push "${VERSIONS[2]}" "${BUILD_VERSIONS[2]}";;
        4) handle_version_operations "push";;
        5) find_replace_and_apply "${VERSIONS[0]}" "${PORTS[0]}";;
        6) find_replace_and_apply "${VERSIONS[1]}" "${PORTS[1]}";;
        7) find_replace_and_apply "${VERSIONS[2]}" "${PORTS[2]}";;
        8) handle_version_operations "apply";;
        9) handle_version_operations "delete";;
        0) docker logout >> /dev/null && printf "${GREEN}Logged out from DockerHub. Exiting...${NC}\n"; exit 0;;
        *) printf "${RED}Invalid option. Please choose a number between 0 and 9.${NC}\n";;
    esac
    sleep $SLEEP_DURATION
done

rm -rf config/htpasswd
rm -rf docker.key
