import 'package:flutter_test/flutter_test.dart';
import 'package:doc_site/pages/layout/breakpoints_page.dart';
import 'package:doc_site/pages/layout/containers_page.dart';

import '../test_utils.dart';

void main() {
  testWidgets('Breakpoints renders without errors', (tester) async {
    await pumpDocPage(tester, const BreakpointsPage());

    expect(find.text('Breakpoints'), findsWidgets);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Containers renders without errors', (tester) async {
    await pumpDocPage(tester, const ContainersPage());

    expect(find.text('Containers'), findsWidgets);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });
}
