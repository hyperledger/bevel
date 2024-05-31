{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "fabric-channel-join.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fabric-channel-join.fullname" -}}
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
{{- define "fabric-channel-join.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create orderer tls configmap name depending on Configmap existance
*/}}
{{- define "fabric-channel-join.orderercrt" -}}
{{- $secret := lookup "v1" "ConfigMap" .Release.Namespace "orderer-tls-cacert" -}}
{{- if $secret -}}
{{/*
   Use this configmap
*/}}
{{- printf "orderer-tls-cacert" -}}
{{- else -}}
{{/*
    Use the release configmap
*/}}
{{- printf "%s-orderer-tls-cacert" $.Values.peer.name -}}
{{- end -}}
{{- end -}}
