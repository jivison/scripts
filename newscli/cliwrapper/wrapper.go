package cliwrapper

import (
	"bufio"
	"fmt"
	"os"
)

// Input function takes user input
func Input(msg string) string {
	reader := bufio.NewReader(os.Stdin)
	fmt.Print(msg)
	text, _ := reader.ReadString('\n')
	return text
}
