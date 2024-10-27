package server

//credits: https://github.com/glblduh/StreamRest
import (
	"bufio"
	"bytes"
	"context"
	"crypto/tls"
	"crypto/x509"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net"
	"net/http"
	"net/http/cookiejar"
	"net/url"
	"os"
	"os/signal"
	"path"
	"path/filepath"
	"regexp"
	"runtime"
	"strconv"
	"strings"
	"sync"
	"syscall"
	"time"

	"github.com/anacrolix/torrent"
	"github.com/anacrolix/torrent/metainfo"
	"github.com/rs/cors"

	"github.com/bzsome/chaoGo/workpool"
	"github.com/go-resty/resty/v2"
	"github.com/patrickmn/go-cache"
)

var torrentCli *torrent.Client
var torrentcliCfg *torrent.ClientConfig
var httpServer *http.Server

func Start(config *Config) (int, error) {

	// Set log output
	log.SetOutput(os.Stdout)

	// Set log prefix and flags
	log.SetPrefix("[MediaServer] ")
	log.SetFlags(log.Ldate | log.Ltime | log.Lshortfile)

	// DnsResolverIP = "8.8.8.8:53"

	InitClient()

	if isWorkPool == nil {
		isWorkPool = new(bool)
	}
	*isWorkPool = false

	torrentcliCfg = torrent.NewDefaultClientConfig()

	torrentcliCfg.DataDir = filepath.Clean(config.Path)

	log.Printf("[INFO] Download directory is set to: %s\n", torrentcliCfg.DataDir)

	var torrentCliErr error
	torrentCli, torrentCliErr = torrent.NewClient(torrentcliCfg)
	if torrentCliErr != nil {
		log.Fatalf("[ERROR] Creation of BitTorrent client failed: %s\n", torrentCliErr)
	}

	dnsResolve()

	signal.Ignore(syscall.SIGPIPE)
	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)
	go func() {
		<-sigs
		log.Println("[INFO] Detected termination signal")
		if err := Stop(); err != nil {
			log.Printf("[ERROR] Error stopping service: %v", err)
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
	mux.HandleFunc("/proxy", handleProxy)
	mux.HandleFunc("/", handleMethod)

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
	httpServer = &http.Server{
		Addr:    config.Address,
		Handler: c.Handler(mux),
	}
	go func() {
		if err := httpServer.Serve(listener); err != nil && err != http.ErrServerClosed {
			log.Printf("[ERROR] HTTP server error: %v", err)
			if err := listener.Close(); err != nil {
				log.Printf("[ERROR] Error closing listener: %v", err)
			}
		}
	}()

	return addr.Port, nil
}

func Stop() error {
	log.Println("[INFO] Stopping service...")

	// 1. Stop HTTP server
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := httpServer.Shutdown(ctx); err != nil {
		log.Printf("[ERROR] Error stopping HTTP server: %v", err)
	}

	// 2. Close all active torrents
	for _, t := range torrentCli.Torrents() {
		log.Printf("[INFO] Removing torrent: [%s]", t.Name())
		t.Drop()
	}

	// 3. Clean up download directory
	if err := os.RemoveAll(torrentcliCfg.DataDir); err != nil {
		log.Printf("[ERROR] Failed to clean up download directory: %v", err)
	}

	// 4. Release other resources
	if torrentCli != nil {
		torrentCli.Close()
		torrentCli = nil
	}

	// 5. Release resources initialized in InitClient
	if NoRedirectClient != nil {
		NoRedirectClient.GetClient().CloseIdleConnections()
		NoRedirectClient = nil
	}
	if NoRedirectClientWithProxy != nil {
		NoRedirectClientWithProxy.GetClient().CloseIdleConnections()
		NoRedirectClientWithProxy = nil
	}
	if RestyClient != nil {
		RestyClient.GetClient().CloseIdleConnections()
		RestyClient = nil
	}
	if RestyClientWithProxy != nil {
		RestyClientWithProxy.GetClient().CloseIdleConnections()
		RestyClientWithProxy = nil
	}

	// Clear cache
	if mediaCache != nil {
		mediaCache.Flush()
		mediaCache = nil
	}

	// Clean up global variables
	torrentcliCfg = nil

	log.Println("[INFO] Service stopped")
	return nil
}

func handleProxy(w http.ResponseWriter, r *http.Request) {
	urlStr := r.URL.Query().Get("url")
	if urlStr == "" {
		http.Error(w, "Missing url parameter", http.StatusBadRequest)
		return
	}

	m3u8Content, err := fetchM3U8(urlStr)
	if err != nil {
		http.Error(w, fmt.Sprintf("Failed to fetch M3U8: %v", err), http.StatusInternalServerError)
		return
	}

	fixedM3U8 := fixAdM3u8Ai(urlStr, m3u8Content)

	w.Header().Set("Content-Type", "application/vnd.apple.mpegurl")
	w.Write([]byte(fixedM3U8))
}

func fetchM3U8(url string) (string, error) {
	log.Printf("Fetching M3U8 from %s", url)
	resp, err := RestyClient.SetRetryCount(3).R().Get(url)
	if err != nil {
		return "", err
	}
	return resp.String(), nil
}

func processM3U8Lines(baseUrl string, lines []string) []string {
	processed := make([]string, len(lines))
	for i, line := range lines {
		if strings.HasPrefix(line, "#EXT-X-KEY") {
			processed[i] = fixKeyLine(line, baseUrl)
		} else if !strings.HasPrefix(line, "#") {
			processed[i] = urljoin(baseUrl, line)
		} else {
			processed[i] = line
		}
	}
	return processed
}

func fixKeyLine(line, baseUrl string) string {
	parts := strings.Split(line, ",")
	for i, part := range parts {
		if strings.HasPrefix(part, "URI=") {
			uri := strings.Trim(strings.TrimPrefix(part, "URI="), "\"")
			uri = urljoin(baseUrl, uri)
			parts[i] = "URI=\"" + uri + "\""
		}
	}
	return strings.Join(parts, ",")
}

func urljoin(base, rel string) string {
	baseUrl, err := url.Parse(base)
	if err != nil {
		return rel
	}
	relUrl, err := url.Parse(rel)
	if err != nil {
		return rel
	}
	return baseUrl.ResolveReference(relUrl).String()
}

func fixAdM3u8Ai(m3u8Url string, m3u8Content string) string {
	lines := strings.Split(strings.TrimSpace(m3u8Content), "\n")

	// 处理嵌套m3u8
	lastUrl := lines[len(lines)-1]
	if strings.Contains(lastUrl, ".m3u8") && lastUrl != m3u8Url {
		nestedM3u8Url := urljoin(m3u8Url, lastUrl)
		log.Printf("[Debug] Nested m3u8_url: %s", nestedM3u8Url)
		nestedContent, err := fetchM3U8(nestedM3u8Url)
		if err == nil {
			lines = strings.Split(strings.TrimSpace(nestedContent), "\n")
			lines = processM3U8Lines(nestedM3u8Url, lines)
		} else {
			log.Printf("[Error] Failed to fetch nested m3u8: %v", err)
		}
	}

	var filteredLines []string
	adCount := 0
	isAdSection := false
	urlPatterns := make(map[string]struct {
		count    int
		duration float64
	})
	hasEndList := false
	var currentDuration float64

	// First pass: Count all .ts file URL patterns and their durations
	for _, line := range lines {
		if strings.HasPrefix(line, "#EXTINF:") {
			durationStr := strings.TrimPrefix(line, "#EXTINF:")
			durationStr = strings.Split(durationStr, ",")[0]
			duration, err := strconv.ParseFloat(durationStr, 64)
			if err == nil {
				currentDuration = duration
			}
		} else if strings.HasSuffix(line, ".ts") {
			pattern := extractUrlPattern(line)
			info := urlPatterns[pattern]
			info.count++
			info.duration += currentDuration
			urlPatterns[pattern] = info
			currentDuration = 0
		}
	}

	// Find the URL pattern with the longest total duration
	var mainUrlPattern string
	var maxDuration float64
	for pattern, info := range urlPatterns {
		if info.duration > maxDuration {
			maxDuration = info.duration
			mainUrlPattern = pattern
		}
	}

	log.Printf("[Debug] Main URL pattern: %s, Total duration: %.2f seconds, Count: %d", mainUrlPattern, maxDuration, urlPatterns[mainUrlPattern].count)

	// Second pass: Filter ads
	for i := 0; i < len(lines); i++ {
		line := lines[i]

		if line == "#EXT-X-DISCONTINUITY" {
			// Check if the next non-empty line is an ad
			for j := i + 1; j < len(lines); j++ {
				if strings.HasPrefix(lines[j], "#EXTINF:") {
					if j+1 < len(lines) && strings.HasSuffix(lines[j+1], ".ts") {
						urlPattern := extractUrlPattern(lines[j+1])
						if urlPattern != mainUrlPattern {
							isAdSection = true
							adCount++
						} else {
							isAdSection = false
							filteredLines = append(filteredLines, line)
						}
					}
					break
				} else if !strings.HasPrefix(lines[j], "#") {
					break
				}
			}
		} else if isAdSection {
			// Skip all lines in the ad section
			adCount++
			if line == "#EXT-X-ENDLIST" {
				hasEndList = true
			}
		} else {
			filteredLines = append(filteredLines, line)
			if line == "#EXT-X-ENDLIST" {
				hasEndList = true
			}
		}
	}

	// If the original file has #EXT-X-ENDLIST but was removed, we need to add it back
	if hasEndList && filteredLines[len(filteredLines)-1] != "#EXT-X-ENDLIST" {
		filteredLines = append(filteredLines, "#EXT-X-ENDLIST")
	}

	log.Printf("[Debug] Total ads removed: %d lines", adCount)

	// Process all URLs
	baseUrl := getBaseUrl(m3u8Url)
	processedLines := processM3U8Lines(baseUrl, filteredLines)

	return strings.Join(processedLines, "\n")
}

func getBaseUrl(urlStr string) string {
	u, err := url.Parse(urlStr)
	if err != nil {
		return urlStr
	}
	u.Path = path.Dir(u.Path)
	return u.String()
}

func extractUrlPattern(url string) string {
	parts := strings.Split(url, "/")
	if len(parts) > 3 {
		return strings.Join(parts[:len(parts)-1], "/")
	}
	return url
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
		log.Printf("Check dns failed: %v, error: %v", addrs, err)

		fn := func(ctx context.Context, network, address string) (net.Conn, error) {
			d := net.Dialer{}
			return d.DialContext(ctx, "udp", "1.1.1.1:53")
		}

		net.DefaultResolver = &net.Resolver{
			Dial: fn,
		}

		addrs, err = net.LookupHost("www.google.com")
		log.Printf("Check cloudflare dns: %v, error: %v", addrs, err)
	} else {
		log.Printf("Check dns OK: %v, error: %v", addrs, err)
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

type Emitter struct {
	pipeReader *io.PipeReader
	pipeWriter *io.PipeWriter
	closed     bool
}

func (em *Emitter) IsClosed() bool {
	return em.closed
}

func (em *Emitter) Read(b []byte) (int, error) {
	n, err := em.pipeReader.Read(b)
	if err != nil {
		em.Close()
		return 0, err
	}
	return n, nil
}

func (em *Emitter) Write(b []byte) (int, error) {
	n, err := em.pipeWriter.Write(b)
	if err != nil {
		em.Close()
		return 0, err
	}
	return n, nil
}

func (em *Emitter) WriteString(s string) (int, error) {
	return em.Write([]byte(s))
}

func (em *Emitter) Close() error {
	em.closed = true
	em.pipeReader.Close()
	em.pipeWriter.Close()
	return nil
}

func NewEmitter(reader *io.PipeReader, writer *io.PipeWriter) *Emitter {
	return &Emitter{
		pipeReader: reader,
		pipeWriter: writer,
		closed:     false,
	}
}

var (
	NoRedirectClient          *resty.Client
	NoRedirectClientWithProxy *resty.Client
	RestyClient               *resty.Client
	RestyClientWithProxy      *resty.Client
	HttpClient                *http.Client
	// DnsResolverIP             string // Initialize to empty string
	IdleConnTimeout = 10 * time.Second
	// dnsResolverProto          = "udp"
	// dnsResolverTimeoutMs      = 10000
)
var UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36"
var DefaultTimeout = time.Second * 30

func InitClient() {
	NoRedirectClient = resty.New().SetRedirectPolicy(
		resty.RedirectPolicyFunc(func(req *http.Request, via []*http.Request) error {
			return http.ErrUseLastResponse
		}),
	).SetTLSClientConfig(&tls.Config{InsecureSkipVerify: true})
	NoRedirectClient.SetHeader("user-agent", UserAgent)

	NoRedirectClientWithProxy = resty.New().SetRedirectPolicy(
		resty.RedirectPolicyFunc(func(req *http.Request, via []*http.Request) error {
			return http.ErrUseLastResponse
		}),
	)
	NoRedirectClientWithProxy.SetHeader("user-agent", UserAgent)
	RestyClient = NewRestyClient()
	RestyClientWithProxy = NewRestyClient()
	HttpClient = NewHttpClient()
}

func NewRestyClient() *resty.Client {
	// dialer := &net.Dialer{
	// 	// Timeout: ConnectTimeout * time.Second, // 设置连接超时为
	// 	Resolver: &net.Resolver{
	// 		PreferGo: true,
	// 		Dial: func(ctx context.Context, network, address string) (net.Conn, error) {
	// 			d := net.Dialer{
	// 				Timeout: time.Duration(dnsResolverTimeoutMs) * time.Millisecond,
	// 			}
	// 			return d.DialContext(ctx, dnsResolverProto, DnsResolverIP)
	// 		},
	// 	},
	// }

	transport := &http.Transport{
		// DialContext: dialer.DialContext,
		TLSClientConfig: &tls.Config{
			InsecureSkipVerify: true,
			VerifyPeerCertificate: func(certificates [][]byte, _ [][]*x509.Certificate) error {
				// Completely ignore certificate verification 完全忽略证书验证
				return nil
			},
		},
		IdleConnTimeout: IdleConnTimeout,
	}

	client := resty.New().
		SetHeader("user-agent", UserAgent).
		SetRetryCount(3).
		SetTimeout(DefaultTimeout).
		SetTransport(transport)
	return client
}

func NewHttpClient() *http.Client {
	// dialer := &net.Dialer{
	// 	//Timeout: 30 * time.Second,
	// 	// Timeout: ConnectTimeout, // 设置连接超时为
	// 	Resolver: &net.Resolver{
	// 		PreferGo: true,
	// 		Dial: func(ctx context.Context, network, address string) (net.Conn, error) {
	// 			d := net.Dialer{
	// 				Timeout: time.Duration(dnsResolverTimeoutMs) * time.Millisecond,
	// 			}
	// 			return d.DialContext(ctx, dnsResolverProto, DnsResolverIP)
	// 		},
	// 	},
	// }

	return &http.Client{
		Timeout: time.Hour * 48,
		Transport: &http.Transport{
			TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
			// DialContext:     dialer.DialContext,
			IdleConnTimeout: IdleConnTimeout,
		},
	}
}

var isWorkPool *bool
var proxyTimeout = int64(10)
var mediaCache = cache.New(4*time.Hour, 10*time.Minute)

type Chunk struct {
	startOffset int64
	endOffset   int64
	buffer      []byte
}

func newChunk(start int64, end int64) *Chunk {
	return &Chunk{
		startOffset: start,
		endOffset:   end,
	}
}

func (ch *Chunk) get() []byte {
	return ch.buffer
}

func (ch *Chunk) put(buffer []byte) {
	ch.buffer = buffer
}

type ProxyDownloadStruct struct {
	ProxyRunning         bool
	NextChunkStartOffset int64
	CurrentOffset        int64
	CurrentChunk         int64
	ChunkSize            int64
	MaxBufferedChunk     int64
	startOffset          int64
	EndOffset            int64
	ProxyMutex           *sync.Mutex
	ProxyTimeout         int64
	ReadyChunkQueue      chan *Chunk
	ThreadCount          int64
	DownloadUrl          string
	CookieJar            *cookiejar.Jar
	OriginThreadNum      int
}

func newProxyDownloadStruct(downloadUrl string, proxyTimeout int64, maxBuferredChunk int64, chunkSize int64, startOffset int64, endOffset int64, numTasks int64, cookiejar *cookiejar.Jar, originThreadNum int) *ProxyDownloadStruct {
	return &ProxyDownloadStruct{
		ProxyRunning:         true,
		MaxBufferedChunk:     int64(maxBuferredChunk),
		ProxyTimeout:         proxyTimeout,
		ReadyChunkQueue:      make(chan *Chunk, maxBuferredChunk),
		ProxyMutex:           &sync.Mutex{},
		ChunkSize:            chunkSize,
		NextChunkStartOffset: startOffset,
		CurrentOffset:        startOffset,
		startOffset:          startOffset,
		EndOffset:            endOffset,
		ThreadCount:          numTasks,
		DownloadUrl:          downloadUrl,
		CookieJar:            cookiejar,
		OriginThreadNum:      originThreadNum,
	}
}

func ConcurrentDownload(p *ProxyDownloadStruct, downloadUrl string, rangeStart int64, rangeEnd int64, splitSize int64, numTasks int64, emitter *Emitter, req *http.Request, jar *cookiejar.Jar) {
	totalLength := rangeEnd - rangeStart + 1
	numSplits := int64(totalLength/int64(splitSize)) + 1
	if numSplits > int64(numTasks) {
		numSplits = int64(numTasks)
	}

	log.Printf("[Debug] Processing: %+v, rangeStart: %+v, rangeEnd: %+v, contentLength :%+v, splitSize: %+v, numSplits: %+v, numTasks: %+v", downloadUrl, rangeStart, rangeEnd, totalLength, splitSize, numSplits, numTasks)

	if *isWorkPool {
		var wp *workpool.WorkPool
		workPoolKey := downloadUrl + "#Workpool"
		if x, found := mediaCache.Get(workPoolKey); found {
			wp = x.(*workpool.WorkPool)
			if isWorkPool == nil {
				wp = workpool.New(int(numTasks))
				wp.SetTimeout(time.Duration(proxyTimeout) * time.Second)
				mediaCache.Set(workPoolKey, wp, 14400*time.Second)
			}
		} else {
			wp = workpool.New(int(numTasks))
			wp.SetTimeout(time.Duration(proxyTimeout) * time.Second)
			mediaCache.Set(workPoolKey, wp, 14400*time.Second)
		}
		for numSplit := 0; numSplit < int(numSplits); numSplit++ {
			wp.Do(func() error {
				p.ProxyWorker(req)
				return nil
			})
		}
	} else {
		for numSplit := 0; numSplit < int(numSplits); numSplit++ {
			go p.ProxyWorker(req)
		}
	}

	defer func() {
		p.ProxyStop()
		p = nil
	}()

	for {
		buffer := p.ProxyRead()

		if len(buffer) == 0 {
			p.ProxyStop()
			emitter.Close()
			log.Printf("[Debug] ProxyRead failed")
			buffer = nil
			return
		}

		_, err := emitter.Write(buffer)

		if err != nil {
			p.ProxyStop()
			emitter.Close()
			log.Printf("[Error] emitter write failed, error: %+v", err)
			buffer = nil
			return
		}

		if p.CurrentOffset >= rangeEnd {
			p.ProxyStop()
			emitter.Close()
			log.Printf("[Debug] All services have completed size: %+v", totalLength)
			buffer = nil
			return
		}
		buffer = nil
	}
}

func (p *ProxyDownloadStruct) ProxyRead() []byte {
	// Check if the file is downloaded
	if p.CurrentOffset >= p.EndOffset {
		p.ProxyStop()
		return nil
	}

	// Get the data of the current chunk
	var currentChunk *Chunk
	select {
	case currentChunk = <-p.ReadyChunkQueue:
		break
	case <-time.After(time.Duration(p.ProxyTimeout) * time.Second):
		log.Printf("[Debug] ProxyRead execution timeout")
		p.ProxyStop()
		return nil
	}

	for {
		if !p.ProxyRunning {
			break
		}
		buffer := currentChunk.get()
		if len(buffer) > 0 {
			p.CurrentOffset += int64(len(buffer))
			currentChunk = nil
			return buffer
		} else {
			time.Sleep(50 * time.Millisecond)
		}
	}
	currentChunk = nil
	return nil
}

func (p *ProxyDownloadStruct) ProxyStop() {
	p.ProxyRunning = false
	var currentChunk *Chunk
	for {
		select {
		case currentChunk = <-p.ReadyChunkQueue:
			currentChunk.buffer = nil
			currentChunk = nil
		case <-time.After(1 * time.Second):
			return
		}
	}
}

func (p *ProxyDownloadStruct) ProxyWorker(req *http.Request) {
	log.Printf("[Debug] Current number of active goroutines: %d", runtime.NumGoroutine()-p.OriginThreadNum)
	for {
		if !p.ProxyRunning {
			break
		}

		p.ProxyMutex.Lock()
		// Generate the next chunk
		var chunk *Chunk
		chunk = nil
		startOffset := p.NextChunkStartOffset
		p.NextChunkStartOffset += p.ChunkSize
		if startOffset <= p.EndOffset {
			endOffset := startOffset + p.ChunkSize - 1
			if endOffset > p.EndOffset {
				endOffset = p.EndOffset
			}
			chunk = newChunk(startOffset, endOffset)

			p.ReadyChunkQueue <- chunk
		}
		p.ProxyMutex.Unlock()

		// All chunks are downloaded
		if chunk == nil {
			break
		}

		for {
			if !p.ProxyRunning {
				break
			} else {
				// Too much data is not taken, rest for a while to avoid memory overflow
				remainingSize := p.GetRemainingSize(p.ChunkSize)
				maxBufferSize := p.ChunkSize * p.MaxBufferedChunk
				if remainingSize >= maxBufferSize {
					log.Printf("[Debug] Unread data: %d >= buffer: %d , Rest for a while to avoid memory overflow", remainingSize, maxBufferSize)
					time.Sleep(1 * time.Second)
				} else {
					// logrus.Debugf("未读取数据: %d < 缓冲区: %d , 下载继续", remainingSize, maxBufferSize)
					break
				}
			}
		}

		for {
			if !p.ProxyRunning {
				break
			} else {
				// Establish connection
				rangeStr := fmt.Sprintf("bytes=%d-%d", chunk.startOffset, chunk.endOffset)
				newHeader := make(map[string][]string)
				for key, value := range req.Header {
					if !shouldFilterHeaderName(key) {
						newHeader[key] = value
					}
				}

				maxRetries := 5
				if startOffset < int64(1048576) || (p.EndOffset-startOffset)/p.EndOffset*1000 < 2 {
					maxRetries = 7
				}

				var resp *resty.Response
				var err error
				for retry := 0; retry < maxRetries; retry++ {
					resp, err = RestyClient.
						SetTimeout(10*time.Second).
						SetRetryCount(1).
						SetCookieJar(p.CookieJar).
						R().
						SetHeaderMultiValues(newHeader).
						SetHeader("Range", rangeStr).
						Get(p.DownloadUrl)

					if err != nil {
						log.Printf("[Error] Processing %+v link range=%d-%d partially failed: %+v", p.DownloadUrl, chunk.startOffset, chunk.endOffset, err)
						time.Sleep(1 * time.Second)
						resp = nil
						continue
					}
					if !strings.HasPrefix(resp.Status(), "20") {
						log.Printf("[Debug] Processing %+v link range=%d-%d partially failed, statusCode: %+v: %s", p.DownloadUrl, chunk.startOffset, chunk.endOffset, resp.StatusCode(), resp.String())
						resp = nil
						p.ProxyStop()
						return
					}
					break
				}

				if err != nil {
					resp = nil
					p.ProxyStop()
					return
				}

				// Receive data
				if resp != nil && resp.Body() != nil {
					buffer := make([]byte, chunk.endOffset-chunk.startOffset+1)
					copy(buffer, resp.Body())
					chunk.put(buffer)
				}
				resp = nil
				break
			}
		}
	}
}

func (p *ProxyDownloadStruct) GetRemainingSize(bufferSize int64) int64 {
	p.ProxyMutex.Lock()
	defer p.ProxyMutex.Unlock()
	return int64(len(p.ReadyChunkQueue)) * bufferSize
}

func handleMethod(w http.ResponseWriter, req *http.Request) {
	switch req.Method {
	case http.MethodGet:
		// Process GET requests
		log.Printf("[Info] Processing GET request")
		// Check if the query parameters are empty
		if req.URL.RawQuery == "" {
			// Get the embedded index.html file
			http.Error(w, "Missing url parameter", http.StatusBadRequest)
			return
		} else {
			// If there are query parameters, return custom content
			handleGetMethod(w, req)
		}
	default:
		// Process other method requests
		log.Printf("[Info] Processing %v request", req.Method)
		handleOtherMethod(w, req)
	}
}

func handleGetMethod(w http.ResponseWriter, req *http.Request) {
	pw := bufio.NewWriterSize(w, 128*1024)
	defer func() {
		if pw.Buffered() > 0 {
			pw.Flush()
		}
	}()

	var urlStr string
	query := req.URL.Query()
	urlStr = query.Get("url")
	strForm := query.Get("form")
	strHeader := query.Get("header")
	strThread := req.URL.Query().Get("thread")
	strSplitSize := req.URL.Query().Get("size")
	quarkFids := query.Get("quarkfids")
	ucFids := query.Get("ucfids")

	if strHeader != "" {
		if strForm == "base64" {
			bytesStrHeader, err := base64.StdEncoding.DecodeString(strHeader)
			if err != nil {
				http.Error(w, fmt.Sprintf("Invalid Base64 Headers: %v", err), http.StatusBadRequest)
				return
			}
			strHeader = string(bytesStrHeader)
		}
		var header map[string]string
		err := json.Unmarshal([]byte(strHeader), &header)
		if err != nil {
			http.Error(w, fmt.Sprintf("Header Json format error: %v", err), http.StatusInternalServerError)
			return
		}
		for key, value := range header {
			req.Header.Set(key, value)
		}
	}

	newHeader := make(map[string][]string)
	for key, value := range req.Header {
		if !shouldFilterHeaderName(key) {
			newHeader[key] = value
		}
	}
	if urlStr == "" && (quarkFids != "" || ucFids != "") {
		var apiUrl string
		var fid string
		if quarkFids != "" {
			apiUrl = "https://drive-pc.quark.cn/1/clouddrive/file/download?pr=ucpro&fr=pc&uc_param_str="
			fid = quarkFids
		} else {
			apiUrl = "https://pc-api.uc.cn/1/clouddrive/file/download?pr=UCBrowser&fr=pc&uc_param_str="
			fid = ucFids
		}

		data := map[string]interface{}{
			"fids": []string{fid},
		}
		var apiResponse struct {
			Data []struct {
				DownloadUrl string `json:"download_url"`
			} `json:"data"`
		}
		resp, err := RestyClient.
			SetRetryCount(3).
			R().
			SetHeaderMultiValues(newHeader).
			SetBody(data).
			Post(apiUrl)
		if err != nil {
			http.Error(w, fmt.Sprintf("Get download link failed: %v", err), http.StatusInternalServerError)
			log.Printf("[Error] Get download link failed: %v", err)
			return
		}
		err = json.Unmarshal(resp.Body(), &apiResponse)
		if err != nil {
			http.Error(w, "Parse API response failed", http.StatusInternalServerError)
			log.Printf("[Error] Parse API response failed: %v", err)
			return
		}

		if len(apiResponse.Data) == 0 {
			http.Error(w, "No download link found", http.StatusNotFound)
			log.Printf("[Error] No download link found")
			return
		}
		urlStr = apiResponse.Data[0].DownloadUrl
		log.Printf("[Debug] urlStr: %v", urlStr)
	}
	if urlStr != "" {
		if strForm == "base64" {
			bytesUrl, err := base64.StdEncoding.DecodeString(urlStr)
			if err != nil {
				http.Error(w, fmt.Sprintf("Invalid Base64 Url: %v", err), http.StatusBadRequest)
				return
			}
			urlStr = string(bytesUrl)
		}
	} else {
		http.Error(w, "Missing url parameter", http.StatusBadRequest)
		return
	}

	for parameterName := range query {
		if parameterName == "url" || parameterName == "form" || parameterName == "thread" || parameterName == "size" || parameterName == "header" || parameterName == "quarkfids" || parameterName == "ucfids" {
			continue
		}
		urlStr = urlStr + "&" + parameterName + "=" + query.Get(parameterName)
	}

	jar, _ := cookiejar.New(nil)
	cookies := req.Cookies()
	if len(cookies) > 0 {
		// Add cookies to the cookie jar
		u, _ := url.Parse(urlStr)
		jar.SetCookies(u, cookies)
	}

	var statusCode int
	var rangeStart, rangeEnd = int64(0), int64(0)
	requestRange := req.Header.Get("Range")
	rangeRegex := regexp.MustCompile(`bytes= *([0-9]+) *- *([0-9]*)`)
	matchGroup := rangeRegex.FindStringSubmatch(requestRange)
	if matchGroup != nil {
		statusCode = 206
		rangeStart, _ = strconv.ParseInt(matchGroup[1], 10, 64)
		if len(matchGroup) > 2 {
			rangeEnd, _ = strconv.ParseInt(matchGroup[2], 10, 64)
		}
	} else {
		statusCode = 200
	}

	log.Printf("[Debug] Headers: %+v", newHeader)
	headersKey := urlStr + "#Headers"
	var responseHeaders interface{}
	var connection = "keep-alive"
	responseHeaders, found := mediaCache.Get(headersKey)
	if !found {
		// Close Idle timeout setting
		IdleConnTimeout = 0
		resp, err := RestyClient.
			SetTimeout(0).
			SetRetryCount(3).
			SetCookieJar(jar).
			R().
			SetDoNotParseResponse(true).
			SetOutput(os.DevNull).
			SetHeaderMultiValues(newHeader).
			SetHeader("Range", "bytes=0-1023").
			Get(urlStr)
		if err != nil {
			http.Error(w, fmt.Sprintf("Failed to download %v link: %v", urlStr, err), http.StatusInternalServerError)
			log.Printf("[Error] Failed to download %v link: %v", urlStr, err)
			return
		}
		if resp.StatusCode() < 200 || resp.StatusCode() >= 400 {
			http.Error(w, resp.Status(), resp.StatusCode())
			log.Printf("[Error] Failed to download %v link: %v", urlStr, resp.Status())
			return
		}
		responseHeaders = resp.Header()

		var fileName string
		contentDisposition := strings.ToLower(responseHeaders.(http.Header).Get("Content-Disposition"))
		if contentDisposition != "" {
			regCompile := regexp.MustCompile(`^.*filename=\"([^\"]+)\".*$`)
			if regCompile.MatchString(contentDisposition) {
				fileName = regCompile.ReplaceAllString(contentDisposition, "$1")
			}
		} else {
			// Find the index of the last "/"
			lastSlashIndex := strings.LastIndex(urlStr, "/")
			// Find the index of the first "?"
			queryIndex := strings.Index(urlStr, "?")
			if queryIndex == -1 {
				// If there is no "?", extract the string from the last "/" to the end
				fileName = urlStr[lastSlashIndex+1:]
			} else {
				// If there is a "?", extract the string from the last "/" to the "?"
				fileName = urlStr[lastSlashIndex+1 : queryIndex]
			}
		}
		log.Printf("[Debug] fileName: %v", fileName)
		contentType := responseHeaders.(http.Header).Get("Content-Type")
		if contentType == "" || contentType == "application/octet-stream" {
			if strings.HasSuffix(fileName, ".webm") {
				contentType = "video/webm"
			} else if strings.HasSuffix(fileName, ".avi") {
				contentType = "video/x-msvideo"
			} else if strings.HasSuffix(fileName, ".wmv") {
				contentType = "video/x-ms-wmv"
			} else if strings.HasSuffix(fileName, ".flv") {
				contentType = "video/x-flv"
			} else if strings.HasSuffix(fileName, ".mov") {
				contentType = "video/quicktime"
			} else if strings.HasSuffix(fileName, ".mkv") {
				contentType = "video/x-matroska"
			} else if strings.HasSuffix(fileName, ".ts") {
				contentType = "video/mp2t"
			} else if strings.HasSuffix(fileName, ".mpeg") || strings.HasSuffix(fileName, ".mpg") {
				contentType = "video/mpeg"
			} else if strings.HasSuffix(fileName, ".3gpp") || strings.HasSuffix(fileName, ".3gp") {
				contentType = "video/3gpp"
			} else if strings.HasSuffix(fileName, ".mp4") || strings.HasSuffix(fileName, ".m4s") {
				contentType = "video/mp4"
			}
			responseHeaders.(http.Header).Set("Content-Type", contentType)
		}

		contentRange := responseHeaders.(http.Header).Get("Content-Range")
		if contentRange != "" {
			matchGroup := regexp.MustCompile(`.*/([0-9]+)`).FindStringSubmatch(contentRange)
			contentSize, _ := strconv.ParseInt(matchGroup[1], 10, 64)
			responseHeaders.(http.Header).Set("Content-Length", strconv.FormatInt(contentSize, 10))
		} else {
			if resp.Size() > 0 {
				responseHeaders.(http.Header).Set("Content-Length", strconv.FormatInt(resp.Size(), 10))
			} else {
				responseHeaders.(http.Header).Set("Content-Length", strconv.FormatInt(resp.RawResponse.ContentLength, 10))
			}

		}

		acceptRange := responseHeaders.(http.Header).Get("Accept-Ranges")
		if contentRange == "" && acceptRange == "" {
			// Not support resume download
			log.Printf("[Debug] Not support resume download")
			buf := make([]byte, 1024*64)
			for {
				n, err := resp.RawBody().Read(buf)
				if n > 0 {
					// Write data to client
					_, writeErr := pw.Write(buf[:n])
					if writeErr != nil {
						http.Error(w, fmt.Sprintf("Failed to write Response to client: %v", writeErr), http.StatusInternalServerError)
						return
					}
				}
				if err != nil {
					if err != io.EOF {
						log.Printf("[Error] Read Response Body error: %v", err)
					}
					break
				}
			}
			responseHeaders.(http.Header).Set("Content-Disposition", fmt.Sprintf("attachment; filename*=UTF-8''%s", fileName))

			defer func() {
				if resp != nil && resp.RawBody() != nil {
					log.Printf("[Debug] resp.RawBody closed")
					resp.RawBody().Close()
				}
			}()
		} else {
			// Support resume download
			log.Printf("[Debug] Support resume download")
			mediaCache.Set(headersKey, responseHeaders, 1800*time.Second)

			if resp != nil && resp.RawBody() != nil {
				log.Printf("[Debug] resp.RawBody closed")
				resp.RawBody().Close()
			}
		}
	}

	acceptRange := responseHeaders.(http.Header).Get("Accept-Ranges")
	contentRange := responseHeaders.(http.Header).Get("Content-Range")
	if contentRange == "" && acceptRange == "" {
		// Not support resume download
		log.Printf("[Debug] Not support resume download-Get Headers from cache")
		for key, values := range responseHeaders.(http.Header) {
			if strings.EqualFold(strings.ToLower(key), "connection") || strings.EqualFold(strings.ToLower(key), "proxy-connection") {
				continue
			}
			w.Header().Set(key, strings.Join(values, ","))
		}
		w.Header().Set("Connection", "keep-alive")
		w.WriteHeader(statusCode)
	} else {
		// Support resume download
		log.Printf("[Debug] Support resume download-Get Headers from cache")
		responseHeaders.(http.Header).Del("Content-Range")
		responseHeaders.(http.Header).Set("Accept-Ranges", "bytes")

		var splitSize int64
		var numTasks int64

		contentSize := int64(0)
		matchGroup = regexp.MustCompile(`.*/([0-9]+)`).FindStringSubmatch(contentRange)
		if matchGroup != nil {
			contentSize, _ = strconv.ParseInt(matchGroup[1], 10, 64)
		} else {
			contentSize, _ = strconv.ParseInt(responseHeaders.(http.Header).Get("Content-Length"), 10, 64)
		}

		if rangeEnd == int64(0) {
			rangeEnd = contentSize - 1
		}
		if rangeStart < contentSize {
			if strThread == "" {
				if contentSize < 1*1024*1024*1024 {
					numTasks = 4
				} else if contentSize < 4*1024*1024*1024 {
					numTasks = 8
				} else if contentSize < 16*1024*1024*1024 {
					numTasks = 12
				} else {
					numTasks = 16
				}
			} else {
				numTasks, _ = strconv.ParseInt(strThread, 10, 64)
			}

			if numTasks <= 0 {
				numTasks = 1
			}

			if strSplitSize != "" {
				splitSize, _ = strconv.ParseInt(strSplitSize, 10, 64)
			} else {
				splitSize = int64(128 * 1024)
			}
			responseHeaders.(http.Header).Set("Content-Range", fmt.Sprintf("bytes %d-%d/%d", rangeStart, rangeEnd, contentSize))

			for key, values := range responseHeaders.(http.Header) {
				if strings.EqualFold(strings.ToLower(key), "connection") || strings.EqualFold(strings.ToLower(key), "proxy-connection") || strings.EqualFold(strings.ToLower(key), "transfer-encoding") {
					continue
				}
				if statusCode == 200 && strings.EqualFold(strings.ToLower(key), "content-range") {
					continue
				} else if statusCode == 206 && strings.EqualFold(strings.ToLower(key), "accept-ranges") {
					continue
				}
				w.Header().Set(key, strings.Join(values, ","))
			}
			w.Header().Set("Connection", "keep-alive")
			w.WriteHeader(statusCode)

			rp, wp := io.Pipe()
			emitter := NewEmitter(rp, wp)

			maxChunks := int64(128*1024*1024) / splitSize
			p := newProxyDownloadStruct(urlStr, proxyTimeout, maxChunks, splitSize, rangeStart, rangeEnd, numTasks, jar, runtime.NumGoroutine()+1)

			go ConcurrentDownload(p, urlStr, rangeStart, rangeEnd, splitSize, numTasks, emitter, req, jar)
			io.Copy(pw, emitter)

			defer func() {
				log.Printf("[Debug] handleGetMethod emitter closed-Support resume download")
				p.ProxyStop()
				p = nil
				emitter.Close()
			}()

		} else {
			statusCode = 200
			connection = "close"
			for key, values := range responseHeaders.(http.Header) {
				if strings.EqualFold(strings.ToLower(key), "connection") || strings.EqualFold(strings.ToLower(key), "proxy-connection") || strings.EqualFold(strings.ToLower(key), "transfer-encoding") {
					continue
				}
				w.Header().Del(key)
				w.Header().Set(key, strings.Join(values, ","))
			}
			w.Header().Set("Connection", connection)
			w.WriteHeader(statusCode)
		}
	}
}

func handleOtherMethod(w http.ResponseWriter, req *http.Request) {
	defer req.Body.Close()

	var urlStr string
	query := req.URL.Query()
	urlStr = query.Get("url")
	strForm := query.Get("form")
	strHeader := query.Get("header")

	if urlStr != "" {
		if strForm == "base64" {
			bytesUrl, err := base64.StdEncoding.DecodeString(urlStr)
			if err != nil {
				http.Error(w, fmt.Sprintf("Invalid Base64 Url: %v", err), http.StatusBadRequest)
				return
			}
			urlStr = string(bytesUrl)
		}
	} else {
		http.Error(w, "Missing url parameter", http.StatusBadRequest)
		return
	}

	// Process custom header
	var header map[string]string
	if strHeader != "" {
		if strForm == "base64" {
			bytesStrHeader, err := base64.StdEncoding.DecodeString(strHeader)
			if err != nil {
				http.Error(w, fmt.Sprintf("Invalid Base64 Headers: %v", err), http.StatusBadRequest)
				return
			}
			strHeader = string(bytesStrHeader)
		}
		err := json.Unmarshal([]byte(strHeader), &header)
		if err != nil {
			http.Error(w, fmt.Sprintf("Header Json format error: %v", err), http.StatusInternalServerError)
			return
		}
		for key, value := range header {
			req.Header.Set(key, value)
		}
	}
	newHeader := make(map[string][]string)
	for key, value := range req.Header {
		if !shouldFilterHeaderName(key) {
			newHeader[key] = value
		}
	}

	// Build new URL
	for parameterName := range query {
		if parameterName == "url" || parameterName == "form" || parameterName == "thread" || parameterName == "size" || parameterName == "header" {
			continue
		}
		urlStr = urlStr + "&" + parameterName + "=" + query.Get(parameterName)
	}

	jar, _ := cookiejar.New(nil)
	cookies := req.Cookies()
	if len(cookies) > 0 {
		// Add cookies to the cookie jar
		u, _ := url.Parse(req.URL.String())
		jar.SetCookies(u, cookies)
	}

	var reqBody []byte
	// Read request body to record
	if req.Body != nil {
		reqBody, _ = io.ReadAll(req.Body)
	}

	var resp *resty.Response
	var err error
	switch req.Method {
	case http.MethodPost:
		resp, err = RestyClient.
			SetTimeout(10 * time.Second).
			SetRetryCount(3).
			SetCookieJar(jar).
			R().
			SetBody(reqBody).
			SetHeaderMultiValues(newHeader).
			Post(urlStr)
	case http.MethodPut:
		resp, err = RestyClient.
			SetTimeout(10 * time.Second).
			SetRetryCount(3).
			SetCookieJar(jar).
			R().
			SetBody(reqBody).
			SetHeaderMultiValues(newHeader).
			Put(urlStr)
	case http.MethodOptions:
		resp, err = RestyClient.
			SetTimeout(10 * time.Second).
			SetRetryCount(3).
			SetCookieJar(jar).
			R().
			SetHeaderMultiValues(newHeader).
			Options(urlStr)
	case http.MethodDelete:
		resp, err = RestyClient.
			SetTimeout(10 * time.Second).
			SetRetryCount(3).
			SetCookieJar(jar).
			R().
			SetHeaderMultiValues(newHeader).
			Delete(urlStr)
	case http.MethodPatch:
		resp, err = RestyClient.
			SetTimeout(10 * time.Second).
			SetRetryCount(3).
			SetCookieJar(jar).
			R().
			SetHeaderMultiValues(newHeader).
			Patch(urlStr)
	case http.MethodHead:
		resp, err = RestyClient.
			SetTimeout(10 * time.Second).
			SetRetryCount(3).
			SetCookieJar(jar).
			R().
			SetHeaderMultiValues(newHeader).
			Head(urlStr)
	default:
		http.Error(w, fmt.Sprintf("Invalid Method: %v", req.Method), http.StatusBadRequest)
	}

	if err != nil {
		http.Error(w, fmt.Sprintf("%v link %v failed: %v", req.Method, urlStr, err), http.StatusInternalServerError)
		resp = nil
		return
	}
	if resp.StatusCode() < 200 || resp.StatusCode() >= 400 {
		http.Error(w, resp.Status(), resp.StatusCode())
		resp = nil
		return
	}

	// Process response
	w.Header().Set("Connection", "close")
	for key, values := range resp.Header() {
		w.Header().Set(key, strings.Join(values, ","))
	}
	w.WriteHeader(resp.StatusCode())
	bodyReader := bytes.NewReader(resp.Body())
	io.Copy(w, bodyReader)
}

func shouldFilterHeaderName(key string) bool {
	if len(strings.TrimSpace(key)) == 0 {
		return false
	}
	key = strings.ToLower(key)
	return key == "range" || key == "host" || key == "http-client-ip" || key == "remote-addr" || key == "accept-encoding"
}
