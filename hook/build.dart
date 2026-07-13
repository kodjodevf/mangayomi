import 'package:hooks/hooks.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';
import 'package:code_assets/code_assets.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final builder = CBuilder.library(
      name: 'subsampling_scale_image_view',
      assetName: 'subsampling_scale_image_view.dart',
      sources: ['lib/ffi/image_decoder.cpp'],
      includes: ['lib/ffi/'],
      flags: [
        if (input.config.code.targetOS == OS.iOS ||
            input.config.code.targetOS == OS.macOS) ...[
          '-framework',
          'CoreFoundation',
          '-framework',
          'CoreGraphics',
          '-framework',
          'ImageIO',
        ],
      ],
    );

    await builder.run(input: input, output: output);
  });
}
