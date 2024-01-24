package libmtorrentserver

// #cgo LDFLAGS: -static-libstdc++
import "C"
import (
	"encoding/json"
	"server"
)

//export Start
func Start(mcfg string) {
	var config server.Config
	json.Unmarshal([]byte(mcfg), &config)
	server.Start(&config)

}
