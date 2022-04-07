#!/usr/bin/env bash

trap 'echo "# $BASH_COMMAND"' DEBUG

set -e

if [[ -z "$COMPANY_NAME" ]]; then
    echo "Must provide COMPANY_NAME in environment" 1>&2
    exit 1
fi

sudo snap install microk8s --classic --channel=1.23

sudo usermod -a -G microk8s $USER

sudo chown -f -R $USER ~/.kube

echo "Restarting session for $USER. Password might be required."

su - $USER -w COMPANY_DOMAIN -c cd $(pwd) && ./complete-setup.sh