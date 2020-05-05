{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
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
{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create unified labels for Grafana Loki components
*/}}
{{- define "common.matchLabels" -}}
app.kubernetes.io/name: {{ include "name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "common.metaLabels" -}}
helm.sh/chart: {{ include "chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "distributor.labels" -}}
{{ include "distributor.matchLabels" . }}
{{ include "common.metaLabels" . }}
{{- end -}}

{{- define "distributor.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.distributor.name }}
{{ include "common.matchLabels" . }}
{{- end -}}

{{- define "ingester.labels" -}}
{{ include "ingester.matchLabels" . }}
{{ include "common.metaLabels" . }}
{{- end -}}

{{- define "ingester.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.ingester.name }}
{{ include "common.matchLabels" . }}
{{- end -}}

{{- define "querier.labels" -}}
{{ include "querier.matchLabels" . }}
{{ include "common.metaLabels" . }}
{{- end -}}

{{- define "querier.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.querier.name }}
{{ include "common.matchLabels" . }}
{{- end -}}

{{- define "query_frontend.labels" -}}
{{ include "query_frontend.matchLabels" . }}
{{ include "common.metaLabels" . }}
{{- end -}}

{{- define "query_frontend.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.query_frontend.name }}
{{ include "common.matchLabels" . }}
{{- end -}}

{{- define "table_manager.labels" -}}
{{ include "table_manager.matchLabels" . }}
{{ include "common.metaLabels" . }}
{{- end -}}

{{- define "table_manager.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.table_manager.name }}
{{ include "common.matchLabels" . }}
{{- end -}}

{{- define "gateway.labels" -}}
{{ include "gateway.matchLabels" . }}
{{ include "common.metaLabels" . }}
{{- end -}}

{{- define "gateway.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.gateway.name }}
{{ include "common.matchLabels" . }}
{{- end -}}

{{/*
Create a fully qualified distributor name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "distributor.fullname" -}}
{{- if .Values.distributor.fullnameOverride -}}
{{- .Values.distributor.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.distributor.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.distributor.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified ingester name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "ingester.fullname" -}}
{{- if .Values.ingester.fullnameOverride -}}
{{- .Values.ingester.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.ingester.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.ingester.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified querier name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "querier.fullname" -}}
{{- if .Values.querier.fullnameOverride -}}
{{- .Values.querier.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.querier.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.querier.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified query_frontend name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "query_frontend.fullname" -}}
{{- if .Values.query_frontend.fullnameOverride -}}
{{- .Values.query_frontend.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.query_frontend.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.query_frontend.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified table_manager name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "table_manager.fullname" -}}
{{- if .Values.table_manager.fullnameOverride -}}
{{- .Values.table_manager.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.table_manager.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.table_manager.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified gateway name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "gateway.fullname" -}}
{{- if .Values.gateway.fullnameOverride -}}
{{- .Values.gateway.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.gateway.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.gateway.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}
