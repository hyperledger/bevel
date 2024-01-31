[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Indy RefApp

## Use case description
Welcome to the Indy Ref App which allows nodes to implement the concept of digital identities using blockchain.
There are 3 components
- Alice: Alice is the end user and a student.
- Faber: Faber is the university.
- Indy Webserver

In this usecase, Alice obtains a Credential from Faber College regarding the transcript. A connection is build between Faber College and Alice (onboarding process).Faber College creates and sends a Credential Offer to Alice. Alice creates a Credential Request and sends it to Faber College.Faber College creates the Credential for Alice. 
Alice now receives the Credential and stores it in her wallet.



## Pre-requisites
A network with 2 organizations:
- Authority
    - 1 Trustee
- University
    - 4 Steward nodes
    - 1 Endorser
A Docker repository


Find more at [Indy-Ref-App](https://github.com/hyperledger/bevel-samples/tree/main/examples/identity-app)
