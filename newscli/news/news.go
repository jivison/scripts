//$ {"name": "news", "language": "go", "description": "Command line news browser and storage"}

package main

import (
	"fmt"
	"newscli/cliwrapper"
	"os"

	"github.com/peterbourgon/diskv"
)

func main() {
	flatTransform := func(s string) []string { return []string{} }

	d := diskv.New(diskv.Options{
		BasePath:     "newsdb",
		Transform:    flatTransform,
		CacheSizeMax: 1024 * 1024,
	})

	if len(os.Args) > 1 {
		cliwrapper.RunCommand(os.Args[1], os.Args[2:], d)
	} else {
		fmt.Println("Please supply a command!")
	}
}
