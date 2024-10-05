#!/bin/bash

#
S="sleep 2"

# Dynamic versions with defaults
VERSIONS=("latest" "stable" "test")
BUILD_VERSIONS=("${1:-3.2.3}" "${2:-3.2.2}" "${3:-master}")

# Docker Hub credentials
DOCKER_USERNAME="orinahum1982"
IMAGE_NAME="radicale"
DOCKER_TOKEN_BASE64="ZGNrcl9wYXRfaklkN3FNVGdKSzQ1dExWMHl2XzVjeG1FZjRnCg=="
DOCKER_TOKEN=$(echo $DOCKER_TOKEN_BASE64 | base64 --decode)

# Login Docker Hub
echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USERNAME" --password-stdin >> /dev/null
echo "DockerHub login completed"  
$S

# General function to find/replace and deploy K8s resources
function find_replace_and_apply() {
    local version=$1
    local port=$2

    sed "s/V_PH/${version}/g" deployment_tmp.yaml > k8s/deployment.yaml
    sed "s/V_PH/${version}/g" service_tmp.yaml > k8s/service.yaml
    sed -i '' "s/V_PH/${port}/g" k8s/service.yaml
    echo $port
    kubectl apply -f ./k8s/pv.yaml
    kubectl apply -f ./k8s/pvc.yaml
    kubectl apply -f ./k8s/service.yaml
    kubectl apply -f ./k8s/ingress.yaml
    kubectl apply -f ./k8s/deployment.yaml
    # rm -rf k8s/deployment.yaml k8s/service.yaml
}

function find_replace_and_delete() {
    local version=$1
    local port=$2

    sed "s/V_PH/${version}/g" deployment_tmp.yaml > k8s/deployment.yaml
    sed "s/V_PH/${version}/g" service_tmp.yaml > k8s/service.yaml
    sed -i '' "s/V_PH/${port}/g" k8s/service.yaml

    kubectl delete -f ./k8s/deployment.yaml    
    kubectl delete -f ./k8s/service.yaml
    kubectl delete -f ./k8s/ingress.yaml
    kubectl delete -f ./k8s/pvc.yaml
    kubectl delete -f ./k8s/pv.yaml

    # rm -rf k8s/deployment.yaml k8s/service.yaml
}

# General function to build and push Docker image
function build_and_push() {
    local version=$1
    local build_arg=$2

    docker build -f Dockerfile -t $DOCKER_USERNAME/$IMAGE_NAME:$version --build-arg VERSION=$build_arg . --no-cache
    docker push $DOCKER_USERNAME/$IMAGE_NAME:$version
}

# Loop through the versions and perform actions
function handle_version_operations() {
    local action=$1
    for i in "${!VERSIONS[@]}"; do
        version="${VERSIONS[$i]}"
        build_version="${BUILD_VERSIONS[$i]}"

        if [ "$action" == "push" ]; then
            build_and_push "$version" "$build_version"
        elif [ "$action" == "apply" ]; then
            find_replace_and_apply ${VERSIONS[0]} "80"
            find_replace_and_apply ${VERSIONS[1]} "90"
            find_replace_and_apply ${VERSIONS[2]} "100"
        elif [ "$action" == "delete" ]; then
            find_replace_and_delete ${VERSIONS[0]} "80"
            find_replace_and_delete ${VERSIONS[1]} "90"
            find_replace_and_delete ${VERSIONS[2]} "100"
        fi
    done
}

# Menu logic
while true; do
printf '\n%s\n' \
'  SETUP AN AUTO-SCALED RADICALE APPLICATION USING DOCKER AND KUBERNETES' \
'                            Configuring Images' \
'[1] Build and Push version Latest         [2] Build and Push version Stable' \
'[3] Build and Push version Test           [4] Build and Push all versions' \
'                          Kubernetes Configuration' \
'[5] Apply version Latest                  [6] Apply version Stable' \
'[7] Apply version Test                    [8] Apply all versions' \
'                                 Cleanup' \
'[9] Delete All Radicale Kubernetes Infrastructure' \
'[0] Exit Radicale Installation Script'


    read -n1 p

    clear
    case "$p" in
        1) build_and_push ${VERSIONS[0]} "${BUILD_VERSIONS[0]}" && $S;;
        2) build_and_push ${VERSIONS[1]} "${BUILD_VERSIONS[1]}" && $S;;
        3) build_and_push ${VERSIONS[2]} "${BUILD_VERSIONS[2]}" && $S;;
        4) handle_version_operations "push" && $S;;
        5) find_replace_and_apply ${VERSIONS[0]} "80" && $S;;
        6) find_replace_and_apply ${VERSIONS[1]} "90" && $S;;
        7) find_replace_and_apply ${VERSIONS[2]} "100" && $S;;
        8) handle_version_operations "apply" && $S;;
        9) handle_version_operations "delete" && $S;;
        0) docker logout >> /dev/null && exit 0;;
        *) echo "[-] Not a valid character. Choose 0-9 " && $S;;
    esac
    
done
