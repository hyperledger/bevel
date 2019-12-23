kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: {{ component_name }}
provisioner: kubernetes.io/aws-ebs
reclaimPolicy: Delete
volumeBindingMode: Immediate
parameters:
  encrypted: "true"
{% if aws.encryption_key is defined %}
  kmsKeyId: {{ aws.encryption_key }}
{% endif %}
{% if aws.zone is defined %}
allowedTopologies:
  - matchLabelExpressions:
    - key: failure-domain.beta.kubernetes.io/zone
      values:
      - {{ aws.zone }}
{% endif %}
