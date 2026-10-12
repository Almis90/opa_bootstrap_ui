import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  testWidgets(
    "a dropdown's items sit inside its border, and the menu is as tall as the CSS one",
    (tester) async {
      await tester.pumpWidget(
        BsApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: BsDropdown(
              toggleBuilder: (context, toggle, isOpen) =>
                  GestureDetector(onTap: toggle, child: const Text('Toggle')),
              items: [
                BsDropdownItem(child: const Text('Action'), onTap: () {}),
                BsDropdownItem(
                  child: const Text('Another action'),
                  onTap: () {},
                ),
                BsDropdownItem(
                  child: const Text('Something else'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.text('Toggle'));
      await tester.pumpAndSettle();

      final menu = tester.getRect(
        find
            .ancestor(
              of: find.text('Action'),
              matching: find.byType(IntrinsicWidth),
            )
            .first,
      );
      final item = tester.getRect(
        find
            .ancestor(
              of: find.text('Action'),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );

      // `.dropdown-menu`: 1px border and .5rem of padding around 3 x 32px items.
      expect(menu.height, 1 + 8 + 3 * 32 + 8 + 1);
      // A hovered item's background must not paint over the menu's side border.
      expect(item.left, menu.left + 1);
      expect(item.right, menu.right - 1);
    },
  );

  // `.dropdown-menu` has `background-clip: padding-box`: its translucent border
  // is painted over what is behind the menu, not over the menu's background.
  testWidgets("the border is drawn over the page, not over the menu's background", (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 300);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final key = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(
        key: key,
        child: BsApp(
          home: ColoredBox(
            color: const Color(0xFF0000FF),
            child: Align(
              alignment: Alignment.topLeft,
              child: BsDropdown(
                toggleBuilder: (context, toggle, isOpen) =>
                    GestureDetector(onTap: toggle, child: const Text('Toggle')),
                items: [BsDropdownItem(child: const Text('Action'))],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Toggle'));
    await tester.pumpAndSettle();
    final menu = tester.getRect(
      find
          .ancestor(of: find.text('Action'), matching: find.byType(IntrinsicWidth))
          .first,
    );

    final pixel = (await tester.runAsync(() async {
      final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage();
      final data = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
      final x = menu.left.round();
      final y = (menu.top + menu.height / 2).round();
      final i = (y * image.width + x) * 4;
      return [data.getUint8(i), data.getUint8(i + 1), data.getUint8(i + 2)];
    }))!;
    // rgba(0,0,0,.175) over the blue page (not over the white menu: ~210 grey).
    expect(pixel[0], lessThan(10));
    expect(pixel[1], lessThan(10));
    expect(pixel[2], inInclusiveRange(200, 220));
  });
}
