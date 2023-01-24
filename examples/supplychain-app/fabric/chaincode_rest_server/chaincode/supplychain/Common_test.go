package supplychain

import (
	"encoding/json"
	"testing"

	"github.com/franela/goblin"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	. "github.com/onsi/gomega"
)

func TestCommon(t *testing.T) {
	g := goblin.Goblin(t)
	RegisterFailHandler(func(m string, _ ...int) { g.Fail(m) })

	var mockStub *shim.MockStub
	chaincode := new(SmartContract)

	g.Describe("getIdentity", func() {
		g.It("should return the organization and organizationUnit", func() {
			mockStub = NewMockStubWithCreator("mockstub", chaincode, "ManufacturerMSP", "../testdata/manufacturer.pem")

			// Run getIdentity transaction
			args := [][]byte{[]byte("getIdentity")}
			response := mockStub.MockInvoke("supplychain", args)
			// Retrieve results
			var results map[string]interface{}
			json.Unmarshal(response.Payload, &results)

			Expect(response.Status).To(BeEquivalentTo(200))
			Expect(results["organization"]).To(Equal("PartyA"))
			Expect(results["organizationUnit"]).To(ContainElement("user"))
			Expect(results["organizationUnit"]).To(ContainElement("Manufacturer"))
		})
	})
}
