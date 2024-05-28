{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "fabric-channel-create.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fabric-channel-create.fullname" -}}
{{- $name := default .Chart.Name -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" $name .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "fabric-channel-create.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "labels.deployment" -}}
{{- if $.Values.labels }}
{{- range $key, $value := $.Values.labels.deployment }}
{{- range $k, $v := $value }}
  {{ $k }}: {{ $v | quote }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- define "labels.service" -}}
{{- if $.Values.labels }}
{{- range $key, $value := $.Values.labels.service }}
{{- range $k, $v := $value }}
  {{ $k }}: {{ $v | quote }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- define "labels.pvc" -}}
{{- if $.Values.labels }}
{{- range $key, $value := $.Values.labels.pvc }}
{{- range $k, $v := $value }}
  {{ $k }}: {{ $v | quote }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
