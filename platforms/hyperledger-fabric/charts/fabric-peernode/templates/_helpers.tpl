{{- define "labels.custom" }}
  {{ range $key, $val := $.Values.metadata.labels }}
  {{ $key }}: {{ $val }}
  {{ end }}
{{- end }}

{{- define "labels.deployment" -}}
{{- if $.Values.labels }}
{{- range $key, $value := $.Values.labels.deployment }}
{{- range $k, $v := $value }}
  {{ $k }}: {{ $v | quote }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- define "labels.service" -}}
{{- if $.Values.labels }}
{{- range $key, $value := $.Values.labels.service }}
{{- range $k, $v := $value }}
  {{ $k }}: {{ $v | quote }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- define "labels.pvc" -}}
{{- if $.Values.labels }}
{{- range $key, $value := $.Values.labels.pvc }}
{{- range $k, $v := $value }}
  {{ $k }}: {{ $v | quote }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
