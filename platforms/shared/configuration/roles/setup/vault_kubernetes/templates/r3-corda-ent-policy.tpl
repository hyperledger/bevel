{
  "policy": "\npath \"{{ vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}/*\" {
    \ncapabilities = [\"list\", \"read\", \"create\", \"update\"]\n
  }"
}
