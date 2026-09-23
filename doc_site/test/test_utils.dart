import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

/// Pumps [page] inside the same `WidgetsApp` shell `main.dart` uses, then
/// advances a bounded number of frames.
///
/// Deliberately avoids `pumpAndSettle`: several pages carry continuously
/// repeating animations or timers (carousel autoplay, spinners, indeterminate
/// progress), which never "settle" and would make `pumpAndSettle` throw.
Future<void> pumpDocPage(WidgetTester tester, Widget page) async {
  await tester.pumpWidget(
    WidgetsApp(
      color: BsColors.blue,
      builder: (context, child) => DefaultTextStyle(
        style: const TextStyle(color: BsColors.gray900),
        child: child!,
      ),
      home: page,
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      ),
    ),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Unmounts the current widget tree so `State.dispose()` runs (cancelling
/// any timers/animation controllers) before the test ends, avoiding
/// "pending timer" test failures from pages with autoplay/animation.
Future<void> unmountDocPage(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
}
