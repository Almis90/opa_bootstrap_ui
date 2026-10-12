import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  testWidgets('Tapping BsFormFloating focuses the field and floats the label', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 300,
            child: BsFormFloating(label: Text('Email address')),
          ),
        ),
      ),
    );

    // At rest the label sits where the input's text would: its 24px line starts
    // 17px down (1px border and 1rem of padding) and 13px in.
    var label = tester.getRect(find.text('Email address'));
    expect(label.top, closeTo(17, 0.01));
    expect(label.left, closeTo(13, 0.01));
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
      false,
    );

    await tester.tap(find.byType(BsFormFloating));
    // `transition: transform .1s ease-in-out`: done within 100ms.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // `scale(.85) translateY(-.5rem) translateX(.15rem)` about the top-left
    // corner: the line goes (17 - 8) * .85 = 7.65 .. 28.05 down, and starts
    // (13 + 2.4) * .85 = 13.09 in, 85% as wide.
    final width = label.width;
    label = tester.getRect(find.text('Email address'));
    expect(label.top, closeTo(7.65, 0.01));
    expect(label.bottom, closeTo(28.05, 0.01));
    expect(label.left, closeTo(13.09, 0.01));
    expect(label.width, closeTo(width * 0.85, 0.01));
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
      true,
    );
  });

  testWidgets(
    "a floated label does not run into the typing line (the caret's top is below the label's glyphs)",
    (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 300,
              child: BsFormFloating(label: Text('Email address')),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(BsFormFloating));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // The input's text starts 1.625rem (26px) down; the label's line ends at
      // 28.05, whose glyphs end about 4px above that (descender at most).
      final label = tester.getRect(find.text('Email address'));
      final caretTop = 26 + (20 - 16 * 1.17) / 2;
      expect(label.bottom - 4.5, lessThan(caretTop));
    },
  );
}
