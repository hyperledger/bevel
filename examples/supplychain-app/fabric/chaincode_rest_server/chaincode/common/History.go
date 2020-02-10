package common

// The History models a historical custodian change in the supply chain
type History struct {
	Location  string `json:"lastScannedAt"`
	Timestamp int64  `json:"timestamp"`
	Custodian string `json:"custodian"`
}
