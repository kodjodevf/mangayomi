// This is a generated file - do not edit.
//
// Generated from BackupEpisode.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use backupEpisodeDescriptor instead')
const BackupEpisode$json = {
  '1': 'BackupEpisode',
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
    {'1': 'seen', '3': 4, '4': 1, '5': 8, '10': 'seen'},
    {'1': 'bookmark', '3': 5, '4': 1, '5': 8, '10': 'bookmark'},
    {'1': 'lastSecondSeen', '3': 6, '4': 1, '5': 3, '10': 'lastSecondSeen'},
    {'1': 'dateFetch', '3': 7, '4': 1, '5': 3, '10': 'dateFetch'},
    {'1': 'dateUpload', '3': 8, '4': 1, '5': 3, '10': 'dateUpload'},
    {'1': 'episodeNumber', '3': 9, '4': 1, '5': 2, '10': 'episodeNumber'},
    {'1': 'sourceOrder', '3': 10, '4': 1, '5': 3, '10': 'sourceOrder'},
    {'1': 'lastModifiedAt', '3': 11, '4': 1, '5': 3, '10': 'lastModifiedAt'},
    {'1': 'version', '3': 12, '4': 1, '5': 3, '10': 'version'},
    {'1': 'totalSeconds', '3': 16, '4': 1, '5': 3, '10': 'totalSeconds'},
    {'1': 'fillermark', '3': 501, '4': 1, '5': 8, '10': 'fillermark'},
    {
      '1': 'summary',
      '3': 502,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'summary',
      '17': true
    },
    {
      '1': 'previewUrl',
      '3': 503,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'previewUrl',
      '17': true
    },
  ],
  '8': [
    {'1': '_scanlator'},
    {'1': '_summary'},
    {'1': '_previewUrl'},
  ],
};

/// Descriptor for `BackupEpisode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupEpisodeDescriptor = $convert.base64Decode(
    'Cg1CYWNrdXBFcGlzb2RlEhAKA3VybBgBIAEoCVIDdXJsEhIKBG5hbWUYAiABKAlSBG5hbWUSIQ'
    'oJc2NhbmxhdG9yGAMgASgJSABSCXNjYW5sYXRvcogBARISCgRzZWVuGAQgASgIUgRzZWVuEhoK'
    'CGJvb2ttYXJrGAUgASgIUghib29rbWFyaxImCg5sYXN0U2Vjb25kU2VlbhgGIAEoA1IObGFzdF'
    'NlY29uZFNlZW4SHAoJZGF0ZUZldGNoGAcgASgDUglkYXRlRmV0Y2gSHgoKZGF0ZVVwbG9hZBgI'
    'IAEoA1IKZGF0ZVVwbG9hZBIkCg1lcGlzb2RlTnVtYmVyGAkgASgCUg1lcGlzb2RlTnVtYmVyEi'
    'AKC3NvdXJjZU9yZGVyGAogASgDUgtzb3VyY2VPcmRlchImCg5sYXN0TW9kaWZpZWRBdBgLIAEo'
    'A1IObGFzdE1vZGlmaWVkQXQSGAoHdmVyc2lvbhgMIAEoA1IHdmVyc2lvbhIiCgx0b3RhbFNlY2'
    '9uZHMYECABKANSDHRvdGFsU2Vjb25kcxIfCgpmaWxsZXJtYXJrGPUDIAEoCFIKZmlsbGVybWFy'
    'axIeCgdzdW1tYXJ5GPYDIAEoCUgBUgdzdW1tYXJ5iAEBEiQKCnByZXZpZXdVcmwY9wMgASgJSA'
    'JSCnByZXZpZXdVcmyIAQFCDAoKX3NjYW5sYXRvckIKCghfc3VtbWFyeUINCgtfcHJldmlld1Vy'
    'bA==');
