package cliwrapper

import (
	"fmt"
	"io/ioutil"
	"newscli/apiwrapper"
	"newscli/dbwrapper"
	"newscli/errorutil"
	"os/exec"
	"runtime"

	"github.com/peterbourgon/diskv"
	"github.com/skratchdot/open-golang/open"
)

// RunCommand runs a given command if it exists
func RunCommand(command string, args []string, d *diskv.Diskv) {
	commandMap := map[string]func([]string, *diskv.Diskv) string{
		"find":   find,
		"read":   read,
		"help":   help,
		"--help": help,
		"list":   list,
	}

	if val, ok := commandMap[command]; ok {
		fmt.Println(val(args, d))
	} else {
		fmt.Printf("Command '%s' not found!\n", command)
	}

}

func find(args []string, d *diskv.Diskv) string {
	params := map[string]string{
		"q": args[0],
	}
	response := apiwrapper.GetNews(params, d)
	return response
}

func read(args []string, d *diskv.Diskv) string {
	url := dbwrapper.GetOne(args[0], d)

	if runtime.GOOS == "windows" {
		fmt.Println("Can't read this on a windows machine")
		return url
	}

	flag := len(args) >= 2

	if flag {
		if args[1] == "--term" || args[1] == "--terminal" {
			_, err := exec.Command(fmt.Sprintf("curl -L \"%s\" | w3m -dump -T text/html | less", url)).Output()
			errorutil.Check(err)
		}

	} else {
		err := open.Run(url)
		errorutil.Check(err)
	}

	return ""
}

func help(args []string, d *diskv.Diskv) string {
	dat, err := ioutil.ReadFile("/home/john/go/src/newscli/cliwrapper/help.txt")
	errorutil.Check(err)
	return string(dat)
}

func list(args []string, d *diskv.Diskv) string {
	dbwrapper.GetAll(d)

	return ""
}
