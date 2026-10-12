import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  testWidgets(
    'a spinner far below the fold does not keep frames coming, and spins once scrolled to',
    (tester) async {
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = ScrollController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        BsApp(
          home: SingleChildScrollView(
            controller: controller,
            child: const Column(
              children: [
                SizedBox(height: 3000),
                BsSpinnerBorder(),
                SizedBox(height: 500),
              ],
            ),
          ),
        ),
      );

      // Out of view: once it has been seen to be, nothing animates, so the app
      // settles (a spinner that spun regardless would never let it).
      await tester.pump();
      await tester.pumpAndSettle();
      expect(tester.binding.hasScheduledFrame, isFalse);

      // Scrolled to: it spins, a frame is wanted every tick.
      controller.jumpTo(2800);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 16));
      expect(tester.binding.hasScheduledFrame, isTrue);

      // Scrolled away again: it stops.
      controller.jumpTo(0);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 16));
      await tester.pumpAndSettle();
      expect(tester.binding.hasScheduledFrame, isFalse);
    },
  );

  testWidgets(
    'animated progress stripes and a glowing placeholder pause out of view too',
    (tester) async {
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const BsApp(
          home: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 3000),
                BsProgress(value: 50, animated: true),
                SizedBox(
                  height: 40,
                  child: BsPlaceholder(animation: BsPlaceholderAnimation.glow),
                ),
                SizedBox(
                  height: 40,
                  child: BsPlaceholder(animation: BsPlaceholderAnimation.wave),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();
      expect(tester.binding.hasScheduledFrame, isFalse);
    },
  );
}
