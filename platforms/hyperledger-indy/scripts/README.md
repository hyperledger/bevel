[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## Hyperledger Bevel Indy scripts

The following scripts does the following:
- Setup a Hyperledger Indy cluster( with 4 nodes) on your machine.
- Install LibIndy and Indy Cli
- In Indy Cli , it creates a wallet, imports DID's and creates a sandbox environment.
- Furthur it sends a NYM transaction to the ledger and then queries the request from the ledger.

To setup, run the main script `indy-env-txn.sh`.
This script call the helper scripts `pool-setup.sh` and `pool-transaction.sh` for Indy Pool Setup and Ledger Transactions respectively.

**NOTE**: Run the script as a root user. 

PREREQUISITES:
To add user to docker group:

    sudo usermod -aG docker ${USER}
    su - ${USER}
    id -nG
