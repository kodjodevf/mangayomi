// This is a generated file - do not edit.
//
// Generated from BackupManga.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use backupMangaDescriptor instead')
const BackupManga$json = {
  '1': 'BackupManga',
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
    {'1': 'viewer', '3': 14, '4': 1, '5': 5, '10': 'viewer'},
    {
      '1': 'chapters',
      '3': 16,
      '4': 3,
      '5': 11,
      '6': '.BackupChapter',
      '10': 'chapters'
    },
    {'1': 'categories', '3': 17, '4': 3, '5': 3, '10': 'categories'},
    {'1': 'favorite', '3': 100, '4': 1, '5': 8, '10': 'favorite'},
    {'1': 'chapterFlags', '3': 101, '4': 1, '5': 5, '10': 'chapterFlags'},
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
    {
      '1': 'excludedScanlators',
      '3': 108,
      '4': 3,
      '5': 9,
      '10': 'excludedScanlators'
    },
    {'1': 'version', '3': 109, '4': 1, '5': 3, '10': 'version'},
  ],
  '8': [
    {'1': '_artist'},
    {'1': '_author'},
    {'1': '_description'},
    {'1': '_thumbnailUrl'},
    {'1': '_viewer_flags'},
    {'1': '_favoriteModifiedAt'},
  ],
};

/// Descriptor for `BackupManga`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupMangaDescriptor = $convert.base64Decode(
    'CgtCYWNrdXBNYW5nYRIWCgZzb3VyY2UYASABKANSBnNvdXJjZRIQCgN1cmwYAiABKAlSA3VybB'
    'IUCgV0aXRsZRgDIAEoCVIFdGl0bGUSGwoGYXJ0aXN0GAQgASgJSABSBmFydGlzdIgBARIbCgZh'
    'dXRob3IYBSABKAlIAVIGYXV0aG9yiAEBEiUKC2Rlc2NyaXB0aW9uGAYgASgJSAJSC2Rlc2NyaX'
    'B0aW9uiAEBEhQKBWdlbnJlGAcgAygJUgVnZW5yZRIWCgZzdGF0dXMYCCABKAVSBnN0YXR1cxIn'
    'Cgx0aHVtYm5haWxVcmwYCSABKAlIA1IMdGh1bWJuYWlsVXJsiAEBEhwKCWRhdGVBZGRlZBgNIA'
    'EoA1IJZGF0ZUFkZGVkEhYKBnZpZXdlchgOIAEoBVIGdmlld2VyEioKCGNoYXB0ZXJzGBAgAygL'
    'Mg4uQmFja3VwQ2hhcHRlclIIY2hhcHRlcnMSHgoKY2F0ZWdvcmllcxgRIAMoA1IKY2F0ZWdvcm'
    'llcxIaCghmYXZvcml0ZRhkIAEoCFIIZmF2b3JpdGUSIgoMY2hhcHRlckZsYWdzGGUgASgFUgxj'
    'aGFwdGVyRmxhZ3MSJgoMdmlld2VyX2ZsYWdzGGcgASgFSARSC3ZpZXdlckZsYWdziAEBEigKB2'
    'hpc3RvcnkYaCADKAsyDi5CYWNrdXBIaXN0b3J5UgdoaXN0b3J5EiYKDnVwZGF0ZVN0cmF0ZWd5'
    'GGkgASgFUg51cGRhdGVTdHJhdGVneRImCg5sYXN0TW9kaWZpZWRBdBhqIAEoA1IObGFzdE1vZG'
    'lmaWVkQXQSMwoSZmF2b3JpdGVNb2RpZmllZEF0GGsgASgDSAVSEmZhdm9yaXRlTW9kaWZpZWRB'
    'dIgBARIuChJleGNsdWRlZFNjYW5sYXRvcnMYbCADKAlSEmV4Y2x1ZGVkU2NhbmxhdG9ycxIYCg'
    'd2ZXJzaW9uGG0gASgDUgd2ZXJzaW9uQgkKB19hcnRpc3RCCQoHX2F1dGhvckIOCgxfZGVzY3Jp'
    'cHRpb25CDwoNX3RodW1ibmFpbFVybEIPCg1fdmlld2VyX2ZsYWdzQhUKE19mYXZvcml0ZU1vZG'
    'lmaWVkQXQ=');
