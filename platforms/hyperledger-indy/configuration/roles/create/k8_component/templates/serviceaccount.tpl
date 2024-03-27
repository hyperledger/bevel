apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ component_name }}
  namespace: {{ component_namespace }}
---
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: {{ component_name }}-token
  namespace: {{ component_namespace }}
  annotations:
    kubernetes.io/service-account.name: "{{ component_name }}"
