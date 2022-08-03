package common

// The UpdateRequest models a product update in a supply chain
type UpdateRequest struct {
	ID       string                 `json:"trackingID"`
	Health   string                 `json:"health"`
	Metadata map[string]interface{} `json:"misc"`
	Location string                 `json:"lastScannedAt"`
}
