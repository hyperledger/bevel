{{/*
Create name to be used with deployment.
*/}}
{{- define "vitalam-ipfs.fullname" -}}
    {{- if .Values.fullnameOverride -}}
        {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" | lower -}}
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
{{- define "vitalam-ipfs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" | lower}}
{{- end }}

{{- define "vitalam-ipfs-node.fullname" -}}
{{- if .Values.vitalamNode.enabled -}}
{{- template "vitalam-node.fullname" .Subcharts.vitalamNode -}}
{{- end -}}
{{- end -}}

{{- define "vitalam-ipfs.ipfsApiPort" -}}
{{- if .Values.config.ipfsApiPort -}}
{{- .Values.config.ipfsApiPort | quote -}}
{{- end -}}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "vitalam-ipfs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "vitalam-ipfs.fullname" . }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "vitalam-ipfs.labels" -}}
helm.sh/chart: {{ include "vitalam-ipfs.chart" . }}
{{ include "vitalam-ipfs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
IPFS init container name
*/}}
{{- define "vitalam-ipfs.initIpfsConfig.name" -}}
{{- if .Values.fullnameOverride -}}
{{- printf "%s-ipfs-config" .Values.fullnameOverride | lower | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-ipfs-config" .Release.Name .Chart.Name | lower | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Conditionally populate imagePullSecrets if present in the context
*/}}
{{- define "vitalam-ipfs.imagePullSecrets" -}}
  {{- if (not (empty .Values.image.pullSecrets)) }}
imagePullSecrets:
    {{- range .Values.image.pullSecrets }}
  - name: {{ . }}
    {{- end }}
  {{- end }}
{{- end -}}
