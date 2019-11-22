package dbwrapper

import (
	"fmt"

	"github.com/peterbourgon/diskv"
)

// GetOne returns a url from a numbered article
func GetOne(numberString string, d *diskv.Diskv) string {

	key := fmt.Sprintf("%s_url", numberString)

	articleURL, _ := d.Read(key)

	return string(articleURL)

}

// OBSOLETE (with badger)
// GetOne returns a url from a numbered article
// func GetOne(numberString string) string {

// 	number, err := strconv.Atoi(numberString)
// 	errorutil.Check(err)

// 	db, err := badger.Open(badger.DefaultOptions("/tmp/badger"))
// 	errorutil.Check(err)
// 	defer db.Close()

// 	var articleURL []byte

// 	err = db.View(func(txn *badger.Txn) error {
// 		fmt.Printf("Looking for article: %d\n", number)

// 		item, err := txn.Get([]byte(fmt.Sprintf("url_%d", number-1)))

// 		errorutil.Check(err)

// 		err = item.Value(func(val []byte) error {
// 			articleURL = append([]byte{}, val...)
// 			return nil
// 		})

// 		return err
// 	})

// 	errorutil.Check(err)

// 	return string(articleURL)

// }
