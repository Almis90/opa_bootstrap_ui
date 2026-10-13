import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  group('BsTransitions.resolve', () {
    testWidgets('returns the given duration when reduced motion is off', (tester) async {
      late Duration resolved;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(),
          child: Builder(
            builder: (context) {
              resolved = BsTransitions.resolve(context, const Duration(milliseconds: 300));
              return const SizedBox();
            },
          ),
        ),
      );
      expect(resolved, const Duration(milliseconds: 300));
    });

    testWidgets('collapses to reducedMotionDuration when reduced motion is on', (tester) async {
      late Duration resolved;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Builder(
            builder: (context) {
              resolved = BsTransitions.resolve(context, const Duration(milliseconds: 300));
              return const SizedBox();
            },
          ),
        ),
      );
      expect(resolved, BsTransitions.reducedMotionDuration);
    });
  });

  // BsCollapse's own rendered size (not its child's — the child always
  // reports its full natural size; it's the AnimatedSize wrapping it,
  // which BsCollapse's own layout size matches, that's mid-transition)
  // is what actually reflects the size animation's progress.
  Finder findCollapse() => find.byType(BsCollapse);

  testWidgets('BsCollapse expands instantly (one pump, no pumpAndSettle) when reduced motion is on', (tester) async {
    late StateSetter setState;
    var expanded = false;

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: BsApp(
          home: Column(
            children: [
              StatefulBuilder(
                builder: (context, setter) {
                  setState = setter;
                  return BsCollapse(isExpanded: expanded, child: Container(height: 200));
                },
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(findCollapse()).height, 0);

    setState(() => expanded = true);
    // Advancing by exactly BsTransitions.reducedMotionDuration (not
    // pumpAndSettle, and far short of the un-reduced 350ms collapse
    // duration) is enough to finish the whole transition.
    await tester.pump();
    await tester.pump(BsTransitions.reducedMotionDuration);
    expect(tester.getSize(findCollapse()).height, 200);
  });

  testWidgets('BsCollapse still animates normally (over multiple frames) when reduced motion is off', (tester) async {
    late StateSetter setState;
    var expanded = false;

    await tester.pumpWidget(
      BsApp(
        home: Column(
          children: [
            StatefulBuilder(
              builder: (context, setter) {
                setState = setter;
                return BsCollapse(isExpanded: expanded, child: Container(height: 200));
              },
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    setState(() => expanded = true);
    // Immediately after the first frame, the AnimatedSize is still
    // partway through its normal (non-reduced) transition — far short of
    // the content's full 200px height.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));
    expect(tester.getSize(findCollapse()).height, lessThan(50));

    await tester.pumpAndSettle();
    expect(tester.getSize(findCollapse()).height, 200);
  });

  // An animation that repeats forever must stand still, not run at the
  // one-millisecond duration a transition collapses to.
  Widget looping(Widget child, {required bool reduced}) => Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: MediaQueryData(disableAnimations: reduced),
      child: Align(alignment: Alignment.topLeft, child: SizedBox(width: 200, child: child)),
    ),
  );

  testWidgets('an animated BsProgress stands still when reduced motion is on', (tester) async {
    await tester.pumpWidget(looping(const BsProgress(value: 50, animated: true), reduced: true));
    await tester.pumpAndSettle(); // times out if anything keeps ticking
    expect(find.byType(BsProgress), findsOneWidget);
  });

  testWidgets('an animated BsProgress keeps animating otherwise', (tester) async {
    await tester.pumpWidget(looping(const BsProgress(value: 50, animated: true), reduced: false));
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.hasRunningAnimations, isTrue);
  });

  for (final animation in [BsPlaceholderAnimation.glow, BsPlaceholderAnimation.wave]) {
    testWidgets('a $animation BsPlaceholder stands still when reduced motion is on', (tester) async {
      await tester.pumpWidget(looping(BsPlaceholder(height: 16, animation: animation), reduced: true));
      await tester.pumpAndSettle();
      expect(find.byType(BsPlaceholder), findsOneWidget);
    });
  }
}
