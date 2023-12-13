[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Kubernetes Services 

## Kubernetes
[Kubernetes](https://kubernetes.io), commonly referred to as K8s, is an open-source container orchestration platform that simplifies the deployment, scaling, and management of containerized applications. Developed by Google and now maintained by the Cloud Native Computing Foundation (CNCF), Kubernetes has rapidly become the de facto standard for automating the deployment and operation of containerized workloads.

## Managed Kubernetes Services
Various cloud providers offer Managed Kubernetes Services, also known as Kubernetes as a Service (KaaS). These services, such as [Amazon EKS](https://aws.amazon.com/eks/), Google Kubernetes Engine [GKE](https://cloud.google.com/kubernetes-engine/), and Microsoft Azure Kubernetes Service [AKS](https://azure.microsoft.com/en-gb/products/kubernetes-service/), handle the underlying infrastructure management, making it easier for developers to focus on deploying and managing applications rather than the Kubernetes control plane.

Managed Kubernetes services provide benefits like automated updates, scalability, monitoring, and seamless integration with other cloud-native services. They cater to organizations of all sizes, offering simplified Kubernetes cluster provisioning and reducing the operational overhead of managing a Kubernetes environment.

Hyperledger Bevel deploys a DLT/Blockchain network along with other required services in one or more K8s clusters, thereby providing an abstraction over the underlying cloud platform.

## Ambassador Edge Stack
[Ambassador Edge Stack](https://www.getambassador.io/products/edge-stack/api-gateway) is an open-source, comprehensive solution that acts as an API Gateway and Kubernetes Ingress controller. Designed for modern cloud-native environments, Ambassador empowers developers to manage and secure external access to microservices deployed in Kubernetes clusters. It streamlines the process of exposing APIs, enabling seamless communication between clients and services while maintaining reliability, scalability, and security.

Hyperledger Bevel uses Ambassador to route traffic amongst multiple K8s clusters. For each K8s cluster, an Ambassador Loadbalancer Service will be created (so please ensure the k8s cluster has access to public subnet). A user has to manually use a DNS server (e.g. AWS Route53) to map the public IP of the Ambassador Service to a DNS name for each cluster. 
Optionally, you can configure [External-DNS](https://github.com/kubernetes-sigs/external-dns) on the cluster and map the routes automatically. Automatic updation of routes via External DNS is supported from Bevel 0.3.0.0 onwards. 

A simplistic view of how Ambassador works is as follows:

If a pod in Cluster1 wants to reach a target pod in Cluster2, it will just use the Domain address or IP in Cluster2 and then Cluster2 Ambassador will route the traffic to the target pod in Cluster2.

!!! note
    If only one cluster is used in a DLT/Blockchain network, Ambassador may not be needed, but it will still be installed (if chosen).


## HAProxy Ingress
[HAProxy Ingress Controller](https://haproxy-ingress.github.io/) is an open-source solution designed to simplify the management of external access to services running in Kubernetes clusters. As a Kubernetes Ingress controller, HAProxy acts as a smart entry point for incoming traffic, intelligently routing requests to appropriate services within the cluster. It provides a powerful and flexible way to expose and manage APIs, websites, and microservices, ensuring seamless communication between clients and applications.

This is implemented in Bevel Fabric from Release 0.3.0.0 onwards as we were unable to configure Ambassador Edge Stack to do ssl-passthrough for GRPC.

In Bevel, HAProxy Ingress does the same thing as Ambassador does i.e. it routes traffic amongst multiple K8s clusters. For each K8s cluster, an HAProxy Ingress Loadbalancer Service will be created (so please ensure the k8s cluster has access to public subnet). A user has to manually use a DNS server (e.g. AWS Route53) to map the public IP of the HAProxy Service to a DNS name for each cluster. 
Optionally, you can configure [External-DNS](https://github.com/kubernetes-sigs/external-dns) on the cluster and map the routes automatically. Automatic updation of routes via External DNS is supported from Bevel 0.3.0.0 onwards. 

!!! note
    If only one cluster is used in a DLT/Blockchain network, HAProxy may not be needed, but it will still be installed (if chosen).

## Istio
[Istio](https://istio.io/) is an open-source service mesh platform designed to facilitate the management and monitoring of microservices in Kubernetes environments. As organizations adopt microservices architecture, managing the complexity of service-to-service communication becomes challenging. Istio provides a comprehensive solution by adding a dedicated infrastructure layer, the service mesh, that handles communication, security, traffic routing, and observability across microservices.

Istio has been introduced in Bevel with the support for [bevel-operator-fabric](https://github.com/hyperledger/bevel-operator-fabric) and is used in the same way as for Ambassador or HAProxy. 
