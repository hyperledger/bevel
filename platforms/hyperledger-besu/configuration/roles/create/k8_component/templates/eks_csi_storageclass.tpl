kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: {{ component_name }}
provisioner: ebs.csi.aws.com
reclaimPolicy: Delete
volumeBindingMode: Immediate
parameters:
  encrypted: "true"
