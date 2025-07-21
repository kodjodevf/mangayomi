package server

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
	"runtime"
	"strings"
	"sync"
	"syscall"
	"time"

	"github.com/anacrolix/torrent"
	"github.com/anacrolix/torrent/metainfo"
	"github.com/rs/cors"
)

var (
	torrentCli    *torrent.Client
	torrentcliCfg *torrent.ClientConfig
	// Cache for torrent metadata
	torrentCache = sync.Map{}
	// Worker pool for I/O operations
	workerPool *WorkerPool
)

// WorkerPool manages a pool of goroutines for concurrent tasks
type WorkerPool struct {
	workers  int
	jobQueue chan func()
	quit     chan bool
	wg       sync.WaitGroup
}

// NewWorkerPool creates a new worker pool
func NewWorkerPool(workers int) *WorkerPool {
	if workers <= 0 {
		workers = runtime.NumCPU()
	}

	pool := &WorkerPool{
		workers:  workers,
		jobQueue: make(chan func(), workers*2),
		quit:     make(chan bool),
	}

	pool.start()
	return pool
}

// start starts the workers
func (p *WorkerPool) start() {
	for i := 0; i < p.workers; i++ {
		p.wg.Add(1)
		go p.worker()
	}
}

// worker executes the jobs
func (p *WorkerPool) worker() {
	defer p.wg.Done()
	for {
		select {
		case job := <-p.jobQueue:
			job()
		case <-p.quit:
			return
		}
	}
}

// Submit submits a job to the pool
func (p *WorkerPool) Submit(job func()) {
	select {
	case p.jobQueue <- job:
	default:
		// If pool is full, execute directly
		go job()
	}
}

// Stop stops the pool
func (p *WorkerPool) Stop() {
	close(p.quit)
	p.wg.Wait()
}

// TorrentMetadata caches torrent metadata
type TorrentMetadata struct {
	InfoHash  string
	Name      string
	Files     []FileMetadata
	UpdatedAt time.Time
}

// FileMetadata contains file information
type FileMetadata struct {
	Path      string
	Size      int64
	StreamURL string
}

func Start(config *Config) (int, error) {
	// Initialize worker pool
	workerPool = NewWorkerPool(runtime.NumCPU() * 2)

	torrentcliCfg = torrent.NewDefaultClientConfig()
	torrentcliCfg.DataDir = filepath.Clean(config.Path)

	// Performance optimizations
	torrentcliCfg.DisableUTP = false
	torrentcliCfg.NoDHT = false
	torrentcliCfg.NoDefaultPortForwarding = false
	torrentcliCfg.DisablePEX = false
	torrentcliCfg.AcceptPeerConnections = true
	torrentcliCfg.EstablishedConnsPerTorrent = 80
	torrentcliCfg.HalfOpenConnsPerTorrent = 25
	torrentcliCfg.TorrentPeersHighWater = 200
	torrentcliCfg.TorrentPeersLowWater = 50

	log.Printf("[INFO] Download directory: %s", torrentcliCfg.DataDir)
	log.Printf("[INFO] Worker pool size: %d", workerPool.workers)

	var err error
	torrentCli, err = torrent.NewClient(torrentcliCfg)
	if err != nil {
		log.Fatalf("[ERROR] BitTorrent client creation failed: %s", err)
	}

	// Optimized DNS configuration
	configureDNS()

	// HTTP server configuration with optimized timeouts
	mux := setupRoutes()
	c := configureCORS()

	listener, err := net.Listen("tcp", config.Address)
	if err != nil {
		return 0, err
	}
	addr := listener.Addr().(*net.TCPAddr)

	// Optimized HTTP server
	server := &http.Server{
		Handler:           c.Handler(mux),
		ReadTimeout:       30 * time.Second,
		WriteTimeout:      30 * time.Second,
		IdleTimeout:       120 * time.Second,
		ReadHeaderTimeout: 10 * time.Second,
		MaxHeaderBytes:    1 << 20, // 1MB
	}

	// Graceful shutdown handling
	setupGracefulShutdown(server)

	log.Printf("[INFO] Server listening on %s", addr.AddrPort())

	go func() {
		if err := server.Serve(listener); err != nil && err != http.ErrServerClosed {
			log.Printf("[ERROR] Server error: %s", err)
		}
	}()

	return addr.Port, nil
}

func setupRoutes() *http.ServeMux {
	mux := http.NewServeMux()
	mux.HandleFunc("/torrent/addmagnet", addMagnet)
	mux.HandleFunc("/torrent/stream", streamTorrent)
	mux.HandleFunc("/torrent/remove", removeTorrent)
	mux.HandleFunc("/torrent/torrents", listTorrents)
	mux.HandleFunc("/torrent/play", playTorrent)
	mux.HandleFunc("/torrent/add", AddTorrent)
	mux.HandleFunc("/", Init)
	return mux
}

func configureCORS() *cors.Cors {
	return cors.New(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"GET", "POST", "DELETE"},
		AllowCredentials: true,
		MaxAge:           86400, // 24h cache
	})
}

func setupGracefulShutdown(server *http.Server) {
	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		<-sigs
		log.Println("[INFO] Shutdown signal received")

		// Graceful server shutdown
		ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
		defer cancel()

		if err := server.Shutdown(ctx); err != nil {
			log.Printf("[ERROR] Server shutdown error: %s", err)
		}

		// Torrent cleanup
		cleanupTorrents()

		// Stop worker pool
		if workerPool != nil {
			workerPool.Stop()
		}

		os.Exit(0)
	}()
}

func cleanupTorrents() {
	log.Println("[INFO] Cleaning up torrents...")
	for _, t := range torrentCli.Torrents() {
		log.Printf("[INFO] Removing torrent: [%s]", t.Name())
		t.Drop()
		if err := os.RemoveAll(filepath.Join(torrentcliCfg.DataDir, t.Name())); err != nil {
			log.Printf("[ERROR] Failed to remove torrent files [%s]: %s", t.Name(), err)
		}
	}
	if torrentCli != nil {
		torrentCli.Close()
	}
}

func safenDisplayPath(displayPath string) string {
	return strings.ReplaceAll(displayPath, "/", " ")
}

func appendFilePlaylist(scheme, host, infohash, name string) string {
	var sb strings.Builder
	sb.WriteString("#EXTINF:-1,")
	sb.WriteString(safenDisplayPath(name))
	sb.WriteString("\n")
	sb.WriteString(scheme)
	sb.WriteString("://")
	sb.WriteString(host)
	sb.WriteString("/torrent/stream?infohash=")
	sb.WriteString(infohash)
	sb.WriteString("&file=")
	sb.WriteString(url.QueryEscape(name))
	sb.WriteString("\n")
	return sb.String()
}

func nameCheck(str, substr string) bool {
	strLower := strings.ToLower(str)
	words := strings.Fields(strings.ToLower(substr))
	for _, word := range words {
		if !strings.Contains(strLower, word) {
			return false
		}
	}
	return true
}

func getTorrentFile(files []*torrent.File, filename string, exactName bool) *torrent.File {
	if filename == "" && !exactName {
		return nil
	}

	for _, file := range files {
		if exactName && file.DisplayPath() == filename {
			return file
		}
		if !exactName && nameCheck(file.DisplayPath(), filename) {
			return file
		}
	}
	return nil
}

// configureDNS optimizes DNS resolution
func configureDNS() {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	addrs, err := net.DefaultResolver.LookupHost(ctx, "www.google.com")
	if len(addrs) == 0 || err != nil {
		log.Printf("[WARN] DNS check failed, using Cloudflare DNS: %v", err)

		net.DefaultResolver = &net.Resolver{
			PreferGo: true,
			Dial: func(ctx context.Context, network, address string) (net.Conn, error) {
				d := net.Dialer{Timeout: 5 * time.Second}
				return d.DialContext(ctx, "udp", "1.1.1.1:53")
			},
		}

		// Test with Cloudflare DNS
		ctx2, cancel2 := context.WithTimeout(context.Background(), 5*time.Second)
		defer cancel2()
		addrs, err = net.DefaultResolver.LookupHost(ctx2, "www.google.com")
		log.Printf("[INFO] Cloudflare DNS test: %v, error: %v", len(addrs) > 0, err)
	} else {
		log.Printf("[INFO] DNS check OK: %d addresses", len(addrs))
	}
}

// getCachedTorrentMetadata retrieves metadata from cache
func getCachedTorrentMetadata(infoHash string) (*TorrentMetadata, bool) {
	if cached, ok := torrentCache.Load(infoHash); ok {
		meta := cached.(*TorrentMetadata)
		// Cache valid for 5 minutes
		if time.Since(meta.UpdatedAt) < 5*time.Minute {
			return meta, true
		}
		// Remove expired cache
		torrentCache.Delete(infoHash)
	}
	return nil, false
}

// cacheTorrentMetadata caches metadata
func cacheTorrentMetadata(t *torrent.Torrent) *TorrentMetadata {
	meta := &TorrentMetadata{
		InfoHash:  t.InfoHash().String(),
		Name:      t.Name(),
		UpdatedAt: time.Now(),
	}

	if t.Info() != nil {
		meta.Files = make([]FileMetadata, 0, len(t.Files()))
		for _, file := range t.Files() {
			meta.Files = append(meta.Files, FileMetadata{
				Path:      file.DisplayPath(),
				Size:      file.Length(),
				StreamURL: makePlayStreamURL(meta.InfoHash, file.DisplayPath(), true),
			})
		}
	}

	torrentCache.Store(meta.InfoHash, meta)
	return meta
}

func makePlayStreamURL(infohash, filename string, isStream bool) string {
	var sb strings.Builder
	sb.WriteString("/torrent/")
	if isStream {
		sb.WriteString("stream")
	} else {
		sb.WriteString("play")
	}
	sb.WriteString("?infohash=")
	sb.WriteString(infohash)
	if filename != "" {
		sb.WriteString("&file=")
		sb.WriteString(url.QueryEscape(filename))
	}
	return sb.String()
}

func httpJSONError(w http.ResponseWriter, error string, code int) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	if err := json.NewEncoder(w).Encode(errorRes{Error: error}); err != nil {
		http.Error(w, error, code)
	}
}

func parseRequestBody(w http.ResponseWriter, r *http.Request, v interface{}) error {
	defer r.Body.Close()
	decoder := json.NewDecoder(r.Body)
	decoder.DisallowUnknownFields() // Additional security
	err := decoder.Decode(v)
	if err != nil {
		httpJSONError(w, "Request JSON body decode error", http.StatusBadRequest)
	}
	return err
}

func makeJSONResponse(w http.ResponseWriter, v interface{}) {
	w.Header().Set("Content-Type", "application/json")
	encoder := json.NewEncoder(w)
	if err := encoder.Encode(v); err != nil {
		httpJSONError(w, "Response JSON body encode error", http.StatusInternalServerError)
	}
}

// getInfoWithTimeout waits for torrent information with timeout
func getInfoWithTimeout(t *torrent.Torrent, timeout time.Duration) error {
	if t == nil {
		return nil
	}

	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()

	select {
	case <-t.GotInfo():
		return nil
	case <-ctx.Done():
		return ctx.Err()
	}
}

func initMagnet(w http.ResponseWriter, magnet string, alldn, alltr []string) *torrent.Torrent {
	var sb strings.Builder
	sb.WriteString(magnet)

	for _, dn := range alldn {
		sb.WriteString("&dn=")
		sb.WriteString(url.QueryEscape(dn))
	}
	for _, tr := range alltr {
		sb.WriteString("&tr=")
		sb.WriteString(url.QueryEscape(tr))
	}

	t, err := torrentCli.AddMagnet(sb.String())
	if err != nil {
		httpJSONError(w, "Torrent add error: "+err.Error(), http.StatusInternalServerError)
		return nil
	}

	// Wait for information with timeout
	if err := getInfoWithTimeout(t, 30*time.Second); err != nil {
		log.Printf("[WARN] Timeout waiting for torrent info: %s", err)
	}

	// Cache metadata
	cacheTorrentMetadata(t)

	return t
}

func getTorrent(w http.ResponseWriter, infoHash string) *torrent.Torrent {
	if len(infoHash) != 40 {
		httpJSONError(w, "InfoHash not valid", http.StatusBadRequest)
		return nil
	}

	// Check cache first
	if _, found := getCachedTorrentMetadata(infoHash); found {
		if t, ok := torrentCli.Torrent(metainfo.NewHashFromHex(infoHash)); ok {
			return t
		}
		// Remove from cache if torrent no longer exists
		torrentCache.Delete(infoHash)
	}

	t, ok := torrentCli.Torrent(metainfo.NewHashFromHex(infoHash))
	if !ok {
		httpJSONError(w, "Torrent not found", http.StatusNotFound)
		return nil
	}

	if t == nil {
		httpJSONError(w, "Torrent is nil", http.StatusInternalServerError)
		return nil
	}

	// Wait for information with timeout
	if err := getInfoWithTimeout(t, 10*time.Second); err != nil {
		log.Printf("[WARN] Timeout waiting for torrent info: %s", err)
		// Don't return nil here, torrent may still be usable
	}

	// Cache metadata only if we have the info
	if t.Info() != nil {
		cacheTorrentMetadata(t)
	}

	return t
}

func parseTorrentStats(t *torrent.Torrent) torrentStatsRes {
	// Protection against nil pointers
	if t == nil {
		return torrentStatsRes{}
	}

	// Use cache if available
	if meta, found := getCachedTorrentMetadata(t.InfoHash().String()); found {
		stats := t.Stats()
		return torrentStatsRes{
			InfoHash:      meta.InfoHash,
			Name:          meta.Name,
			TotalPeers:    stats.TotalPeers,
			ActivePeers:   stats.ActivePeers,
			HalfOpenPeers: stats.HalfOpenPeers,
			PendingPeers:  stats.PendingPeers,
			Files:         buildFilesFromCache(meta, t),
		}
	}

	// Fallback to original method
	var tsRes torrentStatsRes

	tsRes.InfoHash = t.InfoHash().String()
	tsRes.Name = t.Name()

	stats := t.Stats()
	tsRes.TotalPeers = stats.TotalPeers
	tsRes.ActivePeers = stats.ActivePeers
	tsRes.HalfOpenPeers = stats.HalfOpenPeers
	tsRes.PendingPeers = stats.PendingPeers

	if t.Info() == nil {
		return tsRes
	}

	files := t.Files()
	if files == nil {
		return tsRes
	}

	tsRes.Files.OnTorrent = make([]torrentStatsFilesOnTorrent, 0, len(files))

	for _, tFile := range files {
		if tFile == nil {
			continue
		}
		tsRes.Files.OnTorrent = append(tsRes.Files.OnTorrent, torrentStatsFilesOnTorrent{
			FileName:      tFile.DisplayPath(),
			FileSizeBytes: int(tFile.Length()),
		})

		if tFile.BytesCompleted() > 0 {
			tsRes.Files.OnDisk = append(tsRes.Files.OnDisk, torrentStatsFilesOnDisk{
				FileName:        tFile.DisplayPath(),
				StreamURL:       makePlayStreamURL(t.InfoHash().String(), tFile.DisplayPath(), true),
				BytesDownloaded: int(tFile.BytesCompleted()),
				FileSizeBytes:   int(tFile.Length()),
			})
		}
	}

	// Update cache only if we have complete info
	if t.Info() != nil {
		cacheTorrentMetadata(t)
	}

	return tsRes
}

func buildFilesFromCache(meta *TorrentMetadata, t *torrent.Torrent) torrentStatsFiles {
	var files torrentStatsFiles
	files.OnTorrent = make([]torrentStatsFilesOnTorrent, 0, len(meta.Files))

	for _, fileMeta := range meta.Files {
		files.OnTorrent = append(files.OnTorrent, torrentStatsFilesOnTorrent{
			FileName:      fileMeta.Path,
			FileSizeBytes: int(fileMeta.Size),
		})

		// Check if file is downloaded (requires access to real torrent)
		if tFile := getTorrentFile(t.Files(), fileMeta.Path, true); tFile != nil && tFile.BytesCompleted() > 0 {
			files.OnDisk = append(files.OnDisk, torrentStatsFilesOnDisk{
				FileName:        fileMeta.Path,
				StreamURL:       fileMeta.StreamURL,
				BytesDownloaded: int(tFile.BytesCompleted()),
				FileSizeBytes:   int(fileMeta.Size),
			})
		}
	}

	return files
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
	query := r.URL.Query()
	infoHashParams, ihOk := query["infohash"]
	fileNameParams, fnOk := query["file"]

	if !ihOk || !fnOk || len(infoHashParams) == 0 || len(fileNameParams) == 0 {
		httpJSONError(w, "InfoHash or File is not provided", http.StatusBadRequest)
		return
	}

	infoHash := infoHashParams[0]
	fileName := fileNameParams[0]

	t := getTorrent(w, infoHash)
	if t == nil {
		return
	}

	tFile := getTorrentFile(t.Files(), fileName, true)
	if tFile == nil {
		httpJSONError(w, "File not found", http.StatusNotFound)
		return
	}

	fileReader := tFile.NewReader()
	defer fileReader.Close()

	readaheadSize := calculateReadahead(tFile.Length())
	fileReader.SetReadahead(readaheadSize)

	// Headers for optimized streaming
	w.Header().Set("Accept-Ranges", "bytes")
	w.Header().Set("Content-Type", getContentType(fileName))
	w.Header().Set("Cache-Control", "public, max-age=3600")

	http.ServeContent(w, r, tFile.DisplayPath(), time.Now(), fileReader)
}

// calculateReadahead calculates optimal readahead size
func calculateReadahead(fileSize int64) int64 {
	switch {
	case fileSize < 100*1024*1024: // < 100MB
		return fileSize / 20 // 5%
	case fileSize < 1024*1024*1024: // < 1GB
		return fileSize / 50 // 2%
	default:
		return fileSize / 100 // 1%
	}
}

// getContentType determines file MIME type
func getContentType(filename string) string {
	ext := strings.ToLower(filepath.Ext(filename))
	switch ext {
	// Video formats
	case ".mp4":
		return "video/mp4"
	case ".mkv":
		return "video/x-matroska"
	case ".avi":
		return "video/x-msvideo"
	case ".mov":
		return "video/quicktime"
	case ".wmv":
		return "video/x-ms-wmv"
	case ".webm":
		return "video/webm"
	case ".flv":
		return "video/x-flv"
	case ".m4v":
		return "video/x-m4v"
	case ".3gp":
		return "video/3gpp"
	case ".3g2":
		return "video/3gpp2"
	case ".ts":
		return "video/mp2t"
	case ".mts":
		return "video/mp2t"
	case ".m2ts":
		return "video/mp2t"
	case ".vob":
		return "video/dvd"
	case ".ogv":
		return "video/ogg"
	case ".asf":
		return "video/x-ms-asf"
	case ".rm":
		return "application/vnd.rn-realmedia"
	case ".rmvb":
		return "application/vnd.rn-realmedia-vbr"
	case ".f4v":
		return "video/x-f4v"
	case ".mpg", ".mpeg":
		return "video/mpeg"
	case ".m1v":
		return "video/mpeg"
	case ".m2v":
		return "video/mpeg"
	case ".divx":
		return "video/divx"
	case ".xvid":
		return "video/x-msvideo"
	// Audio formats
	case ".mp3":
		return "audio/mpeg"
	case ".flac":
		return "audio/flac"
	case ".wav":
		return "audio/wav"
	case ".aac":
		return "audio/aac"
	case ".ogg":
		return "audio/ogg"
	case ".wma":
		return "audio/x-ms-wma"
	case ".m4a":
		return "audio/mp4"
	case ".opus":
		return "audio/opus"
	case ".ac3":
		return "audio/ac3"
	case ".dts":
		return "audio/dts"
	default:
		return "application/octet-stream"
	}
}

func removeTorrent(w http.ResponseWriter, r *http.Request) {
	query := r.URL.Query()
	infoHashParams, ihOk := query["infohash"]

	if !ihOk || len(infoHashParams) == 0 {
		httpJSONError(w, "InfoHash is not provided", http.StatusBadRequest)
		return
	}

	infoHash := infoHashParams[0]
	t := getTorrent(w, infoHash)
	if t == nil {
		return
	}

	name := t.Name()

	// Immediate response before cleanup
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("Torrent removal initiated"))

	// Asynchronous deletion after response
	workerPool.Submit(func() {
		t.Drop()

		// Clean cache
		torrentCache.Delete(infoHash)

		// Remove files
		if err := os.RemoveAll(filepath.Join(torrentcliCfg.DataDir, name)); err != nil {
			log.Printf("[ERROR] Failed to remove torrent files [%s]: %s", name, err)
			return
		}

		log.Printf("[INFO] Successfully removed torrent: %s", name)
	})
}

func listTorrents(w http.ResponseWriter, r *http.Request) {
	query := r.URL.Query()
	infoHashParams, ihOk := query["infohash"]

	var ltRes listTorrentsRes
	allTorrents := torrentCli.Torrents()

	if ihOk && len(infoHashParams) > 0 {
		t := getTorrent(w, infoHashParams[0])
		if t == nil {
			return
		}
		allTorrents = []*torrent.Torrent{t}
	}

	// Parallel processing of statistics
	type result struct {
		stats torrentStatsRes
		index int
	}

	results := make(chan result, len(allTorrents))
	var wg sync.WaitGroup

	for i, t := range allTorrents {
		wg.Add(1)
		go func(idx int, torrent *torrent.Torrent) {
			defer wg.Done()
			stats := parseTorrentStats(torrent)
			results <- result{stats: stats, index: idx}
		}(i, t)
	}

	go func() {
		wg.Wait()
		close(results)
	}()

	// Collect results in order
	statsMap := make(map[int]torrentStatsRes)
	for res := range results {
		statsMap[res.index] = res.stats
	}

	// Rebuild list in order
	ltRes.Torrents = make([]torrentStatsRes, 0, len(allTorrents))
	for i := 0; i < len(allTorrents); i++ {
		if stats, exists := statsMap[i]; exists {
			ltRes.Torrents = append(ltRes.Torrents, stats)
		}
	}

	if !ihOk && len(ltRes.Torrents) == 0 {
		w.WriteHeader(http.StatusNotFound)
		return
	}

	makeJSONResponse(w, &ltRes)
}

func AddTorrent(w http.ResponseWriter, r *http.Request) {
	// Limit upload file size
	r.ParseMultipartForm(100 << 20) // 100MB max

	file, _, err := r.FormFile("file")
	if err != nil {
		log.Printf("[ERROR] Upload error: %s", err)
		httpJSONError(w, "File upload error", http.StatusBadRequest)
		return
	}
	defer file.Close()

	metainf, err := metainfo.Load(file)
	if err != nil {
		log.Printf("[ERROR] MetaInfo load error: %s", err)
		httpJSONError(w, "Invalid torrent file", http.StatusBadRequest)
		return
	}

	torrent, err := torrentCli.AddTorrent(metainf)
	if err != nil {
		log.Printf("[ERROR] Add torrent error: %s", err)
		httpJSONError(w, "Failed to add torrent", http.StatusInternalServerError)
		return
	}

	// Wait for information with timeout
	if err := getInfoWithTimeout(torrent, 30*time.Second); err != nil {
		log.Printf("[WARN] Timeout waiting for torrent info: %s", err)
	}

	// Cache metadata
	cacheTorrentMetadata(torrent)

	w.Header().Set("Content-Type", "text/plain")
	w.Write([]byte(torrent.InfoHash().HexString()))
}

func Init(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/plain")
	w.Write([]byte("Torrent server is running - Optimized version"))
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
