/// This file is a part of media_kit (https://github.com/media-kit/media-kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.

import 'package:test/test.dart';

import 'package:media_kit/src/player/native/core/native_library.dart';

void main() {
  test(
    'native-library-ensure-initialized',
    () {
      expect(
        NativeLibrary.ensureInitialized,
        returnsNormally,
      );
    },
  );
  test(
    'native-library-path',
    () {
      expect(
        () {
          final library = NativeLibrary.path;
          print(library);
        },
        returnsNormally,
      );
    },
  );
}
