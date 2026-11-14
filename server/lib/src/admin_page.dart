// The admin page: one self-contained HTML file, nothing loaded from
// elsewhere. Device names come from the devices, so they only ever go into
// the page as text.
const adminPage = r'''<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Mangayomi Sync Server</title>
<style>
:root {
  --bg: #f6f6f8; --card: #fff; --text: #1b1b1f; --muted: #66666f;
  --line: #e2e2e8; --accent: #3b5bdb; --danger: #c92a2a; --ok: #2b8a3e;
  color-scheme: light dark;
}
@media (prefers-color-scheme: dark) {
  :root {
    --bg: #121216; --card: #1c1c22; --text: #ececf1; --muted: #9a9aa6;
    --line: #2c2c35; --accent: #748ffc; --danger: #ff6b6b; --ok: #69db7c;
  }
}
* { box-sizing: border-box; }
body {
  margin: 0; background: var(--bg); color: var(--text);
  font: 15px/1.5 system-ui, -apple-system, "Segoe UI", sans-serif;
}
main { max-width: 760px; margin: 0 auto; padding: 24px 16px 48px; }
h1 { font-size: 22px; margin: 0 0 4px; }
h2 { font-size: 16px; margin: 0 0 12px; }
.sub { color: var(--muted); margin: 0 0 24px; word-break: break-all; }
.card {
  background: var(--card); border: 1px solid var(--line); border-radius: 12px;
  padding: 16px; margin-bottom: 16px;
}
.stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(120px, 1fr)); gap: 12px; }
.stat b { display: block; font-size: 22px; font-variant-numeric: tabular-nums; }
.stat span { color: var(--muted); font-size: 13px; }
button {
  font: inherit; border-radius: 8px; padding: 8px 14px; cursor: pointer;
  border: 1px solid var(--line); background: var(--card); color: var(--text);
}
button.primary { background: var(--accent); border-color: var(--accent); color: #fff; }
button.danger { color: var(--danger); }
button:disabled { opacity: .5; cursor: default; }
.row {
  display: flex; align-items: center; gap: 12px; padding: 10px 0;
  border-top: 1px solid var(--line); flex-wrap: wrap;
}
.row:first-child { border-top: 0; }
.grow { flex: 1; min-width: 180px; }
.muted { color: var(--muted); font-size: 13px; }
.mono { font-family: ui-monospace, Menlo, monospace; font-size: 12px; word-break: break-all; }
.pairing { display: flex; gap: 20px; flex-wrap: wrap; align-items: flex-start; }
.pairing img { width: 220px; height: 220px; border-radius: 8px; background: #fff; }
.code { font: 600 22px ui-monospace, Menlo, monospace; letter-spacing: 2px; }
.pending { border: 1px solid var(--accent); border-radius: 10px; padding: 12px; margin-top: 12px; }
.error { color: var(--danger); }
.empty { color: var(--muted); }
code { font-family: ui-monospace, Menlo, monospace; font-size: 13px; }
pre {
  font: 13px ui-monospace, Menlo, monospace; background: var(--bg);
  border: 1px solid var(--line); border-radius: 8px; padding: 10px 12px;
  overflow-x: auto; margin: 8px 0;
}
</style>
</head>
<body>
<main>
  <h1>Mangayomi Sync Server</h1>
  <p class="sub" id="fingerprint">Connecting…</p>
  <p class="error" id="error" hidden></p>

  <section class="card" id="locked" hidden>
    <h2>Open this page with its link</h2>
    <p id="locked-reason"></p>
    <p>On the machine the server runs on, run:</p>
    <pre>mangayomi-sync-server admin</pre>
    <p class="muted">It prints a link with a token in it, such as
    <code>http://127.0.0.1:53320/#token=…</code>. Open that link in a browser
    on the same machine. The token changes each time the server starts, so
    run the command again after a restart.</p>
  </section>

  <div id="console">
  <section class="card">
    <div class="stats">
      <div class="stat"><b id="devices-count">–</b><span>Devices</span></div>
      <div class="stat"><b id="rows">–</b><span>Items kept</span></div>
      <div class="stat"><b id="tombstones">–</b><span>Deletions kept</span></div>
      <div class="stat"><b id="port">–</b><span>Port</span></div>
    </div>
  </section>

  <section class="card">
    <h2>Add a device</h2>
    <div id="pairing-closed">
      <p class="muted">In Mangayomi on the device to add, open
      Settings → Sync → Sync between your devices. Under Join a host, choose
      Scan the host's QR code and scan the code shown here, or Paste a pairing
      link and paste its link.</p>
      <button class="primary" id="open-pairing">Show a pairing code</button>
    </div>
    <div id="pairing-open" hidden>
      <div class="pairing">
        <img id="qr" alt="Pairing QR code">
        <div class="grow">
          <div class="muted">Code</div>
          <div class="code" id="code"></div>
          <p class="muted" id="expires"></p>
          <p><button id="copy-link">Copy link</button>
          <button id="close-pairing">Stop pairing</button></p>
          <div class="muted">Addresses in the code</div>
          <div class="mono" id="addresses"></div>
        </div>
      </div>
    </div>
    <div id="pending"></div>
  </section>

  <section class="card">
    <h2>Devices</h2>
    <div id="devices"></div>
  </section>
  </div>
</main>
<script>
(() => {
  const hash = new URLSearchParams(location.hash.slice(1));
  let token = hash.get('token');
  try {
    if (token) sessionStorage.setItem('token', token);
    else token = sessionStorage.getItem('token');
  } catch (_) {}
  history.replaceState(null, '', location.pathname);

  const $ = (id) => document.getElementById(id);
  const showError = (message) => {
    $('error').textContent = message;
    $('error').hidden = !message;
  };
  // Without a token that works, nothing on the page can: show how to get
  // one instead of controls that do nothing.
  let timer = null;
  const lock = (reason) => {
    try { sessionStorage.removeItem('token'); } catch (_) {}
    if (timer) clearInterval(timer);
    showError('');
    $('fingerprint').textContent = 'Not connected';
    $('locked-reason').textContent = reason;
    $('locked').hidden = false;
    $('console').hidden = true;
  };
  if (!token) {
    lock('This page needs the token from its link, and this address has none.');
    return;
  }

  class Locked extends Error {}
  async function api(method, path) {
    const response = await fetch('/api' + path, {
      method, headers: { authorization: 'Bearer ' + token },
    });
    if (response.status === 401) throw new Locked();
    const type = response.headers.get('content-type') || '';
    const body = type.includes('json') ? await response.json() : await response.text();
    if (!response.ok) throw new Error(body.error || response.statusText);
    return body;
  }
  const lockIfLocked = (error) => {
    if (!(error instanceof Locked)) return false;
    lock('The token in this link is not the server\'s: it changes each time ' +
      'the server starts.');
    return true;
  };

  const time = (ms) => ms ? new Date(ms).toLocaleString() : 'never';
  let shownLink = null;

  async function refresh() {
    let status;
    try {
      status = await api('GET', '/status');
      showError('');
    } catch (error) {
      if (lockIfLocked(error)) return;
      showError('Cannot reach the server: ' + error.message +
        '. Is it still running?');
      return;
    }
    $('fingerprint').textContent = 'Version ' + status.version +
      ' · fingerprint ' + status.fingerprint;
    $('devices-count').textContent = status.devices.length;
    $('rows').textContent = status.rows.toLocaleString();
    $('tombstones').textContent = status.tombstones.toLocaleString();
    $('port').textContent = status.port;

    const pairing = status.pairing;
    $('pairing-open').hidden = !pairing;
    $('pairing-closed').hidden = !!pairing;
    if (pairing) {
      $('code').textContent = pairing.code;
      $('addresses').textContent = pairing.addresses.join('\n');
      $('addresses').style.whiteSpace = 'pre-line';
      const left = Math.max(0, Math.round((pairing.expiresAt - Date.now()) / 1000));
      $('expires').textContent = 'Works for ' + Math.floor(left / 60) + ' min ' +
        (left % 60) + ' s, for one device.';
      if (shownLink !== pairing.link) {
        shownLink = pairing.link;
        try {
          const svg = await api('GET', '/pairing/qr.svg');
          $('qr').src = 'data:image/svg+xml;base64,' + btoa(svg);
        } catch (error) {
          if (lockIfLocked(error)) return;
          shownLink = null;
          showError('Could not load the QR code: ' + error.message);
        }
      }
    } else {
      shownLink = null;
    }

    const pending = $('pending');
    pending.replaceChildren(...status.pending.map((request) => {
      const box = document.createElement('div');
      box.className = 'pending';
      const title = document.createElement('div');
      title.textContent = '“' + request.deviceName + '” wants to sync, from ' +
        request.address + '.';
      const fp = document.createElement('div');
      fp.className = 'mono muted';
      fp.textContent = request.fingerprint;
      const actions = document.createElement('p');
      const accept = document.createElement('button');
      accept.className = 'primary';
      accept.textContent = 'Allow';
      accept.onclick = () => answer(request.id, 'accept');
      const refuse = document.createElement('button');
      refuse.textContent = 'Deny';
      refuse.onclick = () => answer(request.id, 'refuse');
      actions.append(accept, ' ', refuse);
      box.append(title, fp, actions);
      return box;
    }));

    const devices = $('devices');
    if (!status.devices.length) {
      const empty = document.createElement('p');
      empty.className = 'empty';
      empty.textContent = 'No device yet.';
      devices.replaceChildren(empty);
    } else {
      devices.replaceChildren(...status.devices.map((device) => {
        const row = document.createElement('div');
        row.className = 'row';
        const info = document.createElement('div');
        info.className = 'grow';
        const name = document.createElement('div');
        name.textContent = device.name;
        const meta = document.createElement('div');
        meta.className = 'muted';
        meta.textContent = 'Paired ' + time(device.pairedAt) +
          ' · last sync ' + time(device.lastSyncAt);
        info.append(name, meta);
        const forget = document.createElement('button');
        forget.className = 'danger';
        forget.textContent = 'Forget';
        forget.onclick = async () => {
          if (!confirm('Forget “' + device.name + '”? It will have to pair again to sync.')) return;
          await run(() => api('DELETE', '/devices/' + device.fingerprint));
        };
        row.append(info, forget);
        return row;
      }));
    }
  }

  async function run(action) {
    try {
      await action();
    } catch (error) {
      if (lockIfLocked(error)) return;
      showError(error.message);
    }
    await refresh();
  }
  const answer = (id, verdict) => run(() => api('POST', '/pairing/' + id + '/' + verdict));

  $('open-pairing').onclick = () => run(() => api('POST', '/pairing'));
  $('close-pairing').onclick = () => run(() => api('DELETE', '/pairing'));
  $('copy-link').onclick = async () => {
    try { await navigator.clipboard.writeText(shownLink); }
    catch (error) { showError('Could not copy: ' + error.message); }
  };

  refresh();
  timer = setInterval(refresh, 2000);
})();
</script>
</body>
</html>
''';
