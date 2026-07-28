{{- define "booking-service.name" -}}
booking-service
{{- end }}

{{- define "booking-service.fullname" -}}
{{ .Release.Name }}
{{- end }}