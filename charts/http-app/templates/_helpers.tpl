{{/*
Expand the name of the chart.
*/}}
{{- define "http-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "http-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "http-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "http-app.labels" -}}
helm.sh/chart: {{ include "http-app.chart" . }}
{{ include "http-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "http-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "http-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "http-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "http-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Deployment Annotations
*/}}
{{- define "http-app.deploymentAnnotations" -}}
{{- if .Values.opConnect.enabled -}}
operator.1password.io/item-path: {{ .Values.opConnect.item.path }}
operator.1password.io/item-name: {{ .Values.opConnect.item.name }}
{{- end -}}
{{ if .Values.deploymentAnnotations }}
{{ toYaml .Values.deploymentAnnotations }}
{{- end -}}
{{- end -}}
