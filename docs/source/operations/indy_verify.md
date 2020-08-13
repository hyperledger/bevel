# Verify that Indy DLT/Blockchain network is working
1. You need to verify that network is successfully configured as mentioned in [setting_dlt.md](./setting_dlt.md).
2. Verify that there are no errors in the logs of stewards.
2. You can find the generated pool-genesis inside your release folder under <organization>-ptg folder as pool_genesis.yaml. Copy the genesis to a seperate file inside the build folder and use that file to connect to your indy pool.
3. Install Indy CLI. Readme how to install and use indy CLI is [here](https://github.com/hyperledger/indy-sdk/tree/master/cli).
4. Connect to your pool using Indy CLI to verify your installation.
```bash
> indy-cli
indy> pool create <POOL-NAME> gen_txn_file=<PATH-TO-YOUR-GENESIS>
indy> pool connect <POOL-NAME>
```

> **_NOTE:_** The ports mentioned in the genesis file should be open.

If the connection is successful, Congratulation!!! you have deployed an Indy DLT Network sucessfully.
