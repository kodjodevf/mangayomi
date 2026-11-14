# Mangayomi sync server

Keeps your Mangayomi library, reading progress, history, tracking and
settings in sync across your devices, on a machine you own: a home server,
a NAS, a Raspberry Pi, or an always-on computer.

Devices pair with it the same way they pair with a device that hosts sync:
scan a QR code, accept the device, done. There are no accounts or passwords.
Every connection is mutual TLS, so the server only answers devices you
accepted, and a device only trusts this server.

## Run it

Download the archive for your system from the
[latest release](https://github.com/kodjodevf/mangayomi/releases/tag/sync-server),
unpack it, and run:

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
between your devices**. Under **Join a host**, choose **Scan the host's QR
code** or **Paste a pairing link**. When the device asks to pair, `pair` asks
you to allow it. Check that the name and address are your device's before
you say yes.

A code works once, for 5 minutes (`--minutes` up to 30). After 5 wrong codes
it stops working, and you run `pair` again. `pair --yes` lets in the first
device that sends the right code without asking, for when no one is at the
terminal.

The device then syncs on its own. **Auto sync** on the same screen sets how
often.

### The admin page

The admin page does the same from a browser: open a pairing code, allow the
device, see when each device last synced, remove one.

1. Start the server with `serve`. The page is part of it, on port 53320.
2. On the same machine, run:

   ```sh
   ./bin/mangayomi-sync-server admin
   ```

3. Open the link it prints, of the form `http://127.0.0.1:53320/#token=…`.

The page only answers on 127.0.0.1, and only with that token. The link carries
the token, so keep it to yourself. The token changes each time the server
starts. If the page says **Open this page with its link**, run `admin` again
and open the new link. To reach the page from another computer, forward the
port over SSH instead of opening it to the network:

```sh
ssh -L 53320:127.0.0.1:53320 you@server
```

Start the server with `--no-admin` to turn the page off.

## What is synced

- The library: titles, categories, chapters with their read and bookmarked
  state, reading history, tracking and updates, for manga, anime and novels.
- Settings, except those that only make sense on one device: download and
  local folders, proxy, Java and extension server paths, and the last
  category open in the library.

Downloads, extensions and their sources' data stay on each device.

When two devices change the same thing, the change made last wins. A title
added on two devices before they synced becomes one title. Removing a title
removes its chapters, history and tracking on every device.

## Host on a device or run the server?

Mangayomi can also host sync itself: on one device, turn on **Host sync on
this device** on the same screen, and pair the others with it. It works the
same way, but the other devices only sync while the app is open on the host.
Run the server when you want sync to work at any time, from anywhere.

A device syncs with one host at a time. Joining another asks first, and
deletes nothing on either side.

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
| `forget <name or fingerprint>` | Stop a device from syncing, at once. |
| `status` | Whether the server runs, and what it keeps. |
| `admin` | Print the admin page link. |
| `backup <file>` | Copy the database, even while the server runs. |
| `fingerprint` | The certificate fingerprint devices check. |
| `service` | Print the file that starts the server with the machine. |

Every command takes `--data-dir`. Run `mangayomi-sync-server help <command>`
for a command's options.

### `serve` options

| Option | Default | What it does |
| --- | --- | --- |
| `--address` | `0.0.0.0` | The address to listen on. |
| `--port` | `53319` | The port devices connect to. |
| `--advertise <https://host:port>` | none | An address to put first in pairing codes. Repeat for several. |
| `--allow-public` | off | Answer devices on public networks, not only local ones and VPNs. |
| `--admin-port` | `53320` | The admin page and API port, on 127.0.0.1. |
| `--[no-]admin` | on | Serve the admin page and API. |
| `-v`, `--verbose` | off | Log every sync. |

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
- `sync.db`: everything synced, and the paired devices. Copy it safely with
  `backup`.
- `admin.json`: the admin page's port and token, readable by you alone.
- `server.lock`: keeps a second server off the same directory.

## Back up, restore and move

**Back up** while the server runs:

```sh
./bin/mangayomi-sync-server backup ~/mangayomi-sync-$(date +%F).db
```

Keep a copy of `identity.json` with it. It does not change.

**Restore:** stop the server, put the backup in place of `sync.db`, delete
any `sync.db-wal` and `sync.db-shm` beside it, and start the server again.
Devices keep syncing without pairing again, as long as `identity.json` is
the same. Changes they sent after the backup was taken reach the server
again only when they are changed again.

**Move to another machine:** stop the server, copy the whole data directory
to the new machine, and start it there. If its address changed, devices
that cannot reach it at any address from their pairing code have to pair
again. Advertising a name that stays the same, such as a Tailscale name or a
domain, avoids this.

**Lost `identity.json`:** the server makes a new one on start, and no device
trusts it. On each device, choose **Stop syncing with the host**, then pair
again. What `sync.db` holds is kept. Remove the old devices with `forget`.

## Update

Stop the server, unpack the new archive over the old one, and start it
again. The data directory is separate and kept. When it runs as a service,
restart it: `sudo systemctl restart mangayomi-sync-server` on Linux,
`launchctl kickstart -k gui/$(id -u)/com.mangayomi.sync-server` on macOS.

## Troubleshooting

**A device says it couldn't reach the host.**
Check that the server runs (`status`) and that the device is on one of the
networks the pairing code lists. A firewall on the server machine must let
TCP port 53319 in. On macOS, allow the server when the system asks. From
outside the network, see [Reach it from elsewhere](#reach-it-from-elsewhere):
without `--allow-public` the server turns away public addresses.

**"Another server is already running with …".**
A server already uses that data directory, maybe as a service. Stop it, or
use another `--data-dir`.

**"No server is running with data in …".**
`pair` and `admin` talk to the running server. Start it with `serve`, and
pass the same `--data-dir` to both.

**The admin page says Open this page with its link.**
The server restarted since the link was printed, or the link was opened
without its token. Run `admin` again and open the new link.

**A device stopped syncing after it was removed.**
`forget` cuts it off at once. To let it back, pair it again.

**Where are the logs?**
`serve` logs to the terminal; add `--verbose` to see every sync. As a service:
`journalctl -u mangayomi-sync-server` on Linux, `server.log` in the data
directory on macOS.


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

How sync works, its security model and the admin API are described in
[docs/sync.md](../docs/sync.md).
