import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/services/http/m_client.dart';

enum CloudDriveType {
  quark,
  uc,
}

class QuarkUcExtractor {
  late CloudDriveType cloudDriveType;
  String apiUrl = ""; //"https://drive-pc.quark.cn/1/clouddrive/";
  String cookie = "";
  Map<String, dynamic> shareTokenCache = {};
  String pr = ""; //"pr=ucpro&fr=pc";
  final List<String> subtitleExts = ['.srt', '.ass', '.scc', '.stl', '.ttml'];
  Map<String, String> saveFileIdCaches = {};
  String? saveDirId;
  final String saveDirName = 'TV';

  Future<void> initCloudDrive(
      String cookie, CloudDriveType cloudDriveType) async {
    this.cookie = cookie;
    this.cloudDriveType = cloudDriveType;
    if (cloudDriveType == CloudDriveType.quark) {
      apiUrl = "https://drive-pc.quark.cn/1/clouddrive/";
      pr = "pr=ucpro&fr=pc";
    } else {
      apiUrl = "https://pc-api.uc.cn/1/clouddrive/";
      pr = "pr=UCBrowser&fr=pc";
    }
  }

  Map<String, String> getHeaders() {
    if (cloudDriveType == CloudDriveType.quark) {
      return {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) quark-cloud-drive/2.5.20 Chrome/100.0.4896.160 Electron/18.3.5.4-b478491100 Safari/537.36 Channel/pckk_other_ch',
        'Referer': 'https://pan.quark.cn/',
        "Content-Type": "application/json",
        "Cookie": cookie,
        "Host": "drive-pc.quark.cn"
      };
    } else {
      return {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) uc-cloud-drive/2.5.20 Chrome/100.0.4896.160 Electron/18.3.5.4-b478491100 Safari/537.36 Channel/pckk_other_ch',
        'Referer': 'https://drive.uc.cn/',
        "Content-Type": "application/json",
        "Cookie": cookie,
        "Host": "pc-api.uc.cn"
      };
    }
  }

  Future<Map<String, dynamic>> api(
      String url, dynamic data, String method) async {
    InterceptedClient client =
        MClient.init(reqcopyWith: {'useDartHttpClient': true});
    late Response resp;
    if (method != "get") {
      resp = await client.post(Uri.parse(apiUrl + url),
          body: jsonEncode(data), headers: getHeaders());
    } else {
      resp = await client.get(Uri.parse(apiUrl + url), headers: getHeaders());
    }
    if (resp.headers['set-cookie'] != null) {
      final puus = resp.headers['set-cookie']!
          .split(';;;')
          .join()
          .split(';')
          .firstWhere((element) => element.startsWith('__puus='),
              orElse: () => '');
      if (puus.isNotEmpty) {
        final newPuus = puus.split('=')[1];
        if (cookie.contains('__puus=')) {
          cookie =
              cookie.replaceFirst(RegExp(r'__puus=[^;]+'), '__puus=$newPuus');
        }
      }
    }
    return jsonDecode(resp.body);
  }

  Map<String, String>? getShareData(String url) {
    RegExp regex;
    if (cloudDriveType == CloudDriveType.quark) {
      regex = RegExp(r'https://pan\.quark\.cn/s/([^\\|#/]+)');
    } else {
      regex = RegExp(r'https://drive\.uc\.cn/s/([^?]+)');
    }
    final matches = regex.firstMatch(url);
    if (matches != null) {
      return {
        'shareId': matches.group(1)!,
        'folderId': '0',
      };
    }
    return null;
  }

  List<String> getPlayFormtList() {
    return ["high", "normal", "low", "super", "2k", "4k", "原画"];
  }

  Future<void> getShareToken(Map<String, String> shareData) async {
    if (!shareTokenCache.containsKey(shareData['shareId'])) {
      shareTokenCache.remove(shareData['shareId']);
      final shareToken = await api(
          'share/sharepage/token?$pr',
          {
            'pwd_id': shareData['shareId'],
            'passcode': shareData['sharePwd'] ?? '',
          },
          'post');
      if (shareToken['data'] != null && shareToken['data']['stoken'] != null) {
        shareTokenCache[shareData['shareId']!] = shareToken['data'];
      }
    }
  }

  Future<List<dynamic>> listFile(
      int shareIndex,
      Map<String, String> shareData,
      List<dynamic> videos,
      List<dynamic> subtitles,
      String shareId,
      String folderId,
      {int page = 1}) async {
    const int prePage = 200;
    final listData = await api(
        'share/sharepage/detail?$pr&pwd_id=$shareId&stoken=${Uri.encodeComponent(shareTokenCache[shareId]['stoken'])}&pdir_fid=$folderId&force=0&_page=$page&_size=$prePage&_sort=file_type:asc,file_name:desc',
        null,
        'get');
    if (listData['data'] == null) return [];
    final items = listData['data']['list'];
    if (items == null) return [];
    final subDir = [];
    for (final item in items) {
      if (item['dir'] == true) {
        subDir.add(item);
      } else if (item['file'] == true && item['obj_category'] == 'video') {
        if (item['size'] < 1024 * 1024 * 5) continue;
        item['stoken'] = shareTokenCache[shareData['shareId']]['stoken'];
        videos.add(Item.objectFrom(
            item, shareData['shareId']!, shareIndex, cloudDriveType));
      } else if (item['type'] == 'file' &&
          subtitleExts.any((x) => item['file_name'].endsWith(x))) {
        subtitles.add(Item.objectFrom(
            item, shareData['shareId']!, shareIndex, cloudDriveType));
      }
    }
    if (page < (listData['metadata']['_total'] / prePage).ceil()) {
      final nextItems = await listFile(
          shareIndex, shareData, videos, subtitles, shareId, folderId,
          page: page + 1);
      items.addAll(nextItems);
    }
    for (final dir in subDir) {
      final subItems = await listFile(
          shareIndex, shareData, videos, subtitles, shareId, dir['fid']);
      items.addAll(subItems);
    }
    return items;
  }

  Map<String, dynamic> findBestLCS(Item mainItem, List<Item> targetItems) {
    final results = [];
    var bestMatchIndex = 0;
    for (var i = 0; i < targetItems.length; i++) {
      final currentLCS = lcs(mainItem.name, targetItems[i].name);
      results.add({'target': targetItems[i], 'lcs': currentLCS});
      if (currentLCS['length'] > results[bestMatchIndex]['lcs']['length']) {
        bestMatchIndex = i;
      }
    }
    final bestMatch = results[bestMatchIndex];
    return {
      'allLCS': results,
      'bestMatch': bestMatch,
      'bestMatchIndex': bestMatchIndex
    };
  }

  Future<void> getFilesByShareUrl(int shareIndex, dynamic shareInfo,
      List<dynamic> videos, List<dynamic> subtitles) async {
    final shareData = shareInfo is String ? getShareData(shareInfo) : shareInfo;
    if (shareData == null) return;
    await getShareToken(shareData);
    if (!shareTokenCache.containsKey(shareData['shareId'])) return;
    await listFile(shareIndex, shareData, videos, subtitles,
        shareData['shareId']!, shareData['folderId']!);
    if (subtitles.isNotEmpty) {
      for (var item in videos) {
        var matchSubtitle = findBestLCS(item, subtitles as List<Item>);
        if (matchSubtitle['bestMatch'] != null) {
          item.subtitle = matchSubtitle['bestMatch']['target'];
        }
      }
    }
  }

  void clean() {
    saveFileIdCaches.clear();
  }

  Future<void> clearSaveDir() async {
    final listData = await api(
        'file/sort?$pr&pdir_fid=$saveDirId&_page=1&_size=200&_sort=file_type:asc,updated_at:desc',
        {},
        'get');
    if (listData['data'] != null &&
        listData['data']['list'] != null &&
        listData['data']['list'].isNotEmpty) {
      await api(
          'file/delete?$pr',
          {
            'action_type': 2,
            'filelist': listData['data']['list'].map((v) => v['fid']).toList(),
            'exclude_fids': [],
          },
          'post');
    }
  }

  Future<void> createSaveDir(bool clean) async {
    if (saveDirId != null) {
      if (clean) await clearSaveDir();
      return;
    }
    final listData = await api(
        'file/sort?$pr&pdir_fid=0&_page=1&_size=200&_sort=file_type:asc,updated_at:desc',
        {},
        'get');
    if (listData['data'] != null && listData['data']['list'] != null) {
      for (final item in listData['data']['list']) {
        if (item['file_name'] == saveDirName) {
          saveDirId = item['fid'];
          await clearSaveDir();
          break;
        }
      }
    }
    if (saveDirId == null) {
      final create = await api(
          'file?$pr',
          {
            'pdir_fid': '0',
            'file_name': saveDirName,
            'dir_path': '',
            'dir_init_lock': false,
          },
          'post');
      if (create['data'] != null && create['data']['fid'] != null) {
        saveDirId = create['data']['fid'];
      }
    }
  }

  Future<String?> save(String shareId, String stoken, String fileId,
      String fileToken, bool clean) async {
    await createSaveDir(clean);
    if (clean) {
      this.clean();
    }
    if (saveDirId == null) return null;
    if (stoken.isEmpty) {
      await getShareToken({'shareId': shareId});
      if (!shareTokenCache.containsKey(shareId)) return null;
    }
    final saveResult = await api(
        'share/sharepage/save?$pr',
        {
          'fid_list': [fileId],
          'fid_token_list': [fileToken],
          'to_pdir_fid': saveDirId,
          'pwd_id': shareId,
          'stoken':
              stoken.isNotEmpty ? stoken : shareTokenCache[shareId]['stoken'],
          'pdir_fid': '0',
          'scene': 'link',
        },
        'post');
    if (saveResult['data'] != null && saveResult['data']['task_id'] != null) {
      var retry = 0;
      while (true) {
        final taskResult = await api(
            'task?$pr&task_id=${saveResult['data']['task_id']}&retry_index=$retry',
            {},
            'get');
        if (taskResult['data'] != null &&
            taskResult['data']['save_as'] != null &&
            taskResult['data']['save_as']['save_as_top_fids'] != null &&
            taskResult['data']['save_as']['save_as_top_fids'].isNotEmpty) {
          return taskResult['data']['save_as']['save_as_top_fids'][0];
        }
        retry++;
        if (retry > 2) break;
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    return null;
  }

  Future<String?> getLiveTranscoding(String shareId, String stoken,
      String fileId, String fileToken, String quality) async {
    if (!saveFileIdCaches.containsKey(fileId)) {
      final saveFileId = await save(shareId, stoken, fileId, fileToken, true);
      if (saveFileId == null) return null;
      saveFileIdCaches[fileId] = saveFileId;
    }
    final transcoding = await api(
        'file/v2/play?$pr',
        {
          'fid': saveFileIdCaches[fileId],
          'resolutions': 'normal,low,high,super,2k,4k',
          'supports': 'fmp4',
        },
        'post');
    if (transcoding['data'] != null &&
        transcoding['data']['video_list'] != null) {
      for (final video in transcoding['data']['video_list']) {
        if (video['resolution'] == quality) {
          return video['video_info']['url'];
        }
      }
      // 如果没有找到匹配的质量,返回null
      return null;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getDownload(String shareId, String stoken,
      String fileId, String fileToken, bool clean) async {
    if (!saveFileIdCaches.containsKey(fileId)) {
      final saveFileId = await save(shareId, stoken, fileId, fileToken, clean);
      if (saveFileId == null) return null;
      saveFileIdCaches[fileId] = saveFileId;
    }
    final down = await api(
        'file/download?$pr&uc_param_str=',
        {
          'fids': [saveFileIdCaches[fileId]],
        },
        'post');
    if (down['data'] != null) {
      return down['data'][0];
    }
    return null;
  }

  Future<List<Map<String, String>>> videoFilesFromUrl(List<String> shareUrlList,
      {String typeName = "电影"}) async {
    List<dynamic> videoItems = [];
    List<dynamic> subItems = [];

    for (int i = 0; i < shareUrlList.length; i++) {
      String shareUrl = shareUrlList[i];
      await getFilesByShareUrl(i + 1, shareUrl, videoItems, subItems);
    }

    // if (videoItems.isNotEmpty) {
    //   print('获取播放链接成功,分享链接为:${shareUrlList.join("\t")}');
    // } else {
    //   print('获取播放链接失败,检查分享链接为:${shareUrlList.join("\t")}');
    // }

    return await getVodFile(videoItems, subItems, typeName);
  }

  Future<List<Map<String, String>>> getVodFile(List<dynamic> videoItemList,
      List<dynamic> subItemList, String typeName) async {
    if (videoItemList.isEmpty) {
      return [];
    }
    List<Map<String, String>> vodItems = [];
    for (var videoItem in videoItemList) {
      String episodeUrl = videoItem.getEpisodeUrl(typeName);
      String subtitles = findSubs(videoItem.getName(), subItemList);
      String fullUrl = episodeUrl + subtitles;
      List<String> parts = fullUrl.split('\$');
      String name = parts[0].trim();
      String url = parts[1];
      vodItems.add({"name": name, "url": url});
    }
    // print(vodItems);
    return vodItems;
  }

  Future<List<Video>> videosFromUrl(String url) async {
    List<String> parts = url.split('++');
    String fileId = parts[1];
    String fileToken = parts[2];
    String shareId = parts[3];
    String stoken = parts[4];
    String type = parts[0];
    List<String> subtitleParts = parts.length > 5 ? parts[5].split('+') : [];
// 获取可用的质量列表
    List<String> qualities = getPlayFormtList();
    List<Video> videos = [];
    if (type == "uc") {
      var headers = getHeaders();
      headers.remove('Host');
      headers.remove('Content-Type');
      String? url = (await getDownload(
          shareId, stoken, fileId, fileToken, true))?['download_url'];
      if (url != null) {
        videos.add(Video(url, "原画", url, headers: headers));
      }
    } else {
      // 原画起播慢，所以先获取high/low
      String? originalUrl = (await getLiveTranscoding(
              shareId, stoken, fileId, fileToken, 'high')) ??
          (await getLiveTranscoding(shareId, stoken, fileId, fileToken, 'low'));

      for (String quality in qualities) {
        if (quality == "原画") {
          String? url = (await getDownload(
              shareId, stoken, fileId, fileToken, true))?['download_url'];
          if (url != null) {
            var headers = getHeaders();
            headers.remove('Host');
            headers.remove('Content-Type');
            videos
                .add(Video(url, quality, originalUrl ?? '', headers: headers));
          }
        } else {
          String? url = await getLiveTranscoding(
              shareId, stoken, fileId, fileToken, quality);
          if (url != null) {
            var headers = getHeaders();
            headers.remove('Host');
            videos.add(Video(
              url,
              quality,
              originalUrl ?? '',
              headers: headers,
            ));
          }
        }
      }
    }

    // 处理字幕
    List<Track> subtitles = [];
    for (String subtitleInfo in subtitleParts) {
      if (subtitleInfo.isNotEmpty) {
        List<String> subParts = subtitleInfo.split('@@@');
        if (subParts.length == 3) {
          String subName = subParts[0];
          String subFileId = subParts[2];
          var subDownload =
              await getDownload(shareId, stoken, subFileId, '', true);
          String? subUrl = subDownload?['download_url'];
          if (subUrl != null) {
            subtitles.add(Track(file: subUrl, label: subName));
          }
        }
      }
    }

    // 为所有视频添加字幕
    for (var video in videos) {
      video.subtitles = subtitles;
    }
    return videos;
  }

  String findSubs(String name, List<dynamic> itemList) {
    List<dynamic> subItemList = [];
    pair(removeExt(name).toLowerCase(), itemList, subItemList);
    if (subItemList.isEmpty) {
      subItemList.addAll(itemList);
    }
    String subStr = "";
    for (var item in subItemList) {
      subStr +=
          "+${removeExt(item.getName())}@@@${item.getFileExtension()}@@@${item.getFileId()}";
    }
    return subStr;
  }

  void pair(String name, List<dynamic> itemList, List<dynamic> subItemList) {
    for (var item in itemList) {
      final subName = removeExt(item.getName()).toLowerCase();
      if (name.contains(subName) || subName.contains(name)) {
        subItemList.add(item);
      }
    }
  }

  String removeExt(String text) {
    return text.contains('.') ? text.substring(0, text.lastIndexOf(".")) : text;
  }

  Map<String, dynamic> lcs(String str1, String str2) {
    if (str1.isEmpty || str2.isEmpty) {
      return {
        'length': 0,
        'sequence': '',
        'offset': 0,
      };
    }
    var sequence = '';
    var str1Length = str1.length;
    var str2Length = str2.length;
    var num = List.generate(str1Length, (_) => List<int>.filled(str2Length, 0));
    var maxlen = 0;
    var lastSubsBegin = 0;
    var thisSubsBegin = 0;
    for (var i = 0; i < str1Length; i++) {
      for (var j = 0; j < str2Length; j++) {
        if (str1[i] != str2[j]) {
          num[i][j] = 0;
        } else {
          if (i == 0 || j == 0) {
            num[i][j] = 1;
          } else {
            num[i][j] = 1 + num[i - 1][j - 1];
          }
          if (num[i][j] > maxlen) {
            maxlen = num[i][j];
            thisSubsBegin = i - num[i][j] + 1;
            if (lastSubsBegin == thisSubsBegin) {
              sequence += str1[i];
            } else {
              lastSubsBegin = thisSubsBegin;
              sequence = str1.substring(lastSubsBegin, i + 1);
            }
          }
        }
      }
    }
    return {
      'length': maxlen,
      'sequence': sequence,
      'offset': thisSubsBegin,
    };
  }
}

class Item {
  String fileId = "";
  String shareId = "";
  String shareToken = "";
  String shareFileToken = "";
  String seriesId = "";
  String name = "";
  String type = "";
  String formatType = "";
  String size = "";
  String parent = "";
  dynamic shareData;
  int shareIndex = 0;
  int lastUpdateAt = 0;
  dynamic subtitle;
  late CloudDriveType cloudDriveType;

  static Item objectFrom(Map<String, dynamic> itemJson, String shareId,
      int shareIndex, CloudDriveType cloudDriveType) {
    Item item = Item();
    item.fileId = itemJson['fid'] ?? "";
    item.shareId = shareId;
    item.shareToken = itemJson['stoken'] ?? "";
    item.shareFileToken = itemJson['share_fid_token'] ?? "";
    item.seriesId = itemJson['series_id'] ?? "";
    item.name = itemJson['file_name'] ?? "";
    item.type = itemJson['obj_category'] ?? "";
    item.formatType = itemJson['format_type'] ?? "";
    item.size = (itemJson['size'] ?? 0).toString();
    item.parent = itemJson['pdir_fid'] ?? "";
    item.lastUpdateAt = itemJson['last_update_at'] ?? 0;
    item.shareIndex = shareIndex;
    item.cloudDriveType = cloudDriveType;
    return item;
  }

  String getFileExtension() {
    return name.split(".").last;
  }

  String getFileId() {
    return fileId;
  }

  String getName() {
    return name;
  }

  String getParent() {
    return "[$parent]";
  }

  String getSize() {
    return size == "0" ? "" : "[${getHumanReadableSize(int.parse(size))}]";
  }

  int getShareIndex() {
    return shareIndex;
  }

  String getDisplayName(String typeName) {
    String drivePrefix =
        cloudDriveType == CloudDriveType.quark ? '[quark]' : '[uc]';
    String displayName = getName();
    if (typeName == "电视剧") {
      List<String> replaceNameList = ["4k", "4K"];
      displayName = displayName.replaceAll(".$getFileExtension()", "");
      displayName = displayName.replaceAll(" ", "").replaceAll(" ", "");
      for (String replaceName in replaceNameList) {
        displayName = displayName.replaceAll(replaceName, "");
      }
      displayName =
          RegExp(r'\.S01E(.*?)\.').firstMatch(displayName)?.group(1) ??
              displayName;
      final numbers = RegExp(r'\d+')
          .allMatches(displayName)
          .map((m) => m.group(0))
          .toList();
      if (numbers.isNotEmpty) {
        displayName = numbers[0]!;
      }
    }
    return "$drivePrefix $displayName ${getSize()}";
  }

  String getEpisodeUrl(String typeName) {
    return "${getDisplayName(typeName)}\$${cloudDriveType == CloudDriveType.quark ? "quark" : "uc"}++${getFileId()}++$shareFileToken++$shareId++$shareToken";
  }

  String getHumanReadableSize(int bytes) {
    if (bytes <= 0) return "";
    final units = ['B', 'KB', 'MB', 'GB', 'TB'];
    int digitGroups = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, digitGroups)).toStringAsFixed(2)} ${units[digitGroups]}';
  }
}
