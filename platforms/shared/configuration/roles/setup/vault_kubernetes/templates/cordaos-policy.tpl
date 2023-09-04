{
    "policy": "path \"{{ vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}/*\"{ 
        capabilities = [\"read\", \"list\", \"create\", \"update\"]
    }"
}
