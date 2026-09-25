import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  // A real `.nav` sizes to its own content, like any other unstretched flex
  // item — it doesn't claim its whole parent's width just because that
  // parent happens to hand it a loose (as opposed to tight) constraint.
  // BsNav's horizontal Row defaulted to MainAxisSize.max, so a bare BsNav
  // placed beside a sibling in a Wrap/Row always claimed the rest of the
  // shared row for itself, pushing the sibling onto its own line instead of
  // sitting next to it.
  testWidgets('BsNav sizes to its content instead of claiming its whole parent width', (tester) async {
    await tester.pumpWidget(
      BsApp(
        home: Center(
          child: SizedBox(
            width: 700,
            child: Wrap(
              children: [
                const Text('Brand', key: Key('brand')),
                BsNav(
                  variant: BsNavVariant.pills,
                  items: [
                    BsNavItem(child: const Text('Home'), active: true),
                    BsNavItem(child: const Text('Features')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final brandRect = tester.getRect(find.byKey(const Key('brand')));
    final navRect = tester.getRect(find.byType(BsNav));

    // Both fit on the same line (same vertical band) instead of BsNav
    // pushing the brand onto a line by itself.
    expect(navRect.top, closeTo(brandRect.top, brandRect.height));
    // BsNav itself is only as wide as its two pills, not the 700px parent.
    expect(navRect.width, lessThan(400));
  });
}
