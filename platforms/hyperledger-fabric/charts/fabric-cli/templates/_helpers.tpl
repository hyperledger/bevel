{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "fabric-cli.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fabric-cli.fullname" -}}
{{- $name := default .Chart.Name -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-cli" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" $name .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "fabric-cli.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create orderer tls configmap name depending on Configmap existance
*/}}
{{- define "fabric-cli.orderercrt" -}}
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
{{- printf "%s-orderer-tls-cacert" .Release.Name -}}
{{- end -}}
{{- end -}}

{{/*
Peer name can be passed by Values or by Parent chart release name
*/}}
{{- define "fabric-cli.peername" -}}
{{- if .Values.peerName -}}
{{- printf .Values.peerName -}}
{{- else -}}
{{- printf .Release.Name -}}
{{- end -}}
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
