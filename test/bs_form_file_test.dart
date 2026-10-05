import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  Future<Size> sizeOf(WidgetTester tester, BsFormFile file) async {
    await tester.pumpWidget(
      BsApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: 400, child: file),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return tester.getSize(find.byType(BsFormFile));
  }

  // `$input-height`: line height + padding + borders, as for `.form-control`.
  testWidgets('is as tall as a text input, per size', (tester) async {
    expect((await sizeOf(tester, BsFormFile(onPressed: () {}))).height, 38);
    expect(
      (await sizeOf(
        tester,
        BsFormFile(size: BsFormControlSize.small, onPressed: () {}),
      )).height,
      31,
    );
    expect(
      (await sizeOf(
        tester,
        BsFormFile(size: BsFormControlSize.large, onPressed: () {}),
      )).height,
      48,
    );
  });

  testWidgets('shows the file name once chosen, and taps', (tester) async {
    var taps = 0;
    await sizeOf(tester, BsFormFile(onPressed: () => taps++));
    expect(find.text('No file chosen'), findsOneWidget);
    await tester.tap(find.text('Choose File'));
    expect(taps, 1);
    await sizeOf(tester, BsFormFile(fileName: 'photo.png', onPressed: () {}));
    expect(find.text('photo.png'), findsOneWidget);
    expect(find.text('No file chosen'), findsNothing);
  });
}
