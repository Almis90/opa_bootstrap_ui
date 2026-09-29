import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  Brightness? resolvedIn(BuildContext context) => BsTheme.of(context);

  testWidgets('brightness defaults to light, unchanged from before', (tester) async {
    Brightness? resolved;
    await tester.pumpWidget(
      BsApp(
        home: Builder(
          builder: (context) {
            resolved = resolvedIn(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(resolved, Brightness.light);
  });

  testWidgets('an explicit brightness is installed as-is, unchanged from before', (tester) async {
    Brightness? resolved;
    await tester.pumpWidget(
      BsApp(
        brightness: Brightness.dark,
        home: Builder(
          builder: (context) {
            resolved = resolvedIn(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(resolved, Brightness.dark);
  });

  testWidgets('brightness: null (data-bs-theme="auto") follows the platform brightness', (tester) async {
    Brightness? resolved;
    Widget buildApp() => MediaQuery(
      data: const MediaQueryData(platformBrightness: Brightness.dark),
      child: BsApp(
        brightness: null,
        home: Builder(
          builder: (context) {
            resolved = resolvedIn(context);
            return const SizedBox();
          },
        ),
      ),
    );

    await tester.pumpWidget(buildApp());
    expect(resolved, Brightness.dark);
  });

  testWidgets('brightness: null updates live if the platform brightness changes while running', (tester) async {
    Brightness? resolved;
    Widget buildApp(Brightness platformBrightness) => MediaQuery(
      data: MediaQueryData(platformBrightness: platformBrightness),
      child: BsApp(
        brightness: null,
        home: Builder(
          builder: (context) {
            resolved = resolvedIn(context);
            return const SizedBox();
          },
        ),
      ),
    );

    await tester.pumpWidget(buildApp(Brightness.light));
    expect(resolved, Brightness.light);

    await tester.pumpWidget(buildApp(Brightness.dark));
    expect(resolved, Brightness.dark);
  });
}
