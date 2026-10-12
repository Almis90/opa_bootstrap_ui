import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  // The patterns are what Bootstrap's own `.progress-bar-striped.
  // progress-bar-animated` paints (read from the page, with its animation
  // paused at 0 and 250ms): 45deg stripes leaning `\`, 8px wide on a 16px
  // pitch, sliding left 16px a second.
  testWidgets('stripes lean, repeat and slide like Bootstrap\'s', (
    tester,
  ) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      BsApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: RepaintBoundary(
            key: key,
            child: const SizedBox(
              width: 80,
              child: BsProgress(value: 100, animated: true),
            ),
          ),
        ),
      ),
    );

    // Where the stripes start along a row (past the first pixels, where the
    // bar's rounded clip blends the edge).
    Future<List<int>> starts(int y) async {
      return (await tester.runAsync(() async {
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final image = await boundary.toImage();
        final data = (await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        ))!;
        int lum(int x) =>
            data.getUint8((y * image.width + x) * 4) +
            data.getUint8((y * image.width + x) * 4 + 1);
        var min = 9999;
        for (var x = 4; x < 48; x++) {
          if (lum(x) < min) min = lum(x);
        }
        // (a stripe adds about 58: half-covered edge pixels add less)
        bool bright(int x) => lum(x) > min + 40;
        return [
          for (var x = 4; x < 48; x++)
            if (bright(x) && !bright(x - 1)) x,
        ];
      }))!;
    }

    // t = 0 (the first frame of the animation): the stripe's left edge on row y
    // is at x = y (+ a multiple of the 16px tile), so it leans `\`.
    await tester.pump(const Duration(milliseconds: 1));
    // (the edge is at x = y + .5 in pixel-row y, so the first fully lit pixel is y + 1)
    expect(await starts(4), [5, 21, 37]);
    expect(await starts(8), [9, 25, 41]);
    expect(await starts(12), [13, 29, 45]);

    // A quarter of a second on: 4px to the left.
    await tester.pump(const Duration(milliseconds: 250));
    expect(await starts(8), [5, 21, 37]);

    // Half a second: 8px.
    await tester.pump(const Duration(milliseconds: 250));
    expect(await starts(8), [17, 33]);
  });

  testWidgets(
    'in a right-to-left page the stripes are mirrored but still slide left',
    (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.rtl,
          child: BsApp(
            home: Align(
              alignment: Alignment.topLeft,
              child: RepaintBoundary(
                key: key,
                child: const SizedBox(
                  width: 80,
                  child: BsProgress(value: 100, animated: true),
                ),
              ),
            ),
          ),
        ),
      );
      Future<List<int>> starts(int y) async {
        return (await tester.runAsync(() async {
          final boundary =
              key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          final image = await boundary.toImage();
          final data = (await image.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          ))!;
          int lum(int x) =>
              data.getUint8((y * image.width + x) * 4) +
              data.getUint8((y * image.width + x) * 4 + 1);
          var min = 9999;
          for (var x = 4; x < 48; x++) {
            if (lum(x) < min) min = lum(x);
          }
          bool bright(int x) => lum(x) > min + 40;
          return [
            for (var x = 4; x < 48; x++)
              if (bright(x) && !bright(x - 1)) x,
          ];
        }))!;
      }

      await tester.pump(const Duration(milliseconds: 1));
      // Left edge at x = 8 - y: it moves left as the row goes down (a `/`).
      final top = await starts(4);
      final bottom = await starts(12);
      expect(
        top.first - bottom.first,
        anyOf(8, -8),
        reason: 'the rows are 8px apart, so the edges differ by 8 (mod 16)',
      );
      final before = await starts(8);
      await tester.pump(const Duration(milliseconds: 250));
      final after = await starts(8);
      // 4px to the left (mod the 16px pitch).
      expect((before.first - after.first) % 16, 4);
    },
  );
}
