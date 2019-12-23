---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ca-tools-crypto-pvc
  namespace: {{ component_name }}
spec:
  storageClassName: {{ storage_class_name }}
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ca-tools-pvc
  namespace: {{ component_name }}
spec:
  storageClassName: {{ storage_class_name }}
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
