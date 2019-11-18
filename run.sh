#!/bin/bash
set -e

echo "Starting build process..."
PATH=$PATH:/root/bin
exec ansible-playbook -vv ./platforms/shared/configuration/site.yaml --inventory-file=platforms/shared/inventory/ -e "@./network.yaml" 