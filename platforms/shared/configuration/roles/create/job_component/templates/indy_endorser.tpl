image:
  cli: ghcr.io/hyperledger/bevel-indy-ledger-txn:latest
  pullSecret:
network: bevel
admin: {{ trustee }}
newIdentity:
  name: {{ endorser }}
  role: ENDORSER
