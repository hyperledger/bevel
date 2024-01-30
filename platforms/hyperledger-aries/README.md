# ariesagent

Hyperledger Aries Agent Deployment using Kubernetes

## Introduction
This repository contains Kubernetes charts for deploying Hyperledger Aries agents. Hyperledger Aries provides a framework for building decentralized identity systems and this set of charts simplifies the deployment process in a Kubernetes environment.

## Prerequisites
- Kubernetes cluster 
- Helm 
- Knowledge of your Kubernetes cluster configuration (e.g., storage classes, ingress controller)
- Basic understanding of Hyperledger Aries and decentralized identity systems

## Installation
- Step 1: Clone the Repository
- Step 2: Configure the Kubernetes Charts
Edit the Helm chart values in chart/values.yaml to suit your deployment environment. Key configurations include:

- You can manually change agent configurations as needed for different deployment strategies. 

- Step 3: Deploy the Aries Agent
Deploy the Aries agent using Helm:

```bash
$ helm install my-aries-agent ./chart
```

Step 4: Verify Deployment
Check the status of your deployment:

```bash
$ kubectl get pods
```
Ensure that the Aries agent pods are running successfully.

## Usage
Once deployed, the Aries agent can be interacted with via its exposed service. Depending on your service.type configuration, this may be within the cluster or via an external IP/hostname.

## Customization
You can customize the deployment by editing the Helm chart values. This includes configuring:

Resource limits and requests
Persistence options
Custom environment variables
Additional parameters specific to Hyperledger Aries

### Configuration
Edit values.yaml in the chart/ directory to customize the deployment.
Key configurations: agent parameters, service type, ingress settings.

### Upgrading
To upgrade your Aries agent deployment:
```bash
$ helm upgrade my-aries-agent ./chart
```
Ensure that you review the changelog for any breaking changes or necessary actions before upgrading.

### Troubleshooting
If you encounter issues, check the Kubernetes logs for the Aries agent pods:
```bash
$ kubectl logs [Pod-Name]
```

For more detailed troubleshooting, refer to the Hyperledger Aries documentation.

## License
This project is licensed under Apache License 2.0.

## Acknowledgements
This project builds upon the foundational work of the Hyperledger Aries community. Kudos to the team at Superlogic for this contribution. 
