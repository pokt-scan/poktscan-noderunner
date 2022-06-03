#!/usr/bin/env bash

set -e

trap 'echo "# $BASH_COMMAND"' DEBUG

microk8s helm3 uninstall -n tobs tobs
microk8s helm3 uninstall -n ingress-nginx ingress-nginx

microk8s helm3 repo remove timescale
microk8s helm3 repo remove ingress-nginx

microk8s kubectl delete namespace tobs
microk8s kubectl delete namespace ingress-nginx
