import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doc_site/pages/layout/breakpoints_page.dart';
import 'package:doc_site/pages/layout/columns_page.dart';
import 'package:doc_site/pages/layout/containers_page.dart';
import 'package:doc_site/pages/layout/flex_page.dart';
import 'package:doc_site/pages/layout/grid_page.dart';
import 'package:doc_site/pages/layout/gutters_page.dart';
import 'package:doc_site/pages/layout/utilities_page.dart';

import '../test_utils.dart';

void main() {
  testWidgets('Breakpoints renders without errors', (tester) async {
    await pumpDocPage(tester, const BreakpointsPage());

    expect(find.text('Breakpoints'), findsWidgets);
    expect(find.text('Available breakpoints'), findsOneWidget);
    expect(find.text('3 columns'), findsWidgets);
    expect(find.text('your window'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Containers renders without errors', (tester) async {
    await pumpDocPage(tester, const ContainersPage());

    expect(find.text('Containers'), findsWidgets);
    expect(find.text('Responsive containers'), findsOneWidget);
    // The test window is 800 wide (md).
    expect(find.textContaining('BsContainer: 720px,'), findsOneWidget);
    expect(find.textContaining('responsiveFrom(lg): 100%,'), findsOneWidget);
    expect(find.textContaining('BsContainer.fluid: 100%,'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Flex renders without errors', (tester) async {
    await pumpDocPage(tester, const FlexPage());

    expect(find.text('Flex'), findsWidgets);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Utilities renders without errors', (tester) async {
    await pumpDocPage(tester, const UtilitiesPage());

    expect(find.text('Utilities'), findsWidgets);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Grid renders at every size and stacks below sm', (tester) async {
    addTearDown(tester.view.reset);
    tester.view.devicePixelRatio = 1;

    for (final width in [400.0, 800.0, 1500.0]) {
      tester.view.physicalSize = Size(width, 900);
      await pumpDocPage(tester, const GridPage());

      expect(find.text('Grid system'), findsWidgets);
      expect(find.text('Nesting'), findsOneWidget);

      final wide = tester.getTopLeft(find.text('col-sm-8'));
      final narrow = tester.getTopLeft(find.text('col-sm-4'));
      if (width < 576) {
        expect(narrow.dy, greaterThan(wide.dy), reason: 'stacked at $width');
      } else {
        expect(narrow.dy, wide.dy, reason: 'side by side at $width');
      }
      expect(tester.takeException(), isNull);
      await unmountDocPage(tester);
    }
  });

  testWidgets('Columns renders at every size and aligns within the line', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    tester.view.devicePixelRatio = 1;

    for (final width in [400.0, 800.0, 1500.0]) {
      tester.view.physicalSize = Size(width, 900);
      await pumpDocPage(tester, const ColumnsPage());

      expect(find.text('Columns'), findsWidgets);
      expect(find.text('Standalone column widths'), findsOneWidget);

      // The "Start", "Center" and "End" columns sit at the top, middle
      // and bottom of the line set by the tall one.
      final start = tester.getRect(find.text('Start')).top;
      final center = tester.getRect(find.text('Center')).top;
      final end = tester.getRect(find.text('End')).top;
      expect(center, greaterThan(start));
      expect(end, greaterThan(center));

      expect(tester.takeException(), isNull);
      await unmountDocPage(tester);
    }
  });

  testWidgets('Gutters renders at every size and spaces columns by g', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    tester.view.devicePixelRatio = 1;

    for (final width in [400.0, 800.0, 1500.0]) {
      tester.view.physicalSize = Size(width, 900);
      await pumpDocPage(tester, const GuttersPage());

      expect(find.text('Gutters'), findsWidgets);
      expect(find.text('No gutters'), findsOneWidget);

      // The fourth example (g-2) has four columns of col-6: the first two
      // texts of it are the ninth and the tenth on the page.
      Rect box(int index) => tester.getRect(
        find
            .ancestor(
              of: find.text('Custom column padding').at(index),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final first = box(8);
      final right = box(9);
      final below = box(10);
      expect(right.left - first.right, 8, reason: 'gx at $width');
      expect(below.top - first.bottom, 8, reason: 'gy at $width');

      expect(tester.takeException(), isNull);
      await unmountDocPage(tester);
    }
  });
}
