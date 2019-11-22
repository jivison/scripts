package dbwrapper

import (
	"fmt"
	"newscli/errorutil"
	"strconv"

	"github.com/peterbourgon/diskv"
)

// GetAll returns all the previously fetched result
func GetAll(d *diskv.Diskv) {
	numArticles, _ := d.Read("mostRecentCount")

	num, err := strconv.Atoi(string(numArticles))
	errorutil.Check(err)

	for i := 0; i < num; i++ {
		key := fmt.Sprintf("%d_string", i)

		articleString, _ := d.Read(key)
		fmt.Printf("%s", articleString)

		// Only show 10 at a time
		if i == 10 {
			break
		}
	}

}
