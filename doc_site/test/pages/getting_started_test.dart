import 'package:flutter_test/flutter_test.dart';
import 'package:doc_site/pages/getting_started/introduction_page.dart';

import '../test_utils.dart';

void main() {
  testWidgets('Introduction renders without errors', (tester) async {
    await pumpDocPage(tester, const IntroductionPage());

    expect(find.text('Introduction'), findsWidgets);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });
}
