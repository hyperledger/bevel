# Default values for ambassador.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

# Manually set metadata for the Release.
#
# Defaults to .Chart.Name
nameOverride: edge-stack
# Defaults to .Release.Name-.Chart.Name unless .Release.Name contains "ambassador"
fullnameOverride: ''
# Defaults to .Release.Namespace
namespaceOverride: ''

# Emissary Chart Values.
emissary-ingress:
  service:
{% if network.type == 'indy' %}
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
      service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
      service.beta.kubernetes.io/aws-load-balancer-eip-allocations: "{{ elastic_ip }}"
{% endif %}
    type: LoadBalancer

    # Note that target http ports need to match your ambassador configurations service_port
    # https://www.getambassador.io/reference/modules/#the-ambassador-module
    ports:
    - name: http
      port: 80
      targetPort: 8080
    - name: https
      port: 443
      targetPort: 8443
{% for port in ports or [] %}
    - name: tcp-{{ port }}
      port: {{ port | int }}
      targetPort: {{ port | int }}
{% endfor %}
{% if (port_range_from is defined) and (port_range_to is defined)  %}
{% for port in range(port_range_from | int, port_range_to | int + 1) %}
    - name: tcp-{{ port }}
      port: {{ port }}
      targetPort: {{ port }}
{% endfor %}
{% endif %}
  adminService:
    # IP address to assign (if cloud provider supports it)
    loadBalancerIP:
    # Passed to cloud provider load balancer if created (e.g: AWS ELB)
    loadBalancerSourceRanges: {{ loadBalancerSourceRanges }}

  # Whether Emissary should be created with default listeners:
  # - HTTP on port 8080
  # - HTTPS on port 8443
  createDefaultListeners: true

################################################################################
## Ambassador Edge Stack Configuration                                        ##
################################################################################

# The Ambassador Edge Stack is free for limited use without a license key.
# Go to https://{ambassador-host}/edge_stack/admin/#dashboard to register
# for a community license key.

licenseKey:
  value:
  createSecret: true
  secretName:
  # Annotations to attach to the license-key-secret.
  annotations: {}

