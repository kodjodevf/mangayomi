//! A host whose requests are answered later, by id: what a bridge to another
//! language needs, where the request leaves as a message and its answer
//! comes back as a call.

use crate::server::{Handler, Host, HostConfig, HostRequest, HostResponse};
use std::collections::HashMap;
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::{Arc, Mutex};
use tokio::sync::oneshot;

/// A request waiting for [QueuedHost::respond] under its [id].
pub struct QueuedRequest {
    pub id: u64,
    pub request: HostRequest,
}

/// Takes each request; false when it could not take it, and the device gets
/// 503 at once.
pub type Listener = Box<dyn Fn(QueuedRequest) -> bool + Send + Sync>;

type Pending = Arc<Mutex<HashMap<u64, oneshot::Sender<HostResponse>>>>;

/// Forgets a request once its device stops waiting for the answer, whether
/// answered, timed out or disconnected.
struct PendingGuard {
    pending: Pending,
    id: u64,
}

impl Drop for PendingGuard {
    fn drop(&mut self) {
        self.pending.lock().unwrap().remove(&self.id);
    }
}

fn unavailable() -> HostResponse {
    HostResponse {
        status: 503,
        body: Vec::new(),
        approve_peer: false,
    }
}

pub struct QueuedHost {
    host: Host,
    pending: Pending,
    listener: Arc<Mutex<Option<Listener>>>,
}

impl QueuedHost {
    /// Starts listening. Devices get 503 until [listen] is called.
    pub async fn start(config: HostConfig) -> anyhow::Result<Self> {
        let pending: Pending = Arc::default();
        let listener: Arc<Mutex<Option<Listener>>> = Arc::default();
        let next_id = Arc::new(AtomicU64::new(1));

        let handler: Handler = {
            let pending = pending.clone();
            let listener = listener.clone();
            Arc::new(move |request: HostRequest| {
                let id = next_id.fetch_add(1, Ordering::Relaxed);
                let (answer, answered) = oneshot::channel();
                pending.lock().unwrap().insert(id, answer);
                let guard = PendingGuard {
                    pending: pending.clone(),
                    id,
                };
                let taken = listener
                    .lock()
                    .unwrap()
                    .as_ref()
                    .is_some_and(|listen| listen(QueuedRequest { id, request }));
                Box::pin(async move {
                    let _guard = guard;
                    if !taken {
                        return unavailable();
                    }
                    answered.await.unwrap_or_else(|_| unavailable())
                })
            })
        };

        Ok(Self {
            host: Host::start(config, handler).await?,
            pending,
            listener,
        })
    }

    pub fn host(&self) -> &Host {
        &self.host
    }

    /// Hands every request to [listener] from now on, replacing any other.
    pub fn listen(&self, listener: Listener) {
        *self.listener.lock().unwrap() = Some(listener);
    }

    /// Answers request [id]. False when its device stopped waiting.
    pub fn respond(&self, id: u64, response: HostResponse) -> bool {
        let Some(answer) = self.pending.lock().unwrap().remove(&id) else {
            return false;
        };
        answer.send(response).is_ok()
    }

    /// Stops the host, then drops the listener: for a bridge, what ends the
    /// stream on the other side.
    pub async fn stop(&self) {
        self.host.stop().await;
        self.listener.lock().unwrap().take();
    }
}
