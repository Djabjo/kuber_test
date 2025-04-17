{{- define "my-bot.fullname" -}}
{{- $root := . -}}
{{- printf "%s-my-bot" $.Release.Name $root.Values.bot.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Common labels */}}
{{- define "my-bot.labels" -}}
team: bot
app.kubernetes.io/name: {{ include "my-bot.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
helm.sh/chart: {{ include "my-bot.chart" . }}
app.kubernetes.io/version: {{ .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
{{- define "my-bot.chart" -}}{{ .Chart.Name }}{{- end -}}


{{/* Selector labels */}}
{{- define "my-bot.selectorLabels" -}}
app.kubernetes.io/name: {{ include "my-bot.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}