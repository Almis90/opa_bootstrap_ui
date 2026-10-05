import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  // `.btn-link`: link-colored, underlined text, no background, no visible border.
  testWidgets('BsButton link is an underlined, link-colored text button', (
    tester,
  ) async {
    await tester.pumpWidget(
      BsApp(
        home: Center(
          child: BsButton(
            link: true,
            onPressed: () {},
            child: const Text('Link'),
          ),
        ),
      ),
    );
    final style = DefaultTextStyle.of(tester.element(find.text('Link'))).style;
    expect(style.decoration, TextDecoration.underline);
    expect(style.color, BsLink.color);
    final box = tester.widget<BsDecoratedBox>(
      find
          .descendant(
            of: find.byType(BsButton),
            matching: find.byType(BsDecoratedBox),
          )
          .first,
    );
    expect((box.decoration as BoxDecoration).color, const Color(0x00000000));
  });
}
