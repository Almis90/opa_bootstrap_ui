import 'package:flutter_test/flutter_test.dart';
import 'package:doc_site/pages/customize/color_page.dart';
import 'package:doc_site/pages/customize/options_page.dart';
import 'package:doc_site/pages/customize/overview_page.dart';
import 'package:doc_site/pages/customize/tokens_page.dart';

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

  testWidgets('Tokens renders without errors', (tester) async {
    await pumpDocPage(tester, const TokensPage());

    expect(find.text('Tokens'), findsOneWidget);
    expect(find.text('Variable defaults'), findsOneWidget);
    expect(find.text('Functions'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Options renders without errors', (tester) async {
    await pumpDocPage(tester, const OptionsPage());

    expect(find.text('Options'), findsOneWidget);
    expect(find.text(r'$enable-shadows'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Color renders without errors', (tester) async {
    await pumpDocPage(tester, const ColorPage());

    expect(find.text('Color'), findsOneWidget);
    expect(find.text('Theme colors'), findsOneWidget);
    expect(find.text('All colors'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });
}
