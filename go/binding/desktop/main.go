package main

import (
	"server"
)

import "C"

//export Start
func Start(path *C.char) {
	server.Start(C.GoString(path))
}

func main() {}
