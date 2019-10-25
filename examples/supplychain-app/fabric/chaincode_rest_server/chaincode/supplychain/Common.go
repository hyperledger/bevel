package supplychain

import (
	"bytes"
	"encoding/json"
	"fmt"
	. "github.com/chaincode/common"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

//updateState takes health and misc data and allows a user to update the trackingID
func (s *SmartContract) updateState(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	//get user identity
	identity, err := GetInvokerIdentity(stub)
	if err != nil {
		shim.Error(fmt.Sprintf("Error getting invoker identity: %s\n", err.Error()))
	}

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}

	//get request data fields for health,  misc, and location
	argBytes := []byte(args[1])
	var request UpdateRequest
	if err := json.Unmarshal(argBytes, &request); err != nil {
		return shim.Error(err.Error())
	}
	//get state by id as key
	existingsBytes, _ := stub.GetState(args[0])

	// return 404 is not found
	if len(existingsBytes) == 0 {
		return peer.Response{
			Status:  404,
			Message: fmt.Sprintf("Item with trackingID %s not found", args[0]),
		}
	}

	//variable declaration of new state value
	var newBytes []byte

	//try to unmarshal as product
	var productData Product
	err = json.Unmarshal(existingsBytes, &productData)
	//set new data
	productData.Health = request.Health
	productData.Metadata = request.Metadata

	if !(identity.Cert.Subject.String() == productData.Custodian) {
		return peer.Response{
			Status:  403,
			Message: fmt.Sprintf("You are not authorized to perform this transaction"),
		}
	}

	newBytes, _ = json.Marshal(productData)

	if err != nil {
		//retry with container
		var containerData Container
		err := json.Unmarshal(existingsBytes, &containerData)
		if err != nil {
			return shim.Error(err.Error())
		}
		containerData.Health = request.Health
		containerData.Metadata = request.Metadata

		//check is user is custodian
		if !(identity.Cert.Subject.String() == containerData.Custodian) {
			return peer.Response{
				Status:  403,
				Message: fmt.Sprintf("You are not authorized to perform this transaction"),
			}
		}
		newBytes, _ = json.Marshal(containerData)
	}

	if err := stub.PutState(request.ID, newBytes); err != nil {
		return shim.Error(err.Error())
	}

	s.logger.Infof("Updated state: %s\n", args[0])
	s.logger.Infof("New state: %s\n", newBytes)
	return shim.Success([]byte(args[0]))
}

//scan checks to see if state exists and whether it is owned by the current identity
func (s *SmartContract) scan(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	//get user identity
	identity, err := GetInvokerIdentity(stub)
	if err != nil {
		shim.Error(fmt.Sprintf("Error getting invoker identity: %s\n", err.Error()))
	}

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	//get state by id as key
	existingsBytes, _ := stub.GetState(args[0])
	var response map[string]interface{}
	// return 404 is not found
	if len(existingsBytes) == 0 {
		response = map[string]interface{}{
			"status": "new",
		}
		bytes, _ := json.Marshal(response)
		return shim.Success(bytes)
	}
	var owner string
	var product Product
	if err := json.Unmarshal(existingsBytes, &product); err != nil {
		var container Container
		if err := json.Unmarshal(existingsBytes, &container); err != nil {
			return shim.Error(err.Error())
		}
		owner = container.Custodian

	} else {
		owner = product.Custodian
	}
	if owner == identity.Cert.Subject.String() {
		response = map[string]interface{}{
			"status": "owned",
		}
	} else {
		response = map[string]interface{}{
			"status": "unowned",
		}
	}
	bytes, _ := json.Marshal(response)
	return shim.Success(bytes)

}

// getIdentity optains users current identity
func (s *SmartContract) getIdentity(stub shim.ChaincodeStubInterface) peer.Response {
	//get user identity
	identity, err := GetInvokerIdentity(stub)
	if err != nil {
		shim.Error(fmt.Sprintf("Error getting invoker identity: %s\n", err.Error()))
	}
	response := map[string]interface{}{}

	response["organization"] = identity.Cert.Subject.Organization[0]
	response["organizationUnit"] = identity.Cert.Subject.OrganizationalUnit

	bytes, _ := json.Marshal(response)
	return shim.Success(bytes)
}

//getHistory retrieves single items hsitory on the ledger
func (s *SmartContract) getHistory(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	// Get iterator for all history entries
	iterator, err := stub.GetHistoryForKey(args[0])
	if err != nil {
		shim.Error(fmt.Sprintf("Error getting state iterator: %s", err))
	}
	defer iterator.Close()

	// Create array
	var buffer bytes.Buffer
	var historyList []History
	buffer.WriteString("[")
	for iterator.HasNext() {
		record, iterErr := iterator.Next()
		if iterErr != nil {
			return shim.Error(fmt.Sprintf("Error accessing history: %s", err))
		}
		var historyItem History
		json.Unmarshal(record.Value, &historyItem)
		if !(isInHistory(historyList, historyItem)) {
			historyList = append(historyList, historyItem)
			historyAsBytes, _ := json.Marshal(historyItem)
			if buffer.Len() != 1 {
				buffer.WriteString(",")
			}
			buffer.WriteString(string(historyAsBytes))
		}
	}

	buffer.WriteString("]")

	return shim.Success(buffer.Bytes())
}

//helper to check if in history
func isInHistory(list []History, item History) bool {
	for _, v := range list {
		if v == item {
			return true
		}
	}
	return false
}
