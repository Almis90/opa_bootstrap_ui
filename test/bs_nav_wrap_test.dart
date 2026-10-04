import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  Widget nav({BsJustify? justifyContent, bool fill = false}) => BsApp(
    debugShowCheckedModeBanner: false,
    home: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 200,
        child: BsNav(
          justifyContent: justifyContent,
          fill: fill,
          items: [
            for (final l in ['Home', 'Features', 'Pricing', 'FAQs', 'About'])
              BsNavItem(child: Text(l), onTap: () {}),
          ],
        ),
      ),
    ),
  );

  testWidgets(
    'a horizontal nav wider than its space wraps onto further lines (.nav is flex-wrap: wrap)',
    (tester) async {
      await tester.pumpWidget(nav());
      expect(tester.takeException(), isNull);
      // Five links can't share 200px; wrapped, the nav is taller than one link.
      final singleLine = tester.getSize(find.text('Home')).height;
      expect(
        tester.getSize(find.byType(BsNav)).height,
        greaterThan(singleLine * 2),
      );
    },
  );

  testWidgets(
    'justifyContent centres each wrapped line (.justify-content-center)',
    (tester) async {
      await tester.pumpWidget(nav(justifyContent: BsJustify.center));
      final firstLeft = tester.getTopLeft(find.text('Home')).dx;
      await tester.pumpWidget(nav());
      final startLeft = tester.getTopLeft(find.text('Home')).dx;
      expect(firstLeft, greaterThanOrEqualTo(startLeft));
    },
  );
}
