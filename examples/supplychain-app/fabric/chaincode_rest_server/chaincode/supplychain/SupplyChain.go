package supplychain

import (
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"

	"github.com/benbjohnson/clock"
)

// The SmartContract containing this chaincode
type SmartContract struct {
	logger *shim.ChaincodeLogger
	clock  clock.Clock
}

// Init is called during chaincode instantiation to initialize any
// data.
func (s *SmartContract) Init(stub shim.ChaincodeStubInterface) peer.Response {
	s.logger = shim.NewLogger("supplychain")
	s.clock = clock.New()
	return shim.Success(nil)
}

// Invoke is called per transaction on the chaincode.
func (s *SmartContract) Invoke(stub shim.ChaincodeStubInterface) peer.Response {
	// Extract the function and args from the transaction proposal
	function, args := stub.GetFunctionAndParameters()

	// Call the internal function based on the arguments supplied
	switch function {
	case "init":
		return s.Init(stub)
	case "scan":
		return s.scan(stub, args)
	case "createProduct":
		return s.createProduct(stub, args)
	case "getProduct":
		if len(args) == 1 {
			return s.getSingleProduct(stub, args)
		}
		return s.getAllProducts(stub, args)
	case "getContainerlessProducts":
		return s.getContainerlessProducts(stub)
	case "updateState":
		return s.updateState(stub, args)
	case "claimProduct":
		return s.updateProductCustodian(stub, args)
	case "claimContainer":
		return s.updateContainerCustodian(stub, args)
	case "createContainer":
		return s.createContainer(stub, args)
	case "getContainer":
		if len(args) == 1 {
			return s.getSingleContainer(stub, args)
		}
		return s.getAllContainer(stub, args)
	case "package":
		return s.packageItem(stub, args)
	case "unpackage":
		return s.unpackageItem(stub, args)
	case "getIdentity":
		return s.getIdentity(stub)
	case "history":
		return s.getHistory(stub, args)
	default:
		fmt.Printf("Function for Invoke invalid or missing: %s, %s", function, args)
		return shim.Error(fmt.Sprintf("Function for Invoke invalid or missing: %s, %s", function, args))
	}
}
