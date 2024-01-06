import 'package:mangayomi/messages/boa_js.pb.dart';
import 'package:rinf/rinf.dart';

Future<String> evalJs(String script) async {
  final requestMessage = ReadRequest(codeScript: script);
  final rustRequest = RustRequest(
      resource: ID,
      operation: RustOperation.Read,
      message: requestMessage.writeToBuffer());
  final rustResponse = await requestToRust(rustRequest);
  if (rustResponse.successful) {
    final responseMessage = ReadResponse.fromBuffer(
      rustResponse.message!,
    );
    return responseMessage.response;
  }
  return "";
}
