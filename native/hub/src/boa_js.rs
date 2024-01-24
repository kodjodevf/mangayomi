use crate::messages;
use boa_engine::{Context, Source};

pub async fn eval_js() {
    use messages::boa_js::*;

    let mut receiver = BoaInput::get_dart_signal_receiver();
    while let Some(dart_signal) = receiver.recv().await {
        let mut context = Context::default();
        let code_script = dart_signal.message.code_script;
        BoaOutput {
            interaction_id: dart_signal.message.interaction_id,
            response: match context.eval(Source::from_bytes(code_script.as_bytes())) {
                Ok(res) => res.to_string(&mut context).unwrap().to_std_string_escaped(),
                Err(_e) => "error".to_string(),
            },
        }
        .send_signal_to_dart(None);
    }
}
