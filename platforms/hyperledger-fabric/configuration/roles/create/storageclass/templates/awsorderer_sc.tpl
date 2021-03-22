kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: {{ sc_name }}
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
  encrypted: "true"
