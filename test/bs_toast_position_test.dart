import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  testWidgets('showBsToast anchors each BsToastPosition to a distinct corner instead of stretching full-width', (
    tester,
  ) async {
    await tester.pumpWidget(
      BsApp(
        home: Builder(
          builder: (context) => BsButton(
            onPressed: () {
              for (final position in BsToastPosition.values) {
                showBsToast(
                  context,
                  position: position,
                  builder: (context, dismiss) => BsToast(body: Text(position.name)),
                );
              }
            },
            child: const Text('Show'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    final screenWidth = tester.view.physicalSize.width / tester.view.devicePixelRatio;

    final topStart = tester.getRect(find.text('topStart'));
    final topCenter = tester.getRect(find.text('topCenter'));
    final topEnd = tester.getRect(find.text('topEnd'));
    final centerStart = tester.getRect(find.text('centerStart'));
    final centerEnd = tester.getRect(find.text('centerEnd'));
    final bottomStart = tester.getRect(find.text('bottomStart'));
    final bottomCenter = tester.getRect(find.text('bottomCenter'));
    final bottomEnd = tester.getRect(find.text('bottomEnd'));

    // Each row's three positions must land at three distinct x-offsets:
    // start hugging the left edge, end hugging the right edge, center
    // roughly equidistant between them — not all collapsed onto the same
    // horizontal center the way a full-width stretched Column would.
    expect(topStart.left, lessThan(topCenter.left));
    expect(topCenter.left, lessThan(topEnd.left));
    expect(topStart.left, lessThan(screenWidth / 4));
    expect(topEnd.right, greaterThan(screenWidth * 3 / 4));

    expect(bottomStart.left, lessThan(bottomCenter.left));
    expect(bottomCenter.left, lessThan(bottomEnd.left));
    expect(bottomStart.left, lessThan(screenWidth / 4));
    expect(bottomEnd.right, greaterThan(screenWidth * 3 / 4));

    // centerStart/centerEnd hug the left/right edge too, vertically
    // between the top and bottom rows.
    expect(centerStart.left, lessThan(screenWidth / 4));
    expect(centerEnd.right, greaterThan(screenWidth * 3 / 4));
    expect(centerStart.top, greaterThan(topStart.bottom));
    expect(centerStart.bottom, lessThan(bottomStart.top));

    // Top row stays above the bottom row.
    expect(topStart.bottom, lessThan(bottomStart.top));
  });
}
