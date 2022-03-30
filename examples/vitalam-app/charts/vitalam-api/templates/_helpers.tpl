{{/*
Create name to be used with deployment.
*/}}
{{- define "vitalam-api.fullname" -}}
    {{- if .Values.fullNameOverride -}}
        {{- .Values.fullNameOverride | trunc 63 | trimSuffix "-"| lower -}}
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
{{- define "vitalam-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" | lower }}
{{- end }}

{{/*
Template to define the vitalam-node hostname.
*/}}
{{- define "vitalam-api.node-host" -}}
  {{- if .Values.config.externalNodeHost -}}
    {{- .Values.config.externalNodeHost -}}
  {{- else if .Values.vitalamNode.enabled -}}
    {{- template "vitalam-node.fullname" .Subcharts.vitalamNode -}}
  {{- else if .Values.vitalamIpfs.vitalamNode.enabled -}}
    {{- template "vitalam-ipfs-node.fullname" .Subcharts.vitalamIpfs -}}
  {{- else }}
    {{- fail "Must supply either externalNodeHost or enable vitalamNode or vitalamIpfs" -}}
  {{- end -}}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "vitalam-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "vitalam-api.fullname" . }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "vitalam-api.labels" -}}
helm.sh/chart: {{ include "vitalam-api.chart" . }}
{{ include "vitalam-api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Conditionally populate imagePullSecrets if present in the context
*/}}
{{- define "vitalam-api.imagePullSecrets" -}}
  {{- if (not (empty .Values.image.pullSecrets)) }}
imagePullSecrets:
    {{- range .Values.image.pullSecrets }}
  - name: {{ . }}
    {{- end }}
  {{- end }}
{{- end -}}
