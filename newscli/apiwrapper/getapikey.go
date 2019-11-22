package apiwrapper

import (
	"fmt"
	"io/ioutil"
	"newscli/errorutil"
)

// GetKey returns the newsapi key
func GetKey(api string) string {
	dat, err := ioutil.ReadFile(fmt.Sprintf("/home/john/go/src/newscli/apiwrapper/%s.apikey", api))
	errorutil.Check(err)
	return string(dat)
}
