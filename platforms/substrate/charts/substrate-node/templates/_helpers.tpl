{{/* define deployment name */}}
{{- define "substrate_chart.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/* Selector labels */}}
{{- define "substrate_node.selectorLabels" }}
app.kubernetes.io/name: {{ include "substrate_chart.name" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{/* Service labels */}}
{{- define "substrate_node.serviceLabels" -}}
chain: {{ .Values.node.chain }}
release: {{ .Release.Name }}
role: {{ .Values.node.role }}
{{- end }}
