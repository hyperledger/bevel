# Supplychain

## Use case description
Welcome to the Supply Chain application which allows nodes to track products or goods along their chain of custody,
providing everyone along the way with relevant data to their product. The implementation has been done for Hyperledger Fabric and R3 Corda. The two will slightly differ in behavior but follow the same principles. There are two types are items that can be tracked, products and containers. Products are defined as such:


| Field       | Description                 |
|-------------|-----------------------------|
| trackingID  | which is a predefined unique ID, also a UUID, which is directly extracted from a <br>QR code.|
| participants| List of parties that will be in the chain of custody for the given product (extracted<br>                 from QR code) |
|custodian    | Party details of the current holder of the good.. This is changed to null when items<br>                  are scanned out of possession and set to new  owner upon scanning into possession<br>                       at next node |
|health       | Data from IOT sensors regarding condition of good (might only store min, max,<br>                     average values  which are stored on the local device until custodian changes or<br>                         something to minimize constant state changes) NOTE: This value is obsolete and not<br>                      used right now, it'll remain for future updates. |
| productName | Item name extracted from the QR|
| timestamp | Time at which most recent change of hands occurred |
| misc | Other data which is configurable and is being mapped from QR code |
|containerID | ID of any outer containing box. If null, behave normally. If container exists,<br>                   then custodian should be null and actually be read from the ContainerState |


The creator of the product will be marked as its initial custodian.  As a custodian, a node is able to package and unpackage goods. Packaging a good
stores an item in an existing ContainerState structured as such:

| Field       | Description        |
|-------------|-------------|
| trackingID | which is a predefined unique ID which is directly extracted from a QR code |
| participants | List of parties that will be in the chain of custody for the given product<br>                             (extracted from QR code) |
| custodian | Party details of the current holder of the good.. This is changed to null when items<br>                  are scanned out of possession and set to new  owner upon scanning into possession <br>                      at next node|
| health| Data from IOT sensors regarding condition of good (might only store min, max, average<br>                  values which are stored on the local device until custodian changes or something to<br>                     minimize constant state changes) NOTE: This value is obsolete and not used right now,<br>                   it'll remain for future updates. |
| timestamp| Time at which most recent change of hands occurred |
| misc | other data which is configurable and is being mapped from QR code |
| containerID | ID of any outer containing box. If null, behave normally. If container exists, then <br>                    custodian should be null and actually be read from the ContainerState |
| contents |  list of linearIDs for items contained inside |


Products being packaged will have their trackingID added to the contents list of the container. The Product will be
updated when its container is updated. If a product is contained it can no longer be handled directly (ie transfer ownership of a single product while still in a container with others).

Any of the participants can scan the QR code to claim custodianship.  History can be extracted via transactions stored on the ledger/ within the vault.

As mentioned before, items are identified by their QR code. These codes are meant to be generated about a product and used to
interact with a product. The QR will store a parsable JSON body with the following format:

| Field       | Description        |
|-------------|-------------|
| productName | Item name extracted from the QR
| trackingID | which is a predefined unique ID which is directly extracted from a QR code |
counterparties | List of parties that will be in the chain of custody for the given product (extracted <br>                 from QR code) |
| misc | other data which is configurable and is being mapped from QR code |

Also containers are identified by their QR code. These codes are meant to be generated about a container and use to interact with a container. The QR will store a parsable JSON body with the following format:

| Field       | Description        |
|-------------|-------------|
| trackingID | which is a predefined unique ID which is directly extracted from a QR code |
counterparties | List of parties that will be in the chain of custody for the given product (extracted<br>           from QR code)
| misc | other data which is configurable and is being mapped from QR code |
