#!/bin/bash

mkdir vault-service
cd vault-service
wget https://releases.hashicorp.com/vault/1.0.3/vault_1.0.3_linux_amd64.zip
unzip vault_1.0.3_linux_amd64.zip -d .
sudo cp vault /usr/bin/htestello

sudo mkdir /etc/vault
sudo mkdir /opt/vault-data
sudo mkdir -p /logs/vault/	

cat <<EOF > config.json
{
"listener": [{
"tcp": {
"address" : "0.0.0.0:8200",
"tls_disable" : 1
}
}],
"storage": {
    "file": {
    "path" : "/opt/vault-data"
    }
 },
"max_lease_ttl": "10h",
"default_lease_ttl": "10h",
"ui":true
}
EOF

cat <<EOF > vault.service
  
[Unit]
Description=vault service
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault/config.json

[Service]
EnvironmentFile=-/etc/sysconfig/vault
Environment=GOMAXPROCS=2
Restart=on-failure
ExecStart=/usr/bin/vault server -config=/etc/vault/config.json
StandardOutput=/logs/vault/output.log
StandardError=/logs/vault/error.log
LimitMEMLOCK=infinity
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM

[Install]
WantedBy=multi-user.target
EOF

sudo mkdir /etc/vault
sudo mkdir /opt/vault-data
sudo mkdir -p /logs/vault/

sudo cp config.json /etc/vault/
sudo cp vault.service /etc/systemd/system/

sudo systemctl start vault.service