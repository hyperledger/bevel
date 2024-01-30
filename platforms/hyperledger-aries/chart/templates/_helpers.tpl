{{/*
Set a consistent name for the app.
*/}}
{{- define "aries-agent.app-name" -}}
{{ .Values.app.name }}{{ .Values.deploy.name.suffix }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "aries-agent.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Set the path of the file used for ACAPY_GENESIS_TRANSACTIONS_LIST env var.
*/}}
{{- define "aries-agent.config.transactions-list-file" -}}
{{ .Values.app.config.mountPath }}/{{ .Values.app.config.genesisFile }}
{{- end }}

{{/*
Controller labels
*/}}
{{- define "aries-agent.controllerLabels" -}}
app.kubernetes.io/env: {{ .Values.app.env }}
app.kubernetes.io/role: {{ .Values.controller.role }}
{{- end }}

{{/*
Allow for debugging in the main container be setting the command to sleep.
*/}}
{{- define "aries-agent.debug.command" -}}
- "sleep 1000"
{{- end }}

{{/*
Set a consistent name for resources deployed by this chart.
*/}}
{{- define "aries-agent.deploy-name" -}}
{{ .Values.deploy.name.prefix }}{{ .Values.deploy.name.suffix }}
{{- end }}

{{/*
Common env var for publicly available URL of genesis pool transactions JSON.
*/}}
{{- define "aries-agent.env.genesis" -}}
{{- $genesisURL := .Values.app.config.genesisURL | required ".Values.app.config.genesisURL is required." -}}
- name: ACAPY_GENESIS_URL
  value: "{{ $genesisURL }}"
{{- end }}

{{/*
Set a consistent name for resources deployed by this chart.
*/}}
{{- define "aries-agent.env.tails-server-base-url" -}}
{{- $tailsServerBaseURL := .Values.tails.serverBaseURL | required ".Values.tails.serverBaseURL is required." -}}
- name: ACAPY_TAILS_SERVER_BASE_URL
  value: "{{ $tailsServerBaseURL }}"
{{- end }}

{{/*
Set the command to be run by the "holder" agent.
*/}}
{{- define "aries-agent.holder.command" -}}
{{- if .Values.app.debugEnable -}}
{{- include "aries-agent.debug.command" . }}
{{- else -}}
{{- $webhookBaseURL := .Values.controller.webhookBaseURL | required ".Values.controller.webhookBaseURL is required." -}}
- $(echo aca-py start
  --admin '0.0.0.0' {{ .Values.service.holder.ports.admin }}
  --anoncreds-legacy-revocation accept
  --inbound-transport http '0.0.0.0' {{ .Values.service.holder.ports.http }}
  --jwt-secret ${WEBHOOK_JWT}
  --log-level {{ .Values.logLevel }}
  --monitor-revocation-notification
  --multitenant
  --multitenant-admin
  --outbound-transport http
  --public-invites
  --trace-tag acapy.events
  --trace-target log
  --wallet-name {{ .Values.wallet.holder.databaseSecret.databaseName }}
  --wallet-type askar
  --webhook-url {{ $webhookBaseURL }}/api/v1/holder);
{{- end }}
{{- end }}

{{/*
Set the env to be used by the "holder" agent.
*/}}
{{- define "aries-agent.holder.env" -}}
{{- $walletHost := .Values.wallet.host | required ".Values.wallet.host is required." -}}
- name: ACAPY_ADMIN_API_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.holder.secret.api" . }}
      key: admin-api-key
- name: ACAPY_ADMIN_INSECURE_MODE
  value: "false"
- name: ACAPY_AUTO_PROVISION
  value: "true"
- name: ACAPY_CREDENTIAL_STORE_NAME
  value: "{{ .Values.wallet.holder.credentialStoreName }}"
- name: ACAPY_DEBUG_CONNECTIONS
  value: "true"
- name: ACAPY_ENDPOINT
  value: "{{ .Values.service.holder.endpoint }}"
{{ include "aries-agent.env.genesis" . }}
- name: ACAPY_LABEL
  value: "{{ .Values.service.holder.label }}"
- name: ACAPY_LOG_LEVEL
  value: "{{ .Values.logLevel }}"
- name: ACAPY_MULTITENANCY_CONFIGURATION
  value: "{\"wallet_type\":\"askar-profile\",\"wallet_name\":\"{{ .Values.wallet.holder.databaseSecret.databaseName }}\"}"
{{ include "aries-agent.env.tails-server-base-url" . }}
- name: ACAPY_WALLET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.holder.secret.wallet" . }}
      key: verkey
- name: ACAPY_WALLET_SEED
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.holder.secret.wallet" . }}
      key: seed
- name: ACAPY_WALLET_STORAGE_CONFIG
  value: "{{ include "aries-agent.wallet.storage-config" . }}"
- name: ACAPY_WALLET_STORAGE_CREDS
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.holder.secret.database" . }}
      key: storage-creds
- name: ACAPY_WALLET_STORAGE_TYPE
  value: "{{ .Values.wallet.storageType }}"
- name: ACAPY_WALLET_TYPE
  value: "askar"
- name: ADMIN_PORT
  value: "{{ .Values.service.holder.ports.admin }}"
- name: AGENT_PORT
  value: "{{ .Values.service.holder.ports.http }}"
- name: POSTGRESQL_WALLET_ADMIN_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.holder.secret.database" . }}
      key: admin-password
- name: POSTGRESQL_HOST
  value: "{{ $walletHost }}"
- name: POSTGRESQL_WALLET_HOST
  value: "{{ $walletHost }}"
- name: POSTGRESQL_WALLET_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.holder.secret.database" . }}
      key: database-password
- name: POSTGRESQL_PORT
  value: "{{ .Values.wallet.port }}"
- name: POSTGRESQL_WALLET_PORT
  value: "{{ .Values.wallet.port }}"
- name: POSTGRESQL_WALLET_USER
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.holder.secret.database" . }}
      key: database-user
- name: WALLET_DID
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.holder.secret.wallet" . }}
      key: did
- name: WEBHOOK_JWT
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.holder.secret.api" . }}
      key: webhook-jwt
{{- end }}

{{/*
The 'name' label of the holder agent.
*/}}
{{- define "aries-agent.holder.labelName" -}}
name: {{ include "aries-agent.holder.name" . }}
{{- end }}

{{/*
Common labels plus "name" of the holder agent.
*/}}
{{- define "aries-agent.holder.labelsWithName" -}}
{{ include "aries-agent.labels" . }}
{{ include "aries-agent.holder.labelName" . }}
{{- end }}

{{/*
Set the name of resources created for the holder agent.
*/}}
{{- define "aries-agent.holder.name" -}}
{{ include "aries-agent.deploy-name" . }}-holder
{{- end }}

{{/*
Set the name of the secret used to store the admin API key for the holder agent.
*/}}
{{- define "aries-agent.holder.secret.api" -}}
{{ include "aries-agent.holder.name" . }}-api-key
{{- end }}

{{/*
Set the name of the secret used to store database credentials for the holder agent.
*/}}
{{- define "aries-agent.holder.secret.database" -}}
{{ include "aries-agent.holder.name" . }}-database
{{- end }}

{{/*
Set the name of the secret used to seed the wallet credential store.
*/}}
{{- define "aries-agent.holder.secret.wallet" -}}
{{ include "aries-agent.holder.name" . }}-wallet
{{- end }}

{{/*
Selector labels of the holder agent.
*/}}
{{- define "aries-agent.holder.selectorLabels" -}}
{{ include "aries-agent.selectorLabels" . }}
{{ include "aries-agent.holder.labelName" . }}
{{- end }}

{{/*
Combine the image name and tag into a single, consistent string.
*/}}
{{- define "aries-agent.image" -}}
{{ .Values.deploy.image.name }}:{{ .Values.deploy.image.tag }}
{{- end }}

{{/*
Set the command to be run by the "issuer" agent.
*/}}
{{- define "aries-agent.issuer.command" -}}
{{- if .Values.app.debugEnable -}}
{{- include "aries-agent.debug.command" . }}
{{- else -}}
{{- $webhookBaseURL := .Values.controller.webhookBaseURL | required ".Values.controller.webhookBaseURL is required." -}}
- $(echo aca-py start
  --admin '0.0.0.0' {{ .Values.service.issuer.ports.admin }}
  --anoncreds-legacy-revocation accept
  --auto-provision
  --emit-new-didcomm-prefix
  --inbound-transport http '0.0.0.0' {{ .Values.service.issuer.ports.http }}
  --log-level {{ .Values.logLevel }}
  --monitor-revocation-notification
  --notify-revocation
  --outbound-transport http
  --public-invites
  --trace-tag acapy.events
  --trace-target log
  --wallet-allow-insecure-seed
  --wallet-name {{ .Values.wallet.issuer.databaseSecret.databaseName }}
  --wallet-type askar
  --webhook-url {{ $webhookBaseURL }}/api/v1/issuer);
{{- end }}
{{- end }}

{{/*
Set the env to be used by the "issuer" agent.
*/}}
{{- define "aries-agent.issuer.env" -}}
{{- $walletHost := .Values.wallet.host | required ".Values.wallet.host is required." -}}
- name: ACAPY_ADMIN_API_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.issuer.secret.api" . }}
      key: admin-api-key
- name: ACAPY_ADMIN_INSECURE_MODE
  value: "false"
- name: ACAPY_AUTO_PROVISION
  value: "true"
- name: ACAPY_CREDENTIAL_STORE_NAME
  value: "{{ .Values.wallet.issuer.credentialStoreName }}"
- name: ACAPY_DEBUG_CONNECTIONS
  value: "true"
- name: ACAPY_ENDPOINT
  value: "{{ .Values.service.issuer.endpoint }}"
{{ include "aries-agent.env.genesis" . }}
- name: ACAPY_LABEL
  value: "{{ .Values.service.issuer.label }}"
- name: ACAPY_LOG_LEVEL
  value: "{{ .Values.logLevel }}"
- name: ACAPY_MULTITENANCY_CONFIGURATION
  value: "{\"wallet_type\":\"askar-profile\",\"wallet_name\":\"{{ .Values.wallet.issuer.databaseSecret.databaseName }}\"}"
- name: ACAPY_PUBLIC_INVITES
  value: "true"
{{ include "aries-agent.env.tails-server-base-url" . }}
- name: ACAPY_WALLET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.issuer.secret.wallet" . }}
      key: verkey
- name: ACAPY_WALLET_SEED
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.issuer.secret.wallet" . }}
      key: seed
- name: ACAPY_WALLET_STORAGE_CONFIG
  value: "{{ include "aries-agent.wallet.storage-config" . }}"
- name: ACAPY_WALLET_STORAGE_CREDS
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.issuer.secret.database" . }}
      key: storage-creds
- name: ACAPY_WALLET_STORAGE_TYPE
  value: "{{ .Values.wallet.storageType }}"
- name: ACAPY_WALLET_TYPE
  value: "askar"
- name: ADMIN_PORT
  value: "{{ .Values.service.issuer.ports.admin }}"
- name: AGENT_PORT
  value: "{{ .Values.service.issuer.ports.http }}"
- name: POSTGRESQL_WALLET_ADMIN_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.issuer.secret.database" . }}
      key: admin-password
- name: POSTGRESQL_WALLET_HOST
  value: "{{ $walletHost }}"
- name: POSTGRESQL_WALLET_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.issuer.secret.database" . }}
      key: database-password
- name: POSTGRESQL_WALLET_PORT
  value: "{{ .Values.wallet.port }}"
- name: POSTGRESQL_WALLET_USER
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.issuer.secret.database" . }}
      key: database-user
- name: WALLET_DID
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.issuer.secret.wallet" . }}
      key: did
{{- end }}

{{/*
The 'name' label of the issuer agent.
*/}}
{{- define "aries-agent.issuer.labelName" -}}
name: {{ include "aries-agent.issuer.name" . }}
{{- end }}

{{/*
Common labels plus "name" of the issuer agent.
*/}}
{{- define "aries-agent.issuer.labelsWithName" -}}
{{ include "aries-agent.labels" . }}
{{ include "aries-agent.issuer.labelName" . }}
{{- end }}

{{/*
Set the name of resources created for the issuer agent.
*/}}
{{- define "aries-agent.issuer.name" -}}
{{ include "aries-agent.deploy-name" . }}-issuer
{{- end }}

{{/*
Set the name of the secret used to store the admin API key for the issuer agent.
*/}}
{{- define "aries-agent.issuer.secret.api" -}}
{{ include "aries-agent.issuer.name" . }}-api-key
{{- end }}

{{/*
Set the name of the secret used to store database credentials for the issuer agent.
*/}}
{{- define "aries-agent.issuer.secret.database" -}}
{{ include "aries-agent.issuer.name" . }}-database
{{- end }}

{{/*
Set the name of the secret used to seed the wallet credential store.
*/}}
{{- define "aries-agent.issuer.secret.wallet" -}}
{{ include "aries-agent.issuer.name" . }}-wallet
{{- end }}

{{/*
Selector labels of the issuer agent.
*/}}
{{- define "aries-agent.issuer.selectorLabels" -}}
{{ include "aries-agent.selectorLabels" . }}
{{ include "aries-agent.issuer.labelName" . }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "aries-agent.labels" -}}
helm.sh/chart: {{ include "aries-agent.chart" . }}
{{ include "aries-agent.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ include "aries-agent.app-name" . }}
app.kubernetes.io/role: {{ .Values.app.role }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Define the livenessProbe used by each aries-agent container.
*/}}
{{- define "aries-agent.probe.liveness" -}}
livenessProbe:
  periodSeconds: 60
  timeoutSeconds: 30
  initialDelaySeconds: 300
  exec:
    command:
      - bash
      - "-c"
      - 'curl --fail "http://localhost:${ADMIN_PORT}/status/live"'
{{- end }}

{{/*
Define the readinessProbe used by each aries-agent container.
*/}}
{{- define "aries-agent.probe.readiness" -}}
readinessProbe:
  periodSeconds: 60
  timeoutSeconds: 30
  initialDelaySeconds: 3
  exec:
    command:
      - bash
      - "-c"
      - 'curl --fail "http://localhost:${ADMIN_PORT}/status/ready"'
{{- end }}

{{/*
Selector labels
*/}}
{{- define "aries-agent.selectorLabels" -}}
app.kubernetes.io/env: {{ .Values.app.env }}
app.kubernetes.io/group: {{ .Values.app.group }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/name: {{ include "aries-agent.app-name" . }}
{{- end }}

{{/*
Set the command to be run by the "verifier" agent.
*/}}
{{- define "aries-agent.verifier.command" -}}
{{- if .Values.app.debugEnable -}}
{{- include "aries-agent.debug.command" . }}
{{- else -}}
{{- $webhookBaseURL := .Values.controller.webhookBaseURL | required ".Values.controller.webhookBaseURL is required." -}}
- $(echo aca-py start
  --admin '0.0.0.0' {{ .Values.service.verifier.ports.admin }}
  --anoncreds-legacy-revocation accept
  --auto-provision
  --emit-new-didcomm-prefix
  --inbound-transport http '0.0.0.0' {{ .Values.service.verifier.ports.http }}
  --log-level {{ .Values.logLevel }}
  --monitor-revocation-notification
  --notify-revocation
  --outbound-transport http
  --public-invites
  --trace-target log
  --trace-tag acapy.events
  --wallet-name {{ .Values.wallet.verifier.databaseSecret.databaseName }}
  --wallet-type askar
  --webhook-url {{ $webhookBaseURL }}/api/v1/verifier);
{{- end }}
{{- end }}

{{/*
Set the env to be used by the "verifier" agent.
*/}}
{{- define "aries-agent.verifier.env" -}}
{{- $walletHost := .Values.wallet.host | required ".Values.wallet.host is required." -}}
- name: ACAPY_ADMIN_API_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.verifier.secret.api" . }}
      key: admin-api-key
- name: ACAPY_ADMIN_INSECURE_MODE
  value: "false"
- name: ACAPY_AUTO_PROVISION
  value: "true"
- name: ACAPY_CREDENTIAL_STORE_NAME
  value: "{{ .Values.wallet.verifier.credentialStoreName }}"
- name: ACAPY_DEBUG_CONNECTIONS
  value: "true"
- name: ACAPY_ENDPOINT
  value: "{{ .Values.service.verifier.endpoint }}"
{{ include "aries-agent.env.genesis" . }}
- name: ACAPY_LABEL
  value: "{{ .Values.service.verifier.label }}"
- name: ACAPY_LOG_LEVEL
  value: "{{ .Values.logLevel }}"
- name: ACAPY_MULTITENANCY_CONFIGURATION
  value: "{\"wallet_type\":\"askar-profile\",\"wallet_name\":\"{{ .Values.wallet.verifier.databaseSecret.databaseName }}\"}"
- name: ACAPY_PUBLIC_INVITES
  value: "true"
{{ include "aries-agent.env.tails-server-base-url" . }}
- name: ACAPY_WALLET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.verifier.secret.wallet" . }}
      key: verkey
- name: ACAPY_WALLET_SEED
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.verifier.secret.wallet" . }}
      key: seed
- name: ACAPY_WALLET_STORAGE_CONFIG
  value: "{{ include "aries-agent.wallet.storage-config" . }}"
- name: ACAPY_WALLET_STORAGE_CREDS
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.verifier.secret.database" . }}
      key: storage-creds
- name: ACAPY_WALLET_STORAGE_TYPE
  value: "{{ .Values.wallet.storageType }}"
- name: ACAPY_WALLET_TYPE
  value: "askar"
- name: ADMIN_PORT
  value: "{{ .Values.service.verifier.ports.admin }}"
- name: AGENT_PORT
  value: "{{ .Values.service.verifier.ports.http }}"
- name: POSTGRESQL_WALLET_ADMIN_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.verifier.secret.database" . }}
      key: admin-password
- name: POSTGRESQL_WALLET_HOST
  value: "{{ $walletHost }}"
- name: POSTGRESQL_WALLET_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.verifier.secret.database" . }}
      key: database-password
- name: POSTGRESQL_WALLET_PORT
  value: "{{ .Values.wallet.port }}"
- name: POSTGRESQL_WALLET_USER
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.verifier.secret.database" . }}
      key: database-user
- name: WALLET_DID
  valueFrom:
    secretKeyRef:
      name: {{ include "aries-agent.verifier.secret.wallet" . }}
      key: did
{{- end }}

{{/*
The 'name' label of the verifier agent.
*/}}
{{- define "aries-agent.verifier.labelName" -}}
name: {{ include "aries-agent.verifier.name" . }}
{{- end }}

{{/*
Common labels plus "name" of the verifier agent.
*/}}
{{- define "aries-agent.verifier.labelsWithName" -}}
{{ include "aries-agent.labels" . }}
{{ include "aries-agent.verifier.labelName" . }}
{{- end }}

{{/*
Set the name of resources created for the verifier agent.
*/}}
{{- define "aries-agent.verifier.name" -}}
{{ include "aries-agent.deploy-name" . }}-verifier
{{- end }}

{{/*
Set the name of the secret used to store the admin API key for the verifier agent.
*/}}
{{- define "aries-agent.verifier.secret.api" -}}
{{ include "aries-agent.verifier.name" . }}-api-key
{{- end }}

{{/*
Set the name of the secret used to store database credentials for the verifier agent.
*/}}
{{- define "aries-agent.verifier.secret.database" -}}
{{ include "aries-agent.verifier.name" . }}-database
{{- end }}

{{/*
Set the name of the secret used to seed the wallet credential store.
*/}}
{{- define "aries-agent.verifier.secret.wallet" -}}
{{ include "aries-agent.verifier.name" . }}-wallet
{{- end }}

{{/*
Selector labels of the verifier agent.
*/}}
{{- define "aries-agent.verifier.selectorLabels" -}}
{{ include "aries-agent.selectorLabels" . }}
{{ include "aries-agent.verifier.labelName" . }}
{{- end }}

{{/*
Combine several variables into a single JSON data structure for wallet storage config.
*/}}
{{- define "aries-agent.wallet.storage-config" -}}
{{- $walletHost := .Values.wallet.host | required ".Values.wallet.host is required." -}}
{\"url\":\"{{ $walletHost }}:{{ .Values.wallet.port }}\",\"max_connections\":5,\"wallet_scheme\":\"MultiWalletSingleTable\"}
{{- end }}

