import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  Color? backgroundOf(WidgetTester tester) {
    final box = tester.widget<BsDecoratedBox>(
      find
          .descendant(
            of: find.byType(BsBadge),
            matching: find.byType(BsDecoratedBox),
          )
          .first,
    );
    return (box.decoration as BoxDecoration).color;
  }

  testWidgets(
    'a subtle badge uses the variant\'s subtle background and emphasis text',
    (tester) async {
      await tester.pumpWidget(
        const BsApp(
          home: BsBadge(
            variant: BsVariant.success,
            subtle: true,
            child: Text('Success'),
          ),
        ),
      );
      expect(backgroundOf(tester), BsVariant.success.bgSubtle);
      expect(
        DefaultTextStyle.of(tester.element(find.text('Success'))).style.color,
        BsVariant.success.textEmphasis,
      );
    },
  );

  // `badge p-1 pe-2 border`: 12px of line (line-height 1) + 4+4 padding + 2 border.
  testWidgets('p, pe and border size the badge', (tester) async {
    await tester.pumpWidget(
      const BsApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: BsBadge(
            border: true,
            subtle: true,
            p: BsSpacing.s1,
            pe: BsSpacing.s2,
            child: SizedBox(width: 30, height: 12),
          ),
        ),
      ),
    );
    final size = tester.getSize(find.byType(BsBadge));
    expect(size.height, 12 + 4 + 4 + 2);
    expect(size.width, 30 + 4 + 8 + 2);
  });
}
