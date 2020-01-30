#!/bin/bash

xterm -title "Docker Pool Setup" -hold -e "./pool-setup.sh" &
xterm -title "Indy Pool Transactions" -hold -e "./indy-ledger.sh vault_addr vault_token admin_path admin_name identity_path identity_name identity_role pool_genesis_path"

#Replace the above arguments with actual values
