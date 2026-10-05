import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  double linkHeight(WidgetTester tester) => tester
      .getSize(
        find
            .descendant(
              of: find.byType(BsNav),
              matching: find.byType(BsDecoratedBox),
            )
            .first,
      )
      .height;

  Future<void> pump(WidgetTester tester, BsNavItem item) async {
    await tester.pumpWidget(
      BsApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: BsNav(
            variant: BsNavVariant.pills,
            vertical: true,
            items: [item],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  // `nav-link py-3 border-bottom`: 16px above and below the content, and the
  // 1px border below that.
  testWidgets('BsNavItem py and borderBottom size the link', (tester) async {
    await pump(
      tester,
      BsNavItem(
        py: BsSpacing.s3,
        borderBottom: true,
        child: const SizedBox(width: 24, height: 24),
      ),
    );
    expect(linkHeight(tester), 16 + 24 + 16 + 1);
  });

  testWidgets('BsNavItem without utilities keeps the .5rem padding', (
    tester,
  ) async {
    await pump(tester, BsNavItem(child: const SizedBox(width: 24, height: 24)));
    expect(linkHeight(tester), 8 + 24 + 8);
  });

  testWidgets('BsNavItem textColor colors an inactive link', (tester) async {
    await pump(
      tester,
      BsNavItem(textColor: BsTextColor.white, child: const Text('Orders')),
    );
    final style = DefaultTextStyle.of(tester.element(find.text('Orders')));
    expect(style.style.color, BsColors.white);
  });
}
