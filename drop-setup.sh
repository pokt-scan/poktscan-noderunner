#!/usr/bin/env bash

set -e

trap 'echo "# $BASH_COMMAND"' DEBUG

sudo snap remove --purge microk8s
