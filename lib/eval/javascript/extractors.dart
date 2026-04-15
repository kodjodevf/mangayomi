import 'dart:convert';
import 'package:js_interpreter/js_interpreter.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/models/video.dart';

class JsVideosExtractors {
  late JSInterpreter runtime;
  JsVideosExtractors(this.runtime);

  void init() {
    runtime.onMessage('sibnetExtractor', (dynamic args) async {
      return (await MBridge.sibnetExtractor(
        args[0],
        args[1] ?? "",
      )).encodeToJson();
    });
    runtime.onMessage('myTvExtractor', (dynamic args) async {
      return (await MBridge.myTvExtractor(args[0])).encodeToJson();
    });
    runtime.onMessage('okruExtractor', (dynamic args) async {
      return (await MBridge.okruExtractor(args[0])).encodeToJson();
    });
    runtime.onMessage('voeExtractor', (dynamic args) async {
      return (await MBridge.voeExtractor(args[0], args[1])).encodeToJson();
    });
    runtime.onMessage('vidBomExtractor', (dynamic args) async {
      return (await MBridge.vidBomExtractor(args[0])).encodeToJson();
    });
    runtime.onMessage('quarkVideosExtractor', (dynamic args) async {
      return (await MBridge.quarkVideosExtractor(
        args[0],
        args[1],
      )).encodeToJson();
    });
    runtime.onMessage('ucVideosExtractor', (dynamic args) async {
      return (await MBridge.ucVideosExtractor(args[0], args[1])).encodeToJson();
    });
    runtime.onMessage('quarkFilesExtractor', (dynamic args) async {
      List<String> urls = (args[0] as List).cast<String>();
      return (await MBridge.quarkFilesExtractor(urls, args[1]));
    });
    runtime.onMessage('ucFilesExtractor', (dynamic args) async {
      List<String> urls = (args[0] as List).cast<String>();
      return (await MBridge.ucFilesExtractor(urls, args[1]));
    });
    runtime.onMessage('streamlareExtractor', (dynamic args) async {
      return (await MBridge.streamlareExtractor(
        args[0],
        args[1] ?? "",
        args[2] ?? "",
      )).encodeToJson();
    });
    runtime.onMessage('sendVidExtractor', (dynamic args) async {
      return (await MBridge.sendVidExtractor(
        args[0],
        args[1] != null
            ? jsonEncode((args[1] as Map?).toMapStringString)
            : null,
        args[2] ?? "",
      )).encodeToJson();
    });
    runtime.onMessage('yourUploadExtractor', (dynamic args) async {
      return (await MBridge.yourUploadExtractor(
        args[0],
        args[1] != null
            ? jsonEncode((args[1] as Map?).toMapStringString)
            : null,
        args[2],
        args[3] ?? "",
      )).encodeToJson();
    });
    runtime.onMessage('gogoCdnExtractor', (dynamic args) async {
      return (await MBridge.gogoCdnExtractor(args[0])).encodeToJson();
    });
    runtime.onMessage('doodExtractor', (dynamic args) async {
      return (await MBridge.doodExtractor(args[0], args[1])).encodeToJson();
    });
    runtime.onMessage('streamTapeExtractor', (dynamic args) async {
      return (await MBridge.streamTapeExtractor(
        args[0],
        args[1],
      )).encodeToJson();
    });
    runtime.onMessage('mp4UploadExtractor', (dynamic args) async {
      return (await MBridge.mp4UploadExtractor(
        args[0],
        args[1] != null
            ? jsonEncode((args[1] as Map?).toMapStringString)
            : null,
        args[2] ?? "",
        args[3] ?? "",
      )).encodeToJson();
    });
    runtime.onMessage('streamWishExtractor', (dynamic args) async {
      return (await MBridge.streamWishExtractor(
        args[0],
        args[1] ?? "",
      )).encodeToJson();
    });
    runtime.onMessage('filemoonExtractor', (dynamic args) async {
      return (await MBridge.filemoonExtractor(
        args[0],
        args[1] ?? "",
        args[2] ?? "",
      )).encodeToJson();
    });

    runtime.eval('''
async function sibnetExtractor(url, prefix) {
    const result = await sendMessageAsync(
        "sibnetExtractor",
        JSON.stringify([url, prefix])
    );
    return JSON.parse(result);
}
async function myTvExtractor(url) {
    const result = await sendMessageAsync(
        "myTvExtractor",
        JSON.stringify([url])
    );
    return JSON.parse(result);
}
async function okruExtractor(url) {
    const result = await sendMessageAsync(
        "okruExtractor",
        JSON.stringify([url])
    );
    return JSON.parse(result);
}
async function voeExtractor(url, quality) {
    const result = await sendMessageAsync(
        "voeExtractor",
        JSON.stringify([url, quality])
    );
    return JSON.parse(result);
}
async function vidBomExtractor(url) {
    const result = await sendMessageAsync(
        "vidBomExtractor",
        JSON.stringify([url])
    );
    return JSON.parse(result);
}
async function streamlareExtractor(url, prefix, suffix) {
    const result = await sendMessageAsync(
        "streamlareExtractor",
        JSON.stringify([url, prefix, suffix])
    );
    return JSON.parse(result);
}
async function sendVidExtractor(url, headers, prefix) {
    const result = await sendMessageAsync(
        "sendVidExtractor",
        JSON.stringify([url, JSON.stringify(headers), prefix])
    );
    return JSON.parse(result);
}
async function yourUploadExtractor(url, headers, name, prefix) {
    const result = await sendMessageAsync(
        "yourUploadExtractor",
        JSON.stringify([url, JSON.stringify(headers), name, prefix])
    );
    return JSON.parse(result);
}
async function gogoCdnExtractor(url) {
    const result = await sendMessageAsync(
        "gogoCdnExtractor",
        JSON.stringify([url])
    );
    return JSON.parse(result);
}
async function doodExtractor(url, quality) {
    const result = await sendMessageAsync(
        "doodExtractor",
        JSON.stringify([url, quality])
    );
    return JSON.parse(result);
}
async function streamTapeExtractor(url, quality) {
    const result = await sendMessageAsync(
        "streamTapeExtractor",
        JSON.stringify([url, quality])
    );
    return JSON.parse(result);
}
async function mp4UploadExtractor(url, headers, prefix, suffix) {
    const result = await sendMessageAsync(
        "mp4UploadExtractor",
        JSON.stringify([url, JSON.stringify(headers), prefix, suffix])
    );
    return JSON.parse(result);
}
async function streamWishExtractor(url, prefix) {
    const result = await sendMessageAsync(
        "streamWishExtractor",
        JSON.stringify([url, prefix])
    );
    return JSON.parse(result);
}
async function filemoonExtractor(url, prefix, suffix) {
    const result = await sendMessageAsync(
        "filemoonExtractor",
        JSON.stringify([url, prefix, suffix])
    );
    return JSON.parse(result);
}
async function quarkVideosExtractor(url, cookie) {
    const result = await sendMessageAsync(
        "quarkVideosExtractor",
        JSON.stringify([url, cookie])
    );
    return JSON.parse(result);
}
async function ucVideosExtractor(url, cookie) {
    const result = await sendMessageAsync(
        "ucVideosExtractor",
        JSON.stringify([url, cookie])
    );
    return JSON.parse(result);
}
async function quarkFilesExtractor(urls, cookie) {
    const result = await sendMessageAsync(
        "quarkFilesExtractor",
        JSON.stringify([urls, cookie])
    );
    return result;
}
async function ucFilesExtractor(urls, cookie) {
    const result = await sendMessageAsync(
        "ucFilesExtractor",
        JSON.stringify([urls, cookie])
    );
    return result;
}
''');
  }
}

extension ResponseExtexsion on List<Video> {
  String encodeToJson() {
    return jsonEncode(map((e) => e.toJson()).toList());
  }
}
