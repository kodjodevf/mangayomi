package server

import (
	"bytes"
	"context"
	"io"
	"net/http/httptest"
	"net/url"
	"strings"
	"testing"

	"github.com/anacrolix/torrent"
)

type fakeTorrentReader struct {
	pos           int64
	responsive    bool
	readaheadFunc torrent.ReadaheadFunc
	ctx           context.Context
}

func (f *fakeTorrentReader) Read(p []byte) (int, error) {
	for index := range p {
		p[index] = 'a'
	}
	f.pos += int64(len(p))
	return len(p), nil
}

func (f *fakeTorrentReader) Seek(offset int64, whence int) (int64, error) {
	f.pos = resolveSeekPosition(f.pos, 1<<30, offset, whence)
	return f.pos, nil
}

func (f *fakeTorrentReader) Close() error {
	return nil
}

func (f *fakeTorrentReader) ReadContext(_ context.Context, p []byte) (int, error) {
	return f.Read(p)
}

func (f *fakeTorrentReader) SetContext(ctx context.Context) {
	f.ctx = ctx
}

func (f *fakeTorrentReader) SetReadahead(_ int64) {}

func (f *fakeTorrentReader) SetReadaheadFunc(fn torrent.ReadaheadFunc) {
	f.readaheadFunc = fn
}

func (f *fakeTorrentReader) SetResponsive() {
	f.responsive = true
}

func TestSanitizeConfigDefaultsToLoopback(t *testing.T) {
	config, err := sanitizeConfig(&Config{Path: t.TempDir()})
	if err != nil {
		t.Fatalf("sanitizeConfig returned error: %v", err)
	}

	if config.Address != "127.0.0.1:0" {
		t.Fatalf("expected loopback default address, got %q", config.Address)
	}
}

func TestSanitizeConfigRejectsNonLoopbackAddress(t *testing.T) {
	_, err := sanitizeConfig(&Config{Path: t.TempDir(), Address: "192.168.1.20:8080"})
	if err == nil {
		t.Fatal("expected sanitizeConfig to reject non-loopback address")
	}
}

func TestResolveTorrentDataPathRejectsTraversal(t *testing.T) {
	_, err := resolveTorrentDataPath(t.TempDir(), "../outside")
	if err == nil {
		t.Fatal("expected traversal path to be rejected")
	}
}

func TestParseRequestBodyRejectsMultipleJSONValues(t *testing.T) {
	recorder := httptest.NewRecorder()
	request := httptest.NewRequest("POST", "/torrent/addmagnet", strings.NewReader(`{"magnet":"a"}{"magnet":"b"}`))

	var payload addMagnetBody
	err := parseRequestBody(recorder, request, &payload)
	if err == nil {
		t.Fatal("expected parseRequestBody to reject multiple JSON values")
	}
	if recorder.Code != 400 {
		t.Fatalf("expected HTTP 400, got %d", recorder.Code)
	}
}

func TestParseRequestBodyRejectsOversizedPayload(t *testing.T) {
	largeBody := bytes.NewBufferString(`{"magnet":"`)
	largeBody.Write(bytes.Repeat([]byte("a"), int(maxJSONBodyBytes)))
	largeBody.WriteString(`"}`)

	recorder := httptest.NewRecorder()
	request := httptest.NewRequest("POST", "/torrent/addmagnet", largeBody)

	var payload addMagnetBody
	err := parseRequestBody(recorder, request, &payload)
	if err == nil {
		t.Fatal("expected oversized payload to be rejected")
	}
	if recorder.Code != 400 {
		t.Fatalf("expected HTTP 400, got %d", recorder.Code)
	}
}

func TestIsAllowedOriginOnlyAcceptsLocalOrigins(t *testing.T) {
	if !isAllowedOrigin("http://localhost:3000") {
		t.Fatal("expected localhost origin to be allowed")
	}
	if !isAllowedOrigin("http://127.0.0.1:8080") {
		t.Fatal("expected loopback origin to be allowed")
	}
	if isAllowedOrigin("https://example.com") {
		t.Fatal("expected remote origin to be rejected")
	}
}

func TestNewTorrentHTTPTransportIsTunedForFallbacks(t *testing.T) {
	transport := newTorrentHTTPTransport()
	if transport == nil {
		t.Fatal("expected a transport instance")
	}
	if !transport.ForceAttemptHTTP2 {
		t.Fatal("expected HTTP/2 to be enabled")
	}
	if transport.MaxIdleConnsPerHost < 16 {
		t.Fatalf("expected connection pooling per host, got %d", transport.MaxIdleConnsPerHost)
	}
	if transport.ResponseHeaderTimeout != httpResponseHeaderTimeout {
		t.Fatalf("expected response header timeout %s, got %s", httpResponseHeaderTimeout, transport.ResponseHeaderTimeout)
	}
}

func TestCollectTorrentFallbacksIncludesLegacyMagnetParams(t *testing.T) {
	values, err := url.ParseQuery(
		"magnet=magnet%3A%3Fxt%3Durn%3Abtih%3Aabc123%26dn%3DExample&xs=https%3A%2F%2Fmeta.example%2Fmovie.torrent&as=https%3A%2F%2Fbackup.example%2Fmovie.torrent&ws=https%3A%2F%2Fcdn.example%2Fmovie.mkv&source=https%3A%2F%2Fexplicit.example%2Fmovie.torrent&webseed=https%3A%2F%2Fexplicit-cdn.example%2Fmovie.mkv",
	)
	if err != nil {
		t.Fatalf("ParseQuery failed: %v", err)
	}

	sources, webseeds := collectTorrentFallbacks(values)

	if len(sources) != 3 {
		t.Fatalf("expected 3 sources, got %d: %#v", len(sources), sources)
	}
	if len(webseeds) != 2 {
		t.Fatalf("expected 2 webseeds, got %d: %#v", len(webseeds), webseeds)
	}
	if values.Get("magnet") != "magnet:?xt=urn:btih:abc123&dn=Example" {
		t.Fatalf("expected magnet payload to stay intact, got %q", values.Get("magnet"))
	}
}

func TestConfigureStreamReaderBoostsReadaheadAfterLargeSeek(t *testing.T) {
	fakeReader := &fakeTorrentReader{}
	streamReader := configureStreamReader(fakeReader, 1<<30, true)

	if !fakeReader.responsive {
		t.Fatal("expected stream reader to enable responsive mode")
	}
	if fakeReader.readaheadFunc == nil {
		t.Fatal("expected stream reader to install a readahead function")
	}

	ctx := context.Background()
	fakeReader.SetContext(ctx)
	if fakeReader.ctx != ctx {
		t.Fatal("expected reader context to be stored")
	}

	baseReadahead := fakeReader.readaheadFunc(torrent.ReadaheadContext{})
	if _, err := streamReader.Seek(32<<20, io.SeekStart); err != nil {
		t.Fatalf("seek failed: %v", err)
	}

	boostedReadahead := fakeReader.readaheadFunc(torrent.ReadaheadContext{
		ContiguousReadStartPos: 32 << 20,
		CurrentPos:             32 << 20,
	})

	if boostedReadahead <= baseReadahead {
		t.Fatalf("expected boosted readahead to be greater than base, got base=%d boosted=%d", baseReadahead, boostedReadahead)
	}
}
