path "secret/*" {
    capabilities = ["list"]
}
path "secret/crypto/ordererOrganizations/*" {
    capabilities = ["deny"]
}
path "secret/credentials/{{ component_name }}/*" {
    capabilities = ["read", "list"]
}
path "secret/crypto/peerOrganizations" {
capabilities = ["deny"]
}
path "secret/crypto/peerOrganizations/*" {
capabilities = ["deny"]
}
path "secret/crypto/peerOrganizations/{{ component_name }}/*" {
    capabilities = ["read", "list"]
}
