#!/bin/bash

kubectl apply -f ./k8s/pvc.yaml
kubectl apply -f ./k8s/service.yaml
kubectl apply -f ./k8s/ingress.yaml
kubectl apply -f ./k8s/deployment.yaml


