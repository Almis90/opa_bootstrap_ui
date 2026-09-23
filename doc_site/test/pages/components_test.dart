import 'package:flutter_test/flutter_test.dart';
import 'package:doc_site/pages/components/accordion_page.dart';
import 'package:doc_site/pages/components/alerts_page.dart';
import 'package:doc_site/pages/components/badge_page.dart';
import 'package:doc_site/pages/components/breadcrumb_page.dart';
import 'package:doc_site/pages/components/button_group_page.dart';
import 'package:doc_site/pages/components/buttons_page.dart';
import 'package:doc_site/pages/components/card_page.dart';
import 'package:doc_site/pages/components/carousel_page.dart';
import 'package:doc_site/pages/components/close_button_page.dart';
import 'package:doc_site/pages/components/collapse_page.dart';
import 'package:doc_site/pages/components/dropdowns_page.dart';
import 'package:doc_site/pages/components/list_group_page.dart';
import 'package:doc_site/pages/components/modal_page.dart';
import 'package:doc_site/pages/components/navbar_page.dart';
import 'package:doc_site/pages/components/navs_tabs_page.dart';
import 'package:doc_site/pages/components/offcanvas_page.dart';
import 'package:doc_site/pages/components/pagination_page.dart';
import 'package:doc_site/pages/components/placeholders_page.dart';
import 'package:doc_site/pages/components/popovers_page.dart';
import 'package:doc_site/pages/components/progress_page.dart';
import 'package:doc_site/pages/components/scrollspy_page.dart';
import 'package:doc_site/pages/components/spinners_page.dart';
import 'package:doc_site/pages/components/toasts_page.dart';
import 'package:doc_site/pages/components/tooltips_page.dart';

import '../test_utils.dart';

void main() {
  testWidgets('Accordion renders without errors', (tester) async {
    await pumpDocPage(tester, const AccordionPage());
    expect(find.text('Accordion'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Alerts renders without errors', (tester) async {
    await pumpDocPage(tester, const AlertsPage());
    expect(find.text('Alerts'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Badge renders without errors', (tester) async {
    await pumpDocPage(tester, const BadgePage());
    expect(find.text('Badge'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Breadcrumb renders without errors', (tester) async {
    await pumpDocPage(tester, const BreadcrumbPage());
    expect(find.text('Breadcrumb'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Button group renders without errors', (tester) async {
    await pumpDocPage(tester, const ButtonGroupPage());
    expect(find.text('Button group'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Buttons renders without errors', (tester) async {
    await pumpDocPage(tester, const ButtonsPage());
    expect(find.text('Buttons'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Card renders without errors', (tester) async {
    await pumpDocPage(tester, const CardPage());
    expect(find.text('Card'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Carousel renders without errors', (tester) async {
    await pumpDocPage(tester, const CarouselPage());
    expect(find.text('Carousel'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Close button renders without errors', (tester) async {
    await pumpDocPage(tester, const CloseButtonPage());
    expect(find.text('Close button'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Collapse renders without errors', (tester) async {
    await pumpDocPage(tester, const CollapsePage());
    expect(find.text('Collapse'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Dropdowns renders without errors', (tester) async {
    await pumpDocPage(tester, const DropdownsPage());
    expect(find.text('Dropdowns'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('List group renders without errors', (tester) async {
    await pumpDocPage(tester, const ListGroupPage());
    expect(find.text('List group'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Modal renders without errors', (tester) async {
    await pumpDocPage(tester, const ModalPage());
    expect(find.text('Modal'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Navbar renders without errors', (tester) async {
    await pumpDocPage(tester, const NavbarPage());
    expect(find.text('Navbar'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Navs & tabs renders without errors', (tester) async {
    await pumpDocPage(tester, const NavsTabsPage());
    expect(find.text('Navs & tabs'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Offcanvas renders without errors', (tester) async {
    await pumpDocPage(tester, const OffcanvasPage());
    expect(find.text('Offcanvas'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Pagination renders without errors', (tester) async {
    await pumpDocPage(tester, const PaginationPage());
    expect(find.text('Pagination'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Placeholders renders without errors', (tester) async {
    await pumpDocPage(tester, const PlaceholdersPage());
    expect(find.text('Placeholders'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Popovers renders without errors', (tester) async {
    await pumpDocPage(tester, const PopoversPage());
    expect(find.text('Popovers'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Progress renders without errors', (tester) async {
    await pumpDocPage(tester, const ProgressPage());
    expect(find.text('Progress'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Scrollspy renders without errors', (tester) async {
    await pumpDocPage(tester, const ScrollspyPage());
    expect(find.text('Scrollspy'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Spinners renders without errors', (tester) async {
    await pumpDocPage(tester, const SpinnersPage());
    expect(find.text('Spinners'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Toasts renders without errors', (tester) async {
    await pumpDocPage(tester, const ToastsPage());
    expect(find.text('Toasts'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });

  testWidgets('Tooltips renders without errors', (tester) async {
    await pumpDocPage(tester, const TooltipsPage());
    expect(find.text('Tooltips'), findsWidgets);
    expect(tester.takeException(), isNull);
    await unmountDocPage(tester);
  });
}
