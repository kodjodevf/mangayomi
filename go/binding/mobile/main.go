package libmtorrentserver

// #cgo LDFLAGS: -static-libstdc++
import "C"
import (
	"server"
)

//export Start
func Start(path string) {
	server.Start(path)
}
