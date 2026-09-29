import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  const items = [
    BsAccordionItem(header: Text('Header 1'), body: Text('Body 1')),
    BsAccordionItem(header: Text('Header 2'), body: Text('Body 2')),
  ];

  testWidgets('Tapping a header expands it and collapses the other grouped item', (tester) async {
    await tester.pumpWidget(BsApp(home: BsAccordion(items: items)));

    expect(find.text('Body 1'), findsNothing);
    expect(find.text('Body 2'), findsNothing);

    await tester.tap(find.text('Header 1'));
    await tester.pumpAndSettle();
    expect(find.text('Body 1'), findsOneWidget);
    expect(find.text('Body 2'), findsNothing);

    await tester.tap(find.text('Header 2'));
    await tester.pumpAndSettle();
    expect(find.text('Body 1'), findsNothing);
    expect(find.text('Body 2'), findsOneWidget);
  });

  testWidgets('BsAccordionController.expand/collapse/toggle/collapseAll drive items without tapping', (tester) async {
    final controller = BsAccordionController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(BsApp(home: BsAccordion(controller: controller, items: items)));

    controller.expand(0);
    await tester.pumpAndSettle();
    expect(find.text('Body 1'), findsOneWidget);

    controller.toggle(1);
    await tester.pumpAndSettle();
    expect(find.text('Body 1'), findsNothing);
    expect(find.text('Body 2'), findsOneWidget);

    controller.collapseAll();
    await tester.pumpAndSettle();
    expect(find.text('Body 1'), findsNothing);
    expect(find.text('Body 2'), findsNothing);
  });

  testWidgets('A detached item expands/collapses independently of the grouped items', (tester) async {
    final detachedItems = [
      items[0],
      const BsAccordionItem(detached: true, header: Text('Header 2'), body: Text('Body 2')),
    ];
    await tester.pumpWidget(BsApp(home: BsAccordion(items: detachedItems)));

    await tester.tap(find.text('Header 1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Header 2'));
    await tester.pumpAndSettle();

    expect(find.text('Body 1'), findsOneWidget);
    expect(find.text('Body 2'), findsOneWidget);
  });

  testWidgets('onExpansionChanged/onExpansionEnd fire per index, for both a tap and a grouped close', (tester) async {
    final events = <String>[];
    await tester.pumpWidget(
      BsApp(
        home: BsAccordion(
          items: items,
          onExpansionChanged: (index, isExpanded) => events.add('changed:$index:$isExpanded'),
          onExpansionEnd: (index, isExpanded) => events.add('ended:$index:$isExpanded'),
        ),
      ),
    );

    await tester.tap(find.text('Header 1'));
    expect(events, ['changed:0:true']);
    await tester.pumpAndSettle();
    expect(events, ['changed:0:true', 'ended:0:true']);

    events.clear();
    // Opening item 1 closes the grouped item 0 in the same transition, so
    // both indices must be reported.
    await tester.tap(find.text('Header 2'));
    expect(events, containsAll(['changed:1:true', 'changed:0:false']));
    await tester.pumpAndSettle();
    expect(events, containsAll(['ended:1:true', 'ended:0:false']));
  });

  testWidgets('onExpansionChanged/onExpansionEnd fire for controller-driven changes too', (tester) async {
    final controller = BsAccordionController();
    addTearDown(controller.dispose);
    final events = <String>[];
    await tester.pumpWidget(
      BsApp(
        home: BsAccordion(
          controller: controller,
          items: items,
          onExpansionChanged: (index, isExpanded) => events.add('changed:$index:$isExpanded'),
          onExpansionEnd: (index, isExpanded) => events.add('ended:$index:$isExpanded'),
        ),
      ),
    );

    controller.expand(0);
    expect(events, ['changed:0:true']);
    await tester.pumpAndSettle();
    expect(events, ['changed:0:true', 'ended:0:true']);
  });
}
