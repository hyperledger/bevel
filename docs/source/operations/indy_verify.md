# Verify that Indy DLT/Blockchain network is working
1. Recommend you to go through the [Flux Troubleshooting Guide](./flux_troubleshooting.md), before you start your network deployment.
2. Then, you need to verify that network is successfully configured as mentioned in [setting_dlt.md](./setting_dlt.md).
3. Verify that there are no errors in the logs of Indy Nodes (running as pods on your k8s cluster).
4. You can find the generated pool-genesis inside your release folder under <organization>-ptg folder as pool_genesis.yaml. Copy the genesis to a seperate file inside the build folder and use that file to connect to your indy pool.
5. Install Indy CLI. Readme how to install and use indy CLI is [here](https://github.com/hyperledger/indy-sdk/tree/master/cli).
6. Connect to your pool using Indy CLI to verify your installation.
```bash
> indy-cli
indy> pool create <POOL-NAME> gen_txn_file=<PATH-TO-YOUR-GENESIS>
indy> pool connect <POOL-NAME>
```

> **_NOTE:_** The ports mentioned in the genesis file should be open.

If the connection is successful, Congratulation!!! you have deployed an Indy DLT Network sucessfully.
