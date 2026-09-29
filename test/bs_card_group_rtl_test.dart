import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  // BsCardGroup drops the border shared between two adjacent cards from
  // whichever one is "later" in list order, leaving the "earlier" card's
  // own border to draw the single shared seam. It's built from
  // BorderDirectional's logical start/end (not left/right), so Flutter
  // resolves which physical side that actually lands on against whatever
  // Directionality is ambient at paint time — this only needs to check
  // that the logical start/end sides themselves come out right, the same
  // regardless of LTR/RTL.
  BorderDirectional borderOf(WidgetTester tester, int index) {
    final decoratedBoxes = tester.widgetList<DecoratedBox>(find.byType(DecoratedBox)).toList();
    // Each card's outer DecoratedBox is the one carrying a non-null border.
    final withBorder = decoratedBoxes.where((box) => (box.decoration as BoxDecoration).border != null).toList();
    return (withBorder[index].decoration as BoxDecoration).border! as BorderDirectional;
  }

  testWidgets('the first card keeps its start border, later cards drop theirs (the shared seam)', (tester) async {
    await tester.pumpWidget(
      BsApp(
        home: SizedBox(
          width: 400,
          height: 100,
          child: BsCardGroup(
            children: [BsCard(child: const Text('One')), BsCard(child: const Text('Two')), BsCard(child: const Text('Three'))],
          ),
        ),
      ),
    );

    final first = borderOf(tester, 0);
    final middle = borderOf(tester, 1);
    final last = borderOf(tester, 2);

    expect(first.start.style, isNot(BorderStyle.none));
    expect(middle.start.style, BorderStyle.none);
    expect(last.start.style, BorderStyle.none);

    // Every card's own end border stays — for a middle card that's the
    // seam the next card's dropped start border relies on; for the last
    // card it's just its own outer edge.
    expect(first.end.style, isNot(BorderStyle.none));
    expect(middle.end.style, isNot(BorderStyle.none));
    expect(last.end.style, isNot(BorderStyle.none));
  });
}
