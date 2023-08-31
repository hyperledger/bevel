# This creates the host for TLS termination using provided tls certificate
---
apiVersion: getambassador.io/v3alpha1
kind: Host
metadata:
  name: ambassador-self-signed
  namespace: ambassador
spec:
  hostname: '*'
  acmeProvider:
    authority: none
  requestPolicy:
    insecure:
      action: Route
  tlsSecret:
    name: {{ ambassadorDefaultTlsSecretName }}
    namespace: {{ ambassadorDefaultTlsSecretNamespace }}
  tls:
    min_tls_version: v1.2
