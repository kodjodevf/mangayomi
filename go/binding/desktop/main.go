package main

import (
	"encoding/json"
	"server"
)

import "C"

//export Start
func Start(mcfg *C.char) {
	var config server.Config
	json.Unmarshal([]byte(C.GoString(mcfg)), &config)
	server.Start(&config)
}

func main() {}
