{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "corda-node.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "corda-node.fullname" -}}
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
{{- define "corda-node.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "corda-node.doormanDomain" -}}
{{- $url := .Values.nodeConf.doormanURL -}}
{{- $urlParts := splitList "//" $url -}}
{{- $protocol := index $urlParts 0 -}}
{{- $domainParts := splitList "/" (index $urlParts 1) -}}
{{- index $domainParts 0 -}}
{{- end -}}

{{- define "corda-node.nmsDomain" -}}
{{- $url := .Values.nodeConf.networkMapURL -}}
{{- $urlParts := splitList "//" $url -}}
{{- $protocol := index $urlParts 0 -}}
{{- $domainParts := splitList "/" (index $urlParts 1) -}}
{{- index $domainParts 0 -}}
{{- end -}}
