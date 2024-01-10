{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "bevel-storageclass.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bevel-storageclass.fullname" -}}
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
{{- define "bevel-storageclass.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "provisioner" -}}
{{- if eq .Values.global.cluster.provider "aws" }}
provisioner: kubernetes.io/aws-ebs
{{- else if eq .Values.global.cluster.provider "gcp" }}
provisioner: pd.csi.storage.gke.io
{{- else if eq .Values.global.cluster.provider "minikube" }}
provisioner: k8s.io/minikube-hostpath
{{- else if eq .Values.global.cluster.provider "azure" }}
provisioner: disk.csi.azure.com
{{- end -}}
{{- end -}}
