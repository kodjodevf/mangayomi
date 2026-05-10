package main

import (
	"C"
	"encoding/json"
	"server"
)

//export Start
func Start(mcfg *C.char) (int, *C.char) {
	if mcfg == nil {
		return 0, C.CString("missing config")
	}

	var config server.Config
	if err := json.Unmarshal([]byte(C.GoString(mcfg)), &config); err != nil {
		return 0, C.CString("invalid config JSON: " + err.Error())
	}

	port, err := server.Start(&config)
	if err != nil {
		return 0, C.CString(err.Error())
	}
	return port, nil
}

func main() {}
