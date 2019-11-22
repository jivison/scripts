package apiwrapper

import "encoding/json"

// ParseResponse handles a newsapi query
func ParseResponse(responseJSON string) []interface{} {
	var response map[string]interface{}
	json.Unmarshal([]byte(responseJSON), &response)
	return response["articles"].([]interface{})
}
