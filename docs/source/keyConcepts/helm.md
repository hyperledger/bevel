[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Helm

[Helm](https://helm.sh/) is a package manager for Kubernetes that simplifies the deployment and management of applications on a Kubernetes cluster. It streamlines the process of packaging, distributing, and installing Kubernetes resources through the use of Helm charts.

- **Package Manager**: Helm acts as a package manager, similar to how app stores manage applications for your smartphone. It allows you to find, share, and install pre-configured applications (Kubernetes resources) on your Kubernetes cluster.

- **Client-Server Architecture**: Helm follows a client-server architecture. The client, called "Helm CLI," runs on your local machine, allowing you to interact with the Kubernetes cluster. The server component, known as "Tiller" (deprecated since Helm 3), used to manage Helm releases. In Helm 3, Tiller was removed, and Helm interacts directly with the Kubernetes API server.

- **Charts Repositories**: Helm charts are stored in repositories that act as collections of packaged applications. You can use official Helm repositories or create your custom repositories to share and distribute charts across teams.

## Helm Charts

Helm charts are pre-configured templates that define a set of Kubernetes resources required to deploy and manage a specific application or service. They encapsulate everything needed to run an application, including deployment, services, ingress, and more.

**Structure of a Chart**: A Helm chart consists of a predefined directory structure. The essential files are:

- `Chart.yaml`: Contains metadata and information about the chart, such as its name, version, and description.
- `values.yaml`: Holds configurable parameters that users can customize during deployment.
- `templates/`: Directory that contains the Kubernetes resource templates (e.g., Deployment, Service) written in YAML format.

**Customization with Values**: Helm charts allow users to customize deployments based on their requirements. By modifying the values.yaml file or providing custom values during deployment, you can fine-tune the application settings.

**Reusability and Versioning**: Helm charts promote reusability and consistency across deployments. They also support versioning, making it easy to rollback or upgrade applications.

## Working with Helm

1. **Install Helm**: Begin by installing Helm CLI on your local machine, which provides commands for chart management.

1. **Add Repositories**: Optionally, you can add public or private Helm repositories to access various charts easily.

1. **Search and Install Charts**: Use Helm CLI to search for available charts and install them on your Kubernetes cluster.

1. **Customize Charts**: If needed, customize the deployed charts by modifying the values in the values.yaml file.

1. **Deploy Applications**: Deploy the application using Helm CLI, and Helm will handle the packaging and installation of Kubernetes resources.

1. **Manage Releases**: Helm tracks each deployment as a "release," allowing you to manage, upgrade, or rollback applications with ease.

## Advantages of Helm and Helm Charts

- Helm simplifies the deployment process, making it easy to share and distribute Kubernetes applications.
- Helm charts promote reusability and standardization, reducing the effort required to deploy multiple applications.
- Users can customize charts based on their specific requirements, ensuring flexibility.
- Versioning and release management features allow for easy upgrades and rollbacks.

Hyperledger Bevel uses Helm Charts extensively for configuring the DLT/Blockchain network on Kubernetes Cluster(s).
