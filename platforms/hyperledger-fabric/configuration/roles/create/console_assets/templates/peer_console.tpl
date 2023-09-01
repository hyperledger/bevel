{
    "display_name": "{{ component_name }} - local",
    "grpcwp_url": "https://{{ peer.name }}-proxy.{{ component_ns }}.{{ item.external_url_suffix }}",
    "api_url": "grpcs://{{ peer.peerAddress }}",
    "operations_url": "http://{{ peer.name }}-ops.{{ component_ns }}.{{ item.external_url_suffix }}",
    "msp_id": "{{ item.name | lower }}MSP",
    "name": "{{ component_name }} - local",
    "type": "fabric-peer",
    "msp": {
        "component": {
            "admin_certs": [],
            "tls_cert": "{{ ca_info.CAChain }}"
        },
        "ca": {
            "root_certs": [
                "{{ ca_info.CAChain }}"
            ]
        },
        "tlsca": {
            "root_certs": [
                "{{ ca_info.CAChain }}"
            ]
        }
    },
    "pem": "{{ ca_info.CAChain }}",
    "tls_cert": "{{ ca_info.CAChain }}",
    "tls_ca_root_cert": "{{ ca_info.CAChain }}"
}
