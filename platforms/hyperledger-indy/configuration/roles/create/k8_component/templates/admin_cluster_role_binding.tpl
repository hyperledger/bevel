apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: {{ component_name }}-cluster-admin-role-binding
  namespace: {{ component_namespace }}
  labels:
    organization: {{ organization }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: {{ component_name }}
  namespace: {{ component_namespace }}
