import 'package:flutter_test/flutter_test.dart';
import 'package:doc_site/pages/layout/breakpoints_page.dart';
import 'package:doc_site/pages/layout/containers_page.dart';
import 'package:doc_site/pages/layout/flex_page.dart';
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
}
