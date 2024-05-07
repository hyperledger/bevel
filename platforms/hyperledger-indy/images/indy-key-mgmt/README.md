[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Hyperledger Bevel Indy bevel-indy-key-mgmt Docker image

Docker image for indy key management, which generates identity crypto and stores it into Vault or displays it onto the terminal in json format.

### Build
Ideally, the build of the image should be run from this directory.<br>
For build run command below:
```bash
docker build -t <docker_url>/bevel-indy-key-mgmt:1.12.1 .
```
*NOTE*: Version 1.12.1 is default version also for version of Hyperledger Indy in this Docker image.<br>
When you would like to use older version, then override build arguments.<br>
Example for use version 1.11.0:
```bash
docker build --build-arg INDY_NODE_VERSION=1.12.6 -t <docker_url>/bevel-indy-key-mgmt:1.12.6 .
```
#### Build arguments with default values
 - ROCKS_DB_VERSION=5.8.8
 - LIBINDY_CRYPTO_VERSION=0.4.5
 - INDY_NODE_VERSION=1.12.6

## How to use

In this Docker image is shell script generate_identity. The script can generate indy crypto and print it on console or put into Vault.

## generate_itentity script:
### Parameters:
| Parameter number | Default Value | Required | Description |
| --------- | ------------- | -------- | ----------- |
| 1 | | Yes | Name of identity. |
| 2 | | Yes | Vault path, where it will be saved in Vault and root structure in json output. |
| 3 | console | No | Target of generated crypto. Can by as "vault" or "console" |
| 4 | http://localhost:8200 | No | Address of vault server. |
| 5 | 1 | No |  Vault KV version |

### Example:
```bash
docker run -it --rm -e VAULT_TOKEN=<your_token> <docker_url>/bevel-indy-key-mgmt:1.12.1 generate_identity <your_identity_name> <your_vault_path> <your_target> http://<your_vault_address>:8200
```

Insert to vault:
```bash
docker run -it --rm -e VAULT_TOKEN="s.ev8ehHRFYgluTkVDYFH7X5vE" ghcr.io/hyperledger/bevel-indy-key-mgmt:1.12.6 generate_identity my-identity provider.stewards vault http://host.docker.internal:8200
```

Print on console:
```bash
docker run -it --rm  ghcr.io/hyperledger/bevel-indy-key-mgmt:1.12.6 bash -c "generate_identity my-identity provider.stewards | jq"
```
> You could use `| jq` for smooth printing of JSON

## Environment variables
| Variable | Default Value | Description |
| -------- | ------------- | ----------- |
| VAULT_TOKEN | Empty string | Token for access to Vault |
| VIRTUALENVWRAPPER_PYTHON |/usr/bin/python3 | Executable python binary path. |
| WORKON_HOME | $HOME/.virtualenvs | Directory for Python virtual environments. |
| ENABLE_STDOUT_LOG | True | Enables standard output. Use Python syntax of Boolean value. |
| LOG_ROTATION_BACKUP_COUNT | 10 | Count of records for backup rotation. |
| LEDGER_DIR | '/var/lib/indy/data' | Output directory for Ledger. |
| LOG_DIR | '/var/log/indy' | Output directory for logs. |
| KEYS_DIR | '/var/lib/indy/keys-ktb-demo-client' | Output directory for keys. |
| GENESIS_DIR | '/var/lib/indy/genesis-ktb-demo-client' | Output directory for Genesis. |
| BACKUP_DIR | '/var/lib/indy/backup' | Directory for backup. |
| PLUGINS_DIR | '/var/lib/indy/plugins' | Directory for Indy plugins. |
| NODE_INFO_DIR | '/var/lib/indy/data' | Output directory for Indy nodes. |
| NETWORK_NAME | 'udisp' | Network name for Indy and Python virtual environments name. |
| INDY_HOME | /opt/indy/ | Home directory for Indy. |
| INDY_CONFIG_DIR | /etc/indy/ | Directory for Indy configuration file. |
| NODES_COUNT | 4 | Count of Indy nodes |
| NODE_NAMES | "node1,node2,node3,node4" | Indy nodes' names. Use ',' as separator. |
| IPS | "node1,node2,node3,node4" | Ips address of Indy nodes. Use ',' as separator.|
| NODE_PORTS | "9701,9702,9703,9704" | Indy node ports. Use ',' as separator. |
| CLIENT_PORTS | "9705,9706,9707,9708| Indy clients ports. Use ',' as separator. |