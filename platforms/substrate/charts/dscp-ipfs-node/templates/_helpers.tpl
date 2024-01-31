{{/*
Create name to be used with deployment.
*/}}
{{- define "dscp-ipfs.fullname" -}}
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
{{- define "dscp-ipfs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" | lower}}
{{- end }}

{{- define "dscp-ipfs-node.fullname" -}}
{{- if .Values.dscpNode.enabled -}}
{{- template "dscp-node.fullname" .Subcharts.dscpNode -}}
{{- end -}}
{{- end -}}

{{- define "dscp-ipfs.ipfsApiPort" -}}
{{- if .Values.config.ipfsApiPort -}}
{{- .Values.config.ipfsApiPort | quote -}}
{{- end -}}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "dscp-ipfs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dscp-ipfs.fullname" . }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dscp-ipfs.labels" -}}
helm.sh/chart: {{ include "dscp-ipfs.chart" . }}
{{ include "dscp-ipfs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
IPFS init container name
*/}}
{{- define "dscp-ipfs.initIpfsConfig.name" -}}
{{- if .Values.fullnameOverride -}}
{{- printf "%s-ipfs-config" .Values.fullnameOverride | lower | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-ipfs-config" .Release.Name .Chart.Name | lower | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Conditionally populate imagePullSecrets if present in the context
*/}}
{{- define "dscp-ipfs.imagePullSecrets" -}}
  {{- if (not (empty .Values.image.pullSecrets)) }}
imagePullSecrets:
    {{- range .Values.image.pullSecrets }}
  - name: {{ . }}
    {{- end }}
  {{- end }}
{{- end -}}
