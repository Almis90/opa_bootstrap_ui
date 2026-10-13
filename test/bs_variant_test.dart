import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  Future<List<Color>> read(WidgetTester tester, Brightness brightness) async {
    late List<Color> colors;
    await tester.pumpWidget(
      BsApp(
        brightness: brightness,
        home: Builder(
          builder: (context) {
            colors = [
              BsVariant.info.textEmphasisOf(context),
              BsVariant.info.bgSubtleOf(context),
              BsVariant.info.borderSubtleOf(context),
            ];
            return const SizedBox();
          },
        ),
      ),
    );
    return colors;
  }

  testWidgets('the Of getters pick the light colors in light mode', (
    tester,
  ) async {
    expect(await read(tester, Brightness.light), [
      BsVariant.info.textEmphasis,
      BsVariant.info.bgSubtle,
      BsVariant.info.borderSubtle,
    ]);
  });

  testWidgets('the Of getters pick the dark colors in dark mode', (
    tester,
  ) async {
    expect(await read(tester, Brightness.dark), [
      BsVariant.info.darkTextEmphasis,
      BsVariant.info.darkBgSubtle,
      BsVariant.info.darkBorderSubtle,
    ]);
  });
}
