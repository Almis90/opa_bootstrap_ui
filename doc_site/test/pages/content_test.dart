import 'package:flutter_test/flutter_test.dart';
import 'package:doc_site/pages/content/figures_page.dart';
import 'package:doc_site/pages/content/tables_page.dart';
import 'package:doc_site/pages/content/typography_page.dart';

import '../test_utils.dart';

void main() {
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
