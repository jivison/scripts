package dbwrapper

import (
	"fmt"
	"strconv"

	"github.com/peterbourgon/diskv"
)

// StoreNews accepts a list of news and stores it for reading
func StoreNews(news []interface{}, d *diskv.Diskv) {

	count := strconv.Itoa(len(news))

	d.Write("mostRecentCount", []byte(count))

	for index, article := range news {
		typedArticle := article.(map[string]interface{})
		source := typedArticle["source"].(map[string]interface{})

		var sourceName string
		if name, ok := source["name"]; ok && name != nil {
			sourceName = name.(string)
		} else {
			sourceName = "unknown source"
		}

		var articleTitle, articleAuthor string = "unknown title", "unknown author"

		if typedArticle["title"] != nil {
			articleTitle = typedArticle["title"].(string)
		}
		if typedArticle["author"] != nil {
			articleAuthor = typedArticle["author"].(string)
		}

		articleURL := article.(map[string]interface{})["url"].(string)
		articleString := fmt.Sprintf("%d) %s:\n%s by %s\n\n", index+1, sourceName, articleTitle, articleAuthor)

		urlkey := fmt.Sprintf("%d_url", index+1)
		stringkey := fmt.Sprintf("%d_string", index+1)

		d.Write(urlkey, []byte(articleURL))
		d.Write(stringkey, []byte(articleString))
	}
}

// OBSOLETE (with badger)
// StoreNews accepts a list of news and stores it for reading
// func StoreNews(news []interface{}) {
// 	db, err := badger.Open(badger.DefaultOptions("/tmp/badger"))
// 	errorutil.Check(err)
// 	defer db.Close()

// 	for index, article := range news {
// 		err := db.Update(func(txn *badger.Txn) error {
// 			articleURL := article.(map[string]interface{})["url"].(string)

// 			err := txn.Set([]byte(fmt.Sprintf("url_%s", string(index))), []byte(articleURL))
// 			return err
// 		})
// 		errorutil.Check(err)
// 	}
// }
