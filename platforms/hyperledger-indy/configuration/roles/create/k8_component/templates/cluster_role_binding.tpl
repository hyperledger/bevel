apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: {{ component_name }}-role-binding
  namespace: {{ component_namespace }}
  labels:
    organization: {{ organization }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:auth-delegator
subjects:
- kind: ServiceAccount
  name: {{ component_name }}
  namespace: {{ component_namespace }}
