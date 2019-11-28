# The Blockchain Automation Framework Indy indy-key-mgmt Docker image

Docker image for indy key management, which allows using commands in bash.

## How to use
By default is set CMD for `/bin/bash` with set up Python environment.

For running docker image with specify indy commands from shell script or etc, use with set up Python environments:

```bash
docker run -it --rm indy-key-mng bash -c "source /usr/local/bin/virtualenvwrapper.sh; workon <network_name>; init_indy_keys --name Alpha"
```
> If is using command above, then do not use environment variable as <network_name>.

## Environment variables
| Variable | Default Value | Description |
| -------- | ------------- | ----------- |
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