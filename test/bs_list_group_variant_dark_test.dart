import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  Future<void> pump(WidgetTester tester, Brightness brightness) {
    return tester.pumpWidget(
      BsApp(
        brightness: brightness,
        home: const SizedBox(
          width: 400,
          child: BsListGroup(
            items: [
              BsListGroupItem(variant: BsVariant.success, child: Text('Item')),
            ],
          ),
        ),
      ),
    );
  }

  Color textColor(WidgetTester tester) =>
      DefaultTextStyle.of(tester.element(find.text('Item'))).style.color!;

  bool hasBackground(WidgetTester tester, Color color) => tester
      .widgetList<DecoratedBox>(
        find.byWidgetPredicate((widget) => widget is DecoratedBox),
      )
      .any((box) => (box.decoration as BoxDecoration).color == color);

  testWidgets('a variant item uses the subtle light colors in light mode', (
    tester,
  ) async {
    await pump(tester, Brightness.light);
    expect(textColor(tester), BsVariant.success.textEmphasis);
    expect(hasBackground(tester, BsVariant.success.bgSubtle), isTrue);
  });

  testWidgets('a variant item uses the dark counterparts in dark mode', (
    tester,
  ) async {
    await pump(tester, Brightness.dark);
    expect(textColor(tester), BsVariant.success.darkTextEmphasis);
    expect(hasBackground(tester, BsVariant.success.darkBgSubtle), isTrue);
  });
}
