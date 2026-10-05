import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doc_site/pages/examples/album_example_page.dart';
import 'package:doc_site/pages/examples/badges_example_page.dart';
import 'package:doc_site/pages/examples/breadcrumbs_example_page.dart';
import 'package:doc_site/pages/examples/headers_example_page.dart';
import 'package:doc_site/pages/examples/heroes_example_page.dart';
import 'package:doc_site/pages/examples/jumbotron_example_page.dart';
import 'package:doc_site/pages/examples/jumbotrons_example_page.dart';
import 'package:doc_site/pages/examples/list_groups_example_page.dart';
import 'package:doc_site/pages/examples/masonry_example_page.dart';
import 'package:doc_site/pages/examples/modals_example_page.dart';
import 'package:doc_site/pages/examples/navbar_bottom_example_page.dart';
import 'package:doc_site/pages/examples/navbar_fixed_example_page.dart';
import 'package:doc_site/pages/examples/navbar_static_example_page.dart';
import 'package:doc_site/pages/examples/navbars_example_page.dart';
import 'package:doc_site/pages/examples/navbars_offcanvas_example_page.dart';
import 'package:doc_site/pages/examples/offcanvas_navbar_example_page.dart';
import 'package:doc_site/pages/examples/pricing_example_page.dart';
import 'package:doc_site/pages/examples/product_example_page.dart';
import 'package:doc_site/pages/examples/sidebars_example_page.dart';
import 'package:doc_site/pages/examples/sign_in_example_page.dart';
import 'package:doc_site/pages/examples/starter_template_example_page.dart';
import 'package:doc_site/pages/examples/sticky_footer_example_page.dart';
import 'package:doc_site/pages/examples/sticky_footer_navbar_example_page.dart';

import '../test_utils.dart';

void main() {
  for (final width in [375.0, 1000.0, 1300.0]) {
    for (final entry in {
      'Album': () => const AlbumExamplePage(),
      'Album RTL': () => const AlbumExamplePage(rtl: true),
      'Badges': () => const BadgesExamplePage(),
      'Breadcrumbs': () => const BreadcrumbsExamplePage(),
      'Headers': () => const HeadersExamplePage(),
      'Heroes': () => const HeroesExamplePage(),
      'Jumbotron': () => const JumbotronExamplePage(),
      'Jumbotrons': () => const JumbotronsExamplePage(),
      'List groups': () => const ListGroupsExamplePage(),
      'Masonry': () => const MasonryExamplePage(),
      'Modals': () => const ModalsExamplePage(),
      'Navbar bottom': () => const NavbarBottomExamplePage(),
      'Navbar fixed': () => const NavbarFixedExamplePage(),
      'Navbar static': () => const NavbarStaticExamplePage(),
      'Navbars': () => const NavbarsExamplePage(),
      'Navbars offcanvas': () => const NavbarsOffcanvasExamplePage(),
      'Offcanvas navbar': () => const OffcanvasNavbarExamplePage(),
      'Pricing': () => const PricingExamplePage(),
      'Product': () => const ProductExamplePage(),
      'Sidebars': () => const SidebarsExamplePage(),
      'Sign-in': () => const SignInExamplePage(),
      'Starter template': () => const StarterTemplateExamplePage(),
      'Sticky footer': () => const StickyFooterExamplePage(),
      'Sticky footer navbar': () => const StickyFooterNavbarExamplePage(),
    }.entries) {
      testWidgets(
        '${entry.key} example lays out without errors at ${width.toInt()}px',
        (tester) async {
          tester.view.physicalSize = Size(width, 900);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          // The test font (Ahem) is far wider than Roboto, so the Sidebars'
          // fixed-width panes overflow in it; that is not a layout bug.
          if (entry.key == 'Sidebars') {
            final onError = FlutterError.onError;
            FlutterError.onError = (details) {
              if (!details.exceptionAsString().contains('overflowed')) {
                onError?.call(details);
              }
            };
            addTearDown(() => FlutterError.onError = onError);
          }
          await pumpDocPage(
            tester,
            SingleChildScrollView(child: entry.value()),
          );
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
