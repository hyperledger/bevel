{% if prometheus_port == '80' %}
---
apiVersion: getambassador.io/v3alpha1
kind: Mapping
metadata:
  name: {{ network.prometheus.prometheus_prefix }}-mapping
  namespace: default
spec:
  host: {{ network.prometheus.prometheus_prefix }}.{{ external_URL_suffix }}
  prefix: /
  service: prometheus-server:80

{% elif prometheus_port == '443' %}
---
apiVersion: getambassador.io/v3alpha1
kind: Host
metadata:
  name: {{ network.prometheus.prometheus_prefix }}-host
spec:
  hostname: {{ network.prometheus.prometheus_prefix }}.{{ external_URL_suffix }}
  acmeProvider:
    authority: none
  requestPolicy:
    insecure:
      action: Route
  tlsSecret:
    name: "fallback-self-signed-cert"
    namespace: "default"
---
apiVersion: getambassador.io/v3alpha1
kind: Mapping
metadata:
  name: {{ network.prometheus.prometheus_prefix }}-mapping
  namespace: default
spec:
  host: {{ network.prometheus.prometheus_prefix }}.{{ external_URL_suffix }}
  prefix: /
  service: prometheus-server:80

{% elif network.env.ambassadorPorts.portRange.from|int <= prometheus_port|int <= network.env.ambassadorPorts.portRange.to|int %}
---
apiVersion: getambassador.io/v3alpha1
kind: Listener
metadata:
  name: {{ network.prometheus.prometheus_prefix }}-listener
  namespace: default
spec:
  port: {{ prometheus_port }}
  protocol: TCP
  securityModel: XFP
  hostBinding:
    namespace:
      from: SELF
---
apiVersion: getambassador.io/v3alpha1
kind: TCPMapping
metadata:
  name: {{ network.prometheus.prometheus_prefix }}-tcpmapping
  namespace: default
spec:
  port: {{ prometheus_port }}
  service: prometheus-server:80
{% endif %}
