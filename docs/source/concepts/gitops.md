[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# GitOps

[GitOps](https://www.weave.works/technologies/gitops/) is a modern approach to managing and deploying applications in Kubernetes clusters. It leverages the version control system Git as the source of truth for defining the desired state of your infrastructure and applications. Flux is a popular tool used to implement GitOps workflows, enabling automatic synchronization of changes from Git repositories to Kubernetes clusters.

!!! tip

    With 1.1 Release, GitOps is optional for small development environments.

## Features

1. Source of Truth: In GitOps, the Git repository serves as the single source of truth for your infrastructure and application configurations. All desired states are declared and versioned in Git.

1. Declarative Configuration: Instead of manually applying changes to the cluster, you declare the desired state of your applications and infrastructure using YAML manifests in Git.

1. Continuous Deployment: GitOps promotes continuous deployment by automatically applying changes to the cluster whenever there is a new commit or change in the Git repository.

1. Version Control and History: Git provides version control capabilities, allowing you to track changes over time, roll back to previous configurations, and collaborate with teammates.

## Flux

[Flux](https://fluxcd.io/) is a Kubernetes operator that helps implement GitOps workflows. It continuously monitors the specified Git repositories for changes and reconciles them with the Kubernetes cluster.

### Features

1. Automated Synchronization: When you push changes to the Git repository, Flux automatically synchronizes those changes with the cluster, ensuring that the actual state matches the desired state in Git.

1. Automated Rollouts: Flux enables automated rollouts and rollbacks of application changes based on the Git commits, making the deployment process more reliable and predictable.

1. Integration with CI/CD: Flux can be integrated with your CI/CD pipelines, enabling seamless deployments from development to production environments.

1. Multi-Cluster Support: Flux supports multi-cluster configurations, allowing you to manage GitOps workflows across multiple Kubernetes clusters.

## GitOps Workflow

1. Commit Changes: Developers and operators commit changes to the Git repository, updating the desired state of the applications and infrastructure.

1. Flux Watches Git: Flux continuously watches the specified Git repository for changes and events.

1. Synchronization: When a new commit or change is detected, Flux synchronizes the changes to the Kubernetes cluster.

1. Reconciliation: Flux ensures that the actual state of the cluster matches the desired state in Git. If there are any discrepancies, Flux performs the necessary actions to reconcile the state.

1. Deployment and Rollback: Based on the Git commit history, Flux automates the deployment of new changes and rollback to previous configurations if needed.

## Benefits of GitOps and Flux

- Infrastructure and Configuration as Code: Using GitOps and Flux, you can manage your infrastructure and application configurations as code, promoting better collaboration and version control.

- Consistency and Reliability: With GitOps, you ensure that the cluster's actual state matches the desired state, reducing manual errors and ensuring consistent deployments.

- Continuous Deployment: GitOps allows for continuous and automated deployments, making the release process faster and more efficient.

- Auditing and History: Git provides a complete history of changes, enabling easy auditing, rollbacks, and debugging.

- Simplified Management: GitOps simplifies cluster management and configuration updates, streamlining the deployment process.

Hyperledger Bevel uses Flux for the implementation of GitOps for production-worthy deployments. All the parameters required for Flux must be passed via the `network.yaml`.
