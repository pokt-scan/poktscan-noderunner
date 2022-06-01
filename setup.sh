#!/usr/bin/env bash

trap 'echo "# $BASH_COMMAND"' DEBUG

sudo snap install microk8s --classic --channel=1.23

sudo usermod -a -G microk8s $USER

sudo chown -f -R $USER ~/.kube

newgrp microk8s

echo "Restart session for $USER. Password might be required."
