import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'package:doc_site/src/example_code.dart';

void main() {
  testWidgets('inline code is .875em of the paragraph it sits in', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      BsApp(
        home: Builder(
          builder: (c) {
            context = c;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(codeSpan(context, 'x').style!.fontSize, 14);
    // An `fs-5` / `.lead` paragraph is 20px: its code is 17.5px.
    expect(codeSpan(context, 'x', parentFontSize: 20).style!.fontSize, 17.5);
  });
}
