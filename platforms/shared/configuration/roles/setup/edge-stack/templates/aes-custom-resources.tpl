# This creates the host for TLS termination using provided tls certificate
---
apiVersion: getambassador.io/v3alpha1
kind: Host
metadata:
  name: ambassador-self-signed
  namespace: {{ proxy_namespace }}
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
{% if network.type == 'indy' %}
---
apiVersion: getambassador.io/v3alpha1
kind: Module
metadata:
  name: ambassador-module
  namespace: {{ proxy_namespace }}
spec:
  config:
    use_proxy_proto: true
    use_remote_address: false
{% endif %}

