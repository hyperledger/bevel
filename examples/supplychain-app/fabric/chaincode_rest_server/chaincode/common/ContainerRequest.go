package common

// The ContainerRequest models a request body for container creation in a supply chain
type ContainerRequest struct {
	ID           string                 `json:"trackingID"`
	Health       string                 `json:"health"`
	Metadata     map[string]interface{} `json:"misc"`
	Location     string                 `json:"lastScannedAt"`
	Participants []string               `json:"counterparties"`
}
