#!/bin/bash

kubectl delete -f ./k8s/pvc.yaml
kubectl delete -f ./k8s/service.yaml
kubectl delete -f ./k8s/ingress.yaml
kubectl delete -f ./k8s/deployment.yaml