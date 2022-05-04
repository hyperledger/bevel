{
    "display_name": "{{ item.name | lower }} MSP",
    "msp_id": "{{ item.name | lower }}MSP",
    "type": "msp",
    "admins": [],
    "root_certs": [
        "{{ ca_info.CAChain }}"
    ],
    "tls_root_certs": [
        "{{ ca_info.CAChain }}"
    ],
    "fabric_node_ous": {
        "admin_ou_identifier": {
            "certificate": "{{ ca_info.CAChain }}",
            "organizational_unit_identifier": "admin"
        },
        "client_ou_identifier": {
            "certificate": "{{ ca_info.CAChain }}",
            "organizational_unit_identifier": "client"
        },
        "enable": true,
        "orderer_ou_identifier": {
            "certificate": "{{ ca_info.CAChain }}",
            "organizational_unit_identifier": "orderer"
        },
        "peer_ou_identifier": {
            "certificate": "{{ ca_info.CAChain }}",
            "organizational_unit_identifier": "peer"
        }
    },
    "host_url": "https://{{ item.name }}console.{{ component_ns }}.{{ item.external_url_suffix }}",
    "name": "{{ item.name | lower }} MSP"
}
