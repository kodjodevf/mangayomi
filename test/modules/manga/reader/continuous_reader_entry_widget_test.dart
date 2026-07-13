import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/image_view_vertical_continuous.dart';
import 'package:mangayomi/modules/manga/reader/image_view_webtoon.dart';
import 'package:photo_view/photo_view.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

void main() {
  test('Vertical Continuous injects Vertical layout policy', () {
    final photoController = PhotoViewController();
    final scaleController = PhotoViewScaleStateController();
    final scrolling = ValueNotifier(false);
    addTearDown(photoController.dispose);
    addTearDown(scaleController.dispose);
    addTearDown(scrolling.dispose);

    final reader = ImageViewVerticalContinuous(
      pages: const [],
      itemScrollController: ItemScrollController(),
      scrollOffsetController: ScrollOffsetController(),
      itemPositionsListener: ItemPositionsListener.create(),
      minCacheExtent: 800,
      initialScrollIndex: 0,
      physics: const ClampingScrollPhysics(),
      onLongPressData: (_) {},
      onFailedToLoadImage: (_) {},
      backgroundColor: BackgroundColor.black,
      isDoublePageMode: false,
      photoViewController: photoController,
      photoViewScaleStateController: scaleController,
      scalePosition: Alignment.center,
      onScaleEnd: (_) {},
      onDoubleTapDown: (_) {},
      onDoubleTap: () {},
      isScrolling: scrolling,
      scaleType: ScaleType.fitWidth,
      showPageGaps: true,
    );

    expect(reader.scrollDirection, Axis.vertical);
    expect(reader.layoutPolicy.fillAvailableWidth, isTrue);
    expect(reader.layoutPolicy.sidePaddingPercent, 0);
    expect(reader.layoutPolicy.showPageGaps, isTrue);
  });

  test('Webtoon injects Webtoon-only padding and gap policy', () {
    final photoController = PhotoViewController();
    final scaleController = PhotoViewScaleStateController();
    final scrolling = ValueNotifier(false);
    addTearDown(photoController.dispose);
    addTearDown(scaleController.dispose);
    addTearDown(scrolling.dispose);

    final reader = ImageViewWebtoon(
      pages: const [],
      itemScrollController: ItemScrollController(),
      scrollOffsetController: ScrollOffsetController(),
      itemPositionsListener: ItemPositionsListener.create(),
      minCacheExtent: 800,
      initialScrollIndex: 0,
      physics: const ClampingScrollPhysics(),
      onLongPressData: (_) {},
      onFailedToLoadImage: (_) {},
      backgroundColor: BackgroundColor.black,
      isDoublePageMode: false,
      photoViewController: photoController,
      photoViewScaleStateController: scaleController,
      scalePosition: Alignment.center,
      onScaleEnd: (_) {},
      onDoubleTapDown: (_) {},
      onDoubleTap: () {},
      isScrolling: scrolling,
      webtoonSidePadding: 16,
    );

    expect(reader.scrollDirection, Axis.vertical);
    expect(reader.layoutPolicy.fillAvailableWidth, isFalse);
    expect(reader.layoutPolicy.sidePaddingPercent, 16);
    expect(reader.layoutPolicy.showPageGaps, isFalse);
  });
}
