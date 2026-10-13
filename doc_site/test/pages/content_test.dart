import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doc_site/pages/content/reboot_page.dart';
import 'package:doc_site/pages/content/figures_page.dart';
import 'package:doc_site/pages/content/tables_page.dart';
import 'package:doc_site/pages/content/typography_page.dart';

import '../test_utils.dart';

void main() {
  testWidgets('Reboot renders without errors', (tester) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpDocPage(tester, const RebootPage());

    expect(find.text('Reboot'), findsWidgets);
    expect(find.text('Headings'), findsOneWidget);
    expect(find.text('The hidden attribute'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Reboot renders on a narrow window', (tester) async {
    tester.view.physicalSize = const Size(400, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpDocPage(tester, const RebootPage());

    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Figures renders without errors', (tester) async {
    await pumpDocPage(tester, const FiguresPage());

    expect(find.text('Figures'), findsWidgets);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Tables renders without errors', (tester) async {
    await pumpDocPage(tester, const TablesPage());

    expect(find.text('Tables'), findsWidgets);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Typography renders without errors', (tester) async {
    await pumpDocPage(tester, const TypographyPage());

    expect(find.text('Typography'), findsWidgets);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });
}
