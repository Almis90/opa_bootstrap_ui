import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  testWidgets('the caption sits 8 under the image and aligns with its width', (
    tester,
  ) async {
    await tester.pumpWidget(
      BsApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              BsFigure(
                image: SizedBox(key: Key('image'), width: 400, height: 300),
                caption: BsBox(
                  textAlign: BsTextAlign.end,
                  child: BsFigureCaption(child: Text('A caption')),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final image = tester.getRect(find.byKey(const Key('image')));
    final caption = tester.getRect(find.text('A caption'));
    expect(tester.getSize(find.byType(BsFigure)).width, 400);
    expect(caption.top, image.bottom + 8);
    expect(caption.right, image.right);
  });

  testWidgets('a figure keeps its width where its parent is tight', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 800,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BsFigure(
                  image: SizedBox(key: Key('image'), width: 400, height: 300),
                  caption: BsFigureCaption(child: Text('A caption')),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final content = find.descendant(
      of: find.byType(BsFigure),
      matching: find.byType(IntrinsicWidth),
    );
    expect(tester.getSize(content).width, 400);
    expect(tester.getRect(find.byKey(const Key('image'))).left, 0);
  });

  test('the caption defaults to the secondary color of the body', () {
    expect(BsFigureStyle.defaultCaptionColor, BsBody.secondaryColor);
    expect(BsTableStyle.defaultCaptionColor, BsBody.secondaryColor);
  });
}
