#!/bin/bash
set -u
set -e

mkdir -p /var/lib/indy/keys/$INDY_NETWORK_NAME/keys/$INDY_NODE_NAME/public_keys /var/lib/indy/keys/$INDY_NETWORK_NAME/keys/$INDY_NODE_NAME/verif_keys
chown -R indy:indy /var/lib/indy/keys /var/lib/indy/keys/$INDY_NETWORK_NAME /var/lib/indy/keys/$INDY_NETWORK_NAME/keys /var/lib/indy/keys/$INDY_NETWORK_NAME/keys/$INDY_NODE_NAME /var/lib/indy/keys/$INDY_NETWORK_NAME/keys/$INDY_NODE_NAME/public_keys /var/lib/indy/keys/$INDY_NETWORK_NAME/keys/$INDY_NODE_NAME/verif_keys

if [[ ! -f "/var/lib/indy/keys/$INDY_NETWORK_NAME/keys/$INDY_NODE_NAME/public_keys/$INDY_NODE_NAME.key" ]]; then
  cp /var/lib/indy/keys/$INDY_NETWORK_NAME/keys/$INDY_NODE_NAME/public_keys/$INDY_NODE_NAME.key.bootstrap /var/lib/indy/keys/$INDY_NETWORK_NAME/keys/$INDY_NODE_NAME/public_keys/$INDY_NODE_NAME.key
fi

if [[ ! -f "/var/lib/indy/keys/$INDY_NETWORK_NAME/keys/$INDY_NODE_NAME/verif_keys/$INDY_NODE_NAME.key" ]]; then
  cp /var/lib/indy/keys/$INDY_NETWORK_NAME/keys/$INDY_NODE_NAME/verif_keys/$INDY_NODE_NAME.key.bootstrap /var/lib/indy/keys/$INDY_NETWORK_NAME/keys/$INDY_NODE_NAME/verif_keys/$INDY_NODE_NAME.key
fi

su indy

start_indy_node $INDY_NODE_NAME $INDY_NODE_IP $INDY_NODE_PORT $INDY_CLIENT_IP $INDY_CLIENT_PORT