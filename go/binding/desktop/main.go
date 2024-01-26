package main

import (
	"C"
	"encoding/json"
	"server"
)

//export Start
func Start(mcfg *C.char) (int, *C.char) {
	var config server.Config
	json.Unmarshal([]byte(C.GoString(mcfg)), &config)
	port, err := server.Start(&config)
	if err != nil {
		return 0, C.CString(err.Error())
	}
	return port, nil
}

func main() {}
