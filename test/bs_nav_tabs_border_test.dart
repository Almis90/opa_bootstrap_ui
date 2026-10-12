import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  testWidgets(
    "the nav-tabs' line is open under the selected tab and runs on under the others",
    (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        BsApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: RepaintBoundary(
              key: key,
              child: SizedBox(
                width: 300,
                child: BsNav(
                  variant: BsNavVariant.tabs,
                  items: [
                    BsNavItem(
                      child: const Text('Home'),
                      active: true,
                      onTap: () {},
                    ),
                    BsNavItem(child: const Text('Profile'), onTap: () {}),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      final home = tester.getRect(find.text('Home'));
      final profile = tester.getRect(find.text('Profile'));
      final strip = tester.getRect(find.byType(BsNav));

      final pixels = await tester.runAsync(() async {
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final image = await boundary.toImage();
        final data = (await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        ))!;
        ui.Color at(double x, double y) {
          final i = (y.floor() * image.width + x.floor()) * 4;
          return ui.Color.fromARGB(
            255,
            data.getUint8(i),
            data.getUint8(i + 1),
            data.getUint8(i + 2),
          );
        }

        // The last row of the strip: the nav's 1px line.
        final y = strip.bottom - 0.5;
        return (at(home.center.dx, y), at(profile.center.dx, y));
      });

      // Under the selected tab the line is the page's background; under the other
      // tab it is the line's colour (#dee2e6).
      expect(pixels!.$1, const ui.Color(0xFFFFFFFF));
      expect(pixels.$2, const ui.Color(0xFFDEE2E6));
    },
  );
}
