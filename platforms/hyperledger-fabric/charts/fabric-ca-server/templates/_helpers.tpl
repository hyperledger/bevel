{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "fabric-ca-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fabric-ca-server.fullname" -}}
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
{{- define "fabric-ca-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "labels.deployment" -}}
{{- range $value := .Values.labels.deployment }}
{{ toYaml $value }}
{{- end }}
{{- end }}

{{- define "labels.service" -}}
{{- range $value := .Values.labels.service }}
{{ toYaml $value }}
{{- end }}
{{- end }}

{{- define "labels.pvc" -}}
{{- range $value := .Values.labels.pvc }}
{{ toYaml $value }}
{{- end }}
{{- end }}

{{/*
Create server url depending on proxy
*/}}
{{- define "fabric-ca-server.serverURL" -}}
{{- if eq .Values.global.proxy.provider "none" -}}
    {{- printf "ca.%s" .Release.Namespace }}
{{- else -}}
    {{- printf "ca.%s.%s" .Release.Namespace .Values.global.proxy.externalUrlSuffix }}
{{- end -}}
{{- end -}}
