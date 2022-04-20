#!/usr/bin/env bash

trap 'echo "# $BASH_COMMAND"' DEBUG

set -e

microk8s status --wait-ready

microk8s enable dns storage helm3 metrics-server

microk8s helm3 repo add prometheus-community https://prometheus-community.github.io/helm-charts

microk8s helm3 repo add jetstack https://charts.jetstack.io

microk8s helm3 repo update

microk8s helm3 install prometheus --namespace prometheus --create-namespace prometheus-community/kube-prometheus-stack

echo "Attempting to get current server external ipv4"

EXTERNAL_IP=$(curl https://ifconfig.co/ip)

echo "External IP: $EXTERNAL_IP"

if [[ -z "$EXTERNAL_IP" ]]; then
    echo "Could not identify external ip" 1>&2
    exit 1
fi

microk8s helm3 upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace --set controller.metrics.enabled=true --set controller.metrics.serviceMonitor.enabled=true --set controller.metrics.serviceMonitor.additionalLabels.release="prometheus" --set controller.service.externalIPs={"$EXTERNAL_IP"}

microk8s helm3 install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.7.2 --set installCRDs=true

cat ./godaddy-webhook/resources.yaml | sed "s/{COMPANY_DOMAIN}/$COMPANY_DOMAIN/g" | microk8s kubectl apply -f -

microk8s kubectl create namespace poktscan

microk8s kubectl create configmap -n poktscan cluster-settings

microk8s kubectl apply -f local-storage.yaml

echo "Setup has been successful!"
