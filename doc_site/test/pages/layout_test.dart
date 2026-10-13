import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doc_site/pages/layout/breakpoints_page.dart';
import 'package:doc_site/pages/layout/containers_page.dart';
import 'package:doc_site/pages/layout/flex_page.dart';
import 'package:doc_site/pages/layout/grid_page.dart';
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
}
