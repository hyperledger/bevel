apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  annotations:
    flux.weave.works/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}
  chart:
    path: {{ chart_path }}/{{ chart }}
    git: {{ gitops.git_ssh }}
    ref: {{ gitops.branch }}
  values:
    metadata:
      namespace: {{ component_ns }}
      name: {{ component_name }}
    organization:
      name: {{ organization.name }}
    image:
      pullSecret: regcred
      init:
        name: {{ component_name }}-init
        repository: alpine:3.9.4
      server:
        name: {{ component_name }}
        repository: {{ network.docker.url }}/von-network-base:{{ network.version }}
    service:
      port: {{ component_port }}
    vault:
      address: {{ vault.url }}
      serviceAccountName: {{ service_account }}
      authPath: {{ auth_method_path }}
      trusteeName: {{ trustee_name }}
      role: ro
    storage:
      size: 128Mi
      className: {{ organization.name }}-{{ organization.cloud_provider }}-storageclass
    proxy:
{% if organization.cloud_provider == 'minikube' %}     
      provider: "minikube"
      external_url: 
      port: {{ trustee.server.ambassador }}
{% else %}      
      provider: "ambassador"
      external_url: {{ component_name }}.{{ organization.external_url_suffix }}
      port: {{ trustee.server.ambassador }}
{% endif %}
