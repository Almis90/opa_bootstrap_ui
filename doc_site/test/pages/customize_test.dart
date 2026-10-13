import 'package:flutter_test/flutter_test.dart';
import 'package:doc_site/pages/customize/overview_page.dart';

import '../test_utils.dart';

void main() {
  testWidgets('Customize overview renders without errors', (tester) async {
    await pumpDocPage(tester, const CustomizeOverviewPage());

    expect(find.text('Customize'), findsOneWidget);
    expect(find.text('In this section'), findsOneWidget);
    expect(find.text('Icons and assets'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });
}
