import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  testWidgets(
    'BsCloseButton stays at its natural size under a parent that forces a stretched width',
    (tester) async {
      // Reproduces the layout a naive "place it directly, no Row/Center"
      // caller can hit: a parent handing down a *tight*, stretched width
      // constraint (e.g. Container(width: double.infinity) with no
      // alignment of its own). Before the fix, BsCloseButton's CustomPaint
      // got stretched to that width, and its painter (which scales off
      // size.width for both axes) drew the "x" glyph's lines at coordinates
      // far outside the visible area instead of a small mark.
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(
              width: 800,
              child: SizedBox(width: double.infinity, child: const BsCloseButton(onPressed: null)),
            ),
          ),
        ),
      );
      await tester.pump();

      final customPaintFinder = find.descendant(
        of: find.byType(BsCloseButton),
        matching: find.byType(CustomPaint),
      );
      final renderObject = tester.renderObject<RenderCustomPaint>(customPaintFinder);

      expect(renderObject.size, const Size(16, 16));
    },
  );
}
