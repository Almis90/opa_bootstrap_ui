import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  // Bootstrap's `.btn-close` glyph fills its 16px square (its path runs from 0 to 16),
  // and in a modal or offcanvas header the button's padding is half the header's with a
  // negative margin of the same size, so the glyph still sits at the header's padding edge.
  testWidgets('the glyph fills 16x16', (tester) async {
    tester.view.physicalSize = const Size(100, 100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final key = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(
        key: key,
        child: BsApp(
          home: ColoredBox(
            color: const Color(0xFFFFFFFF),
            child: Align(alignment: Alignment.topLeft, child: BsCloseButton(onPressed: () {})),
          ),
        ),
      ),
    );
    final box = (await tester.runAsync(() async {
      final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage();
      final data = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
      var minX = 999, minY = 999, maxX = -1, maxY = -1;
      // (only the button's own corner: the page has something grey along its top edge)
      for (var y = 1; y < 30; y++) {
        for (var x = 0; x < 30; x++) {
          final i = (y * image.width + x) * 4;
          if (data.getUint8(i + 3) > 0 && data.getUint8(i) < 200) {
            if (x < minX) minX = x;
            if (y < minY) minY = y;
            if (x > maxX) maxX = x;
            if (y > maxY) maxY = y;
          }
        }
      }
      return [minX, minY, maxX, maxY];
    }))!;
    // (4px of padding, then a glyph 16px across)
    expect(box, [4, 4, 19, 19]);
  });

  testWidgets('in a header the button takes the room of its glyph only, and reaches into the padding', (tester) async {
    await tester.pumpWidget(
      BsApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: 200, child: BsOffcanvasHeader(child: const Text('Title'), onClose: () {})),
        ),
      ),
    );
    final glyph = tester.getRect(find.byType(CustomPaint).last);
    // 16px of header padding, a 16px glyph at its right edge (200 - 16).
    expect(glyph.right, 200 - 16);
    expect(glyph.width, 16);
  });
}
