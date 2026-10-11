import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'package:doc_site/src/example_file_input.dart';

void main() {
  testWidgets(
    'a file input shows what was chosen before, and a disabled one ignores taps',
    (tester) async {
      await tester.pumpWidget(
        const BsApp(
          home: Column(
            children: [
              ExampleFileInput(initialFileName: 'photo.png'),
              ExampleFileInput(enabled: false),
            ],
          ),
        ),
      );
      expect(find.text('photo.png'), findsOneWidget);
      expect(find.text('No file chosen'), findsOneWidget);

      // Off the web there is no file dialog: tapping chooses nothing and keeps the name.
      await tester.tap(find.text('Choose File').first);
      await tester.pump();
      expect(find.text('photo.png'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
