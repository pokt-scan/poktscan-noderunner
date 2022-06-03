#!/usr/bin/env bash

COMPANY_DOMAIN=$1

set -e

if [[ -z "$COMPANY_DOMAIN" ]]; then
    echo "Must provide COMPANY_DOMAIN as first argument" 1>&2
    exit 1
fi

cat ./godaddy-webhook/resources.yaml | sed "s/{COMPANY_DOMAIN}/$COMPANY_DOMAIN/g" | microk8s kubectl apply -f -
