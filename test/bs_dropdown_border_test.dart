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
}
