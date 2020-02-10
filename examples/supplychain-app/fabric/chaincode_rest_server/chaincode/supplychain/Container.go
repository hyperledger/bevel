package supplychain


import (
	"bytes"
	"encoding/json"
	"fmt"
	. "github.com/chaincode/common"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

// createContainer creates a new Container on the blockchain using the request body with the supplied ID
func (s *SmartContract) createContainer(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	identity, err := GetInvokerIdentity(stub)
	if err != nil {
		shim.Error(fmt.Sprintf("Error getting invoker identity: %s\n", err.Error()))
	}

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	// Create ContainerRequest struct from input JSON.
	argBytes := []byte(args[0])
	var request ContainerRequest
	if err := json.Unmarshal(argBytes, &request); err != nil {
		return shim.Error(err.Error())
	}

	//Check if product  state using id as key exsists
	testContainerAsBytes, err := stub.GetState(request.ID)
	if err != nil {
		return shim.Error(err.Error())
	}
	// Return 404 if result's empty
	if len(testContainerAsBytes) != 0 {
		return peer.Response{
			Status:  404,
			Message: fmt.Sprintf("Existing Container %s Found", args[0]),
		}
	}

	container := Container{
		ID:           request.ID,
		Type:         "container",
		Health:       "",
		Metadata:     request.Metadata,
		Location:     request.Location,
		ContainerID:  "",
		Custodian:    identity.Cert.Subject.String(),
		Timestamp:    int64(s.clock.Now().UTC().Unix()),
		Contents:     []string{},
		Participants: request.Participants,
	}

	container.Participants = append(container.Participants, identity.Cert.Subject.String())

	// Put new Container onto blockchain
	containerAsBytes, _ := json.Marshal(container)
	if err := stub.PutState(container.ID, containerAsBytes); err != nil {
		return shim.Error(err.Error())
	}

	response := map[string]interface{}{
		"generatedID": container.ID,
	}
	bytes, _ := json.Marshal(response)

	s.logger.Infof("Wrote Container: %s\n", container.ID)
	return shim.Success(bytes)
}

//getAllContainer retrieves all Container on the ledger
func (s *SmartContract) getAllContainer(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	//Get user identity
	identity, err := GetInvokerIdentity(stub)
	if err != nil {
		shim.Error(fmt.Sprintf("Error getting invoker identity: %s\n", err.Error()))
	}

	if len(args) != 0 {
		return shim.Error("Incorrect number of arguments. Expecting 0")
	}

	// Get iterator for all entries
	iterator, err := stub.GetStateByRange("", "")
	if err != nil {
		shim.Error(fmt.Sprintf("Error getting state iterator: %s", err))
	}
	defer iterator.Close()

	// Create array
	var buffer bytes.Buffer
	buffer.WriteString("[")
	for iterator.HasNext() {
		state, iterErr := iterator.Next()
		if iterErr != nil {
			return shim.Error(fmt.Sprintf("Error accessing state: %s", err))
		}

		// Don't return Container issuer isn't a party to
		var container Container
		err = json.Unmarshal(state.Value, &container)
		if err != nil && err.Error() != "Not a Container" {
			return shim.Error(err.Error())
		}
		if container.AccessibleBy(identity) {
			if buffer.Len() != 1 {
				buffer.WriteString(",")
			}
			buffer.WriteString(string(state.Value))
		}
	}
	buffer.WriteString("]")

	return shim.Success(buffer.Bytes())
}

//getSingleContainer retrieves single Container on the ledger by trackingID
func (s *SmartContract) getSingleContainer(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	//get user identity
	identity, err := GetInvokerIdentity(stub)
	if err != nil {
		shim.Error(fmt.Sprintf("Error getting invoker identity: %s\n", err.Error()))
	}

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	//get single state using id as key
	containerAsBytes, err := stub.GetState(args[0])
	if err != nil {
		return shim.Error(err.Error())
	}
	// Return 404 if result's empty
	if len(containerAsBytes) == 0 {
		return peer.Response{
			Status:  404,
			Message: fmt.Sprintf("Container %s Not Found", args[0]),
		}
	}

	//check to see if result is a Container or not and unmarsal if so
	var container Container
	err = json.Unmarshal(containerAsBytes, &container)
	if err != nil {
		return peer.Response{
			Status:  400,
			Message: fmt.Sprintf("Error: %s ", err),
		}
	}
	//check if user is allowed to see this Container
	if !container.AccessibleBy(identity) {
		return peer.Response{
			Status:  404,
			Message: fmt.Sprintf("Container %s Not Found", args[0]),
		}
	}
	return shim.Success(containerAsBytes)
}

//updateCustodian claims current user as the custodian
func (s *SmartContract) updateContainerCustodian(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	//get user identity
	identity, err := GetInvokerIdentity(stub)
	if err != nil {
		shim.Error(fmt.Sprintf("Error getting invoker identity: %s\n", err.Error()))
	}

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}
	trackingID := args[0]
	newLocation := args[1]
	newCustodian := identity.Cert.Subject.String()
	//get state by id as key
	existingsBytes, _ := stub.GetState(trackingID)

	// return 404 is not found
	if len(existingsBytes) == 0 {
		return peer.Response{
			Status:  404,
			Message: fmt.Sprintf("Item with trackingID %s not found", trackingID),
		}
	}

	//try to unmarshal as container
	var container Container
	err = json.Unmarshal(existingsBytes, &container)
	if err != nil {
		return shim.Error(err.Error())
	}
	//Ensure user is a participant
	if !(container.AccessibleBy(identity)) {
		return peer.Response{
			Status:  403,
			Message: fmt.Sprintf("You are not authorized to perform this transaction since container not accessible by identity"),
		}
	}
	//Ensure new custodian isnt the same as old one
	if newCustodian == container.Custodian {
		return peer.Response{
			Status:  403,
			Message: fmt.Sprintf("You are already custodian"),
		}
	}

	//make sure user cant claim a product separately from the container
	if container.ContainerID != "" {
		outercontainerBytes, _ := stub.GetState(container.ContainerID)
		var outercontainer Container
		err = json.Unmarshal(outercontainerBytes, &outercontainer)
		if err != nil {
			return shim.Error(err.Error())
		}
		if outercontainer.Custodian != newCustodian {
			return peer.Response{
				Status:  403,
				Message: fmt.Sprintf("Container needs to be unpackaged before claiming a new owner"),
			}
		}
	}

	//change custodian
	//container.Custodian = newCustodian
	//container.Location = newLocation
	//container.Timestamp = int64(s.clock.Now().UTC().Unix())


	//newBytes, _ := json.Marshal(container)
	//if err := stub.PutState(trackingID, newBytes); err != nil {
	//	return shim.Error(err.Error())
	//}

	//arguments for a container id
    //

    var recup func(Container) peer.Response
    recup = func (container Container) peer.Response {

        container.Custodian = newCustodian
        container.Location = newLocation
        container.Timestamp = int64(s.clock.Now().UTC().Unix())

            newBytes, _ := json.Marshal(container)
            if err := stub.PutState(container.ID, newBytes); err != nil {
                        return shim.Error(err.Error())
            }

        //iterate through contents
        for _, contentID := range container.Contents {
            contentBytes, _ := stub.GetState(contentID)
            if len(contentBytes) == 0 {
                return peer.Response{
                    Status:  404,
                    Message: fmt.Sprintf("Content tracking id %s is invalid.", contentID),
                }
            }
            var contentState Product
            err := json.Unmarshal(contentBytes, &contentState)
            if err != nil && err.Error() == "Not a Product" {
                //recursivly claim custodian on containers
                var innercontainer Container
                    err = json.Unmarshal(contentBytes, &innercontainer)
                    if err != nil {
                        return shim.Error(err.Error())
                    }
                recup(innercontainer)
                                                             //s.updateContainerCustodian(stub, []string{contentID, ""})
            }else if err == nil {
                //claim product
                contentState.Custodian = newCustodian
                contentState.Location = newLocation
                contentState.Timestamp = container.Timestamp
                newProductBytes, _ := json.Marshal(contentState)
                if err := stub.PutState(contentID, newProductBytes); err != nil {
                    return shim.Error(err.Error())
                }
            } else {
                return shim.Error(err.Error())
            }
        }

        s.logger.Infof("Updated state: %s\n", trackingID)
        	return shim.Success([]byte(trackingID))
    }
	return recup(container)
}

//packageItem takes product/container and updates its containerID and takes a container and adds to its contents list
func (s *SmartContract) packageItem(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	//get user identity
	identity, err := GetInvokerIdentity(stub)
	if err != nil {
		shim.Error(fmt.Sprintf("Error getting invoker identity: %s\n", err.Error()))
	}

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}

	//get ids for contents and contents
	containerID := args[0]
	contentID := args[1]

    if (containerID == contentID) {
           return peer.Response{
                    Status:  404,
                    Message: fmt.Sprintf("Cannot package item into itself, please choose another container"),
           }
    }

	containerBytes, _ := stub.GetState(containerID)
	contentBytes, _ := stub.GetState(contentID)
	var updatedContentBytes []byte
	// return 404 is not found
	if len(containerBytes) == 0 {
		return peer.Response{
			Status:  404,
			Message: fmt.Sprintf("Item with trackingID %s not found", containerID),
		}
	}
	// return 404 is not found
	if len(contentBytes) == 0 {
		return peer.Response{
			Status:  404,
			Message: fmt.Sprintf("Item with trackingID %s not found", contentID),
		}
	}
	//try to unmarshal as product
	var contentProduct Product
	err = json.Unmarshal(contentBytes, &contentProduct)

    if (err != nil && err.Error() == "Not a Product") {
        //retry with container
        var contentContainer Container
        err = json.Unmarshal(contentBytes, &contentContainer)
        if err != nil {
            return shim.Error(err.Error())
        }
        if !(contentContainer.ContainerID == "") {
            return peer.Response{
                Status:  403,
                Message: fmt.Sprintf("You are not authorized to perform this transaction as containerID is not empty for container"),
            }
        }

        if !(identity.Cert.Subject.String() == contentContainer.Custodian) {
            return peer.Response{
                Status:  403,
                Message: fmt.Sprintf("You are not authorized to perform this transaction as cert.subject.string doesn't equal custodian for container "),
            }
        }
        //set new data
        contentContainer.ContainerID = containerID

        updatedContentBytes, _ = json.Marshal(contentContainer)

    }else if (err != nil) {
        return peer.Response{
                        Status:  403,
                        Message: fmt.Sprintf(err.Error()),
                    }
    }else {
        if !(identity.Cert.Subject.String() == contentProduct.Custodian) {
            return peer.Response{
                Status:  403,
                Message: fmt.Sprintf("You are not authorized to perform this transaction as cert.subject.string doesn't equal custodian for product while packaging"),
            }
        }
        if !(contentProduct.ContainerID == "") {
            return peer.Response{
                Status:  403,
                Message: fmt.Sprintf("You are not authorized to perform this transaction as containerID is not empty for product"),
            }
        }
        //set new data
        contentProduct.ContainerID = containerID

        updatedContentBytes, _ = json.Marshal(contentProduct)

    }

	//update container contents
	var container Container
	if err := json.Unmarshal(containerBytes, &container); err != nil {
		return shim.Error(err.Error())
	}
	container.Contents = append(container.Contents, contentID)
	if !(identity.Cert.Subject.String() == container.Custodian) {
		return peer.Response{
			Status:  403,
			Message: fmt.Sprintf("You are not authorized to perform this transaction as string doesn't match custodian for container while packaging"),
		}
	}
	updatedContainerBytes, _ := json.Marshal(container)

	if err := stub.PutState(containerID, updatedContainerBytes); err != nil {
		return shim.Error(err.Error())
	}
	if err := stub.PutState(contentID, updatedContentBytes); err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success([]byte(containerID))

}

//packageItem takes product/container and updates its containerID and takes a container and adds to its contents list
func (s *SmartContract) unpackageItem(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	//get user identity
	identity, err := GetInvokerIdentity(stub)
	if err != nil {
		shim.Error(fmt.Sprintf("Error getting invoker identity: %s\n", err.Error()))
	}

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}

	//get ids for contents and contents
	containerID := args[0]
	contentID := args[1]

	containerBytes, _ := stub.GetState(containerID)
	contentBytes, _ := stub.GetState(contentID)
	var updatedContentBytes []byte
	// return 404 is not found
	if len(containerBytes) == 0 {
		return peer.Response{
			Status:  404,
			Message: fmt.Sprintf("Item with trackingID %s not found", containerID),
		}
	}
	// return 404 is not found
	if len(contentBytes) == 0 {
		return peer.Response{
			Status:  404,
			Message: fmt.Sprintf("Item with trackingID %s not found", contentID),
		}
	}

	//try to unmarshal as product
	var contentProduct Product
	err = json.Unmarshal(contentBytes, &contentProduct)

	if !(identity.Cert.Subject.String() == contentProduct.Custodian) {
		return peer.Response{
			Status:  403,
			Message: fmt.Sprintf("You are not authorized to perform this transaction as cert.subject.string doesn't equal custodian for product while unpackaging"),
		}
	}
	if !(contentProduct.ContainerID == containerID) {
		return peer.Response{
			Status:  403,
			Message: fmt.Sprintf("Product not located in this container, could not be unpackaged"),
		}
	}
	//set new data
	contentProduct.ContainerID = ""

	updatedContentBytes, _ = json.Marshal(contentProduct)

	if err != nil {
		//retry with container
		var contentContainer Container
		err = json.Unmarshal(contentBytes, &contentContainer)
		if err != nil {
			return shim.Error(err.Error())
		}
		if !(contentContainer.ContainerID == containerID) {
			return peer.Response{
				Status:  403,
				Message: fmt.Sprintf("Container not located in this container, could not be unpackaged"),
			}
		}

		if !(identity.Cert.Subject.String() == contentContainer.Custodian) {
			return peer.Response{
				Status:  403,
				Message: fmt.Sprintf("You are not authorized to perform this transaction as cert.subject.string doesn't equal custodian for contentContainer while unpackaging"),
			}
		}
		//set new data
		contentContainer.ContainerID = ""

		updatedContentBytes, _ = json.Marshal(contentContainer)
	}

	//update container contents
	var container Container
	if err := json.Unmarshal(containerBytes, &container); err != nil {
		return shim.Error(err.Error())
	}
	if !(identity.Cert.Subject.String() == container.Custodian) {
		return peer.Response{
			Status:  403,
			Message: fmt.Sprintf("You are not authorized to perform this transaction as cert.subject.string doesn't equal custodian for container while unpackaging"),
		}
	}
	container.Remove(contentID)
	updatedContainerBytes, _ := json.Marshal(container)

	if err := stub.PutState(containerID, updatedContainerBytes); err != nil {
		return shim.Error(err.Error())
	}
	if err := stub.PutState(contentID, updatedContentBytes); err != nil {
		return shim.Error(err.Error())
	}
	return shim.Success([]byte(containerID))

}
