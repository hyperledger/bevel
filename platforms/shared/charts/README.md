[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## About
This folder contains the common charts as prerequisites used for the deployment of DLT platforms. Deployment of a DLT platform should use files within respective platforms folder.

## Deploying Ambassador Egde Stack

```bash
helm repo add datawire https://app.getambassador.io

kubectl apply -f ../configuration/roles/setup/edge-stack/templates/aes-crds.yaml

kubectl create namespace ambassador

helm upgrade --install edge-stack datawire/edge-stack --namespace ambassador --version 8.7.2 -f ../configuration/roles/setup/edge-stack/templates/aes-custom-values.yaml

```
## Deploying HAProxy

```bash
kubectl create namespace ingress-controller

helm upgrade --install --namespace ingress-controller haproxy ./haproxy-ingress/haproxy-ingress-0.14.6.tgz --set controller.kind=DaemonSet -f ./haproxy-ingress/values.yaml

```