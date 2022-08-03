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
func NewMockStubWithCreatorContainer(name string, cc shim.Chaincode, mspID string, certPath string) *shim.MockStub {
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

func TestContainer(t *testing.T) {
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

	g.Describe("Create Container", func() {
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
				byteValue := readJSON(g, "../testdata/container-input-valid.json")
				var input ContainerRequest
				json.Unmarshal([]byte(byteValue), &input)

				// Run Create Container transaction
				args := [][]byte{[]byte("createContainer"), byteValue}
				response := mockStub.MockInvoke("supplychain", args)

				// Retrieve results
				var results map[string]interface{}
				json.Unmarshal(response.Payload, &results)

				Expect(response.Status).To(BeEquivalentTo(200))
				Expect(results["generatedID"]).To(Equal(input.ID))
			})

			g.It("should write the Container to the blockchain", func() {
				// Read input fixture
				byteValue := readJSON(g, "../testdata/container-input-valid.json")
				var input ContainerRequest
				json.Unmarshal([]byte(byteValue), &input)

				// Run Create Container transaction
				args := [][]byte{[]byte("createContainer"), byteValue}
				response := mockStub.MockInvoke("supplychain", args)

				Expect(response.Status).To(BeEquivalentTo(200))

				// Retrieve results from ledger
				bytes, _ := mockStub.GetState(input.ID)
				var results map[string]interface{}
				json.Unmarshal(bytes, &results)

				// Read output fixture
				byteValue = readJSON(g, "../testdata/container-output.json")
				var output map[string]interface{}
				json.Unmarshal([]byte(byteValue), &output)

				Expect(results).To(Equal(output))
			})
		})

		g.Describe("with invalid data", func() {
			g.It("should return an error if < 1 argument", func() {
				// Run Create Container transaction
				args := [][]byte{[]byte("createContainer")}
				response := mockStub.MockInvoke("supplychain", args)

				Expect(response.Status).To(BeEquivalentTo(500))
				Expect(response.Message).To(Equal("Incorrect number of arguments. Expecting 1"))
			})

			g.It("should return an error if > 1 argument", func() {
				// Run Create Container transaction
				args := [][]byte{[]byte("createContainer"), []byte(""), []byte("")}
				response := mockStub.MockInvoke("supplychain", args)

				Expect(response.Status).To(BeEquivalentTo(500))
				Expect(response.Message).To(Equal("Incorrect number of arguments. Expecting 1"))
			})

		})
	})

	g.Describe("Get All Containers", func() {
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

				// Run getContainer transaction
				args := [][]byte{[]byte("getContainer")}
				response := mockStub.MockInvoke("supplychain", args)

				// Retrieve results
				var results []Container
				if err := json.Unmarshal(response.Payload, &results); err != nil {
					g.Fail(err)
				}
				Expect(response.Status).To(BeEquivalentTo(200))
				Expect(results).To(HaveLen(1))
				Expect(results[0]).To(Equal(container))

			})

		})
		g.It("should return [] if there are no Containers", func() {
			// Run getContainer transaction
			args := [][]byte{[]byte("getContainer")}
			response := mockStub.MockInvoke("supplychain", args)

			Expect(response.Status).To(BeEquivalentTo(200))
			Expect(response.Payload).To(Equal([]byte{'[', ']'}))
		})

		g.Describe("with invalid data", func() {
			g.It("should return an error if > 2 argument", func() {
				// Run get Container transaction
				args := [][]byte{[]byte("getContainer"), []byte(""), []byte("")}
				response := mockStub.MockInvoke("supplychain", args)

				Expect(response.Status).To(BeEquivalentTo(500))
				Expect(response.Message).To(Equal("Incorrect number of arguments. Expecting 0"))
			})

		})
	})

	g.Describe("Get Single Container", func() {
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
				container := Container{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "container",
					Health:       "None",
					Contents:     []string{},
					Metadata:     map[string]interface{}{"name": "Not Expensive Dextrose"},
					Custodian:    "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH",
					Location:     "None",
					Timestamp:    1552583510960,
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				bytes, _ := json.Marshal(container)
				key := container.ID
				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key, bytes)
				mockStub.MockTransactionEnd(txID)

				// Run getContainer transaction
				args := [][]byte{[]byte("getContainer"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46")}
				response := mockStub.MockInvoke("Container", args)

				// Retrieve results
				var result Container
				if err := json.Unmarshal(response.Payload, &result); err != nil {
					g.Fail(err)
				}

				Expect(response.Status).To(BeEquivalentTo(200))
				Expect(result).To(Equal(container))
			})

		})

		g.It("should return 404 if the container doesn't exist", func() {

			args := [][]byte{[]byte("getContainer"), []byte("None")}
			response := mockStub.MockInvoke("Container", args)

			Expect(response.Status).To(BeEquivalentTo(404))
			Expect(response.Message).To(Equal("Container None Not Found"))
		})
		g.It("should return 404 if the container is not owned", func() {
			container := Container{
				ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
				Type:         "container",
				Health:       "None",
				Contents:     []string{},
				Metadata:     map[string]interface{}{"name": "Not Expensive Dextrose"},
				Custodian:    "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US",
				Location:     "None",
				Timestamp:    1552583510960,
				Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
			}
			bytes, _ := json.Marshal(container)
			key := container.ID
			mockStub.MockTransactionStart(txID)
			mockStub.PutState(key, bytes)
			mockStub.MockTransactionEnd(txID)

			args := [][]byte{[]byte("getContainer"), []byte("None")}
			response := mockStub.MockInvoke("Container", args)

			Expect(response.Status).To(BeEquivalentTo(404))
			Expect(response.Message).To(Equal("Container None Not Found"))
		})

	})

	g.Describe("Scan Container ", func() {
		g.BeforeEach(func() {
			// Set time mock
			mockClock := clock.NewMock()
			mockClock.Set(time.Unix(int64(1552583510960), int64(0)))
			chaincode.clock = mockClock
			mockStub = NewMockStubWithCreator("mockstub", chaincode, "ManufacturerMSP", "../testdata/manufacturer.pem")

		})

		g.Describe("with valid data", func() {
			g.It("should return owned", func() {

				container := Container{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "container",
					Health:       "None",
					Contents:     []string{},
					Metadata:     map[string]interface{}{"name": "Not Expensive Dextrose"},
					Custodian:    "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH",
					Location:     "None",
					Timestamp:    1552583510960,
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				bytes, _ := json.Marshal(container)
				key := container.ID
				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key, bytes)
				mockStub.MockTransactionEnd(txID)

				// Run Create Container transaction
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
				// Run Create Container transaction
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

				container := Container{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "container",
					Health:       "None",
					Contents:     []string{},
					Metadata:     map[string]interface{}{"name": "Not Expensive Dextrose"},
					Custodian:    "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US",
					Location:     "None",
					Timestamp:    1552583510960,
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				bytes, _ := json.Marshal(container)
				key := container.ID
				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key, bytes)
				mockStub.MockTransactionEnd(txID)

				// Run Create Container transaction
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

	g.Describe("Update Container Custodian", func() {
		g.BeforeEach(func() {
			// Set time mock
			mockClock := clock.NewMock()
			mockClock.Set(time.Unix(int64(1552583510960), int64(0)))
			chaincode.clock = mockClock
			mockStub = NewMockStubWithCreator("mockstub", chaincode, "ManufacturerMSP", "../testdata/manufacturer.pem")

		})

		g.Describe("with valid data", func() {
			g.It("single should return successfully", func() {

				container := Container{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "container",
					Health:       "None",
					Contents:     []string{},
					Metadata:     map[string]interface{}{"name": "Not Expensive Dextrose"},
					Custodian:    "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US",
					Location:     "None",
					Timestamp:    1552583510960,
					ContainerID:  "",
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				bytes, _ := json.Marshal(container)
				key := container.ID

				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key, bytes)
				mockStub.MockTransactionEnd(txID)

				// Run Create Product transaction
				args := [][]byte{[]byte("claimContainer"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46"), []byte("")}
				response := mockStub.MockInvoke("supplychain", args)

				updated, _ := mockStub.GetState(key)

				var updatedContainer Container

				json.Unmarshal(updated, &updatedContainer)

				// Retrieve results
				var results map[string]interface{}
				json.Unmarshal(response.Payload, &results)

				Expect(response.Status).To(BeEquivalentTo(200))
				Expect(updatedContainer.Custodian).To(BeEquivalentTo("CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"))
			})
			g.It("container with contents should return successfully", func() {

				container := Container{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "container",
					Health:       "None",
					Contents:     []string{"2d15d7b8-caaa-468d-8b83-aae049b40f46","1d15d7b8-caaa-468d-8b83-aae049b40f46"},
					Metadata:     map[string]interface{}{"name": "Not Expensive Dextrose"},
					Custodian:    "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US",
					Location:     "None",
					Timestamp:    1552583510960,
					ContainerID:  "",
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}

				product := Product{
                	ID:           "1d15d7b8-caaa-468d-8b83-aae049b40f46",
                	Type:         "product",
                	Name:         "Dextrose",
                	Health:       "None",
                	Sold:         false,
                	Recalled:     false,
                	ContainerID:  "0d15d7b8-caaa-468d-8b83-aae049b40f46",
                	Metadata:     map[string]interface{}{"name": "Expensive Dextrose"},
                	Custodian:    "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US",
                	Location:     "None",
                	Timestamp:    1552583510960,
                	Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
                }

				containerInner := Container{
					ID:           "2d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "container",
					Health:       "None",
					Contents:     []string{"3d15d7b8-caaa-468d-8b83-aae049b40f46"},
					Metadata:     map[string]interface{}{"name": "Not Expensive Dextrose"},
					Custodian:    "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US",
					Location:     "None",
					Timestamp:    1552583510960,
					ContainerID:  "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				productInner := Product{
					ID:           "3d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "product",
					Name:         "Dextrose",
					Health:       "None",
					Sold:         false,
					Recalled:     false,
					ContainerID:  "2d15d7b8-caaa-468d-8b83-aae049b40f46",
					Metadata:     map[string]interface{}{"name": "Expensive Dextrose"},
					Custodian:    "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US",
					Location:     "None",
					Timestamp:    1552583510960,
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				bytes, _ := json.Marshal(container)
				key := container.ID
				bytes2, _ := json.Marshal(containerInner)
				key2 := containerInner.ID
				bytes3, _ := json.Marshal(product)
				key3 := product.ID
				bytes4, _ := json.Marshal(productInner)
				key4 := productInner.ID
				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key, bytes)
				mockStub.PutState(key2, bytes2)
				mockStub.PutState(key3, bytes3)
				mockStub.PutState(key4, bytes4)
				mockStub.MockTransactionEnd(txID)

				// Run Create Product transaction
				args := [][]byte{[]byte("claimContainer"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46"), []byte("")}
				response := mockStub.MockInvoke("supplychain", args)

				updated, _ := mockStub.GetState(key)
				updated2, _ := mockStub.GetState(key2)
				updated3, _ := mockStub.GetState(key3)
				updated4, _ := mockStub.GetState(key4)

				var updatedContainer Container
				var updatedInnerContainer Container
				var updatedProduct Product
				var updatedInnerProduct Product

				json.Unmarshal(updated, &updatedContainer)
				json.Unmarshal(updated2, &updatedInnerContainer)
				json.Unmarshal(updated3, &updatedProduct)
				json.Unmarshal(updated4, &updatedInnerProduct)

				// Retrieve results
				var results map[string]interface{}
				json.Unmarshal(response.Payload, &results)
				Expect(response.Status).To(BeEquivalentTo(200))
				Expect(updatedContainer.Custodian).To(BeEquivalentTo("CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"))
				Expect(updatedProduct.Custodian).To(BeEquivalentTo("CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"))
				Expect(updatedInnerProduct.Custodian).To(BeEquivalentTo("CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"))
				Expect(updatedInnerContainer.Custodian).To(BeEquivalentTo("CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"))
			})

		})
		g.Describe("with invalid data", func() {
			g.It("should return 404 if the state doesn't exist", func() {

				// Run Claim Product transaction
				args := [][]byte{[]byte("claimContainer"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46"), []byte("")}
				response := mockStub.MockInvoke("supplychain", args)

				Expect(response.Status).To(BeEquivalentTo(404))
				Expect(response.Message).To(Equal("Item with trackingID 0d15d7b8-caaa-468d-8b83-aae049b40f46 not found"))
			})
			g.It("non participant cannot claim", func() {

				container := Container{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "container",
					Health:       "None",
					Contents:     []string{},
					Metadata:     map[string]interface{}{"name": "Not Expensive Dextrose"},
					Custodian:    "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US",
					Location:     "None",
					Timestamp:    1552583510960,
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US"},
				}
				bytes, _ := json.Marshal(container)
				key := container.ID
				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key, bytes)
				mockStub.MockTransactionEnd(txID)

				// Run Create Product transaction
				args := [][]byte{[]byte("claimContainer"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46"), []byte("")}
				response := mockStub.MockInvoke("supplychain", args)

				// Retrieve results
				var results map[string]interface{}
				json.Unmarshal(response.Payload, &results)

				Expect(response.Status).To(BeEquivalentTo(403))
				Expect(response.Message).To(Equal("You are not authorized to perform this transaction since container not accessible by identity"))

			})
			g.It("current custodian cannot claim ", func() {

				container := Container{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "container",
					Health:       "None",
					Contents:     []string{},
					Metadata:     map[string]interface{}{"name": "Not Expensive Dextrose"},
					Custodian:    "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH",
					Location:     "None",
					Timestamp:    1552583510960,
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				bytes, _ := json.Marshal(container)
				key := container.ID
				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key, bytes)
				mockStub.MockTransactionEnd(txID)

				// Run Create Product transaction
				args := [][]byte{[]byte("claimContainer"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46"), []byte("")}
				response := mockStub.MockInvoke("supplychain", args)

				// Retrieve results
				var results map[string]interface{}
				json.Unmarshal(response.Payload, &results)

				Expect(response.Status).To(BeEquivalentTo(403))
				Expect(response.Message).To(Equal("You are already custodian"))

			})
			g.It("Container inside a container cannot be claimed separately", func() {

				container := Container{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "container",
					Health:       "None",
					Contents:     []string{},
					Metadata:     map[string]interface{}{"name": "Not Expensive Dextrose"},
					Custodian:    "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US",
					Location:     "None",
					Timestamp:    1552583510960,
					ContainerID:  "1d15d7b8-caaa-468d-8b83-aae049b40f46",
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
				bytes, _ := json.Marshal(container)
				key := container.ID
				bytes2, _ := json.Marshal(containerOuter)
				key2 := containerOuter.ID
				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key, bytes)
				mockStub.PutState(key2, bytes2)
				mockStub.MockTransactionEnd(txID)

				// Run Create Product transaction
				args := [][]byte{[]byte("claimContainer"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46"), []byte("")}
				response := mockStub.MockInvoke("supplychain", args)

				// Retrieve results
				var results map[string]interface{}
				json.Unmarshal(response.Payload, &results)

				Expect(response.Status).To(BeEquivalentTo(403))
				Expect(response.Message).To(Equal("Container needs to be unpackaged before claiming a new owner"))

			})

			g.It("contianer with non existing contents should fail", func() {

				container := Container{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Type:         "container",
					Health:       "None",
					Contents:     []string{"1d15d7b8-caaa-468d-8b83-aae049b40f46"},
					Metadata:     map[string]interface{}{"name": "Not Expensive Dextrose"},
					Custodian:    "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US",
					Location:     "None",
					Timestamp:    1552583510960,
					ContainerID:  "",
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				bytes, _ := json.Marshal(container)
				key := container.ID

				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key, bytes)
				mockStub.MockTransactionEnd(txID)

				// Run Create Product transaction
				args := [][]byte{[]byte("claimContainer"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46"), []byte("")}
				response := mockStub.MockInvoke("supplychain", args)

				updated, _ := mockStub.GetState(key)

				var updatedContainer Container

				json.Unmarshal(updated, &updatedContainer)

				// Retrieve results
				var results map[string]interface{}
				json.Unmarshal(response.Payload, &results)

				Expect(response.Status).To(BeEquivalentTo(404))
				Expect(response.Message).To(Equal("Content tracking id 1d15d7b8-caaa-468d-8b83-aae049b40f46 is invalid."))
			})
		})
	})

	g.Describe("Package Item", func() {
		g.BeforeEach(func() {
			// Set time mock
			mockClock := clock.NewMock()
			mockClock.Set(time.Unix(int64(1552583510960), int64(0)))
			chaincode.clock = mockClock
			mockStub = NewMockStubWithCreator("mockstub", chaincode, "ManufacturerMSP", "../testdata/manufacturer.pem")

		})

		g.Describe("with valid data", func() {
			g.It("should return successfully", func() {

				container := Container{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Health:       "None",
					Contents:     []string{},
					Metadata:     map[string]interface{}{"name": "Not Expensive Dextrose"},
					Custodian:    "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH",
					Location:     "None",
					Timestamp:    1552583510960,
					ContainerID:  "",
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				product := Product{
					ID:           "1d15d7b8-caaa-468d-8b83-aae049b40f46",
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
				bytes, _ := json.Marshal(container)
				key := container.ID
				bytes2, _ := json.Marshal(product)
				key2 := product.ID
				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key, bytes)
				mockStub.PutState(key2, bytes2)
				mockStub.MockTransactionEnd(txID)

				// Run Create Product transaction
				args := [][]byte{[]byte("package"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46"), []byte("1d15d7b8-caaa-468d-8b83-aae049b40f46")}
				response := mockStub.MockInvoke("supplychain", args)

				updatedBytesContainer, _ := mockStub.GetState(key)
				updatedBytesProduct, _ := mockStub.GetState(key2)

				var updatedContainer Container
				var updatedProduct Product

				json.Unmarshal(updatedBytesContainer, &updatedContainer)
				json.Unmarshal(updatedBytesProduct, &updatedProduct)

				// Retrieve results
				var results map[string]interface{}
				json.Unmarshal(response.Payload, &results)

				Expect(response.Status).To(BeEquivalentTo(200))
				Expect(updatedContainer.Contents).To(BeEquivalentTo([]string{"1d15d7b8-caaa-468d-8b83-aae049b40f46"}))
				Expect(updatedProduct.ContainerID).To(BeEquivalentTo("0d15d7b8-caaa-468d-8b83-aae049b40f46"))
			})
		})
	})
	g.Describe("Package Item", func() {
		g.BeforeEach(func() {
			// Set time mock
			mockClock := clock.NewMock()
			mockClock.Set(time.Unix(int64(1552583510960), int64(0)))
			chaincode.clock = mockClock
			mockStub = NewMockStubWithCreator("mockstub", chaincode, "ManufacturerMSP", "../testdata/manufacturer.pem")

		})

		g.Describe("with valid data", func() {
			g.It("should return successfully", func() {

				container := Container{
					ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Health:       "None",
					Contents:     []string{"1d15d7b8-caaa-468d-8b83-aae049b40f46"},
					Metadata:     map[string]interface{}{"name": "Not Expensive Dextrose"},
					Custodian:    "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH",
					Location:     "None",
					Timestamp:    1552583510960,
					ContainerID:  "",
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				product := Product{
					ID:           "1d15d7b8-caaa-468d-8b83-aae049b40f46",
					Name:         "Dextrose",
					Health:       "None",
					Sold:         false,
					Recalled:     false,
					ContainerID:  "0d15d7b8-caaa-468d-8b83-aae049b40f46",
					Metadata:     map[string]interface{}{"name": "Expensive Dextrose"},
					Custodian:    "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH",
					Location:     "None",
					Timestamp:    1552583510960,
					Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
				}
				bytes, _ := json.Marshal(container)
				key := container.ID
				bytes2, _ := json.Marshal(product)
				key2 := product.ID
				mockStub.MockTransactionStart(txID)
				mockStub.PutState(key, bytes)
				mockStub.PutState(key2, bytes2)
				mockStub.MockTransactionEnd(txID)

				// Run Create Product transaction
				args := [][]byte{[]byte("unpackage"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46"), []byte("1d15d7b8-caaa-468d-8b83-aae049b40f46")}
				response := mockStub.MockInvoke("supplychain", args)

				updatedBytesContainer, _ := mockStub.GetState(key)
				updatedBytesProduct, _ := mockStub.GetState(key2)

				var updatedContainer Container
				var updatedProduct Product

				json.Unmarshal(updatedBytesContainer, &updatedContainer)
				json.Unmarshal(updatedBytesProduct, &updatedProduct)

				// Retrieve results
				var results map[string]interface{}
				json.Unmarshal(response.Payload, &results)

				Expect(response.Status).To(BeEquivalentTo(200))
				Expect(updatedContainer.Contents).To(BeEquivalentTo([]string{}))
				Expect(updatedProduct.ContainerID).To(BeEquivalentTo(""))
			})
		})
	})

	// g.Describe("Container History ", func() {
	// 	g.BeforeEach(func() {
	// 		// Set time mock
	// 		mockClock := clock.NewMock()
	// 		mockClock.Set(time.Unix(int64(1552583510960), int64(0)))
	// 		chaincode.clock = mockClock
	// 		mockStub = NewMockStubWithCreator("mockstub", chaincode, "ManufacturerMSP", "../testdata/manufacturer.pem")
	//
	// 	})
	//
	// 	g.Describe("with valid data", func() {
	// 		g.It("single should return successfully", func() {
	//
	// 			container := Container{
	// 				ID:           "0d15d7b8-caaa-468d-8b83-aae049b40f46",
	// 				Health:       "None",
	// 				Contents:     []string{},
	// 				Metadata:     map[string]interface{}{"name": "Not Expensive Dextrose"},
	// 				Custodian:    "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US",
	// 				Location:     "None",
	// 				Timestamp:    1552583510960,
	// 				ContainerID:  "",
	// 				Participants: []string{"OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=US", "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US", "OU=Store,O=PartyD,L=40.73/-74/New York,C=US", "CN=User1@manufacturer-net,OU=user+OU=Manufacturer,O=PartyA,L=47.38/8.54/Zurich,C=CH"},
	// 			}
	// 			bytes, _ := json.Marshal(container)
	// 			key := container.ID
	//
	// 			mockStub.MockTransactionStart(txID)
	// 			mockStub.PutState(key, bytes)
	// 			mockStub.MockTransactionEnd(txID)
	//
	// 			// Run Create Product transaction
	// 			args := [][]byte{[]byte("claimContainer"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46"), []byte("")}
	// 			response := mockStub.MockInvoke("supplychain", args)
	//
	// 			args2 := [][]byte{[]byte("history"), []byte("0d15d7b8-caaa-468d-8b83-aae049b40f46")}
	// 			response2 := mockStub.MockInvoke("supplychain", args2)
	//
	// 			Expect(response.Status).To(BeEquivalentTo(200))
	// 			Expect(response2.Message).To(BeEquivalentTo(200))
	// 			Expect(response2.Payload).To(HaveLen(2))
	//
	// 		})
	// 	})
	// })
}
