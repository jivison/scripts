package errorutil

// Check panics if an error exists
func Check(e error) {
	if e != nil {
		panic(e)
	}
}
