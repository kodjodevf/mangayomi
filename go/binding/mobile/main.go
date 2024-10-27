package libmtorrentserver

// #cgo LDFLAGS: -static-libstdc++
import "C"
import (
	"encoding/json"
	"server"
)

//export Start
func Start(mcfg string) (int, error) {
	var config server.Config
	json.Unmarshal([]byte(mcfg), &config)
	return server.Start(&config)
}

//export Stop
func Stop() error {
	return server.Stop()
}
