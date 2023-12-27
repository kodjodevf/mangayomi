import 'package:mangayomi/messages/rust_js.pb.dart' as rust_js;
import 'package:rinf/rinf.dart';

Future<String> evalJs(String script) async {
  final requestMessage = rust_js.ReadRequest(codeScript: script);
  final rustRequest = RustRequest(
      resource: rust_js.ID,
      operation: RustOperation.Read,
      message: requestMessage.writeToBuffer());
  final rustResponse = await requestToRust(rustRequest);
  if (rustResponse.successful) {
    final responseMessage = rust_js.ReadResponse.fromBuffer(
      rustResponse.message!,
    );
    return responseMessage.response;
  }
  return "";
}
