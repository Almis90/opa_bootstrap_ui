import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  Widget nav({bool nowrap = false, BsResponsive<BsJustify>? justify}) {
    return BsApp(
      home: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 400,
          child: BsNav(
            variant: BsNavVariant.underline,
            nowrap: nowrap,
            justifyContent: justify,
            items: [
              for (final label in ['One', 'Two', 'Three'])
                BsNavItem(onTap: () {}, child: Text(label, softWrap: false)),
            ],
          ),
        ),
      ),
    );
  }

  // `.nav-underline .nav-link`: no horizontal padding, `.5rem` above and
  // below the line, and the `.125rem` border below that.
  testWidgets('underline links have no side padding and add their border', (
    tester,
  ) async {
    await tester.pumpWidget(nav());
    await tester.pumpAndSettle();
    final box = find.descendant(
      of: find.byType(BsNav),
      matching: find.byType(BsDecoratedBox),
    );
    final size = tester.getSize(box.first);
    final text = tester.getSize(find.text('One'));
    expect(size.width, text.width);
    expect(size.height, text.height + 16 + 2);
  });

  // `flex-nowrap` + `justify-content-between`: one line, spread over the width.
  testWidgets('nowrap keeps one line and justifies between', (tester) async {
    await tester.pumpWidget(
      nav(
        nowrap: true,
        justify: const BsResponsiveValue.all(BsJustify.between),
      ),
    );
    await tester.pumpAndSettle();
    final one = tester.getTopLeft(find.text('One'));
    final two = tester.getTopLeft(find.text('Two'));
    final three = tester.getTopRight(find.text('Three'));
    expect(one.dy, two.dy);
    expect(three.dx, closeTo(400, 0.01));
  });
}
