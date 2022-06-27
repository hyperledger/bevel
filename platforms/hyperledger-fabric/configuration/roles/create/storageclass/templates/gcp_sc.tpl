apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: {{ sc_name }}
provisioner: kubernetes.io/gce-pd
reclaimPolicy: Delete
volumeBindingMode: "WaitForFirstConsumer"
allowVolumeExpansion: true
parameters:
  type: pd-standard
  fstype: ext4
  replication-type: none
