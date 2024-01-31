{
    "display_name": "{{ item.type }}ca - {{ item.name | lower }}",
    "api_url": "https://{{ item.ca_data.url }}",
    "operations_url": "http://ca-ops.{{ component_ns }}.{{ item.external_url_suffix }}",
    "ca_url": "https://{{ item.ca_data.url }}",
    "type": "fabric-ca",
    "ca_name": "ca.{{ component_ns }}",
    "tlsca_name": "ca.{{ component_ns }}",
    "tls_cert": "{{ ca_info.CAChain }}",
    "name": "{{ item.type }}ca - {{ item.name | lower }}"
}
