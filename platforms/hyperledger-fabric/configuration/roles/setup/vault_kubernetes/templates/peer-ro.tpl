path "{{ vault_secret_path }}/*" {
    capabilities = ["list"]
}
path "{{ vault_secret_path }}/data/crypto/ordererOrganizations/*" {
    capabilities = ["deny"]
}
path "{{ vault_secret_path }}/data/credentials/{{ component_name }}/*" {
    capabilities = ["read", "list"]
}
path "{{ vault_secret_path }}/data/crypto/peerOrganizations" {
capabilities = ["deny"]
}
path "{{ vault_secret_path }}/data/crypto/peerOrganizations/*" {
capabilities = ["deny"]
}
path "{{ vault_secret_path }}/data/crypto/peerOrganizations/{{ component_name }}/*" {
    capabilities = ["read", "list"]
}
path "{{ vault_secret_path }}/metadata/credentials/{{ component_name }}/*" {
    capabilities = ["read", "list"]
}