#!/bin/bash
set -e

echo "Starting build process..."

echo "Adding env variables..."
PATH=$PATH:/root/bin

#Path to k8s config file
KUBECONFIG=/home/build/config/config


echo "Running the playbook..."
exec ansible-playbook -vv /home/build/blockchain-automation-framework/platforms/shared/configuration/site.yaml --inventory-file=/home/build/blockchain-automation-framework/platforms/shared/inventory/ -e "@/home/build/config/network.yaml" -e 'ansible_python_interpreter=/usr/bin/python3'
