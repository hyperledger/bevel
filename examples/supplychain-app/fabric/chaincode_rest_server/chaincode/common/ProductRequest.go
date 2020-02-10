package common

// The ProductRequest models request body for new product in a supply chain
type ProductRequest struct {
	ID           string                 `json:"trackingID"`
	ProductName  string                 `json:"productName"`
	Health       string                 `json:"health"`
	Metadata     map[string]interface{} `json:"misc"`
	Location     string                 `json:"lastScannedAt"`
	Participants []string               `json:"counterparties"`
}
