import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

/// Sizes the CSS gives these components that a painted border alone would
/// not: borders take room, a heading's line-height reaches into a button.
void main() {
  Future<Size> sizeOf(WidgetTester tester, Widget child, Type type) async {
    await tester.pumpWidget(
      BsApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: 400, child: child),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return tester.getSize(find.byType(type).first);
  }

  // `.table-bordered`: 4 rows of 8 + 24 + 8 and five 1px rules.
  testWidgets('a bordered table is as tall as its rows and rules', (
    tester,
  ) async {
    final size = await sizeOf(
      tester,
      BsTable(
        bordered: true,
        small: true,
        columns: const [Text('a'), Text('b')],
        rows: [
          for (var i = 0; i < 3; i++)
            const BsTableRow(cells: [Text('x'), Text('y')]),
        ],
      ),
      BsTable,
    );
    // table-sm cells: 4 + 24 + 4 = 32, plus a rule each, plus the top one.
    expect(size.height, 4 * 33 + 1);
  });

  // `.accordion-item` has a 1px border all round; the collapsed header is
  // 16 + 19.2 (a heading's line) + 16.
  testWidgets('accordion items include their borders', (tester) async {
    final size = await sizeOf(
      tester,
      BsAccordion(
        items: [
          BsAccordionItem(header: const Text('One'), body: const Text('1')),
          BsAccordionItem(header: const Text('Two'), body: const Text('2')),
        ],
      ),
      BsAccordion,
    );
    // top border, header, border; header, border: 1 + 2 * 52 + 2 (the header
    // is 51.2 plus the icon's 20 → 52).
    expect(size.height, closeTo(1 + 52 + 1 + 52 + 1, 0.5));
  });

  testWidgets('a nav-tabs link includes its 1px border', (tester) async {
    final size = await sizeOf(
      tester,
      BsNav(
        variant: BsNavVariant.tabs,
        items: [
          BsNavItem(child: const Text('Home'), active: true, onTap: () {}),
        ],
      ),
      BsNav,
    );
    expect(size.height, 42);
  });

  testWidgets('a progress bar takes its variant color, not the default', (
    tester,
  ) async {
    await tester.pumpWidget(
      const BsApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 200,
            child: BsProgress(value: 50, variant: BsVariant.success),
          ),
        ),
      ),
    );
    final bar = tester
        .widgetList<BsDecoratedBox>(find.byType(BsDecoratedBox))
        .map((b) => (b.decoration as BoxDecoration).color)
        .toList();
    expect(bar, contains(BsVariant.success.color));
  });

  testWidgets('a wrapping pagination moves on to another line', (tester) async {
    final size = await sizeOf(
      tester,
      BsPagination(
        wrap: true,
        items: [
          for (var i = 0; i < 12; i++)
            BsPaginationItem(child: Text('Page $i'), onTap: () {}),
        ],
      ),
      BsPagination,
    );
    expect(size.height, greaterThan(38));
  });
}
