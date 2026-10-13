import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';
import 'package:doc_site/pages/customize/color_modes_page.dart';
import 'package:doc_site/pages/customize/color_page.dart';
import 'package:doc_site/pages/customize/components_page.dart';
import 'package:doc_site/pages/customize/options_page.dart';
import 'package:doc_site/pages/customize/overview_page.dart';
import 'package:doc_site/pages/customize/style_classes_page.dart';
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

  testWidgets('Color modes renders without errors', (tester) async {
    await pumpDocPage(tester, const ColorModesPage());

    expect(find.text('Color modes'), findsOneWidget);
    expect(find.text('Dark mode'), findsOneWidget);
    expect(find.text('Adding theme colors'), findsOneWidget);
    expect(tester.takeException(), isNull);

    final dark = find.descendant(
      of: find.byType(BsButtonGroup),
      matching: find.text('Dark'),
    );
    await tester.ensureVisible(dark);
    await tester.tap(dark);
    await tester.pump();
    expect(find.text('Always dark.'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.text('Dark dropdown'));
    await tester.tap(find.text('Dark dropdown'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    final menuItem = find.text('Another action');
    expect(menuItem, findsOneWidget);
    expect(BsTheme.of(tester.element(menuItem)), Brightness.dark);

    await unmountDocPage(tester);
  });

  testWidgets('Components renders without errors', (tester) async {
    await pumpDocPage(tester, const ComponentsPage());

    expect(find.text('Components'), findsOneWidget);
    expect(find.text('Modifiers'), findsOneWidget);
    expect(find.text('Creating your own'), findsOneWidget);
    expect(find.text('This is an info callout.'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Style classes renders and its demo changes at run time', (
    tester,
  ) async {
    await pumpDocPage(tester, const StyleClassesPage());

    expect(find.text('Style classes'), findsWidgets);
    expect(find.text('Component variables'), findsOneWidget);
    expect(find.text('Focus variables'), findsOneWidget);

    BsAlertStyle? alertStyle() => tester
        .widget<BsAlert>(
          find.widgetWithText(BsAlert, 'The corners change at run time.'),
        )
        .style;
    expect(alertStyle()?.borderRadius, 0);
    final toggle = find.text('Round the corners');
    await tester.ensureVisible(toggle);
    await tester.tap(toggle);
    await tester.pump();
    expect(alertStyle()?.borderRadius, 24);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });
}
