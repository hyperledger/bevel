package supplychain

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"testing"
	"time"

	"github.com/benbjohnson/clock"

	. "github.com/chaincode/common"

	"github.com/franela/goblin"
	"github.com/golang/protobuf/proto"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/msp"
	. "github.com/onsi/gomega"
)

// NewMockStubWithCreator creates a MockStub with the createor field set to the supplied msp and cert
// This currently requires using fabric builds from the master branch as it requires the changes below, that are yet to be released:
// See https://jira.hyperledger.org/browse/FAB-5644
func NewMockStubWithCreator(name string, cc shim.Chaincode, mspID string, certPath string) *shim.MockStub {
	// Create new mock
	s := shim.NewMockStub(name, cc)

	// Read cert
	certFile, _ := os.Open(certPath)
	defer certFile.Close()
	byteValue, _ := ioutil.ReadAll(certFile)

	//Create and set identity
	sid := &msp.SerializedIdentity{Mspid: mspID, IdBytes: byteValue}
	b, _ := proto.Marshal(sid)
	s.Creator = b
	return s
}

func readJSON(g *goblin.G, path string) []byte {
	jsonFile, err := os.Open(path)
	if err != nil {
		g.Fail(err)
	}
	defer jsonFile.Close()
	byteValue, _ := ioutil.ReadAll(jsonFile)
	return byteValue
}

func TestProduct(t *testing.T) {
	g := goblin.Goblin(t)
	RegisterFailHandler(func(m string, _ ...int) { g.Fail(m) })

	txID := "mockTxID"
	var mockStub *shim.MockStub
	chaincode := new(SmartContract)

	g.Describe("Init", func() {
		g.It("should initialize successfully", func() {
			mockStub = NewMockStubWithCreator("mockstub", chaincode, "ManufacturerMSP", "../testdata/manufacturer.pem")
			mockStub.MockTransactionStart(txID)
			response := chaincode.Init(mockStub)
			chaincode.logger.SetLevel(shim.LogError)
			mockStub.MockTransactionEnd(txID)
			Expect(response.Status).To(BeEquivalentTo(200))
		})
	})

	g.Describe("Create Product", func() {
		g.BeforeEach(func() {
			// Set time mock
			mockClock := clock.NewMock()
			mockClock.Set(time.Unix(int64(1552583510960), int64(0)))
			chaincode.clock = mockClock
			mockStub = NewMockStubWithCreator("mockstub", chaincode, "ManufacturerMSP", "../testdata/manufacturer.pem")
		})

		g.Describe("with valid data", func() {
			g.It("should return successfully", func() {
				// Read input fixture
				byteValue := readJSON(g, "../testdata/product-input-valid.json")
				var input ProductRequest
				json.Unmarshal([]byte(byteValue), &input)

				// Run Create Product transaction
				args := [][]byte{[]byte("createProduct"), byteValue}
				response := mockStub.MockInvoke("supplychain", args)

				// Retrieve results
				var results map[string]interface{}
				json.Unmarshal(response.Payload, &results)

				Expect(response.Status).To(BeEquivalentTo(200))
				Expect(results["generatedID"]).To(Equal(input.ID))
			})

			g.It("should write the product to the blockchain", func() {
				// Read input fixture
				byteValue := readJSON(g, "../testdata/product-input-valid.json")
				var input ProductRequest
				json.Unmarshal([]byte(byteValue), &input)

				// Run Create Product transaction
				args := [][]byte{[]byte("createProduct"), byteValue}
				response := mockStub.MockInvoke("supplychain", args)

				Expect(response.Status).To(BeEquivalentTo(200))

				// Retrieve results from ledger
				bytes, _ := mockStub.GetState(input.ID)
				var results map[string]interface{}
				json.Unmarshal(bytes, &results)

				// Read output fixture
				byteValue = readJSON(g, "../testdata/product-output.json")
				var output map[string]interface{}
				json.Unmarshal([]byte(byteValue), &output)

				Expect(results).To(Equal(output))
			})

			g.It("should return error 403 if the issuer doesn't have permission to invoke the transaction", func() {
				mockStub = NewMockStubWithCreator("mockstub", chaincode, "WarehouseMSP", "../testdata/carrier.pem")
				// Read input fixture
				byteValue := readJSON(g, "../testdata/product-input-valid.json")
				var input ProductRequest
				json.Unmarshal([]byte(byteValue), &input)

				// Run Create Product transaction
				args := [][]byte{[]byte("createProduct"), byteValue}
				response := mockStub.MockInvoke("supplychain", args)

				Expect(response.Status).To(BeEquivalentTo(403))
				Expect(response.Message).To(Equal("You are not authorized to perform this transaction, cannot invoke createProduct"))
			})
			g.It("duplicate creation", func() {
				// Read input fixture
				byteValue := readJSON(g, "../testdata/product-input-valid.json")
				var input ProductRequest
				json.Unmarshal([]byte(byteValue), &input)

				// Run Create Product transaction
				args := [][]byte{[]byte("createProduct"), byteValue}
				response := mockStub.MockInvoke("supplychain", args)

				response2 := mockStub.MockInvoke("supplychain", args)
				// Retrieve results
				var results map[string]interface{}
				json.Unmarshal(response.Payload, &results)

				Expect(response2.Status).To(BeEquivalentTo(403))
				//Expect(results["generatedID"]).To(Equal(input.ID))
			})
		})

		g.Describe("with invalid data", func() {

			g.It("should return an error if < 1 argument", func() {
				// Run Create Product transaction
				args := [][]byte{[]byte("createProduct")}
				response := mockStub.MockInvoke("supplychain", args)

				Expect(response.Status).To(BeEquivalentTo(500))
				Expect(response.Message).To(Equal("Incorrect number of arguments. Expecting 1"))
			})

			g.It("should return an error if > 1 argument", func() {
				// Run Create Product transaction
				args := [][]byte{[]byte("createProduct"), []byte(""), []byte("")}
				response := mockStub.MockInvoke("supplychain", args)

				Expect(response.Status).To(BeEquivalentTo(500))
				Expect(response.Message).To(Equal("Incorrect number of arguments. Expecting 1"))
			})

		})
	})

	g.Describe("Get All Products", func() {
		g.BeforeEach(func() {
			// Set time mock
			mockClock := clock.NewMock()
			mockClock.Set(time.Unix(int64(1552583510960), int64(0)))
			chaincode.clock = mockClock
			mockStub = NewMockStubWithCreator("mockstub", chaincode, "ManufacturerMSP", "../testdata/manufacturer.pem")
		})

		g.Describe("with valid data", func() {
			g.It("should return successfully", func() {
				// Read input fixture
				product := Product{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "product",
					Name:         "Dextrose",
					Health:       "None",
					Sold:         false,
					Recalled:     false,
					ContainerID:  "",
					Metadata:     map[string]interface{}{"name": "Expensive Dextrose"},
					Custodian:    "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH",
					Location:     "None",
					Timestamp:    1552583510960,
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				product2 := Product{
					ID:           "0e15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "product",
					Name:         "Second Dextrose",
					Health:       "None",
					Sold:         false,
					Recalled:     false,
					ContainerID:  "",
					Metadata:     map[string]interface{}{"name": "Expensive Dextrose"},
					Custodian:    "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH",
					Location:     "None",
					Timestamp:    1552583510960,
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}

				container := Container{
					ID:           "1d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "container",
					Health:       "None",
					Contents:     []string{},
					Metadata:     map[string]interface{}{"name": "Not Expensive Dextrose"},
					Custodian:    "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH",
					Location:     "None",
					Timestamp:    1552583510960,
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				productAsBytes, _ := json.Marshal(product)
				product2AsBytes, _ := json.Marshal(product2)
				containerAsBytes, _ := json.Marshal(container)
				key1 := product.ID
				key2 := product2.ID
				key3 := container.ID
				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key1, productAsBytes)
				mockStub.PutState(key2, product2AsBytes)
				mockStub.PutState(key3, containerAsBytes)
				mockStub.MockTransactionEnd(txID)

				// Run getProduct transaction
				args := [][]byte{[]byte("getProduct")}
				response := mockStub.MockInvoke("supplychain", args)

				// Retrieve results
				var results []Product
				if err := json.Unmarshal(response.Payload, &results); err != nil {
					g.Fail(err)
				}
				Expect(response.Status).To(BeEquivalentTo(200))
				Expect(results).To(HaveLen(2))
				Expect(results[0]).To(Equal(product))
				Expect(results[1]).To(Equal(product2))

			})

		})
		g.It("should return [] if there are no Products", func() {
			// Run getProduct transaction
			args := [][]byte{[]byte("getProduct")}
			response := mockStub.MockInvoke("supplychain", args)

			Expect(response.Status).To(BeEquivalentTo(200))
			Expect(response.Payload).To(Equal([]byte{'[', ']'}))
		})

		g.Describe("with invalid data", func() {
			g.It("should return an error if > 2 argument", func() {
				// Run get Product transaction
				args := [][]byte{[]byte("getProduct"), []byte(""), []byte("")}
				response := mockStub.MockInvoke("supplychain", args)

				Expect(response.Status).To(BeEquivalentTo(500))
				Expect(response.Message).To(Equal("Incorrect number of arguments. Expecting 0"))
			})

		})
	})

	g.Describe("Get Single Product", func() {
		g.BeforeEach(func() {
			// Set time mock
			mockClock := clock.NewMock()
			mockClock.Set(time.Unix(int64(1552583510960), int64(0)))
			chaincode.clock = mockClock
			mockStub = NewMockStubWithCreator("mockstub", chaincode, "ManufacturerMSP", "../testdata/manufacturer.pem")
		})

		g.Describe("with valid data", func() {
			g.It("should return successfully", func() {
				// Read input fixture
				product := Product{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "product",
					Name:         "Dextrose",
					Health:       "None",
					Sold:         false,
					Recalled:     false,
					ContainerID:  "",
					Metadata:     map[string]interface{}{"name": "Expensive Dextrose"},
					Custodian:    "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH",
					Location:     "None",
					Timestamp:    1552583510960,
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				bytes, _ := json.Marshal(product)
				key := product.ID
				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key, bytes)
				mockStub.MockTransactionEnd(txID)

				// Run getProduct transaction
				args := [][]byte{[]byte("getProduct"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46")}
				response := mockStub.MockInvoke("Product", args)

				// Retrieve results
				var result Product
				if err := json.Unmarshal(response.Payload, &result); err != nil {
					g.Fail(err)
				}

				Expect(response.Status).To(BeEquivalentTo(200))
				Expect(result).To(Equal(product))
			})

		})

		g.It("should return 404 if the Product doesn't exist", func() {
			// Run getProduct transaction
			args := [][]byte{[]byte("getProduct"), []byte("None")}
			response := mockStub.MockInvoke("Product", args)

			Expect(response.Status).To(BeEquivalentTo(404))
			Expect(response.Message).To(Equal("Product None Not Found"))
		})

	})

	g.Describe("Get Containerless Products", func() {
		// Not implemented as MockStub doesn't support GetQueryResult
	})

	g.Describe("Update Product", func() {
		g.BeforeEach(func() {
			// Set time mock
			mockClock := clock.NewMock()
			mockClock.Set(time.Unix(int64(1552583510960), int64(0)))
			chaincode.clock = mockClock
			mockStub = NewMockStubWithCreator("mockstub", chaincode, "ManufacturerMSP", "../testdata/manufacturer.pem")

		})

		g.Describe("with valid data", func() {
			g.It("should return successfully", func() {

				product := Product{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "product",
					Name:         "Dextrose",
					Health:       "None",
					Sold:         false,
					Recalled:     false,
					ContainerID:  "",
					Metadata:     map[string]interface{}{"name": "Expensive Dextrose"},
					Custodian:    "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH",
					Location:     "None",
					Timestamp:    1552583510960,
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				bytes, _ := json.Marshal(product)
				key := product.ID
				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key, bytes)
				mockStub.MockTransactionEnd(txID)

				// Read update fixture
				byteValue := readJSON(g, "../testdata/update-product-input.json")
				var input UpdateRequest
				json.Unmarshal([]byte(byteValue), &input)
				// Run Create Product transaction
				args := [][]byte{[]byte("updateState"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46"), byteValue}
				response := mockStub.MockInvoke("supplychain", args)

				Expect(response.Status).To(BeEquivalentTo(200))
				Expect(response.Payload).To(BeEquivalentTo(product.ID))
			})

		})
		g.It("should return 404 if the state doesn't exist", func() {
			// Read update fixture
			byteValue := readJSON(g, "../testdata/update-product-input.json")
			var input UpdateRequest
			json.Unmarshal([]byte(byteValue), &input)
			// Run Create Product transaction
			args := [][]byte{[]byte("updateState"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46"), byteValue}
			response := mockStub.MockInvoke("supplychain", args)

			Expect(response.Status).To(BeEquivalentTo(404))
			Expect(response.Message).To(Equal("Item with trackingID 0d15d7b8-caaa-468d-8b83-aae049b40f46 not found"))
		})
		g.It("non custodian cannot update", func() {

			product := Product{
				ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
				Type:         "product",
				Name:         "Dextrose",
				Health:       "None",
				Sold:         false,
				Recalled:     false,
				ContainerID:  "",
				Metadata:     map[string]interface{}{"name": "Expensive Dextrose"},
				Custodian:    "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US",
				Location:     "None",
				Timestamp:    1552583510960,
				Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
			}
			bytes, _ := json.Marshal(product)
			key := product.ID
			mockStub.MockTransactionStart(txID)
			mockStub.PutState(key, bytes)
			mockStub.MockTransactionEnd(txID)

			// Read update fixture
			byteValue := readJSON(g, "../testdata/update-product-input.json")
			var input UpdateRequest
			json.Unmarshal([]byte(byteValue), &input)
			// Run Create Product transaction
			args := [][]byte{[]byte("updateState"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46"), byteValue}
			response := mockStub.MockInvoke("supplychain", args)

			// Retrieve results
			var results map[string]interface{}
			json.Unmarshal(response.Payload, &results)

			Expect(response.Status).To(BeEquivalentTo(403))
			Expect(response.Message).To(Equal("You are not authorized to perform this transaction"))

		})
	})

	g.Describe("Update Product Custodian", func() {
		g.BeforeEach(func() {
			// Set time mock
			mockClock := clock.NewMock()
			mockClock.Set(time.Unix(int64(1552583510960), int64(0)))
			chaincode.clock = mockClock
			mockStub = NewMockStubWithCreator("mockstub", chaincode, "ManufacturerMSP", "../testdata/manufacturer.pem")

		})

		g.Describe("with valid data", func() {
			g.It("should return successfully", func() {

				product := Product{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "product",
					Name:         "Dextrose",
					Health:       "None",
					Sold:         false,
					Recalled:     false,
					ContainerID:  "",
					Metadata:     map[string]interface{}{"name": "Expensive Dextrose"},
					Custodian:    "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US",
					Location:     "None",
					Timestamp:    1552583510960,
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				bytes, _ := json.Marshal(product)
				key := product.ID
				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key, bytes)
				mockStub.MockTransactionEnd(txID)

				// Run Create Product transaction
				args := [][]byte{[]byte("claimProduct"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46"), []byte("")}
				response := mockStub.MockInvoke("supplychain", args)

				// Retrieve results
				var results map[string]interface{}
				json.Unmarshal(response.Payload, &results)

				Expect(response.Status).To(BeEquivalentTo(200))
			})

		})
		g.Describe("with invalid data", func() {
			g.It("should return 404 if the state doesn't exist", func() {

				// Run Claim Product transaction
				args := [][]byte{[]byte("claimProduct"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46"), []byte("")}
				response := mockStub.MockInvoke("supplychain", args)

				Expect(response.Status).To(BeEquivalentTo(404))
				Expect(response.Message).To(Equal("Item with trackingID 0d15d7b8-caaa-468d-8b83-aae049b40f46 not found"))
			})
			g.It("non participant cannot claim", func() {

				product := Product{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "product",
					Name:         "Dextrose",
					Health:       "None",
					Sold:         false,
					Recalled:     false,
					ContainerID:  "",
					Metadata:     map[string]interface{}{"name": "Expensive Dextrose"},
					Custodian:    "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US",
					Location:     "None",
					Timestamp:    1552583510960,
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US"},
				}
				bytes, _ := json.Marshal(product)
				key := product.ID
				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key, bytes)
				mockStub.MockTransactionEnd(txID)

				// Run Create Product transaction
				args := [][]byte{[]byte("claimProduct"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46"), []byte("")}
				response := mockStub.MockInvoke("supplychain", args)

				// Retrieve results
				var results map[string]interface{}
				json.Unmarshal(response.Payload, &results)

				Expect(response.Status).To(BeEquivalentTo(403))
				Expect(response.Message).To(Equal("You are not authorized to perform this transaction, product not accesible by identity"))

			})
			g.It("current custodian cannot claim ", func() {

				product := Product{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "product",
					Name:         "Dextrose",
					Health:       "None",
					Sold:         false,
					Recalled:     false,
					ContainerID:  "",
					Metadata:     map[string]interface{}{"name": "Expensive Dextrose"},
					Custodian:    "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH",
					Location:     "None",
					Timestamp:    1552583510960,
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				bytes, _ := json.Marshal(product)
				key := product.ID
				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key, bytes)
				mockStub.MockTransactionEnd(txID)

				// Run Create Product transaction
				args := [][]byte{[]byte("claimProduct"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46"), []byte("")}
				response := mockStub.MockInvoke("supplychain", args)

				// Retrieve results
				var results map[string]interface{}
				json.Unmarshal(response.Payload, &results)

				Expect(response.Status).To(BeEquivalentTo(403))
				Expect(response.Message).To(Equal("You are already custodian"))

			})
			g.It("product inside a container cannot be claimed", func() {

				product := Product{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "product",
					Name:         "Dextrose",
					Health:       "None",
					Sold:         false,
					Recalled:     false,
					ContainerID:  "1d15d7b8-caaa-468d-8b83-aae049b40f46",
					Metadata:     map[string]interface{}{"name": "Expensive Dextrose"},
					Custodian:    "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US",
					Location:     "None",
					Timestamp:    1552583510960,
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				containerOuter := Container{
					ID:           "1d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "container",
					Health:       "None",
					Contents:     []string{"0d15d7b8-caaa-468d-8b83-aae049b40f46"},
					Metadata:     map[string]interface{}{"name": "Not Expensive Dextrose"},
					Custodian:    "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US",
					Location:     "None",
					Timestamp:    1552583510960,
					ContainerID:  "",
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				bytes, _ := json.Marshal(product)
				key := product.ID
				bytes2, _ := json.Marshal(containerOuter)
				key2 := containerOuter.ID
				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key, bytes)
				mockStub.PutState(key2, bytes2)
				mockStub.MockTransactionEnd(txID)

				// Run Create Product transaction
				args := [][]byte{[]byte("claimProduct"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46"), []byte("")}
				response := mockStub.MockInvoke("supplychain", args)

				// Retrieve results
				var results map[string]interface{}
				json.Unmarshal(response.Payload, &results)

				Expect(response.Status).To(BeEquivalentTo(403))
				Expect(response.Message).To(Equal("Product needs to be unpackaged before claiming a new owner"))

			})
		})
	})

	g.Describe("Scan Product ", func() {
		g.BeforeEach(func() {
			// Set time mock
			mockClock := clock.NewMock()
			mockClock.Set(time.Unix(int64(1552583510960), int64(0)))
			chaincode.clock = mockClock
			mockStub = NewMockStubWithCreator("mockstub", chaincode, "ManufacturerMSP", "../testdata/manufacturer.pem")

		})

		g.Describe("with valid data", func() {
			g.It("should return owned", func() {

				product := Product{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "product",
					Name:         "Dextrose",
					Health:       "None",
					Sold:         false,
					Recalled:     false,
					ContainerID:  "",
					Metadata:     map[string]interface{}{"name": "Expensive Dextrose"},
					Custodian:    "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH",
					Location:     "None",
					Timestamp:    1552583510960,
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				bytes, _ := json.Marshal(product)
				key := product.ID
				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key, bytes)
				mockStub.MockTransactionEnd(txID)

				// Run Create Product transaction
				args := [][]byte{[]byte("scan"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46")}
				response := mockStub.MockInvoke("supplychain", args)

				// Retrieve results
				var results map[string]interface{}
				json.Unmarshal(response.Payload, &results)
				var expectedresults map[string]interface{}
				expectedresults = map[string]interface{}{
					"status": "owned",
				}

				Expect(response.Status).To(BeEquivalentTo(200))
				Expect(results).To(BeEquivalentTo(expectedresults))

			})
			g.It("should return new", func() {
				// Run Create Product transaction
				args := [][]byte{[]byte("scan"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46")}
				response := mockStub.MockInvoke("supplychain", args)

				// Retrieve results
				var results map[string]interface{}
				json.Unmarshal(response.Payload, &results)
				var expectedresults map[string]interface{}
				expectedresults = map[string]interface{}{
					"status": "new",
				}

				Expect(response.Status).To(BeEquivalentTo(200))
				Expect(results).To(BeEquivalentTo(expectedresults))

			})
			g.It("should return unowned", func() {

				product := Product{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "product",
					Name:         "Dextrose",
					Health:       "None",
					Sold:         false,
					Recalled:     false,
					ContainerID:  "",
					Metadata:     map[string]interface{}{"name": "Expensive Dextrose"},
					Custodian:    "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US",
					Location:     "None",
					Timestamp:    1552583510960,
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				bytes, _ := json.Marshal(product)
				key := product.ID
				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key, bytes)
				mockStub.MockTransactionEnd(txID)

				// Run Create Product transaction
				args := [][]byte{[]byte("scan"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46")}
				response := mockStub.MockInvoke("supplychain", args)

				// Retrieve results
				var results map[string]interface{}
				json.Unmarshal(response.Payload, &results)
				var expectedresults map[string]interface{}
				expectedresults = map[string]interface{}{
					"status": "unowned",
				}

				Expect(response.Status).To(BeEquivalentTo(200))
				Expect(results).To(BeEquivalentTo(expectedresults))

			})
		})
	})
}
