# **Kubernetes Services** 

## **Container**
A [Docker Container](https://www.docker.com/resources/what-container) is an ephermeral running process that have all the necessary package dependencies within it. It differentiates from a [Docker Image](https://docs.docker.com/v17.09/engine/userguide/storagedriver/imagesandcontainers/#images-and-layers) that is a multi-layered file. A container is much more light-weighted, standalone and resuable compared to a Virtual Machine (VM).  

<br>

## **Cluster**
A cluster of containers is grouped by one or more running containers serving different purposes with their duplicates that can ensure high availability of services. One example of a cluster is [Docker Swarm](https://docs.docker.com/engine/swarm/).

<br>

## **Kubernetes**
[Kubernetes](https://kubernetes.io) (K8s) is an open-source system for automating deployment, scaling and maintaining containerized applications. Kubernetes provisions more advanced configurations and features to set up a cluster compared to Docker Swarm, which make it a very strong candidate in any production-scale environments.

## **Ambassador**
[Ambassador](https://www.getambassador.io/about/why-ambassador/) is an open-source microservices API gateway designed for K8s.

The Blockchain Automation Framework uses Ambassador to route traffic amongst multiple K8s clusters. For each K8s cluster, an Ambassador will be created to sit inside it. A user has to manually use a DNS server (e.g. AWS Route53) to map a public IP to a DNS name for the Ambassdor in each cluster, since this feature is not provisioned by the Blockchain Automation Framework. The reason is that feature like this should be provisioned in the infrastructure layer, where the Blockchain Automation Framework mainly focuses on the DLT platform layer sitting on the top.

Here simply explains how Ambassador works. If a pod in Cluster1 wants to reach a target pod in Cluster2, it will try to find the specific Ambassdor (via its DNS name or IP) in Cluster2 and then that Ambassador will route the traffic to the target pod in Cluster2. So, one might notice that the Ambassdor in Cluster1 does not get involved in this case.

Note, if only one cluster is used in a DLT network, Ambassador may not be needed, but it will still be installed as a tool by using the Blockchain Automation Framework.

<br>

## **Managed Kubernetes Services**
The open-source K8s services requires technicians to set up an underlying infrastructure and all initial K8s clusters, but the setting-up process is normally time-consuming and error-prone. This is why K8s is well known for its deep learning curves. To alleviate this complex process for users, many Cloud service providers such as [AWS](https://aws.amazon.com/eks/), [Azure](https://azure.microsoft.com/en-gb/services/kubernetes-service/) and [GCP](https://cloud.google.com/kubernetes-engine/) have provisioned their own Managed K8s Services.

The Blockchain Automation Framework leverages Kubernetes's various features for deploying a DLT network along with other required services in one or more K8s clusters. All the current functions have been tested on Amazon K8s Services (AKS) as a managed K8s service, but in theory they should work on a non-managed K8s service as well.