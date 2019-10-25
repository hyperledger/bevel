package common

import (
	"encoding/json"
	"errors"
)

// The Container models a container in a supply chain
type Container struct {
	ID           string                 `json:"trackingID"`
	Type         string                 `json:"docType"`
	Health       string                 `json:"health"`
	Contents     []string               `json:"contents"`
	Metadata     map[string]interface{} `json:"misc"`
	Custodian    string                 `json:"custodian"`
	Location     string                 `json:"lastScannedAt"`
	Timestamp    int64                  `json:"timestamp"`
	ContainerID  string                 `json:"containerID"`
	Participants []string               `json:"participants"`
}

// AccessibleBy returns true or false depending on if the supplied organization is a member of the application
func (container *Container) AccessibleBy(id *Identity) bool {
	idType := id.Cert.Subject.String()
	for _, v := range container.Participants {
		if v == idType {
			return true
		}
	}
	return false
}

//UnmarshalJSON will override unmarshal
func (container *Container) UnmarshalJSON(data []byte) error {
	var input map[string]interface{}
	err := json.Unmarshal(data, &input)
	if err != nil {
		return err
	}

	if input["productName"] != nil {
		return errors.New("Not a Container")
	}

	// Prevent circular reference
	type Alias Container
	var output Alias
	err = json.Unmarshal(data, &output)
	if err != nil {
		return err
	}

	c := Container(output)
	*container = c

	return nil
}

func (container *Container) Remove(item string) {
	for i, other := range container.Contents {
		if other == item {
			container.Contents = append(container.Contents[:i], container.Contents[i+1:]...)
		}
	}
}
