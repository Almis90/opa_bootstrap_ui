import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doc_site/main.dart';

void main() {
  testWidgets('Docs site loads with the Introduction page selected', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const DocApp());
    await tester.pumpAndSettle();

    expect(find.text('Introduction'), findsWidgets);
    expect(find.text('GETTING STARTED'), findsOneWidget);
    expect(
      find.textContaining('opa_bootstrap_ui ports Bootstrap 5 components'),
      findsOneWidget,
    );
  });

  testWidgets(
    'Mobile viewport hides the persistent sidebar behind a hamburger menu',
    (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const DocApp());
      await tester.pumpAndSettle();

      // No persistent sidebar at this width, and no overflow errors from the
      // narrower page/example padding.
      expect(find.text('GETTING STARTED'), findsNothing);
      expect(find.byKey(const Key('doc-shell-hamburger')), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Opening it reveals the sidebar in an offcanvas.
      await tester.tap(find.byKey(const Key('doc-shell-hamburger')));
      await tester.pumpAndSettle();

      expect(find.text('GETTING STARTED'), findsOneWidget);

      // Selecting a page closes the offcanvas and swaps the content.
      await tester.tap(find.text('Introduction').last);
      await tester.pumpAndSettle();

      expect(find.text('GETTING STARTED'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Header shows the links inline from lg up and in an offcanvas below',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const DocApp());
      await tester.pumpAndSettle();

      expect(find.text('Docs'), findsOneWidget);
      expect(find.text('Examples'), findsOneWidget);
      expect(find.text('v5.3'), findsOneWidget);
      expect(find.byKey(const Key('doc-shell-theme-menu')), findsOneWidget);
      expect(find.byKey(const Key('doc-shell-nav-toggler')), findsNothing);

      // The version menu lists the current release.
      await tester.tap(find.text('v5.3'));
      await tester.pumpAndSettle();
      expect(find.text('Latest (5.3.x)'), findsOneWidget);

      tester.view.physicalSize = const Size(390, 800);
      await tester.pumpAndSettle();
      expect(find.text('Docs'), findsNothing);
      await tester.tap(find.byKey(const Key('doc-shell-nav-toggler')));
      await tester.pumpAndSettle();
      expect(find.text('Docs'), findsOneWidget);
      expect(find.text('Examples'), findsOneWidget);
      expect(find.text('Bootstrap v5.3'), findsOneWidget);
      expect(find.text('Toggle theme'), findsOneWidget);

      // Choosing a section closes the offcanvas.
      await tester.tap(find.text('Examples'));
      await tester.pumpAndSettle();
      expect(find.text('Toggle theme'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
