#!/usr/bin/env bash

set -e

trap 'echo "# $BASH_COMMAND"' DEBUG

sudo snap install microk8s --classic --channel=1.23

sudo usermod -a -G microk8s $USER

sudo microk8s config > ~/.kube/config

sudo chown -f -R $USER ~/.kube

sudo chmod 600 ~/.kube/config

newgrp microk8s

echo "Restart session for $USER. Password might be required."

exit
