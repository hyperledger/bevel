{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "node.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "node.fullname" -}}
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
{{- define "node.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create node url depending on proxy mode
*/}}
{{- define "node.URL" -}}
{{- $port := .Values.port | int -}}
{{- $extport := 443 | int -}}
{{- $protocal := "https://"  -}}
{{- if eq .Values.global.proxy.provider "ambassador" -}}
    {{- printf "https://%s.%s:%d" .Release.name .Values.global.proxy.externalUrlSuffix $extport }}
{{- else -}}
    {{- printf "http://%s.%s:%d" .Release.name .Release.Namespace $port }}
{{- end -}}
{{- end -}}
