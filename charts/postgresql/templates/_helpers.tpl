{{- define "my-postgres.fullname" -}}
{{- $root := . -}}
{{- printf "%s-%s" $.Release.Name $root.Values.bot.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Common labels */}}
{{- define "my-postgres.labels" -}}
team: bot
app.kubernetes.io/name: {{ include "my-postgres.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
helm.sh/chart: {{ include "my-postgres.chart" . }}
app.kubernetes.io/version: {{ .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
{{- define "my-postgres.chart" -}}{{ .Chart.Name }}{{- end -}}