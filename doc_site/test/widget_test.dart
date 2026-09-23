import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doc_site/main.dart';

void main() {
  testWidgets('Docs site loads with the Introduction page selected', (WidgetTester tester) async {
    await tester.pumpWidget(const DocApp());
    await tester.pumpAndSettle();

    expect(find.text('Introduction'), findsWidgets);
    expect(find.text('GETTING STARTED'), findsOneWidget);
    expect(
      find.textContaining('opa_bootstrap_ui ports Bootstrap 5 components'),
      findsOneWidget,
    );
  });
}
