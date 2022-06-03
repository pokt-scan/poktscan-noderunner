#!/usr/bin/env bash

trap 'echo "# $BASH_COMMAND"' DEBUG

set -e

echo "admin passwword $(microk8s kubectl get secret --namespace tobs tobs-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)"
microk8s kubectl -n tobs port-forward service/tobs-grafana 8080:80
