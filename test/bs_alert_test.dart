import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  testWidgets('Tapping the close button fires onClose immediately and onDismissed after the animation', (tester) async {
    final events = <String>[];

    await tester.pumpWidget(
      BsApp(
        home: BsAlert(
          dismissible: true,
          onClose: () => events.add('close'),
          onDismissed: () => events.add('dismissed'),
          child: const Text('Alert message'),
        ),
      ),
    );

    expect(find.text('Alert message'), findsOneWidget);

    await tester.tap(find.byType(BsCloseButton));
    await tester.pump();
    expect(events, ['close']);

    await tester.pumpAndSettle();
    expect(events, ['close', 'dismissed']);
  });

  testWidgets('BsAlertController.close dismisses the alert without a close button', (tester) async {
    final controller = BsAlertController();
    addTearDown(controller.dispose);
    final events = <String>[];

    await tester.pumpWidget(
      BsApp(
        home: BsAlert(
          controller: controller,
          onClose: () => events.add('close'),
          onDismissed: () => events.add('dismissed'),
          child: const Text('Alert message'),
        ),
      ),
    );

    expect(controller.isClosed, isFalse);
    controller.close();
    expect(controller.isClosed, isTrue);
    expect(events, ['close']);

    await tester.pumpAndSettle();
    expect(events, ['close', 'dismissed']);
  });

  testWidgets('BsAlertController.close is idempotent', (tester) async {
    final controller = BsAlertController();
    addTearDown(controller.dispose);
    final events = <String>[];

    await tester.pumpWidget(
      BsApp(
        home: BsAlert(controller: controller, onClose: () => events.add('close'), child: const Text('Alert message')),
      ),
    );

    controller.close();
    controller.close();
    expect(events, ['close']);
    await tester.pumpAndSettle();
  });
}
