import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  TextSpan? findSpan(InlineSpan span) {
    if (span is! TextSpan) return null;
    if (span.text == 'Privacy') return span;
    for (final child in span.children ?? const <InlineSpan>[]) {
      final found = findSpan(child);
      if (found != null) return found;
    }
    return null;
  }

  Color? spanColor(WidgetTester tester) => findSpan(
    tester.widget<RichText>(find.byType(RichText).first).text,
  )?.style?.color;

  Future<void> pumpLink(
    WidgetTester tester,
    VoidCallback onTap, {
    Brightness brightness = Brightness.light,
  }) => tester.pumpWidget(
    BsApp(
      brightness: brightness,
      home: Center(
        child: BsInlineAnchors(
          builder: (context, anchor) =>
              Text.rich(TextSpan(children: [anchor('Privacy', onTap: onTap)])),
        ),
      ),
    ),
  );

  testWidgets(
    'an inline anchor taps, shows the pointing hand and takes the hover color',
    (tester) async {
      var taps = 0;
      await pumpLink(tester, () => taps++);
      expect(spanColor(tester), BsLink.color);

      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer(
        location: tester.getCenter(find.byType(RichText).first),
      );
      await tester.pump();
      expect(
        RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1),
        SystemMouseCursors.click,
      );
      expect(spanColor(tester), BsLink.hoverColor);

      await mouse.moveTo(const Offset(1, 1));
      await tester.pump();
      expect(spanColor(tester), BsLink.color);

      await tester.tap(find.byType(RichText).first);
      expect(taps, 1);
    },
  );

  testWidgets('links use the dark theme\'s tint in dark mode', (tester) async {
    await pumpLink(tester, () {}, brightness: Brightness.dark);
    expect(spanColor(tester), BsLink.darkColor);
    await tester.pumpWidget(
      BsApp(
        brightness: Brightness.dark,
        home: const Center(child: BsAnchor(child: Text('Link'))),
      ),
    );
    final style = tester
        .widget<DefaultTextStyle>(
          find
              .descendant(
                of: find.byType(BsAnchor),
                matching: find.byType(DefaultTextStyle),
              )
              .first,
        )
        .style;
    expect(style.color, BsLink.darkColor);
  });
}
