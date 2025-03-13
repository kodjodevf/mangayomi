//
//  Generated code. Do not modify.
//  source: BackupAnime.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use backupAnimeDescriptor instead')
const BackupAnime$json = {
  '1': 'BackupAnime',
  '2': [
    {'1': 'source', '3': 1, '4': 1, '5': 5, '10': 'source'},
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'artist', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'artist', '17': true},
    {'1': 'author', '3': 5, '4': 1, '5': 9, '9': 1, '10': 'author', '17': true},
    {'1': 'description', '3': 6, '4': 1, '5': 9, '9': 2, '10': 'description', '17': true},
    {'1': 'genre', '3': 7, '4': 3, '5': 9, '10': 'genre'},
    {'1': 'status', '3': 8, '4': 1, '5': 5, '10': 'status'},
    {'1': 'thumbnailUrl', '3': 9, '4': 1, '5': 9, '9': 3, '10': 'thumbnailUrl', '17': true},
    {'1': 'dateAdded', '3': 13, '4': 1, '5': 5, '10': 'dateAdded'},
    {'1': 'episodes', '3': 16, '4': 3, '5': 11, '6': '.BackupEpisode', '10': 'episodes'},
    {'1': 'categories', '3': 17, '4': 3, '5': 5, '10': 'categories'},
    {'1': 'viewer_flags', '3': 103, '4': 1, '5': 5, '9': 4, '10': 'viewerFlags', '17': true},
    {'1': 'history', '3': 104, '4': 3, '5': 11, '6': '.BackupHistory', '10': 'history'},
    {'1': 'lastModifiedAt', '3': 106, '4': 1, '5': 5, '9': 5, '10': 'lastModifiedAt', '17': true},
  ],
  '8': [
    {'1': '_artist'},
    {'1': '_author'},
    {'1': '_description'},
    {'1': '_thumbnailUrl'},
    {'1': '_viewer_flags'},
    {'1': '_lastModifiedAt'},
  ],
};

/// Descriptor for `BackupAnime`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupAnimeDescriptor = $convert.base64Decode(
    'CgtCYWNrdXBBbmltZRIWCgZzb3VyY2UYASABKAVSBnNvdXJjZRIQCgN1cmwYAiABKAlSA3VybB'
    'IUCgV0aXRsZRgDIAEoCVIFdGl0bGUSGwoGYXJ0aXN0GAQgASgJSABSBmFydGlzdIgBARIbCgZh'
    'dXRob3IYBSABKAlIAVIGYXV0aG9yiAEBEiUKC2Rlc2NyaXB0aW9uGAYgASgJSAJSC2Rlc2NyaX'
    'B0aW9uiAEBEhQKBWdlbnJlGAcgAygJUgVnZW5yZRIWCgZzdGF0dXMYCCABKAVSBnN0YXR1cxIn'
    'Cgx0aHVtYm5haWxVcmwYCSABKAlIA1IMdGh1bWJuYWlsVXJsiAEBEhwKCWRhdGVBZGRlZBgNIA'
    'EoBVIJZGF0ZUFkZGVkEioKCGVwaXNvZGVzGBAgAygLMg4uQmFja3VwRXBpc29kZVIIZXBpc29k'
    'ZXMSHgoKY2F0ZWdvcmllcxgRIAMoBVIKY2F0ZWdvcmllcxImCgx2aWV3ZXJfZmxhZ3MYZyABKA'
    'VIBFILdmlld2VyRmxhZ3OIAQESKAoHaGlzdG9yeRhoIAMoCzIOLkJhY2t1cEhpc3RvcnlSB2hp'
    'c3RvcnkSKwoObGFzdE1vZGlmaWVkQXQYaiABKAVIBVIObGFzdE1vZGlmaWVkQXSIAQFCCQoHX2'
    'FydGlzdEIJCgdfYXV0aG9yQg4KDF9kZXNjcmlwdGlvbkIPCg1fdGh1bWJuYWlsVXJsQg8KDV92'
    'aWV3ZXJfZmxhZ3NCEQoPX2xhc3RNb2RpZmllZEF0');

