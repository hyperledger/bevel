{{/*
Create name to be used with deployment.
*/}}
{{- define "dscp-identity-service.fullname" -}}
    {{- if .Values.fullNameOverride -}}
        {{- .Values.fullNameOverride | trunc 63 | trimSuffix "-" | lower -}}
    {{- else -}}
      {{- $name := default .Chart.Name .Values.nameOverride -}}
      {{- if contains $name .Release.Name -}}
        {{- .Release.Name | trunc 63 | trimSuffix "-" | lower -}}
      {{- else -}}
        {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" | lower -}}
      {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "dscp-identity-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" | lower }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "dscp-identity-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dscp-identity-service.fullname" . }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dscp-identity-service.labels" -}}
helm.sh/chart: {{ include "dscp-identity-service.chart" . }}
{{ include "dscp-identity-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Conditionally populate imagePullSecrets if present in the context
*/}}
{{- define "dscp-identity-service.imagePullSecrets" -}}
  {{- if (not (empty .Values.image.pullSecrets)) }}
imagePullSecrets:
    {{- range .Values.image.pullSecrets }}
  - name: {{ . }}
    {{- end }}
  {{- end }}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "dscp-identity-service.postgresql.fullname" -}}
{{- if .Values.config.externalPostgresql -}}
{{ .Values.config.externalPostgresql | trimSuffix "-" -}}
{{- else if not ( .Values.postgresql.enabled ) -}}
{{ fail "Postgresql must either be enabled or passed via config.externalPostgresql" }}
{{- else if .Values.postgresql.fullnameOverride -}}
{{- .Values.postgresql.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Template to define the dscp-node hostname.
*/}}
{{- define "dscp-identity-service.node-host" -}}
  {{- if .Values.config.externalNodeHost -}}
    {{- .Values.config.externalNodeHost -}}
  {{- else if .Values.dscpNode.enabled -}}
    {{- template "dscp-node.fullname" .Subcharts.dscpNode -}}
  {{- else }}
    {{- fail "Must supply either externalNodeHost or enable dscpNode" -}}
  {{- end -}}
{{- end -}}

{{- define "dscp-identity-service.initDb.name" -}}
{{- if .Values.fullnameOverride -}}
{{- printf "%s-db" .Values.fullnameOverride | lower | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-db" .Release.Name .Chart.Name | lower | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
