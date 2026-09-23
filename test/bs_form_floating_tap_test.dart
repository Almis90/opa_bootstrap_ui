import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  testWidgets('Tapping BsFormFloating focuses the field and floats the label', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: BsFormFloating(label: Text('Email address')),
      ),
    );

    Alignment alignmentOf() => tester.widget<AnimatedAlign>(find.byType(AnimatedAlign)).alignment as Alignment;
    expect(alignmentOf(), Alignment.centerLeft);

    await tester.tap(find.byType(BsFormFloating));
    await tester.pump(const Duration(milliseconds: 150));

    expect(alignmentOf(), Alignment.topLeft);
    expect(tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus, true);
  });
}
