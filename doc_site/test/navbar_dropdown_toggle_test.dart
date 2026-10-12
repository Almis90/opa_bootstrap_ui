import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'package:doc_site/src/example_navbar_page.dart';

void main() {
  Widget page() => BsApp(
    home: Align(
      alignment: Alignment.bottomLeft,
      child: BsDropdown(
        direction: BsDropdownDirection.up,
        toggleBuilder: (context, toggle, isOpen) => NavbarDropdownToggle(
          onToggle: toggle,
          isOpen: isOpen,
          padding: const EdgeInsets.all(8),
          child: const Text('Dropup'),
        ),
        items: [BsDropdownItem(child: const Text('Action'), onTap: () {})],
      ),
    ),
  );

  bool ring(WidgetTester tester) {
    final box = tester.widget<BsDecoratedBox>(
      find
          .descendant(
            of: find.byType(NavbarDropdownToggle),
            matching: find.byType(BsDecoratedBox),
          )
          .first,
    );
    return (box.decoration as BoxDecoration).boxShadow?.isNotEmpty ?? false;
  }

  testWidgets(
    'Tab reaches the toggle and shows the ring; Enter opens, Escape closes',
    (tester) async {
      await tester.pumpWidget(page());
      expect(ring(tester), isFalse);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(ring(tester), isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Action'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Action'), findsNothing);
      // (the focus stays on the toggle)
      expect(ring(tester), isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(find.text('Action'), findsOneWidget);
    },
  );

  testWidgets(
    'a click that opens the menu rings the toggle (the plugin focuses it from script)',
    (tester) async {
      await tester.pumpWidget(page());
      await tester.tap(find.text('Dropup'));
      await tester.pumpAndSettle();
      expect(find.text('Action'), findsOneWidget);
      expect(ring(tester), isTrue);

      // Clicking elsewhere takes the focus, and the ring, away.
      await tester.tapAt(const Offset(300, 100));
      await tester.pumpAndSettle();
      expect(find.text('Action'), findsNothing);
      expect(ring(tester), isFalse);
    },
  );
}
