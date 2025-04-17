# templates/_helpers.tpl
{{/* Common names */}}
{{- define "my-postgres.fullname" -}}
{{- printf "%s-postgres" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Common labels */}}
{{- define "my-postgres.labels" -}}
helm.sh/chart: {{ .Chart.Name }}
app.kubernetes.io/name: {{ include "my-postgres.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* Selector labels */}}
{{- define "my-postgres.selectorLabels" -}}
app.kubernetes.io/name: {{ include "my-postgres.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}