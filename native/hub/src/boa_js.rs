use crate::bridge::{RustOperation, RustRequest, RustResponse};
use boa_engine::{Context, Source};
use prost::Message;

pub async fn eval_js(rust_request: RustRequest) -> RustResponse {
    use crate::messages::boa_js::{ReadRequest, ReadResponse};

    match rust_request.operation {
        RustOperation::Create => RustResponse::default(),
        RustOperation::Read => {
            let mut context = Context::default();

            let code_script = rust_request.message.unwrap();
            let request_message = ReadRequest::decode(code_script.as_slice()).unwrap();
            let response_message = ReadResponse {
                response: match context
                    .eval(Source::from_bytes(request_message.code_script.as_bytes()))
                {
                    Ok(res) => res.to_string(&mut context).unwrap().to_std_string_escaped(),
                    Err(_e) => "error".to_string(),
                },
            };
            RustResponse {
                successful: true,
                message: Some(response_message.encode_to_vec()),
                blob: None,
            }
        }
        RustOperation::Delete => RustResponse::default(),
        RustOperation::Update => RustResponse::default(),
    }
}
