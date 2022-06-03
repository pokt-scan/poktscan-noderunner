#!/usr/bin/env bash

trap 'echo "# $BASH_COMMAND"' DEBUG

set -e

export SERVICE_NAME=$(microk8s kubectl get services -n tobs -l "app=kube-prometheus-stack-prometheus,release=tobs" -o jsonpath="{.items[0].metadata.name}")
microk8s kubectl -n tobs port-forward service/$SERVICE_NAME 9090:9090
