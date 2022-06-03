#!/usr/bin/env bash

set -e

trap 'echo "# $BASH_COMMAND"' DEBUG

microk8s status --wait-ready

microk8s enable dns storage helm3 metrics-server

microk8s helm3 repo add jetstack https://charts.jetstack.io
microk8s helm3 repo add timescale https://charts.timescale.com
microk8s helm3 repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

microk8s helm3 repo update

echo "Attempting to get current server external ipv4"

EXTERNAL_IP=$(curl https://ifconfig.co/ip)

echo "External IP: $EXTERNAL_IP"

if [[ -z "$EXTERNAL_IP" ]]; then
    echo "Could not identify external ip" 1>&2
    exit 1
fi

microk8s kubectl create namespace poktscan --save-config --dry-run=client -o yaml | microk8s kubectl apply -f -

microk8s kubectl create configmap -n poktscan cluster-settings --save-config --dry-run=client -o yaml | microk8s kubectl apply -f -

microk8s kubectl apply -f local-storage.yaml

microk8s helm3 upgrade --install \
  --namespace cert-manager \
  --create-namespace \
  --version v1.7.2 \
  --set installCRDs=true \
  cert-manager jetstack/cert-manager

microk8s helm3 upgrade --install \
  --namespace tobs \
  --create-namespace \
  --values tobs_values.yaml \
  --wait \
  tobs timescale/tobs

microk8s helm3 upgrade --install \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.metrics.enabled=true \
  --set controller.metrics.serviceMonitor.enabled=true \
  --set controller.metrics.serviceMonitor.additionalLabels.release="tobs" \
  --set controller.service.externalIPs={"$EXTERNAL_IP"} \
  ingress-nginx ingress-nginx/ingress-nginx

microk8s kubectl apply -f pokt-monitor.yaml -n tobs

sleep .5

microk8s kubectl -n tobs get secret prometheus-tobs-kube-prometheus-prometheus -ojson | jq -r '.data["prometheus.yaml.gz"]' | base64 -d | gunzip | grep "pokt-service-monitor"

echo "Setup has been successful!"
