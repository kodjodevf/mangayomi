import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';

/// The page the slider is on, shown above it while it is dragged: the page
/// only turns when the slider is let go, and a number alone does not say
/// whether that is the double spread or the chapter title.
class ReaderPagePreview extends StatelessWidget {
  const ReaderPagePreview({
    super.key,
    required this.image,
    required this.label,
  });

  /// Null while the page's image is not known yet; the label still shows.
  final ImageProvider? image;
  final String label;

  /// Decoded at this width only: a preview, not the page.
  static const double _width = 132;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    return IgnorePointer(
      child: Material(
        color: tokens.color.ink1,
        elevation: 8,
        shadowColor: ShioriScrim.shadow,
        borderRadius: BorderRadius.circular(ShioriShape.card),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(ShioriSpace.s8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: ShioriSpace.s8,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(ShioriShape.cover),
                child: SizedBox(
                  width: _width,
                  height: _width / coverAspect,
                  child: ColoredBox(
                    color: tokens.color.ink2,
                    child: image == null
                        ? null
                        : Image(
                            image: ResizeImage(
                              image!,
                              width:
                                  (_width *
                                          MediaQuery.devicePixelRatioOf(
                                            context,
                                          ))
                                      .round(),
                              policy: ResizeImagePolicy.fit,
                            ),
                            fit: BoxFit.contain,
                            gaplessPlayback: true,
                            errorBuilder: (_, _, _) => const Center(
                              child: Icon(Symbols.broken_image_rounded),
                            ),
                          ),
                  ),
                ),
              ),
              Text(
                label,
                style: tokens.text.row.copyWith(
                  color: tokens.color.fg,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
