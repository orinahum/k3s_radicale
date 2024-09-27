#!/bin/bash

kubectl create secret generic radicale-htpasswd --from-file=htpasswd=./config/htpasswd

kubectl create secret generic radicale-secret \
  --from-literal=user=admin \
  --from-literal=password=admin

kubectl apply -f ./k8s/pvc.yaml

kubectl apply -f ./k8s/radicale_config_map.yaml

kubectl apply -f ./k8s/deployment.yaml

