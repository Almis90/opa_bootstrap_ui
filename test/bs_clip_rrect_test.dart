import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  // A box at a fractional offset keeps a 1px border painted on its edge: the
  // clip is snapped to the pixel grid like the border, so it isn't cut away.
  testWidgets('clips at the snapped edges, not the fractional ones', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(100, 100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.4, top: 10.6),
          child: Align(
            alignment: Alignment.topLeft,
            child: BsClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const ColoredBox(
                color: Color(0xFF000000),
                child: SizedBox(width: 20, height: 20),
              ),
            ),
          ),
        ),
      ),
    );
    final render = tester.renderObject<RenderBox>(find.byType(BsClipRRect));
    expect(render.size, const Size(20, 20));
    // A repaint with the clip in place does not throw.
    await tester.pump();
  });
}
