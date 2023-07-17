apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ sc_name }}
  namespace: {{ org_name }}-{{ platform_suffix }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ sc_name }}
  interval: 1m
  chart:
    spec:
      chart: {{ charts_dir }}/storage_class 
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
  values:
    metadata:
      name: {{ sc_name }}
    cloud_provider: {{ cloudProvider }}
    reclaimPolicy: Delete
    volumeBindingMode: Immediate
    allowedTopologies:
      - matchLabelExpressions:
          - key: failure-domain.beta.kubernetes.io/zone
            values:
              - "{{ region }}a"
              - "{{ region }}b"
