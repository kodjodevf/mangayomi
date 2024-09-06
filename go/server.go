package server

//credits: https://github.com/glblduh/StreamRest
import (
	"context"
	"encoding/json"
	"log"
	"net"
	"net/http"
	"net/url"
	"os"
	"os/signal"
	"path/filepath"
	"strings"
	"syscall"
	"time"

	"github.com/anacrolix/torrent"
	"github.com/anacrolix/torrent/metainfo"
	"github.com/rs/cors"
)

var torrentCli *torrent.Client
var torrentcliCfg *torrent.ClientConfig

func Start(config *Config) (int, error) {

	torrentcliCfg = torrent.NewDefaultClientConfig()

	torrentcliCfg.DataDir = filepath.Clean(config.Path)

	log.Printf("[INFO] Download directory is set to: %s\n", torrentcliCfg.DataDir)

	var torrentCliErr error
	torrentCli, torrentCliErr = torrent.NewClient(torrentcliCfg)
	if torrentCliErr != nil {
		log.Fatalf("[ERROR] Creation of BitTorrent client failed: %s\n", torrentCliErr)
	}

	dnsResolve()

	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)
	go func() {
		<-sigs
		log.Println("[INFO] Termination detected. Removing torrents")
		for _, t := range torrentCli.Torrents() {
			log.Printf("[INFO] Removing torrent: [%s]\n", t.Name())
			t.Drop()
			rmaErr := os.RemoveAll(filepath.Join(torrentcliCfg.DataDir, t.Name()))
			if rmaErr != nil {
				log.Printf("[ERROR] Failed to remove files of torrent: [%s]: %s\n", t.Name(), rmaErr)
			}
		}
		os.Exit(0)
	}()

	mux := http.NewServeMux()
	mux.HandleFunc("/torrent/addmagnet", addMagnet)
	mux.HandleFunc("/torrent/stream", streamTorrent)
	mux.HandleFunc("/torrent/remove", removeTorrent)
	mux.HandleFunc("/torrent/torrents", listTorrents)
	mux.HandleFunc("/torrent/play", playTorrent)
	mux.HandleFunc("/torrent/add", AddTorrent)
	mux.HandleFunc("/", Init)

	c := cors.New(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"GET", "POST", "DELETE"},
		AllowCredentials: true,
	})

	listener, err := net.Listen("tcp", config.Address)
	if err != nil {
		return 0, err
	}
	addr := listener.Addr().(*net.TCPAddr)

	log.Printf("[INFO] Listening on %s\n", addr.AddrPort())

	go func() {
		if err := http.Serve(listener, c.Handler(mux)); err != nil && err != http.ErrServerClosed {
			panic(err)
		}
	}()

	return addr.Port, nil
}

func safenDisplayPath(displayPath string) string {
	fileNameArray := strings.Split(displayPath, "/")
	return strings.Join(fileNameArray, " ")
}

func appendFilePlaylist(scheme string, host string, infohash string, name string) string {
	playList := "#EXTINF:-1," + safenDisplayPath(name) + "\n"
	playList += scheme + "://" + host + "/torrent/stream?infohash=" + infohash + "&file=" + url.QueryEscape(name) + "\n"
	return playList
}

func nameCheck(str string, substr string) bool {
	splittedSubStr := strings.Split(substr, " ")
	for _, curWord := range splittedSubStr {
		if !strings.Contains(str, curWord) {
			return false
		}
	}
	return true
}

func getTorrentFile(files []*torrent.File, filename string, exactName bool) *torrent.File {
	var tFile *torrent.File = nil
	for _, file := range files {
		if exactName && file.DisplayPath() == filename {
			tFile = file
		}
		if !exactName && filename != "" && nameCheck(strings.ToLower(file.DisplayPath()), strings.ToLower(filename)) {
			tFile = file
		}
		if tFile != nil {
			break
		}
	}
	return tFile
}

// https://github.com/YouROK/TorrServer/blob/681fc5c343f6d2782dee0c015d2ba2dfd210f88f/server/cmd/main.go#L114
func dnsResolve() {
	addrs, err := net.LookupHost("www.google.com")
	if len(addrs) == 0 {
		log.Printf("Check dns failed", addrs, err)

		fn := func(ctx context.Context, network, address string) (net.Conn, error) {
			d := net.Dialer{}
			return d.DialContext(ctx, "udp", "1.1.1.1:53")
		}

		net.DefaultResolver = &net.Resolver{
			Dial: fn,
		}

		addrs, err = net.LookupHost("www.google.com")
		log.Printf("Check cloudflare dns", addrs, err)
	} else {
		log.Printf("Check dns OK", addrs, err)
	}
}

func makePlayStreamURL(infohash string, filename string, isStream bool) string {
	endPoint := "play"
	if isStream {
		endPoint = "stream"
	}
	URL := "/torrent/" + endPoint + "?infohash=" + infohash
	if filename != "" {
		URL += "&file=" + url.QueryEscape(filename)
	}
	return URL
}

func httpJSONError(w http.ResponseWriter, error string, code int) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	if json.NewEncoder(w).Encode(errorRes{
		Error: error,
	}) != nil {
		http.Error(w, error, code)
	}
}

func parseRequestBody(w http.ResponseWriter, r *http.Request, v any) error {
	err := json.NewDecoder(r.Body).Decode(v)
	if err != nil {
		httpJSONError(w, "Request JSON body decode error", http.StatusInternalServerError)
	}
	return err
}

func makeJSONResponse(w http.ResponseWriter, v any) {
	w.Header().Set("Content-Type", "application/json")
	err := json.NewEncoder(w).Encode(v)
	if err != nil {
		httpJSONError(w, "Response JSON body encode error", http.StatusInternalServerError)
	}
}

func getInfo(t *torrent.Torrent) {
	if t != nil {
		<-t.GotInfo()
	}
}

func initMagnet(w http.ResponseWriter, magnet string, alldn []string, alltr []string) *torrent.Torrent {
	var t *torrent.Torrent = nil
	var err error
	magnetString := magnet
	for _, dn := range alldn {
		magnetString += "&dn=" + url.QueryEscape(dn)
	}
	for _, tr := range alltr {
		magnetString += "&tr=" + url.QueryEscape(tr)
	}
	t, err = torrentCli.AddMagnet(magnetString)
	if err != nil {
		httpJSONError(w, "Torrent add error", http.StatusInternalServerError)
	}
	getInfo(t)
	return t
}

func getTorrent(w http.ResponseWriter, infoHash string) *torrent.Torrent {
	var t *torrent.Torrent = nil
	var tOk bool
	if len(infoHash) != 40 {
		httpJSONError(w, "InfoHash not valid", http.StatusInternalServerError)
		return t
	}
	t, tOk = torrentCli.Torrent(metainfo.NewHashFromHex(infoHash))
	if !tOk {
		httpJSONError(w, "Torrent not found", http.StatusNotFound)
	}
	getInfo(t)
	return t
}

func parseTorrentStats(t *torrent.Torrent) torrentStatsRes {
	var tsRes torrentStatsRes

	tsRes.InfoHash = t.InfoHash().String()
	tsRes.Name = t.Name()
	tsRes.TotalPeers = t.Stats().TotalPeers
	tsRes.ActivePeers = t.Stats().ActivePeers
	tsRes.HalfOpenPeers = t.Stats().HalfOpenPeers
	tsRes.PendingPeers = t.Stats().PendingPeers

	if t.Info() == nil {
		return tsRes
	}

	for _, tFile := range t.Files() {
		tsRes.Files.OnTorrent = append(tsRes.Files.OnTorrent, torrentStatsFilesOnTorrent{
			FileName:      tFile.DisplayPath(),
			FileSizeBytes: int(tFile.Length()),
		})
		if tFile.BytesCompleted() != 0 {
			tsRes.Files.OnDisk = append(tsRes.Files.OnDisk, torrentStatsFilesOnDisk{
				FileName:        tFile.DisplayPath(),
				StreamURL:       makePlayStreamURL(t.InfoHash().String(), tFile.DisplayPath(), true),
				BytesDownloaded: int(tFile.BytesCompleted()),
				FileSizeBytes:   int(tFile.Length()),
			})
		}
	}

	return tsRes
}

func addMagnet(w http.ResponseWriter, r *http.Request) {
	var amBody addMagnetBody
	var amRes addMagnetRes

	if parseRequestBody(w, r, &amBody) != nil {
		return
	}

	if amBody.Magnet == "" {
		httpJSONError(w, "Magnet link is not provided", http.StatusNotFound)
		return
	}

	t := initMagnet(w, amBody.Magnet, []string{}, []string{})
	if t == nil {
		return
	}

	amRes.InfoHash = t.InfoHash().String()
	amRes.Name = t.Name()

	if amBody.AllFiles {
		amRes.PlaylistURL = makePlayStreamURL(t.InfoHash().String(), "", false)
		for _, tFile := range t.Files() {
			amRes.Files = append(amRes.Files, addMagnetFiles{
				FileName:      tFile.DisplayPath(),
				StreamURL:     makePlayStreamURL(t.InfoHash().String(), tFile.DisplayPath(), true),
				FileSizeBytes: int(tFile.Length()),
			})
		}
		makeJSONResponse(w, &amRes)
		return
	}

	if len(amBody.Files) > 0 {
		amRes.PlaylistURL = makePlayStreamURL(t.InfoHash().String(), "", false)
		for _, selFile := range amBody.Files {
			tFile := getTorrentFile(t.Files(), selFile, false)
			if tFile == nil {
				continue
			}
			amRes.PlaylistURL += "&file=" + url.QueryEscape(tFile.DisplayPath())
			amRes.Files = append(amRes.Files, addMagnetFiles{
				FileName:      tFile.DisplayPath(),
				StreamURL:     makePlayStreamURL(t.InfoHash().String(), tFile.DisplayPath(), true),
				FileSizeBytes: int(tFile.Length()),
			})
		}
		makeJSONResponse(w, &amRes)
		return
	}

	for _, tFile := range t.Files() {
		amRes.Files = append(amRes.Files, addMagnetFiles{
			FileName:      tFile.DisplayPath(),
			FileSizeBytes: int(tFile.Length()),
		})
	}
	makeJSONResponse(w, &amRes)
}

func streamTorrent(w http.ResponseWriter, r *http.Request) {
	infoHash, ihOk := r.URL.Query()["infohash"]
	fileName, fnOk := r.URL.Query()["file"]

	if !ihOk || !fnOk {
		httpJSONError(w, "InfoHash or File is not provided", http.StatusNotFound)
		return
	}

	t := getTorrent(w, infoHash[0])
	if t == nil {
		return
	}

	tFile := getTorrentFile(t.Files(), fileName[0], true)
	if tFile == nil {
		httpJSONError(w, "File not found", http.StatusNotFound)
		return
	}
	fileRead := tFile.NewReader()
	defer fileRead.Close()
	fileRead.SetReadahead(tFile.Length() / 100)
	http.ServeContent(w, r, tFile.DisplayPath(), time.Now(), fileRead)
}

func removeTorrent(w http.ResponseWriter, r *http.Request) {
	infoHash, ihOk := r.URL.Query()["infohash"]
	if !ihOk {
		httpJSONError(w, "InfoHash is not provided", http.StatusNotFound)
		return
	}
	t := getTorrent(w, infoHash[0])
	if t == nil {
		httpJSONError(w, "Torrent not found", http.StatusNotFound)
		return
	}

	t.Drop()

	if os.RemoveAll(filepath.Join(torrentcliCfg.DataDir, t.Name())) != nil {

		httpJSONError(w, "ERROR WHEN REMOVING FILE", http.StatusInternalServerError)
		return

	}

}

func listTorrents(w http.ResponseWriter, r *http.Request) {
	infoHash, ihOk := r.URL.Query()["infohash"]
	var ltRes listTorrentsRes

	allTorrents := torrentCli.Torrents()

	if ihOk {
		allTorrents = nil
		t := getTorrent(w, infoHash[0])
		if t == nil {
			return
		}
		allTorrents = append(allTorrents, t)
	}

	for _, t := range allTorrents {
		ltRes.Torrents = append(ltRes.Torrents, parseTorrentStats(t))
	}

	if !ihOk && len(ltRes.Torrents) < 1 {
		w.WriteHeader(404)
	}

	makeJSONResponse(w, &ltRes)
}

func AddTorrent(w http.ResponseWriter, request *http.Request) {

	a, _, error := request.FormFile("file")
	if error != nil {
		log.Printf("error upload torrent")
		w.WriteHeader(http.StatusForbidden)
		return
	}

	metainf, er_ := metainfo.Load(a)
	if er_ != nil {
		log.Printf("error error when loading MetaInfo")
		w.WriteHeader(http.StatusForbidden)
		return
	}
	torrent, err := torrentCli.AddTorrent(metainf)
	if err != nil {
		log.Print(err.Error())
		w.WriteHeader(http.StatusForbidden)
		return
	}

	w.Write([]byte(torrent.InfoHash().HexString()))

}
func Init(w http.ResponseWriter, request *http.Request) {

	w.Write([]byte("Torrent server is running"))

}

func playTorrent(w http.ResponseWriter, r *http.Request) {
	infoHash, ihOk := r.URL.Query()["infohash"]
	magnet, magOk := r.URL.Query()["magnet"]
	displayName := r.URL.Query()["dn"]
	trackers := r.URL.Query()["tr"]
	files, fOk := r.URL.Query()["file"]

	if !magOk && !ihOk {
		httpJSONError(w, "Magnet link or InfoHash is not provided", http.StatusNotFound)
		return
	}

	var t *torrent.Torrent
	if magOk && !ihOk {
		t = initMagnet(w, magnet[0], displayName, trackers)
	}

	if ihOk && !magOk {
		t = getTorrent(w, infoHash[0])
	}

	if t == nil {
		return
	}

	w.Header().Set("Content-Disposition", "attachment; filename=\""+t.InfoHash().String()+".m3u\"")
	playList := "#EXTM3U\n"

	httpScheme := "http"
	if r.Header.Get("X-Forwarded-Proto") != "" {
		httpScheme = r.Header.Get("X-Forwarded-Proto")
	}

	if !fOk {
		for _, tFile := range t.Files() {
			playList += appendFilePlaylist(httpScheme, r.Host, t.InfoHash().String(), tFile.DisplayPath())
		}
	}

	for _, file := range files {
		tFile := getTorrentFile(t.Files(), file, false)
		if tFile == nil {
			continue
		}
		playList += appendFilePlaylist(httpScheme, r.Host, t.InfoHash().String(), tFile.DisplayPath())
	}

	w.Write([]byte(playList))
}

type errorRes struct {
	Error string
}

type addMagnetBody struct {
	Magnet   string
	AllFiles bool
	Files    []string
}

type addMagnetRes struct {
	InfoHash    string
	Name        string
	PlaylistURL string
	Files       []addMagnetFiles
}

type addMagnetFiles struct {
	FileName      string
	StreamURL     string
	FileSizeBytes int
}

type listTorrentsRes struct {
	Torrents []torrentStatsRes
}

type torrentStatsRes struct {
	InfoHash      string
	Name          string
	TotalPeers    int
	ActivePeers   int
	PendingPeers  int
	HalfOpenPeers int
	Files         torrentStatsFiles
}

type torrentStatsFiles struct {
	OnTorrent []torrentStatsFilesOnTorrent
	OnDisk    []torrentStatsFilesOnDisk
}

type torrentStatsFilesOnTorrent struct {
	FileName      string
	FileSizeBytes int
}

type torrentStatsFilesOnDisk struct {
	FileName        string
	StreamURL       string
	BytesDownloaded int
	FileSizeBytes   int
}

type Config struct {
	Address string `json:"address"`
	Path    string `json:"path"`
}
