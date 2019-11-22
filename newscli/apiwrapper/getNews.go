package apiwrapper

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"newscli/dbwrapper"
	"newscli/errorutil"

	"github.com/peterbourgon/diskv"
)

func createURL(params map[string]string, apikey string) string {
	u := url.URL{
		Scheme: "https",
		Host:   "newsapi.org",
		Path:   "/v2/everything",
	}

	q := u.Query()
	q.Set("apikey", apikey)

	for name, value := range params {
		q.Set(name, value)
	}

	u.RawQuery = q.Encode()
	return u.String()
}

// GetNews gets news from newsapi (newsapi.org)
func GetNews(params map[string]string, d *diskv.Diskv) string {
	apikey := GetKey("newsapi")
	u := createURL(params, apikey)

	response, err := http.Get(u)
	errorutil.Check(err)

	defer response.Body.Close()

	body, err := ioutil.ReadAll(response.Body)
	errorutil.Check(err)

	parsedResponse := ParseResponse(string(body))

	dbwrapper.StoreNews(parsedResponse, d)

	for index, article := range parsedResponse[:10] {
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

		fmt.Printf("%d) %s:\n%s by %s\n\n", index+1, sourceName, articleTitle, articleAuthor)
	}

	return ""
}
