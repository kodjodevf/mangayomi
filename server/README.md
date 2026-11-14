# Mangayomi sync server

Keeps your Mangayomi library, reading progress, history, tracking and
settings in sync across your devices, on a machine you own: a home server,
a NAS, a Raspberry Pi, or an always-on computer.

Devices pair with it the same way they pair with a device that hosts sync:
scan a QR code, accept the device, done. There are no accounts or passwords.
Every connection is mutual TLS, so the server only answers devices you
accepted, and a device only trusts this server.

## Run it

Download the archive for your system from the releases, unpack it, and run:

```sh
./bin/mangayomi-sync-server serve
```

Nothing else needs to be installed. On first start the server creates its
identity and its database (see [Data](#data)).

On macOS, a downloaded server is blocked until you allow it:

```sh
xattr -dr com.apple.quarantine mangayomi-sync-server-*
```

## Add a device

While the server runs, in another terminal on the same machine:

```sh
./bin/mangayomi-sync-server pair
```

It shows a QR code and a link. In Mangayomi, go to **Settings → Sync → Sync
between your devices**, then **Scan the host's QR code** or **Paste a pairing
link**. When the device asks to pair, `pair` asks you to allow it.

You can also use the admin page: run `mangayomi-sync-server admin` and open
the link it prints. The admin page and its API only listen on 127.0.0.1, and
the link carries a token that only you can read: keep it to yourself.

## Reach it from elsewhere

By default the server answers devices on your local networks and on
Tailscale. The pairing code lists the addresses it found.

To reach it from outside your network, choose one of these:

- **A VPN such as Tailscale or WireGuard** (recommended). Nothing is exposed
  to the internet.
- **Port forwarding on your router.** Forward TCP port 53319 to the server
  and start it with:

  ```sh
  ./bin/mangayomi-sync-server serve --allow-public \
    --advertise https://your.domain.example:53319
  ```

  `--advertise` puts that address first in pairing codes. A device keeps every
  address from its pairing code, and uses whichever one answers. It can pair
  at home and still sync from outside.

## Start it with the machine

`service` prints the right file for your system with its paths filled in,
and how to install it. Add any `serve` options after `--`.

```sh
./bin/mangayomi-sync-server service -- --advertise https://your.domain.example:53319
```

- **Linux:** a systemd unit that runs the server as your user.
- **macOS:** a launchd agent, which logs to `server.log` in the data
  directory.
- **Windows:** a scheduled task that starts the server when you sign in.

## Commands

| Command | What it does |
| --- | --- |
| `serve` | Run the server. |
| `pair` | Show a pairing code and allow the device that uses it. |
| `devices` | List paired devices and when they last synced. |
| `forget <name or fingerprint>` | Stop a device from syncing. |
| `status` | Whether the server runs, and what it keeps. |
| `admin` | Print the admin page link. |
| `backup <file>` | Copy the database, even while the server runs. |
| `fingerprint` | The certificate fingerprint devices check. |
| `service` | Print the file that starts the server with the machine. |

Run `mangayomi-sync-server help <command>` for a command's options.

## Data

| System | Default location |
| --- | --- |
| Linux | `~/.local/share/mangayomi-sync-server` |
| macOS | `~/Library/Application Support/mangayomi-sync-server` |
| Windows | `%APPDATA%\mangayomi-sync-server` |

Change it with `--data-dir` or the `MANGAYOMI_SYNC_DATA` environment variable.
The directory holds:

- `identity.json`: the server's key and certificate. Every device pinned it,
  so if it is lost, every device has to pair again. Back it up, and keep it
  private.
- `sync.db`: everything synced. Copy it safely with `backup`.

## Build from source

You need the Dart SDK (3.10 or later) and Rust.

```sh
cd server
dart pub get
dart run tool/package.dart
```

The archive lands in `dist/`. To run from source instead, build the native
library once (`cargo build` in `server/native`), then run
`dart run bin/mangayomi_sync_server.dart serve`.
