{{/* define deployment name */}}
{{- define "substrate_node.name" }}
name: {{ .Values.node.name }}
{{- end }}


{{/* Selector labels */}}
{{- define "substrate_node.selectorLabels" }}
app.kubernetes.io/name: {{ .Values.node.name }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* Service labels */}}
{{- define "substrate_node.serviceLabels" -}}
chain: {{ .Values.node.chain }}
release: {{ .Release.Name }}
role: {{ .Values.node.role }}
{{- end }}
