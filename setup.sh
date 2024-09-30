#!/bin/bash
x=$1
y=$2
z=$3
latest="${x:-3.2.3}"
stable="${y:-3.2.2}"
test="${z:-'master'}"

# Docker Hub repository
DOCKER_USERNAME="orinahum1982"
IMAGE_NAME="radicale"
DOCKER_TOKEN_BASE64="ZGNrcl9wYXRfaklkN3FNVGdKSzQ1dExWMHl2XzVjeG1FZjRnCg=="
DOCKER_TOKEN=$(echo $DOCKER_TOKEN_BASE64 | base64 --decode)

# Login Docker Hub
# echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USERNAME" --password-stdin >> /dev/null && \
# echo "DockerHub login completed"  
# sleep 3

function find_replace () {
    sed "s/V_PH/${1}/g" deployment_tmp.yaml > k8s/deployment.yaml
    sed "s/V_PH/${1}/g" service_tmp.yaml > k8s/service.yaml
    sed -i "s/V_PH/${2}/g" k8s/service.yaml
}


function push_latest () { ## Build and Push the version latest
    docker build -f Dockerfile -t $DOCKER_USERNAME/$IMAGE_NAME:latest --build-arg VERSION=$latest . --no-cache
    docker push $DOCKER_USERNAME/$IMAGE_NAME:latest
}
function push_stable () { ## Build and Push the version stable
    docker build -f Dockerfile -t $DOCKER_USERNAME/$IMAGE_NAME:stable --build-arg VERSION=$stable . --no-cache
    docker push $DOCKER_USERNAME/$IMAGE_NAME:stable    
}
function push_test () { ## Build and Push the version test
    docker build -f Dockerfile -t $DOCKER_USERNAME/$IMAGE_NAME:test --build-arg VERSION=$test . --no-cache
    docker push $DOCKER_USERNAME/$IMAGE_NAME:test
}

function push_all () {
    push_latest
    push_stable
    push_test
}

function apply_k3s_conf_latest () {
    find_replace "latest" "80"
    kubectl apply -f ./k8s/pvc.yaml
    kubectl apply -f ./k8s/service_latest.yaml
    kubectl apply -f ./k8s/ingress.yaml
    kubectl apply -f ./k8s/deployment_latest.yaml
    rm -rf k8s/deployment.yaml
    rm -rf k8s/service.yaml
}   
function apply_k3s_conf_stable () {
    find_replace "stable" "90"
    kubectl apply -f ./k8s/pvc.yaml
    kubectl apply -f ./k8s/service_stable.yaml
    kubectl apply -f ./k8s/ingress.yaml
    kubectl apply -f ./k8s/deployment_stable.yaml
    rm -rf k8s/deployment.yaml
    rm -rf k8s/service.yaml
}
function apply_k3s_conf_test () {
    find_replace "test" "100"
    kubectl apply -f ./k8s/pvc.yaml
    kubectl apply -f ./k8s/service_test.yaml
    kubectl apply -f ./k8s/ingress.yaml
    kubectl apply -f ./k8s/deployment_test.yaml
    rm -rf k8s/deployment.yaml
    rm -rf k8s/service.yaml
}
function apply_k3s_conf_all () {
    apply_k3s_conf_latest
    apply_k3s_conf_stable
    apply_k3s_conf_test
}

function delete_k3s_all () {
    find_replace "latest" "80"
    kubectl delete -f ./k8s/deployment.yaml
    find_replace "stable" "90"
    kubectl delete -f ./k8s/deployment.yaml
    find_replace "test" "100"
    kubectl delete -f ./k8s/deploymentyaml
    find_replace "latest" "80"
    kubectl delete -f ./k8s/service.yaml
    find_replace "stable" "90"
    kubectl delete -f ./k8s/service.yaml
    find_replace "test" "100"
    kubectl delete -f ./k8s/service.yaml
    kubectl delete -f ./k8s/pvc.yaml
    kubectl delete -f ./k8s/ingress.yaml
    rm -rf k8s/deployment.yaml
    rm -rf k8s/service.yaml
}

while true ; do
    clear
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
        1) push_latest && sleep 2;;
        2) push_stable && sleep 2;;
        3) push_test && sleep 2;;
        4) push_all && sleep 2;;
        5) apply_k3s_conf_latest && sleep 2;;
        6) apply_k3s_conf_stable && sleep 2;;
        7) apply_k3s_conf_test && sleep 2;;
        8) apply_k3s_conf_all && sleep 2;;
        9) delete_k3s_all && sleep 2;;
        0) docker logout >> /dev/null && exit 0;; # Logout Docker Hub
    esac
done
