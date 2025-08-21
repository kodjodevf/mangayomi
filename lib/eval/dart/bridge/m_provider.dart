import 'package:d4rt/d4rt.dart';
import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/eval/model/m_provider.dart';
import 'package:mangayomi/modules/browse/extension/providers/extension_preferences_providers.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';

class MProviderBridged {
  final mProviderBridged = BridgedClass(
    nativeType: MProvider,
    name: 'MProvider',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return MProvider;
      },
    },
    getters: {
      'supportsLatest': (visitor, target) =>
          (target as MProvider).supportsLatest,
      'baseUrl': (visitor, target) => (target as MProvider).baseUrl,
      'headers': (visitor, target) => (target as MProvider).headers,
    },
    methods: {
      'getLatestUpdates': (visitor, target, positionalArgs, namedArgs) =>
          (target as MProvider).getLatestUpdates(positionalArgs[0] as int),
      'getPopular': (visitor, target, positionalArgs, namedArgs) =>
          (target as MProvider).getPopular(positionalArgs[0] as int),
      'getVideoList': (visitor, target, positionalArgs, namedArgs) =>
          (target as MProvider).getVideoList(positionalArgs[0] as String),
      'search': (visitor, target, positionalArgs, namedArgs) =>
          (target as MProvider).search(
            positionalArgs[0] as String,
            positionalArgs[1] as int,
            positionalArgs[2] as FilterList,
          ),
      'getDetail': (visitor, target, positionalArgs, namedArgs) =>
          (target as MProvider).getDetail(positionalArgs[0] as String),
      'getPageList': (visitor, target, positionalArgs, namedArgs) =>
          (target as MProvider).getPageList(positionalArgs[0] as String),
      'cleanHtmlContent': (visitor, target, positionalArgs, namedArgs) =>
          (target as MProvider).cleanHtmlContent(positionalArgs[0] as String),
      'getHtmlContent': (visitor, target, positionalArgs, namedArgs) =>
          (target as MProvider).getHtmlContent(
            positionalArgs[0] as String,
            positionalArgs[1] as String,
          ),
      'getFilterList': (visitor, target, positionalArgs, namedArgs) =>
          (target as MProvider).getFilterList(),
      'getSourcePreferences': (visitor, target, positionalArgs, namedArgs) =>
          (target as MProvider).getSourcePreferences(),
    },
  );

  void registerBridgedClasses(D4rt interpreter) {
    interpreter.registerBridgedClass(
      mProviderBridged,
      'package:mangayomi/bridge_lib.dart',
    );
    interpreter.registertopLevelFunction(
      'getPreferenceValue',
      (visitor, positionalArgs, namedArgs, _) => getPreferenceValue(
        positionalArgs[0] as int,
        positionalArgs[1] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'getPrefStringValue',
      (visitor, positionalArgs, namedArgs, _) => getSourcePreferenceStringValue(
        positionalArgs[0] as int,
        positionalArgs[1] as String,
        positionalArgs[2] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'cryptoHandler',
      (visitor, positionalArgs, namedArgs, _) => MBridge.cryptoHandler(
        positionalArgs[0] as String,
        positionalArgs[1] as String,
        positionalArgs[2] as String,
        positionalArgs[3] as bool,
      ),
    );
    interpreter.registertopLevelFunction(
      'encryptAESCryptoJS',
      (visitor, positionalArgs, namedArgs, _) => MBridge.encryptAESCryptoJS(
        positionalArgs[0] as String,
        positionalArgs[1] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'decryptAESCryptoJS',
      (visitor, positionalArgs, namedArgs, _) => MBridge.decryptAESCryptoJS(
        positionalArgs[0] as String,
        positionalArgs[1] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'deobfuscateJsPassword',
      (visitor, positionalArgs, namedArgs, _) =>
          MBridge.deobfuscateJsPassword(positionalArgs[0] as String),
    );
    interpreter.registertopLevelFunction(
      'sibnetExtractor',
      (visitor, positionalArgs, namedArgs, _) => MBridge.sibnetExtractor(
        positionalArgs[0] as String,
        positionalArgs[1] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'myTvExtractor',
      (visitor, positionalArgs, namedArgs, _) =>
          MBridge.myTvExtractor(positionalArgs[0] as String),
    );
    interpreter.registertopLevelFunction(
      'okruExtractor',
      (visitor, positionalArgs, namedArgs, _) =>
          MBridge.okruExtractor(positionalArgs[0] as String),
    );
    interpreter.registertopLevelFunction(
      'voeExtractor',
      (visitor, positionalArgs, namedArgs, _) => MBridge.voeExtractor(
        positionalArgs[0] as String,
        positionalArgs[1] as String?,
      ),
    );
    interpreter.registertopLevelFunction(
      'vidBomExtractor',
      (visitor, positionalArgs, namedArgs, _) =>
          MBridge.vidBomExtractor(positionalArgs[0] as String),
    );
    interpreter.registertopLevelFunction(
      'streamlareExtractor',
      (visitor, positionalArgs, namedArgs, _) => MBridge.streamlareExtractor(
        positionalArgs[0] as String,
        positionalArgs[1] as String,
        positionalArgs[2] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'sendVidExtractor',
      (visitor, positionalArgs, namedArgs, _) => MBridge.sendVidExtractor(
        positionalArgs[0] as String,
        positionalArgs[1] as String?,
        positionalArgs[2] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'yourUploadExtractor',
      (visitor, positionalArgs, namedArgs, _) => MBridge.yourUploadExtractor(
        positionalArgs[0] as String,
        positionalArgs[1] as String?,
        positionalArgs[2] as String?,
        positionalArgs[3] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'quarkVideosExtractor',
      (visitor, positionalArgs, namedArgs, _) => MBridge.quarkVideosExtractor(
        positionalArgs[0] as String,
        positionalArgs[1] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'ucVideosExtractor',
      (visitor, positionalArgs, namedArgs, _) => MBridge.ucVideosExtractor(
        positionalArgs[0] as String,
        positionalArgs[1] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'quarkFilesExtractor',
      (visitor, positionalArgs, namedArgs, _) => MBridge.quarkFilesExtractor(
        (positionalArgs[0] as List).cast(),
        positionalArgs[1] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'ucFilesExtractor',
      (visitor, positionalArgs, namedArgs, _) => MBridge.ucFilesExtractor(
        (positionalArgs[0] as List).cast(),
        positionalArgs[1] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'substringAfter',
      (visitor, positionalArgs, namedArgs, _) => MBridge.substringAfter(
        positionalArgs[0] as String,
        positionalArgs[1] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'substringBefore',
      (visitor, positionalArgs, namedArgs, _) => MBridge.substringBefore(
        positionalArgs[0] as String,
        positionalArgs[1] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'substringBeforeLast',
      (visitor, positionalArgs, namedArgs, _) => MBridge.substringBeforeLast(
        positionalArgs[0] as String,
        positionalArgs[1] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'substringAfterLast',
      (visitor, positionalArgs, namedArgs, _) => MBridge.substringAfterLast(
        positionalArgs[0] as String,
        positionalArgs[1] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'getMapValue',
      (visitor, positionalArgs, namedArgs, _) => MBridge.getMapValue(
        positionalArgs[0] as String,
        positionalArgs[1] as String,
        namedArgs.get<bool?>('encode') ?? false,
      ),
    );
    interpreter.registertopLevelFunction(
      'parseStatus',
      (visitor, positionalArgs, namedArgs, _) => MBridge.parseStatus(
        positionalArgs[0] as String,
        positionalArgs[1] as List,
      ),
    );
    interpreter.registertopLevelFunction(
      'parseDates',
      (visitor, positionalArgs, namedArgs, _) => MBridge.parseDates(
        positionalArgs[0] as List,
        positionalArgs[1] as String,
        positionalArgs[2] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'xpath',
      (visitor, positionalArgs, namedArgs, _) => MBridge.xpath(
        positionalArgs[0] as String,
        positionalArgs[1] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'gogoCdnExtractor',
      (visitor, positionalArgs, namedArgs, _) =>
          MBridge.gogoCdnExtractor(positionalArgs[0] as String),
    );
    interpreter.registertopLevelFunction(
      'doodExtractor',
      (visitor, positionalArgs, namedArgs, _) => MBridge.doodExtractor(
        positionalArgs[0] as String,
        positionalArgs[1] as String?,
      ),
    );
    interpreter.registertopLevelFunction(
      'streamTapeExtractor',
      (visitor, positionalArgs, namedArgs, _) => MBridge.streamTapeExtractor(
        positionalArgs[0] as String,
        positionalArgs[1] as String?,
      ),
    );
    interpreter.registertopLevelFunction(
      'mp4UploadExtractor',
      (visitor, positionalArgs, namedArgs, _) => MBridge.mp4UploadExtractor(
        positionalArgs[0] as String,
        positionalArgs[1] as String?,
        positionalArgs[2] as String,
        positionalArgs[3] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'streamWishExtractor',
      (visitor, positionalArgs, namedArgs, _) => MBridge.streamWishExtractor(
        positionalArgs[0] as String,
        positionalArgs[1] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'filemoonExtractor',
      (visitor, positionalArgs, namedArgs, _) => MBridge.filemoonExtractor(
        positionalArgs[0] as String,
        positionalArgs[1] as String,
        positionalArgs[2] as String,
      ),
    );
    interpreter.registertopLevelFunction(
      'unpackJs',
      (visitor, positionalArgs, namedArgs, _) =>
          MBridge.unpackJs(positionalArgs[0] as String),
    );
    interpreter.registertopLevelFunction(
      'unpackJsAndCombine',
      (visitor, positionalArgs, namedArgs, _) =>
          MBridge.unpackJsAndCombine(positionalArgs[0] as String),
    );
    interpreter.registertopLevelFunction(
      'evalJs',
      (visitor, positionalArgs, namedArgs, _) =>
          getJavascriptRuntime().evaluateAsync(positionalArgs[0] as String),
    );
    interpreter.registertopLevelFunction(
      'evalJsSync',
      (visitor, positionalArgs, namedArgs, _) =>
          getJavascriptRuntime().evaluate(positionalArgs[0] as String),
    );
    interpreter.registertopLevelFunction(
      'regExp',
      (visitor, positionalArgs, namedArgs, _) => MBridge.regExp(
        positionalArgs[0] as String,
        positionalArgs[1] as String,
        positionalArgs[2] as String,
        positionalArgs[3] as int,
        positionalArgs[4] as int,
      ),
    );
    interpreter.registertopLevelFunction(
      'sortMapList',
      (visitor, positionalArgs, namedArgs, _) => MBridge.sortMapList(
        positionalArgs[0] as List,
        positionalArgs[1] as String,
        positionalArgs[2] as int,
      ),
    );
    interpreter.registertopLevelFunction(
      'parseHtml',
      (visitor, positionalArgs, namedArgs, _) =>
          MBridge.parsHtml(positionalArgs[0] as String),
    );
    interpreter.registertopLevelFunction(
      'getUrlWithoutDomain',
      (visitor, positionalArgs, namedArgs, _) =>
          (positionalArgs[0] as String).getUrlWithoutDomain,
    );
    interpreter.registertopLevelFunction(
      'evaluateJavascriptViaWebview',
      (visitor, positionalArgs, namedArgs, _) =>
          MBridge.evaluateJavascriptViaWebview(
            positionalArgs[0] as String,
            (positionalArgs[1] as Map).cast(),
            (positionalArgs[2] as List).cast(),
            time: namedArgs.get<int?>('time') ?? 30,
          ),
    );
  }
}
