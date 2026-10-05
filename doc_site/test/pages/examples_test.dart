import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doc_site/pages/examples/headers_example_page.dart';
import 'package:doc_site/pages/examples/heroes_example_page.dart';
import 'package:doc_site/pages/examples/jumbotron_example_page.dart';

import '../test_utils.dart';

void main() {
  for (final width in [375.0, 800.0, 1300.0]) {
    for (final entry in {
      'Headers': () => const HeadersExamplePage(),
      'Heroes': () => const HeroesExamplePage(),
      'Jumbotron': () => const JumbotronExamplePage(),
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
