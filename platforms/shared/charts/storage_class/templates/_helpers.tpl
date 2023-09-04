{{- define "provisioner" -}}
{{- if eq .Values.cloud_provider "aws" }}
provisioner: kubernetes.io/aws-ebs
{{- else if eq .Values.cloud_provider "gcp" }}
provisioner: gce.csi.google.com
{{- else if eq .Values.cloud_provider "minikube" }}
provisioner: k8s.io/minikube-hostpath
{{- else if eq .Values.cloud_provider "azure" }}
provisioner: disk.csi.azure.com
{{- end -}}
{{- end -}}
