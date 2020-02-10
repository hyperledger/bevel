package common

import (
	"crypto/x509"
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/core/chaincode/shim/ext/cid"
)

// Identity encapsulates a chaincode invokers identity
type Identity struct {
	Organization string
	Cert         *x509.Certificate
}

// GetInvokerIdentity returns an Identity for the user invoking the transaction
func GetInvokerIdentity(stub shim.ChaincodeStubInterface) (*Identity, error) {
	var mspid string
	var err error
	var cert *x509.Certificate

	mspid, err = cid.GetMSPID(stub)
	if err != nil {
		fmt.Printf("Error getting MSP identity: %s\n", err.Error())
		return nil, err
	}

	cert, err = cid.GetX509Certificate(stub)
	if err != nil {
		fmt.Printf("Error getting client certificate: %s\n", err.Error())
		return nil, err
	}

	return &Identity{Organization: mspid, Cert: cert}, nil
}

// CanInvoke returns true or false depending on whether the Identity can invoke the supplied transaction
func (id *Identity) CanInvoke(function string) bool {
	switch function {
	case "createProduct":
		return id.isManufacturer()
	default:
		return false
	}
}

func (id *Identity) isManufacturer() bool {
	for _, org := range id.Cert.Subject.OrganizationalUnit {
		if org == "Manufacturer" || org == "manufacturer" {
			return true
		}
	}
	return false
}
