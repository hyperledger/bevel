global:
  cluster:
    provider: "{{ cloud_provider }}"
reclaimPolicy: Delete
volumeBindingMode: Immediate
{% if cloudProvider == "aws" %}
provisioner: kubernetes.io/aws-ebs
{% elif cloudProvider == "gcp" %}
provisioner: pd.csi.storage.gke.io
{% elif cloudProvider == "minikube" %}
provisioner: k8s.io/minikube-hostpath
{% endif %}
{% if cloudProvider == "aws" %}
allowedTopologies:
  enabled: false
  matchLabelExpressions:
    - key: failure-domain.beta.kubernetes.io/zone
      values:
        - "{{ region }}a"
{% endif %}
