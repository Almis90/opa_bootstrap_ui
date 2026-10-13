import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';
import 'package:doc_site/pages/content/reboot_page.dart';
import 'package:doc_site/pages/content/figures_page.dart';
import 'package:doc_site/pages/content/images_page.dart';
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

  testWidgets('Images renders without errors', (tester) async {
    tester.view.physicalSize = const Size(1200, 6000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpDocPage(tester, const ImagesPage());

    expect(find.text('Images'), findsWidgets);
    expect(find.text('Aligning images'), findsOneWidget);
    expect(find.byType(BsThumbnail), findsNWidgets(2));
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Images aligns the images', (tester) async {
    tester.view.physicalSize = const Size(1200, 6000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpDocPage(tester, const ImagesPage());

    final wrap = find.byType(Wrap).first;
    final wrapRect = tester.getRect(wrap);
    final images = find.descendant(of: wrap, matching: find.byType(BsImage));
    expect(images, findsNWidgets(2));
    expect(tester.getRect(images.at(0)).left, closeTo(wrapRect.left, 1));
    expect(tester.getRect(images.at(1)).right, closeTo(wrapRect.right, 1));

    final centered = find.byWidgetPredicate(
      (w) => w is BsImage && w.block && w.width == 200,
    );
    final box = find.ancestor(of: centered, matching: find.byType(BsBox)).last;
    expect(
      tester.getRect(centered).center.dx,
      closeTo(tester.getRect(box).center.dx, 1),
    );
    expect(tester.getRect(centered).width, 200);

    await unmountDocPage(tester);
  });

  testWidgets('Images renders on a narrow window', (tester) async {
    tester.view.physicalSize = const Size(400, 6000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpDocPage(tester, const ImagesPage());

    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Figures renders without errors', (tester) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpDocPage(tester, const FiguresPage());

    expect(find.text('Figures'), findsWidgets);
    expect(find.text('Aligning the caption'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Figures aligns the caption with the image', (tester) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpDocPage(tester, const FiguresPage());

    final figures = find.byType(BsFigure);
    expect(figures, findsNWidgets(3));
    final captions = find.text('A caption for the above image.');
    final first = tester.getRect(
      find.descendant(of: figures.at(0), matching: find.byType(IntrinsicWidth)),
    );
    final aligned = tester.getRect(
      find.descendant(of: figures.at(1), matching: find.byType(IntrinsicWidth)),
    );
    expect(first.width, greaterThanOrEqualTo(400));
    expect(aligned.width, first.width);
    expect(tester.getRect(captions.at(0)).left, closeTo(first.left, 1));
    expect(tester.getRect(captions.at(1)).right, closeTo(aligned.right, 1));

    await unmountDocPage(tester);
  });

  testWidgets('Figures renders on a narrow window', (tester) async {
    tester.view.physicalSize = const Size(400, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpDocPage(tester, const FiguresPage());

    for (final figure in find.byType(BsFigure).evaluate()) {
      expect(
        tester.getSize(find.byWidget(figure.widget)).width,
        lessThanOrEqualTo(400),
      );
    }
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Tables renders without errors', (tester) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpDocPage(tester, const TablesPage());

    expect(find.text('Tables'), findsWidgets);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Customizing'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Tables scrolls only the always responsive table from md up', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpDocPage(tester, const TablesPage());

    final scrolling = find.byWidgetPredicate(
      (w) => w is SingleChildScrollView && w.scrollDirection == Axis.horizontal,
    );
    final wrapped = find.descendant(
      of: scrolling,
      matching: find.byType(BsTable),
    );
    // Only the always-responsive table scrolls from md up.
    expect(wrapped, findsOneWidget);
    expect(
      tester.getSize(wrapped).width,
      greaterThanOrEqualTo(
        tester
            .getSize(find.ancestor(of: wrapped, matching: scrolling).first)
            .width,
      ),
    );
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Tables scrolls the responsive tables on a narrow window', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpDocPage(tester, const TablesPage());

    final scrolling = find.byWidgetPredicate(
      (w) => w is SingleChildScrollView && w.scrollDirection == Axis.horizontal,
    );
    final wrapped = find.descendant(
      of: scrolling,
      matching: find.byType(BsTable),
    );
    expect(wrapped, findsNWidgets(2));
    for (var i = 0; i < 2; i++) {
      final table = tester.getSize(wrapped.at(i)).width;
      final view = tester
          .getSize(find.ancestor(of: wrapped.at(i), matching: scrolling).first)
          .width;
      expect(table, greaterThan(view));
    }
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Typography renders without errors', (tester) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpDocPage(tester, const TypographyPage());

    expect(find.text('Typography'), findsWidgets);
    expect(find.text('Description list alignment'), findsOneWidget);
    final term = tester.getRect(find.text('Description lists'));
    final definition = tester.getRect(
      find.text('A description list is perfect for defining terms.'),
    );
    expect(definition.left, greaterThan(term.right));
    expect(definition.top, lessThan(term.bottom));
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Typography aligns the blockquote footers', (tester) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpDocPage(tester, const TypographyPage());

    final footers = find.textContaining('Someone famous in Source Title');
    final quotes = find.text(
      'A well-known quote, contained in a blockquote element.',
    );
    expect(footers, findsNWidgets(3));
    expect(quotes, findsNWidgets(4));

    final start = tester.getRect(footers.at(0));
    final centered = tester.getRect(footers.at(1));
    final end = tester.getRect(footers.at(2));
    final centeredQuote = tester.getRect(quotes.at(2));
    final endQuote = tester.getRect(quotes.at(3));

    expect(centered.center.dx, closeTo(centeredQuote.center.dx, 1));
    expect(centered.left, greaterThan(start.left));
    expect(end.right, closeTo(endQuote.right, 1));

    await unmountDocPage(tester);
  });

  testWidgets('Typography renders on a narrow window', (tester) async {
    tester.view.physicalSize = const Size(400, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpDocPage(tester, const TypographyPage());

    final term = tester.getRect(find.text('Description lists'));
    final definition = tester.getRect(
      find.text('A description list is perfect for defining terms.'),
    );
    expect(definition.top, greaterThan(term.bottom - 1));

    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });
}
