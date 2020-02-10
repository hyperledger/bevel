package common

import (
	"encoding/json"
	"errors"
)

// The Product models a product in a supply chain
type Product struct {
	ID           string                 `json:"trackingID"`
	Type         string                 `json:"docType"`
	Name         string                 `json:"productName"`
	Health       string                 `json:"health"`
	Sold         bool                   `json:"sold"`
	Recalled     bool                   `json:"recalled"`
	Metadata     map[string]interface{} `json:"misc"`
	Custodian    string                 `json:"custodian"`
	Location     string                 `json:"lastScannedAt"`
	Timestamp    int64                  `json:"timestamp"`
	ContainerID  string                 `json:"containerID"`
	Participants []string               `json:"participants"`
}

// AccessibleBy returns true or false depending on if the supplied organization is a member of the application
func (product *Product) AccessibleBy(id *Identity) bool {
	idType := id.Cert.Subject.String()
	for _, v := range product.Participants {
		if v == idType {
			return true
		}
	}
	return false
}

//UnmarshalJSON will override Unmarshal
func (product *Product) UnmarshalJSON(data []byte) error {
	var input map[string]interface{}
	err := json.Unmarshal(data, &input)
	if err != nil {
		return err
	}

	if input["productName"] == nil {
		return errors.New("Not a Product")
	}

	// Prevent circular reference
	type Alias Product
	var output Alias
	err = json.Unmarshal(data, &output)
	if err != nil {
		return err
	}

	c := Product(output)
	*product = c

	return nil
}
