{
  "policy": "path \"{{ vault.secret_path | default('secretsv2') }}/data/{{ component_ns }}/crypto/*\" {
    capabilities = [\"read\", \"list\", \"create\", \"update\"]
  }
  path \"{{ vault.secret_path | default('secretsv2') }}/data/{{ component_ns }}/smartContracts/*\" {
    capabilities = [\"read\", \"list\"]
  }"
}
