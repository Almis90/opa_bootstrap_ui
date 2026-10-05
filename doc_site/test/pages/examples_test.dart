import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

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

import '../test_utils.dart';

void main() {
  for (final width in [375.0, 1000.0, 1300.0]) {
    for (final entry in {
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
    }.entries) {
      testWidgets('${entry.key} example lays out without errors at ${width.toInt()}px', (tester) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await pumpDocPage(tester, SingleChildScrollView(child: entry.value()));
        expect(tester.takeException(), isNull);
      });
    }
  }
}
