import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  Widget buildDropdown({
    BsDropdownController? controller,
    BsDropdownDirection direction = BsDropdownDirection.down,
    List<BsDropdownEntry> items = const [BsDropdownItem(child: Text('Item'))],
    ValueChanged<bool>? onOpenChanged,
    VoidCallback? onShow,
    VoidCallback? onShown,
    VoidCallback? onHide,
    VoidCallback? onHidden,
  }) {
    return BsApp(
      home: Center(
        child: BsDropdown(
          controller: controller,
          direction: direction,
          items: items,
          onOpenChanged: onOpenChanged,
          onShow: onShow,
          onShown: onShown,
          onHide: onHide,
          onHidden: onHidden,
          toggleBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: const Text('Toggle')),
        ),
      ),
    );
  }

  testWidgets('Tapping the toggle opens and closes the menu', (tester) async {
    await tester.pumpWidget(buildDropdown());
    expect(find.text('Item'), findsNothing);

    await tester.tap(find.text('Toggle'));
    await tester.pumpAndSettle();
    expect(find.text('Item'), findsOneWidget);

    await tester.tap(find.text('Toggle'));
    await tester.pumpAndSettle();
    expect(find.text('Item'), findsNothing);
  });

  testWidgets('Tapping outside the menu closes it', (tester) async {
    await tester.pumpWidget(buildDropdown());
    await tester.tap(find.text('Toggle'));
    await tester.pumpAndSettle();
    expect(find.text('Item'), findsOneWidget);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.text('Item'), findsNothing);
  });

  testWidgets('An outside tap that lands on another widget closes the menu and still activates that widget', (
    tester,
  ) async {
    var otherButtonTaps = 0;
    final controller = BsDropdownController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      BsApp(
        home: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BsButton(onPressed: () => otherButtonTaps++, child: const Text('Other button')),
              BsDropdown(
                controller: controller,
                items: const [BsDropdownItem(child: Text('Item'))],
                toggleBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: const Text('Toggle')),
              ),
            ],
          ),
        ),
      ),
    );

    controller.show();
    await tester.pumpAndSettle();
    expect(find.text('Item'), findsOneWidget);

    await tester.tap(find.text('Other button'));
    await tester.pumpAndSettle();
    expect(find.text('Item'), findsNothing);
    expect(otherButtonTaps, 1);
  });

  testWidgets('BsDropdownController disables the toggle and closes an already-open menu', (tester) async {
    final controller = BsDropdownController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(buildDropdown(controller: controller));

    await tester.tap(find.text('Toggle'));
    await tester.pumpAndSettle();
    expect(find.text('Item'), findsOneWidget);

    controller.disable();
    await tester.pumpAndSettle();
    expect(find.text('Item'), findsNothing);

    // Disabled: tapping the toggle again must not reopen it.
    await tester.tap(find.text('Toggle'));
    await tester.pumpAndSettle();
    expect(find.text('Item'), findsNothing);

    controller.enable();
    await tester.tap(find.text('Toggle'));
    await tester.pumpAndSettle();
    expect(find.text('Item'), findsOneWidget);
  });

  testWidgets('BsDropdownController show/hide/toggle work without any tap', (tester) async {
    final controller = BsDropdownController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(buildDropdown(controller: controller));
    expect(find.text('Item'), findsNothing);

    controller.show();
    await tester.pumpAndSettle();
    expect(find.text('Item'), findsOneWidget);
    expect(controller.isShown, isTrue);

    controller.hide();
    await tester.pumpAndSettle();
    expect(find.text('Item'), findsNothing);

    controller.toggle();
    await tester.pumpAndSettle();
    expect(find.text('Item'), findsOneWidget);

    controller.toggle();
    await tester.pumpAndSettle();
    expect(find.text('Item'), findsNothing);

    // show() is a no-op while disabled.
    controller.disable();
    controller.show();
    await tester.pumpAndSettle();
    expect(find.text('Item'), findsNothing);
  });

  testWidgets('BsDropdownController.setItems updates an already-open menu', (tester) async {
    final controller = BsDropdownController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      buildDropdown(
        controller: controller,
        items: const [BsDropdownItem(child: Text('Original'))],
      ),
    );

    controller.show();
    await tester.pumpAndSettle();
    expect(find.text('Original'), findsOneWidget);

    controller.setItems(const [BsDropdownItem(child: Text('Updated'))]);
    await tester.pump();
    expect(find.text('Original'), findsNothing);
    expect(find.text('Updated'), findsOneWidget);

    controller.setItems(null);
    await tester.pump();
    expect(find.text('Original'), findsOneWidget);
  });

  testWidgets('BsDropdownController.setDirection moves an already-open menu', (tester) async {
    final controller = BsDropdownController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(buildDropdown(controller: controller));

    controller.show();
    await tester.pumpAndSettle();
    final toggleRect = tester.getRect(find.text('Toggle'));
    var itemRect = tester.getRect(find.text('Item'));
    // Default direction is down: the menu sits below the toggle.
    expect(itemRect.top, greaterThanOrEqualTo(toggleRect.bottom));

    controller.setDirection(BsDropdownDirection.up);
    await tester.pumpAndSettle();
    itemRect = tester.getRect(find.text('Item'));
    expect(itemRect.bottom, lessThanOrEqualTo(toggleRect.top));
  });

  testWidgets('BsDropdown fires onShow/onShown/onHide/onHidden and onOpenChanged in order', (tester) async {
    final controller = BsDropdownController();
    addTearDown(controller.dispose);
    final events = <String>[];

    await tester.pumpWidget(
      buildDropdown(
        controller: controller,
        onShow: () => events.add('show'),
        onShown: () => events.add('shown'),
        onHide: () => events.add('hide'),
        onHidden: () => events.add('hidden'),
        onOpenChanged: (open) => events.add('openChanged:$open'),
      ),
    );

    controller.show();
    await tester.pumpAndSettle();
    expect(events, ['show', 'shown', 'openChanged:true']);

    controller.hide();
    await tester.pumpAndSettle();
    expect(events, ['show', 'shown', 'openChanged:true', 'hide', 'hidden', 'openChanged:false']);
  });

  testWidgets('setItems/setDirection while open do not re-fire onShow/onShown', (tester) async {
    final controller = BsDropdownController();
    addTearDown(controller.dispose);
    final events = <String>[];

    await tester.pumpWidget(
      buildDropdown(controller: controller, onShow: () => events.add('show'), onShown: () => events.add('shown')),
    );

    controller.show();
    await tester.pumpAndSettle();
    expect(events, ['show', 'shown']);

    controller.setItems(const [BsDropdownItem(child: Text('Updated'))]);
    controller.setDirection(BsDropdownDirection.up);
    await tester.pumpAndSettle();
    expect(events, ['show', 'shown']);
  });
}
