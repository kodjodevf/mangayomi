# Device sync

How Mangayomi keeps devices in sync with each other: the pieces, the wire
protocol, the conflict rules and the security model. For running the sync
server, see [server/README.md](../server/README.md).

## The pieces

```
 device A ──┐                         ┌── a device that hosts (the app)
            │  mutual TLS, HTTP/1.1   │      lib/services/sync_host/
 device B ──┼────────────────────────►┤
            │  POST /pair             │── or the sync server
 device C ──┘  POST /api/sync/v1      └──    server/
```

| Part | Where | What it does |
| --- | --- | --- |
| `mangayomi_sync` | `packages/mangayomi_sync/` | Pure Dart, shared by the app and the server: `SyncEngine` (what a host does with a sync request), request validation, `PairingInvite`, `PairedDevice`, the `SyncStore` interface and an in-memory store for tests. |
| `mangayomi_sync_host` | `rust/sync_host/` | The transport, in Rust: identities (ECDSA P-256 self-signed certificates), the mutual-TLS server and client (rustls, TLS 1.3 only), the pairing window, connection limits. It decides who may send a request. What a request means is left to a handler on the Dart side. |
| The app as host | `lib/services/sync_host/` | `SyncHostService` runs the Rust host inside the app and answers requests with `SyncEngine` over an Isar store (`IsarSyncStore`, `HostRow`). `SyncSecrets` keeps the identity and pinned fingerprints in the OS secure storage. |
| The app as device | `lib/services/sync/`, `lib/services/sync_server.dart` | Collects local changes, sends them, applies the response. `SyncTransport` picks how the request travels: to another host over mutual TLS (`PeerSyncTransport`), to this device's own host directly, or over plain HTTP to the older account-based server. |
| The sync server | `server/` | A command-line program: the same Rust host (built from `server/native`, loaded through FFI) and the same `SyncEngine`, over SQLite. Adds the CLI, the admin API and page on 127.0.0.1, and service files. |

Because the host and the server run the same engine behind the same
transport, a device does not know or care which one it syncs with.

## Pairing

1. The host opens a pairing window and shows a `PairingInvite`, as a QR code
   or a link:

   ```
   mangayomi-sync://pair?u=https://192.168.1.20:53319&u=https://100.64.1.2:53319&f=<fingerprint>&c=K7Q2-M9XD-4TPA
   ```

   - `u`: the addresses to reach the host at, best first. `--advertise`
     addresses come first, then private networks, then Tailscale's.
     Each is `https://host:port` with no path, query or user info.
   - `f`: the SHA-256 of the host's certificate (DER), 64 uppercase hex
     digits.
   - `c`: a one-time code, `XXXX-XXXX-XXXX`, from an alphabet without
     look-alikes (no 0/O, 1/I/L): about 59 bits.

2. The device connects to the first address that answers, with its own
   certificate, and checks that the host's certificate has fingerprint `f`.
   It trusts that host and no other, whatever answers at that address.
3. It sends `POST /pair` with the code in the `x-pairing-code` header and its
   name (at most 200 bytes) as body.
4. A right code closes the window: a code works once. The host asks its user
   to allow the device, showing its name, address and fingerprint. The
   request waits up to two minutes for the answer.
5. Allowed, the host pins the device's fingerprint, answers 200, and the
   device stores the host's fingerprint and every address from the invite.

The window lasts 5 minutes by default (1 to 30 on the server). Five wrong
codes close it, whoever sent them, so guessing gets nowhere even from many
addresses. Opening a new window replaces the previous one.

| `/pair` answer | Meaning | What the app shows |
| --- | --- | --- |
| 200 | Allowed | Paired with the host |
| 401 | Wrong code | Wrong code, show a new QR code |
| 403 | No window open, or it closed | Turned down, or the code expired |
| 403 after the wait | The user refused | Turned down |
| no connection | | Couldn't reach the host |

## Security model

- **No accounts, no passwords, no certificate authority.** A device is known
  by the fingerprint of its certificate. Each side learns the other's at
  pairing and checks it on every connection.
- **Mutual TLS on every connection**, TLS 1.3 only. The handshake already
  turns away a device that is neither paired nor allowed to pair at that
  moment. Each request checks again, so a device removed while connected is
  cut off at its next request.
- **Only `POST`**, and a request with an `Origin` header gets 403: nothing on
  the host is meant for a browser.
- **Local networks only by default:** private and link-local ranges,
  loopback, unique-local IPv6 and 100.64.0.0/10 (Tailscale). Public
  addresses are turned away unless the server runs with `--allow-public`.
- **Resource limits:** 32 connections at once, 4 per address (loopback only
  counts towards the total), 10 s for the TLS handshake and for the headers,
  25 MiB per sync request on the server.
- **Secrets:** the app keeps its identity and the pinned fingerprints in the
  OS secure storage (the login keychain on macOS). The server keeps
  `identity.json` and `admin.json` readable by its user alone.
- **The admin API** listens on 127.0.0.1 only. It answers only a `Host` of
  `127.0.0.1` or `localhost` on its own port, so a web page cannot reach it
  through a DNS name pointed at 127.0.0.1. It takes a bearer token compared
  in constant time, and sends `no-store`, `nosniff`, `no-referrer` and, for
  the page, a strict CSP and `frame-ancestors 'none'`. The page gets the
  token from the URL fragment, which a browser never sends, and keeps it in
  `sessionStorage`.

## The sync protocol

A device sends one request to `POST /api/sync/v1`: what it changed since its
last sync, plus where it is in reading what others changed. The answer
carries the changes it has not seen. The device repeats until `hasMore` is
false.

### Entities

In the order they depend on each other:

| Entity | Belongs to | Natural key |
| --- | --- | --- |
| `categories` | | |
| `manga` (titles of every kind) | | `itemType`, `source`, `link` |
| `chapters` | a manga | the manga, `url` |
| `tracks` | a manga | |
| `histories` | a manga and a chapter | |
| `updates` | a manga | |

Plus one `settings` object. Every row has a `clientId` (an integer the device
gave it, the same on every device once synced) and an `updatedAt` in
milliseconds. Validation keeps only the fields it knows for each entity, so
a device cannot store anything else, and refuses a request with more than
5000 rows of one entity.

### Request

```json
{
  "since": 1731571200000,
  "cursors": { "manga": "1731571300000", "tombstones": null },
  "categories": [], "manga": [{ "clientId": 12, "updatedAt": 1731571250000, "...": "..." }],
  "chapters": [], "tracks": [], "histories": [], "updates": [],
  "deleted": { "chapters": [40, 41] },
  "settings": { "data": { "...": "..." }, "updatedAt": 1731571250000 }
}
```

- `since`: the `syncedAt` of the device's last complete sync, 0 the first
  time.
- `cursors`: per entity, and for `tombstones`, where the previous page of
  this same sync stopped.
- `deleted`: the `clientId`s the device deleted, per entity.
- `settings`: only when they changed. The device strips its device-local
  keys (folders, proxy, Java and extension server paths, last library
  category) before sending, and keeps its own when applying.

### Response

```json
{
  "categories": [], "manga": [], "chapters": [], "tracks": [], "histories": [], "updates": [],
  "tombstones": { "categories": [], "manga": [3], "chapters": [], "tracks": [], "histories": [], "updates": [] },
  "settings": null,
  "hasMore": false,
  "syncedAt": 1731571400000,
  "cursors": { "manga": null, "tombstones": null },
  "totalCounts": { "manga": 1, "tombstones": 1 },
  "mangaClientIdRemap": { "12": 7 },
  "chapterClientIdRemap": {}
}
```

- Up to 2000 rows per entity per page, and 2000 tombstones. A row this same
  request stored is not sent back.
- `hasMore`: send again with the returned `cursors` and the same `since`.
- `syncedAt`: set once nothing is left. It becomes the device's next
  `since`.
- `totalCounts`: on the first page, how many changes there are in all, for
  the progress shown.
- `*ClientIdRemap`: the device's `clientId` → the one to adopt instead (see
  duplicates below).

| Status | Meaning |
| --- | --- |
| 200 | Applied |
| 400 | Refused by validation; nothing was stored |
| 403 | Not paired, or removed |
| 413 | Body over the limit |
| 503 | The handler did not answer in time |

### Rules

- **Newest edit wins, per row**, by `updatedAt` on the uploading device's
  clock. A row is stored only when newer than the stored one, so sending a
  request twice is harmless. An `updatedAt` more than a day ahead of the
  host's clock is taken as now, or a device with a wrong clock would win
  against every later edit, for good.
- **Paging goes by the host's clock, never the device's.** Each stored change
  gets a `receivedAt` stamp, strictly increasing even when the clock goes
  back, and devices page by it. An edit made offline and uploaded later
  carries an old `updatedAt`, earlier than the other devices' last sync. Paged
  by that, they would never see it.
- **Duplicates merge.** A title added on two devices before either synced has
  two `clientId`s. When a new manga matches a stored one by natural key, the
  host keeps the stored one, remembers the new id as an alias, and answers
  with the remap for the device to adopt. Chapters merge the same way within
  their manga. Rows that point to an alias are rewritten to the canonical id.
- **Children need a live parent.** A chapter, track, history or update whose
  manga is unknown or deleted is dropped, and a history needs its chapter.
- **Deletions are tombstones.** A deleted row stays as a tombstone, so devices
  that still have it learn of it. Deleting a manga deletes its chapters,
  tracks, histories and updates. A newer edit of a deleted row brings it
  back. A row missing from a response never means it was deleted: only
  `tombstones` does. Tombstones are kept for good.
- **Settings** are one row, under the same newest-wins rule.

### Reaching the host

A device keeps every address from its invite. Each request starts with the
address that answered last and tries the others in turn, with a 5-second
connect timeout each. Sending again elsewhere is safe for the reason above.
A device can pair at home on a private address and sync from outside through
an advertised one.

## The server's storage

SQLite in WAL mode (`sync.db`), with a 5-second busy timeout:

- `sync_rows (entity, client_id, received_at, updated_at, deleted,
  natural_key, parent_client_id, data)`: every row and tombstone, the JSON in
  `data`. Indexed for paging by `received_at`, for natural keys and for
  children by parent. The `meta` row holds the last stamp given out, and
  `alias:<entity>` rows hold the merged ids.
- `devices (fingerprint, name, paired_at, last_sync_at)`.

`backup` runs `VACUUM INTO`, which is safe while the server writes.

## Admin API

On `http://127.0.0.1:53320` (`--admin-port`), every route under `/api/` with
`Authorization: Bearer <token>`. The token is in `admin.json` in the data
directory, written at each start. Answers are JSON. Errors are
`{"error": "…"}` with 401 (no or wrong token), 404, 421 (unexpected `Host`)
or 500.

| Route | Answer |
| --- | --- |
| `GET /` | The admin page (no token needed: it reads it from the fragment). |
| `GET /api/status` | `version`, `fingerprint`, `port`, `rows`, `tombstones`, `devices`, `pairing`, `pending` |
| `POST /api/pairing?minutes=5` | Opens a pairing window (1 to 30 minutes) and returns `pairing`. |
| `DELETE /api/pairing` | Closes it and refuses every pending request: `{"closed": true}` |
| `GET /api/pairing/qr.svg` | The invite as an SVG QR code, or 404 when closed. |
| `POST /api/pairing/<id>/accept` | Allows a pending device: `{"answered": true}`, or 404. |
| `POST /api/pairing/<id>/refuse` | Refuses it, the same way. |
| `GET /api/devices` | The paired devices. |
| `DELETE /api/devices/<fingerprint>` | Removes one at once: `{"forgotten": true}`, or 404. |

The objects:

```json
{
  "pairing": { "link": "mangayomi-sync://pair?…", "code": "K7Q2-M9XD-4TPA",
               "addresses": ["https://192.168.1.20:53319"], "expiresAt": 1731571700000 },
  "pending": [{ "id": "…", "deviceName": "Pixel 9", "fingerprint": "…", "address": "192.168.1.30" }],
  "devices": [{ "fingerprint": "…", "name": "Pixel 9", "pairedAt": 1731571400000, "lastSyncAt": 1731571500000 }]
}
```

`pairing` is null when no window is open. `lastSyncAt` is absent for a
device that has not synced yet. The CLI's `pair`, `admin` and `status` ask the
running server through this API. `forget` uses it when a server runs, and the
database otherwise. `devices` reads the database.

## Working on it

```sh
# The shared package
cd packages/mangayomi_sync && dart test

# The Rust host
cd rust && cargo test -p mangayomi_sync_host

# The server (build its native library first)
cd server/native && cargo build
cd server && dart test
```

The `Sync server` workflow (`.github/workflows/sync_server.yml`) runs these
on every change to `server/`, `packages/mangayomi_sync/` or
`rust/sync_host/`, and packs the server for Linux x64 and arm64, macOS arm64
and Windows x64. A `sync-server-v*` tag publishes the archives as a release.

A change to the protocol has to land in `mangayomi_sync`, where both the app
and the server pick it up. Devices and hosts on different versions stay
compatible only as long as validation accepts what the other sends.
