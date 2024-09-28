#!/bin/bash
latest=3.2.3
stable=3.2.2
test=master

# Docker Hub repository
DOCKER_USERNAME="orinahum1982"
IMAGE_NAME="radicale"
DOCKER_TOKEN=$(cat dockerhub_token_encoded | base64 --decode)

# Login Docker Hub
# echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USERNAME" --password-stdin

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
    kubectl apply -f ./k8s/pvc.yaml
    kubectl apply -f ./k8s/service_latest.yaml
    kubectl apply -f ./k8s/ingress.yaml
    kubectl apply -f ./k8s/deployment_latest.yaml
}
function apply_k3s_conf_stable () {
    kubectl apply -f ./k8s/pvc.yaml
    kubectl apply -f ./k8s/service_stable.yaml
    kubectl apply -f ./k8s/ingress.yaml
    kubectl apply -f ./k8s/deployment_stable.yaml
}
function apply_k3s_conf_test () {
    kubectl apply -f ./k8s/pvc.yaml
    kubectl apply -f ./k8s/service_test.yaml
    kubectl apply -f ./k8s/ingress.yaml
    kubectl apply -f ./k8s/deployment_test.yaml
}
function apply_k3s_conf_all () {
    apply_k3s_conf_latest
    apply_k3s_conf_stable
    apply_k3s_conf_test
}
echo "DockerHub login completed, press any key to start configuring the images and kuberenetes"
read -n1 p
while true ; do
    clear

    echo "                            Configuring Images"
    echo ""
    echo "(1) Build and Push version Latest         (2) Build and Push version Stable"
    echo "(3) Build and Push version Test           (4) Build and Push all versions"
    echo ""
    echo "                            Kubernetes Configuration"
    echo ""
    echo "(5) Apply version Latest         (6) Apply version Stable"
    echo "(7) Apply version Test           (8) Apply all versions"
    echo ""
    echo "                            To Exit enter 0"
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
        9) echo "Placeholder for deletion" && sleep 2;;
        0) docker logout && exit 0;;
    
    esac
done


# # Logout Docker Hub



