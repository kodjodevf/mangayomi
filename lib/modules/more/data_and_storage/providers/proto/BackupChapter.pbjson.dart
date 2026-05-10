// This is a generated file - do not edit.
//
// Generated from BackupChapter.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use backupChapterDescriptor instead')
const BackupChapter$json = {
  '1': 'BackupChapter',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'scanlator',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'scanlator',
      '17': true
    },
    {'1': 'read', '3': 4, '4': 1, '5': 8, '10': 'read'},
    {'1': 'bookmark', '3': 5, '4': 1, '5': 8, '10': 'bookmark'},
    {'1': 'lastPageRead', '3': 6, '4': 1, '5': 3, '10': 'lastPageRead'},
    {'1': 'dateFetch', '3': 7, '4': 1, '5': 3, '10': 'dateFetch'},
    {'1': 'dateUpload', '3': 8, '4': 1, '5': 3, '10': 'dateUpload'},
    {'1': 'chapterNumber', '3': 9, '4': 1, '5': 2, '10': 'chapterNumber'},
    {'1': 'sourceOrder', '3': 10, '4': 1, '5': 3, '10': 'sourceOrder'},
    {'1': 'lastModifiedAt', '3': 11, '4': 1, '5': 3, '10': 'lastModifiedAt'},
    {'1': 'version', '3': 12, '4': 1, '5': 3, '10': 'version'},
  ],
  '8': [
    {'1': '_scanlator'},
  ],
};

/// Descriptor for `BackupChapter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupChapterDescriptor = $convert.base64Decode(
    'Cg1CYWNrdXBDaGFwdGVyEhAKA3VybBgBIAEoCVIDdXJsEhIKBG5hbWUYAiABKAlSBG5hbWUSIQ'
    'oJc2NhbmxhdG9yGAMgASgJSABSCXNjYW5sYXRvcogBARISCgRyZWFkGAQgASgIUgRyZWFkEhoK'
    'CGJvb2ttYXJrGAUgASgIUghib29rbWFyaxIiCgxsYXN0UGFnZVJlYWQYBiABKANSDGxhc3RQYW'
    'dlUmVhZBIcCglkYXRlRmV0Y2gYByABKANSCWRhdGVGZXRjaBIeCgpkYXRlVXBsb2FkGAggASgD'
    'UgpkYXRlVXBsb2FkEiQKDWNoYXB0ZXJOdW1iZXIYCSABKAJSDWNoYXB0ZXJOdW1iZXISIAoLc2'
    '91cmNlT3JkZXIYCiABKANSC3NvdXJjZU9yZGVyEiYKDmxhc3RNb2RpZmllZEF0GAsgASgDUg5s'
    'YXN0TW9kaWZpZWRBdBIYCgd2ZXJzaW9uGAwgASgDUgd2ZXJzaW9uQgwKCl9zY2FubGF0b3I=');
