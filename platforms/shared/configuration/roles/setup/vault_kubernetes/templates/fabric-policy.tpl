{% if component_type == 'orderer' %}
{
  "policy": "\npath \"{{ vault.secret_path | default(name)}}/data/crypto/ordererOrganizations/{{ component_ns }}/*\" {
    \ncapabilities = [\"list\", \"read\", \"create\", \"update\"]\n
  }
  \npath \"{{ vault.secret_path | default(name)}}/*\" {
    \ncapabilities = [\"list\"]\n
  }
  \npath \"{{ vault.secret_path | default(name)}}/data/crypto/peerOrganizations/*\" {
    \ncapabilities = [\"deny\"]\n
  }
  \npath \"{{ vault.secret_path | default(name)}}/data/credentials/{{ component_ns }}/*\" {
    \ncapabilities = [\"list\", \"read\", \"create\", \"update\"]\n
  }"
}
{% endif %}

{% if component_type == 'peer' %}
{
  "policy": "\npath \"{{ vault.secret_path | default(name)}}/*\" {
    \ncapabilities = [\"list\"]\n
  }
  \npath \"{{ vault.secret_path | default(name)}}/data/crypto/ordererOrganizations/*\" {
    \ncapabilities = [\"deny\"]\n
  }
  \npath \"{{ vault.secret_path | default(name)}}/data/credentials/{{ component_ns }}/*\" {
    \ncapabilities = [\"list\", \"read\", \"create\", \"update\"]\n
  }
  \npath \"{{ vault.secret_path | default(name)}}/data/crypto/peerOrganizations\" {
    \ncapabilities = [\"deny\"]\n
  }
  \npath \"{{ vault.secret_path | default(name)}}/data/crypto/peerOrganizations/{{ component_ns }}/*\" {
    \ncapabilities = [\"list\", \"read\", \"create\", \"update\"]\n
  }"
}
{% endif %}
