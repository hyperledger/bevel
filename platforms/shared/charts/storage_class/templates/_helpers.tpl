{{- define "provisioner" -}}
{{- if eq .Values.cloud_provider "aws" }}
provisioner: ebs.csi.aws.com
{{- else if eq .Values.cloud_provider "gcp" }}
provisioner: gce.csi.google.com
{{- else if eq .Values.cloud_provider "minikube" }}
provisioner: k8s.io/minikube-hostpath
{{- end -}}
{{- end -}}
