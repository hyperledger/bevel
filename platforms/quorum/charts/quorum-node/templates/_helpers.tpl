{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "quorum-node.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "quorum-node.fullname" -}}
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
{{- define "quorum-node.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create static nodes url depending on proxy
*/}}
{{- define "quorum-node.enodeURL" -}}
{{- $fullname := include "quorum-node.fullname" . -}}
{{- $port := .Values.node.quorum.p2p.port | int -}}
{{- $extport := .Values.global.proxy.p2p | int -}}
{{- if eq .Values.global.proxy.provider "ambassador" -}}
    {{- printf "%s.%s:%d" .Release.Name .Values.global.proxy.externalUrlSuffix $extport | quote }}
{{- else -}}
    {{- printf "%s-0.%s.%s.svc.cluster.local:%d" $fullname $fullname .Release.Namespace $port | quote }}
{{- end -}}
{{- end -}}
