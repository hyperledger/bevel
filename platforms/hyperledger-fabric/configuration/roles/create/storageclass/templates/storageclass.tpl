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
