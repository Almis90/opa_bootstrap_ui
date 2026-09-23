import 'package:flutter_test/flutter_test.dart';
import 'package:doc_site/pages/forms/checks_radios_page.dart';
import 'package:doc_site/pages/forms/floating_labels_page.dart';
import 'package:doc_site/pages/forms/form_control_page.dart';
import 'package:doc_site/pages/forms/input_group_page.dart';
import 'package:doc_site/pages/forms/range_page.dart';
import 'package:doc_site/pages/forms/select_page.dart';

import '../test_utils.dart';

void main() {
  testWidgets('Checks & radios renders without errors', (tester) async {
    await pumpDocPage(tester, const ChecksRadiosPage());

    expect(find.text('Checks & radios'), findsWidgets);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Floating labels renders without errors', (tester) async {
    await pumpDocPage(tester, const FloatingLabelsPage());

    expect(find.text('Floating labels'), findsWidgets);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Form control renders without errors', (tester) async {
    await pumpDocPage(tester, const FormControlPage());

    expect(find.text('Form control'), findsWidgets);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Input group renders without errors', (tester) async {
    await pumpDocPage(tester, const InputGroupPage());

    expect(find.text('Input group'), findsWidgets);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Range renders without errors', (tester) async {
    await pumpDocPage(tester, const RangePage());

    expect(find.text('Range'), findsWidgets);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });

  testWidgets('Select renders without errors', (tester) async {
    await pumpDocPage(tester, const SelectPage());

    expect(find.text('Select'), findsWidgets);
    expect(tester.takeException(), isNull);

    await unmountDocPage(tester);
  });
}
