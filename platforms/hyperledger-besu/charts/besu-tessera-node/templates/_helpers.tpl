{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "besu-tessera-node.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "besu-tessera-node.fullname" -}}
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
{{- define "besu-tessera-node.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create tessera url depending on tls mode
*/}}
{{- define "besu-tessera-node.tesseraURL" -}}
{{- $fullname := include "besu-tessera-node.fullname" . -}}
{{- $port := .Values.tessera.port | int -}}
{{- $extport := .Values.global.proxy.tmport | int -}}
{{- if eq .Values.tessera.tlsMode "STRICT" -}}
{{- if eq .Values.global.proxy.provider "ambassador" -}}
    {{- printf "https://%s.%s:%d" .Release.Name .Values.global.proxy.externalUrlSuffix $extport | quote }}
{{- else -}}
    {{- printf "https://%s.%s:%d" $fullname .Release.Namespace $port | quote }}
{{- end -}}
{{- else -}}
{{- if eq .Values.global.proxy.provider "ambassador" -}}
    {{- printf "http://%s.%s:%d" .Release.Name .Values.global.proxy.externalUrlSuffix $extport | quote }}
{{- else -}}
    {{- printf "http://%s.%s:%d" $fullname .Release.Namespace $port | quote }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Client URL is defaulted to http; tls certificates need to be checked for using https
*/}}
{{- define "besu-tessera-node.clientURL" -}}
{{- $fullname := include "besu-tessera-node.fullname" . -}}
{{- $port := .Values.tessera.q2tport | int -}}
{{- printf "http://%s.%s:%d" $fullname .Release.Namespace $port | quote }}
{{- end -}}
