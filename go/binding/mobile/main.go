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
	if err := json.Unmarshal([]byte(mcfg), &config); err != nil {
		return 0, err
	}

	return server.Start(&config)
}
