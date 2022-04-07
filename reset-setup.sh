#!/usr/bin/env bash

trap 'echo "# $BASH_COMMAND"' DEBUG

set -e

microk8s helm3 repo remove jetstack
microk8s helm3 repo remove prometheus-community
sudo snap remove microk8s