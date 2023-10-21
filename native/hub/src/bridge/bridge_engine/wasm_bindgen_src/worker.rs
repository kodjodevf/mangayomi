use crate::bridge::bridge_engine::script_path;
use js_sys::Array;
use wasm_bindgen::prelude::*;
use web_sys::{Blob, BlobPropertyBag, Url, Worker};

thread_local! {
    pub static WEB_WORKER: Worker = create_worker();
}

fn create_worker() -> Worker {
    let script = format!(
        "
        importScripts('{}');
        onmessage = event => {{
            let init = wasm_bindgen(...event.data).catch(err => {{
                setTimeout(() => {{ throw err }})
                throw err
            }})
            onmessage = async event => {{
                await init
                let [payload, ...transfer] = event.data
                try {{
                    wasm_bindgen.receive_transfer_closure(payload, transfer)
                }} catch (err) {{
                    if (transfer[0] && typeof transfer[0].postMessage === 'function') {{
                        transfer[0].postMessage([1, 'ABORT', err.toString(), err.stack])
                    }}
                    setTimeout(() => {{ throw err }})
                    postMessage(null)
                    throw err
                }}
            }}
        }}
        ",
        script_path().unwrap()
    );
    let blob = Blob::new_with_blob_sequence_and_options(
        &Array::from_iter([JsValue::from(script)]).into(),
        BlobPropertyBag::new().type_("text/javascript"),
    )
    .unwrap();
    let url = Url::create_object_url_with_blob(&blob).unwrap();
    let worker = Worker::new(&url).unwrap();
    let module = wasm_bindgen::module();
    let memory = wasm_bindgen::memory();
    worker
        .post_message(&Array::from_iter([module, memory]))
        .unwrap();
    worker
}
