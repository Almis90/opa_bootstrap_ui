import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

Future<Color> _pumpAndGetBackground(WidgetTester tester, Brightness brightness) async {
  final key = GlobalKey();
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: BsTheme(
        brightness: brightness,
        child: Center(
          child: SizedBox(
            width: 200,
            child: BsCard(key: key, child: const SizedBox(height: 50)),
          ),
        ),
      ),
    ),
  );
  final box = tester.renderObject<RenderDecoratedBox>(
    find.descendant(of: find.byKey(key), matching: find.byType(DecoratedBox)).first,
  );
  return (box.decoration as BoxDecoration).color!;
}

void main() {
  testWidgets('BsCard light background', (tester) async {
    final color = await _pumpAndGetBackground(tester, Brightness.light);
    expect(color, BsCardStyle.defaultBackground);
  });

  testWidgets('BsCard dark background', (tester) async {
    final color = await _pumpAndGetBackground(tester, Brightness.dark);
    expect(color, BsCardStyle.defaultDarkBackground);
  });

  testWidgets('BsCard with no BsTheme ancestor defaults to light', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(width: 200, child: BsCard(key: key, child: const SizedBox(height: 50))),
      ),
    );
    final box = tester.renderObject<RenderDecoratedBox>(
      find.descendant(of: find.byKey(key), matching: find.byType(DecoratedBox)).first,
    );
    expect((box.decoration as BoxDecoration).color, BsCardStyle.defaultBackground);
  });
}
