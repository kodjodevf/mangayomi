import 'dart:convert';
import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:mangayomi/eval/dart/model/m_bridge.dart';
import 'package:mangayomi/models/video.dart';

class JsVideosExtractors {
  late JavascriptRuntime runtime;
  JsVideosExtractors(this.runtime);

  init() {
    runtime.onMessage('sibnetExtractor', (dynamic args) async {
      return (await MBridge.sibnetExtractor(args[0], args[1] ?? ""))
          .encodeToJson();
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
    runtime.onMessage('streamlareExtractor', (dynamic args) async {
      return (await MBridge.streamlareExtractor(args[0], args[1], args[2]))
          .encodeToJson();
    });
    runtime.onMessage('sendVidExtractor', (dynamic args) async {
      return (await MBridge.sendVidExtractor(args[0], args[1], args[2] ?? ""))
          .encodeToJson();
    });
    runtime.onMessage('yourUploadExtractor', (dynamic args) async {
      return (await MBridge.yourUploadExtractor(
              args[0], args[1], args[2], args[3] ?? ""))
          .encodeToJson();
    });
    runtime.onMessage('gogoCdnExtractor', (dynamic args) async {
      return (await MBridge.gogoCdnExtractor(args[0])).encodeToJson();
    });
    runtime.onMessage('doodExtractor', (dynamic args) async {
      return (await MBridge.doodExtractor(args[0], args[1])).encodeToJson();
    });
    runtime.onMessage('streamTapeExtractor', (dynamic args) async {
      return (await MBridge.streamTapeExtractor(args[0], args[1]))
          .encodeToJson();
    });
    runtime.onMessage('mp4UploadExtractor', (dynamic args) async {
      return (await MBridge.mp4UploadExtractor(
              args[0], args[1], args[2], args[3] ?? ""))
          .encodeToJson();
    });
    runtime.onMessage('streamWishExtractor', (dynamic args) async {
      return (await MBridge.streamWishExtractor(args[0], args[1] ?? ""))
          .encodeToJson();
    });
    runtime.onMessage('filemoonExtractor', (dynamic args) async {
      return (await MBridge.filemoonExtractor(
              args[0], args[1] ?? "", args[2] ?? ""))
          .encodeToJson();
    });

    runtime.evaluate('''
async function sibnetExtractor(url, prefix) {
    const result = await sendMessage(
        "sibnetExtractor",
        JSON.stringify([url, prefix])
    );
    return JSON.parse(result);
}
async function myTvExtractor(url) {
    const result = await sendMessage(
        "myTvExtractor",
        JSON.stringify([url])
    );
    return JSON.parse(result);
}
async function okruExtractor(url) {
    const result = await sendMessage(
        "okruExtractor",
        JSON.stringify([url])
    );
    return JSON.parse(result);
}
async function voeExtractor(url, quality) {
    const result = await sendMessage(
        "voeExtractor",
        JSON.stringify([url, quality])
    );
    return JSON.parse(result);
}
async function vidBomExtractor(url) {
    const result = await sendMessage(
        "vidBomExtractor",
        JSON.stringify([url])
    );
    return JSON.parse(result);
}
async function streamlareExtractor(url, prefix, suffix) {
    const result = await sendMessage(
        "streamlareExtractor",
        JSON.stringify([url, prefix, suffix])
    );
    return JSON.parse(result);
}
async function sendVidExtractor(url, headers, prefix) {
    const result = await sendMessage(
        "sendVidExtractor",
        JSON.stringify([url, JSON.stringify(headers), prefix])
    );
    return JSON.parse(result);
}
async function yourUploadExtractor(url, headers, name, prefix) {
    const result = await sendMessage(
        "yourUploadExtractor",
        JSON.stringify([url, JSON.stringify(headers), name, prefix])
    );
    return JSON.parse(result);
}
async function gogoCdnExtractor(url) {
    const result = await sendMessage(
        "gogoCdnExtractor",
        JSON.stringify([url])
    );
    return JSON.parse(result);
}
async function doodExtractor(url, quality) {
    const result = await sendMessage(
        "doodExtractor",
        JSON.stringify([url, quality])
    );
    return JSON.parse(result);
}
async function streamTapeExtractor(url, quality) {
    const result = await sendMessage(
        "streamTapeExtractor",
        JSON.stringify([url, quality])
    );
    return JSON.parse(result);
}
async function mp4UploadExtractor(url, headers, prefix, suffix) {
    const result = await sendMessage(
        "mp4UploadExtractor",
        JSON.stringify([url, JSON.stringify(headers), prefix, suffix])
    );
    return JSON.parse(result);
}
async function streamWishExtractor(url, prefix) {
    const result = await sendMessage(
        "streamWishExtractor",
        JSON.stringify([url, prefix])
    );
    return JSON.parse(result);
}
async function filemoonExtractor(url, prefix, suffix) {
    const result = await sendMessage(
        "filemoonExtractor",
        JSON.stringify([url, prefix, suffix])
    );
    return JSON.parse(result);
}
''');
  }
}

extension ResponseExtexsion on List<Video> {
  String encodeToJson() {
    return jsonEncode(map((e) => e.toJson()).toList());
  }
}
