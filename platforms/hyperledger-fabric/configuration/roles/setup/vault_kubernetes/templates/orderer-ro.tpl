path "secret/crypto/ordererOrganizations/{{ component_name }}/*" {
    capabilities = ["read", "list"]
}
path "secret/*" {
    capabilities = ["list"]
}
path "secret/crypto/peerOrganizations/*" {
    capabilities = ["deny"]
}
path "secret/credentials/{{ component_name }}/*" {
    capabilities = ["read", "list"]
}
