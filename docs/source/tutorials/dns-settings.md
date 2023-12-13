# How to configure DNS for Bevel

## DNS Update

Hyperledger Bevel uses [Ambassador Edge Stack](https://www.getambassador.io/products/edge-stack/api-gateway) or [HAProxy Ingress Controller](https://haproxy-ingress.github.io/) (for Fabric) for inter-cluster communication. 
Bevel automation can deploy either as per the configuration provided in the Bevel configuration file, but if you are not using [External DNS](#externaldns), you will have to manually add DNS entries.


* After Ambassador/HAProxy is deployed on the cluster (manually or using `platforms/shared/configuration/setup-k8s-environment.yaml` playbook), get the external IP address of the Ambassador/HAProxy service.

    ```
    kubectl get services -o wide
    ```
    The output of the above command will look like this:
    ![Ambassador Service Output](../_static/ambassador-service.png)

* Copy the **EXTERNAL-IP** for ambassador/ha-proxy service from the output.

!!! warning

    If Ambassador is configured by the playbook, then this configuration has to be done while the playbook is being executed, otherwise the deployment will fail.

* Configure your subdomain configuration to redirect the external DNS name to this external IP. For example, if you want to configure the external domain suffix as **test.corda.blockchaincloudpoc.com**, then update the DNS mapping to redirect all requests to ***.test.corda.blockchaincloudpoc.com** towards **EXTERNAL-IP** from above as an ALIAS.
In AWS Route53, the settings look like below (in Hosted Zones).
![Ambassador DNS Configuration](../_static/ambassador-dns.png)

!!! note

    Ambassador for AWS and AWS-baremetal expose Hyperledger Indy nodes via a TCP Network Load Balancer with a fixed IP address. The fixed IP address is used as EIP allocation ID for all steward public IPs found in the network.yaml. The same public IP is specified for all stewards within one organization. All ports used by Indy nodes in the particular organization have to be exposed.


<a name = "externaldns"></a>
## External DNS

In case you do not want to manually update the route configurations every time you change DNS name, you can use [External DNS](https://github.com/kubernetes-sigs/external-dns) for automatic updation of DNS routes. 
Follow the steps as per your cloud provider, and then use `external_dns: enabled` in the `env` section of the Bevel configuration file (network.yaml).

!!! note

    Detailed configuration for External DNS setup is not provided here, please refer the link above.
