import 'package:flutter_test/flutter_test.dart';
import 'package:doc_site/pages/getting_started/contents_page.dart';
import 'package:doc_site/pages/getting_started/installation_page.dart';
import 'package:doc_site/pages/getting_started/introduction_page.dart';
import 'package:doc_site/pages/getting_started/platforms_page.dart';

import '../test_utils.dart';

void main() {
  testWidgets('Introduction renders without errors', (tester) async {
    await pumpDocPage(tester, const IntroductionPage());

    expect(find.text('Get started with opa_bootstrap_ui'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Installation renders without errors', (tester) async {
    await pumpDocPage(tester, const InstallationPage());

    expect(find.text('Installation'), findsOneWidget);
    expect(find.text('Package installation'), findsOneWidget);
    expect(find.text('Download source'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Contents renders without errors', (tester) async {
    await pumpDocPage(tester, const ContentsPage());

    expect(find.text('Contents'), findsOneWidget);
    expect(find.text('Package exports'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Supported platforms renders without errors', (tester) async {
    await pumpDocPage(tester, const PlatformsPage());

    expect(find.text('Supported platforms and devices'), findsOneWidget);
    expect(find.text('Platform compatibility'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });
}
