library localstore;

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:math';

import 'utils/html.dart' if (dart.library.io) 'utils/io.dart';

part 'collection_ref.dart';
part 'collection_ref_impl.dart';
part 'document_ref.dart';
part 'document_ref_impl.dart';
part 'set_option.dart';
part 'localstore_base.dart';
part 'localstore_impl.dart';
