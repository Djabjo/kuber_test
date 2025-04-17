{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "platform.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}


{{/*
Common labels
*/}}
{{- define "platform.labels" -}}
app.kubernetes.io/name: {{ include "platform.name" . }}
helm.sh/chart: {{ include "platform.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.labels }}
{{ toYaml .Values.labels }}
{{ end }}
{{- end -}}


{{/*
Create the name of the service account to use
*/}}
{{- define "platform.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "platform.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "platform.registrySecretName" -}}
{{- if .Values.global.registry.secretName -}}
{{- .Values.global.registry.secretName -}}
{{- else -}}
{{- printf "%s-dockerconfig" (.Release.Name | trunc 50 | trimSuffix "-") -}}
{{- end -}}
{{- end -}}

{{- define "platform.imagePullSecrets" -}}
{{- if .Values.global.registry.server -}}
imagePullSecrets:
    - name: {{ include "platform.registrySecretName" . }}
{{- end -}}
{{- end -}}
