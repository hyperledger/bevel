{{- define "labels.custom" }}
  {{ range $key, $val := $.Values.metadata.labels }}
  {{ $key }}: {{ $val }}
  {{ end }}
{{- end }}

{{- define "application.labels" }}
  app.kubernetes.io/managed-by: {{ .Release.Service }}
  app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}