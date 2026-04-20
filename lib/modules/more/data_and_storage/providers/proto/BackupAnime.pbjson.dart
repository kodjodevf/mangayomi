// This is a generated file - do not edit.
//
// Generated from BackupAnime.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use backupAnimeDescriptor instead')
const BackupAnime$json = {
  '1': 'BackupAnime',
  '2': [
    {'1': 'source', '3': 1, '4': 1, '5': 3, '10': 'source'},
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'artist', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'artist', '17': true},
    {'1': 'author', '3': 5, '4': 1, '5': 9, '9': 1, '10': 'author', '17': true},
    {
      '1': 'description',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'description',
      '17': true
    },
    {'1': 'genre', '3': 7, '4': 3, '5': 9, '10': 'genre'},
    {'1': 'status', '3': 8, '4': 1, '5': 5, '10': 'status'},
    {
      '1': 'thumbnailUrl',
      '3': 9,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'thumbnailUrl',
      '17': true
    },
    {'1': 'dateAdded', '3': 13, '4': 1, '5': 3, '10': 'dateAdded'},
    {
      '1': 'episodes',
      '3': 16,
      '4': 3,
      '5': 11,
      '6': '.BackupEpisode',
      '10': 'episodes'
    },
    {'1': 'categories', '3': 17, '4': 3, '5': 3, '10': 'categories'},
    {'1': 'favorite', '3': 100, '4': 1, '5': 8, '10': 'favorite'},
    {'1': 'episodeFlags', '3': 101, '4': 1, '5': 5, '10': 'episodeFlags'},
    {
      '1': 'viewer_flags',
      '3': 103,
      '4': 1,
      '5': 5,
      '9': 4,
      '10': 'viewerFlags',
      '17': true
    },
    {
      '1': 'history',
      '3': 104,
      '4': 3,
      '5': 11,
      '6': '.BackupHistory',
      '10': 'history'
    },
    {'1': 'updateStrategy', '3': 105, '4': 1, '5': 5, '10': 'updateStrategy'},
    {'1': 'lastModifiedAt', '3': 106, '4': 1, '5': 3, '10': 'lastModifiedAt'},
    {
      '1': 'favoriteModifiedAt',
      '3': 107,
      '4': 1,
      '5': 3,
      '9': 5,
      '10': 'favoriteModifiedAt',
      '17': true
    },
    {'1': 'version', '3': 109, '4': 1, '5': 3, '10': 'version'},
    {
      '1': 'backgroundUrl',
      '3': 500,
      '4': 1,
      '5': 9,
      '9': 6,
      '10': 'backgroundUrl',
      '17': true
    },
    {
      '1': 'parentId',
      '3': 502,
      '4': 1,
      '5': 3,
      '9': 7,
      '10': 'parentId',
      '17': true
    },
    {'1': 'id', '3': 503, '4': 1, '5': 3, '9': 8, '10': 'id', '17': true},
    {'1': 'seasonFlags', '3': 504, '4': 1, '5': 3, '10': 'seasonFlags'},
    {'1': 'seasonNumber', '3': 505, '4': 1, '5': 1, '10': 'seasonNumber'},
    {
      '1': 'seasonSourceOrder',
      '3': 506,
      '4': 1,
      '5': 3,
      '10': 'seasonSourceOrder'
    },
    {'1': 'fetchType', '3': 507, '4': 1, '5': 5, '10': 'fetchType'},
  ],
  '8': [
    {'1': '_artist'},
    {'1': '_author'},
    {'1': '_description'},
    {'1': '_thumbnailUrl'},
    {'1': '_viewer_flags'},
    {'1': '_favoriteModifiedAt'},
    {'1': '_backgroundUrl'},
    {'1': '_parentId'},
    {'1': '_id'},
  ],
};

/// Descriptor for `BackupAnime`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupAnimeDescriptor = $convert.base64Decode(
    'CgtCYWNrdXBBbmltZRIWCgZzb3VyY2UYASABKANSBnNvdXJjZRIQCgN1cmwYAiABKAlSA3VybB'
    'IUCgV0aXRsZRgDIAEoCVIFdGl0bGUSGwoGYXJ0aXN0GAQgASgJSABSBmFydGlzdIgBARIbCgZh'
    'dXRob3IYBSABKAlIAVIGYXV0aG9yiAEBEiUKC2Rlc2NyaXB0aW9uGAYgASgJSAJSC2Rlc2NyaX'
    'B0aW9uiAEBEhQKBWdlbnJlGAcgAygJUgVnZW5yZRIWCgZzdGF0dXMYCCABKAVSBnN0YXR1cxIn'
    'Cgx0aHVtYm5haWxVcmwYCSABKAlIA1IMdGh1bWJuYWlsVXJsiAEBEhwKCWRhdGVBZGRlZBgNIA'
    'EoA1IJZGF0ZUFkZGVkEioKCGVwaXNvZGVzGBAgAygLMg4uQmFja3VwRXBpc29kZVIIZXBpc29k'
    'ZXMSHgoKY2F0ZWdvcmllcxgRIAMoA1IKY2F0ZWdvcmllcxIaCghmYXZvcml0ZRhkIAEoCFIIZm'
    'F2b3JpdGUSIgoMZXBpc29kZUZsYWdzGGUgASgFUgxlcGlzb2RlRmxhZ3MSJgoMdmlld2VyX2Zs'
    'YWdzGGcgASgFSARSC3ZpZXdlckZsYWdziAEBEigKB2hpc3RvcnkYaCADKAsyDi5CYWNrdXBIaX'
    'N0b3J5UgdoaXN0b3J5EiYKDnVwZGF0ZVN0cmF0ZWd5GGkgASgFUg51cGRhdGVTdHJhdGVneRIm'
    'Cg5sYXN0TW9kaWZpZWRBdBhqIAEoA1IObGFzdE1vZGlmaWVkQXQSMwoSZmF2b3JpdGVNb2RpZm'
    'llZEF0GGsgASgDSAVSEmZhdm9yaXRlTW9kaWZpZWRBdIgBARIYCgd2ZXJzaW9uGG0gASgDUgd2'
    'ZXJzaW9uEioKDWJhY2tncm91bmRVcmwY9AMgASgJSAZSDWJhY2tncm91bmRVcmyIAQESIAoIcG'
    'FyZW50SWQY9gMgASgDSAdSCHBhcmVudElkiAEBEhQKAmlkGPcDIAEoA0gIUgJpZIgBARIhCgtz'
    'ZWFzb25GbGFncxj4AyABKANSC3NlYXNvbkZsYWdzEiMKDHNlYXNvbk51bWJlchj5AyABKAFSDH'
    'NlYXNvbk51bWJlchItChFzZWFzb25Tb3VyY2VPcmRlchj6AyABKANSEXNlYXNvblNvdXJjZU9y'
    'ZGVyEh0KCWZldGNoVHlwZRj7AyABKAVSCWZldGNoVHlwZUIJCgdfYXJ0aXN0QgkKB19hdXRob3'
    'JCDgoMX2Rlc2NyaXB0aW9uQg8KDV90aHVtYm5haWxVcmxCDwoNX3ZpZXdlcl9mbGFnc0IVChNf'
    'ZmF2b3JpdGVNb2RpZmllZEF0QhAKDl9iYWNrZ3JvdW5kVXJsQgsKCV9wYXJlbnRJZEIFCgNfaW'
    'Q=');
