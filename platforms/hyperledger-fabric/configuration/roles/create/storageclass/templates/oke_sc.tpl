apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: {{ sc_name }}
provisioner: blockvolume.csi.oraclecloud.com
volumeBindingMode: WaitForFirstConsumer
reclaimPolicy: Delete
