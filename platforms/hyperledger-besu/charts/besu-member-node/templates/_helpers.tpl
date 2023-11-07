{{- define "labels.custom" }}
  {{ range $key, $val := $.Values.metadata.labels }}
  {{ $key }}: {{ $val }}
  {{ end }}
{{- end }}

{{- define "metrics_port" }}
  {{- if .Values.metrics.port }}
  {{- .Values.metrics.port -}}
  {{- else -}}
  {{- printf "9545" -}}
  {{- end -}}
{{- end }}
