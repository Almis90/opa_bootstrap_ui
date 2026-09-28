import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  List<BsCarouselItem> slides(int count) => [
    for (var i = 0; i < count; i++) BsCarouselItem(child: Center(child: Text('Slide $i'))),
  ];

  Widget buildCarousel({
    BsCarouselController? controller,
    int count = 3,
    bool wrap = true,
    BsCarouselTransition transition = BsCarouselTransition.slide,
    Duration? interval,
    ValueChanged<int>? onIndexChanged,
    VoidCallback? onSlide,
    VoidCallback? onSlid,
  }) {
    return BsApp(
      home: SizedBox(
        height: 200,
        width: 400,
        child: BsCarousel(
          controller: controller,
          items: slides(count),
          wrap: wrap,
          transition: transition,
          interval: interval,
          onIndexChanged: onIndexChanged,
          onSlide: onSlide,
          onSlid: onSlid,
        ),
      ),
    );
  }

  testWidgets('Built-in next/prev controls still work without a controller', (tester) async {
    final indexChanges = <int>[];
    await tester.pumpWidget(buildCarousel(interval: null, onIndexChanged: indexChanges.add));

    expect(find.text('Slide 0'), findsOneWidget);

    // The prev/next controls have no text/tooltip to find by — they're
    // hotspots spanning the leading/trailing edge of the carousel.
    final carouselRect = tester.getRect(find.byType(BsCarousel));
    await tester.tapAt(Offset(carouselRect.right - 10, carouselRect.center.dy));
    await tester.pumpAndSettle();
    expect(find.text('Slide 1'), findsOneWidget);
    expect(indexChanges, [1]);

    await tester.tapAt(Offset(carouselRect.left + 10, carouselRect.center.dy));
    await tester.pumpAndSettle();
    expect(find.text('Slide 0'), findsOneWidget);
    expect(indexChanges, [1, 0]);
  });

  testWidgets('BsCarouselController.next/previous/goTo drive navigation', (tester) async {
    final controller = BsCarouselController(itemCount: 3);
    addTearDown(controller.dispose);

    await tester.pumpWidget(buildCarousel(controller: controller, interval: null));
    expect(find.text('Slide 0'), findsOneWidget);
    expect(controller.index, 0);

    controller.next();
    await tester.pumpAndSettle();
    expect(controller.index, 1);
    expect(find.text('Slide 1'), findsOneWidget);

    controller.next();
    await tester.pumpAndSettle();
    expect(controller.index, 2);
    expect(find.text('Slide 2'), findsOneWidget);

    // Wraps past the last slide back to the first (wrap: true default).
    controller.next();
    await tester.pumpAndSettle();
    expect(controller.index, 0);
    expect(find.text('Slide 0'), findsOneWidget);

    controller.previous();
    await tester.pumpAndSettle();
    expect(controller.index, 2);
    expect(find.text('Slide 2'), findsOneWidget);

    controller.goTo(1);
    await tester.pumpAndSettle();
    expect(controller.index, 1);
    expect(find.text('Slide 1'), findsOneWidget);
  });

  testWidgets('wrap: false clamps instead of wrapping', (tester) async {
    final controller = BsCarouselController(itemCount: 3, wrap: false);
    addTearDown(controller.dispose);

    await tester.pumpWidget(buildCarousel(controller: controller, wrap: false, interval: null));

    controller.previous(); // already at 0
    await tester.pumpAndSettle();
    expect(controller.index, 0);

    controller.goTo(2);
    await tester.pumpAndSettle();
    controller.next(); // already at the last slide
    await tester.pumpAndSettle();
    expect(controller.index, 2);
  });

  testWidgets('An explicit controller wins over initialIndex/wrap widget params', (tester) async {
    final controller = BsCarouselController(itemCount: 3, initialIndex: 2);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      buildCarousel(
        controller: controller,
        // These would seed an owned controller differently, but are
        // ignored entirely once an explicit controller is given.
        interval: null,
      ),
    );

    expect(controller.index, 2);
    expect(find.text('Slide 2'), findsOneWidget);
  });

  testWidgets('pause()/cycle() gate autoplay independent of hover', (tester) async {
    final controller = BsCarouselController(itemCount: 3);
    addTearDown(controller.dispose);

    await tester.pumpWidget(buildCarousel(controller: controller, interval: const Duration(milliseconds: 100)));

    controller.pause();
    // Crosses the 100ms/200ms autoplay ticks while paused — both must be
    // no-ops (Timer.periodic keeps ticking on schedule regardless; only
    // the isPaused check inside each tick suppresses the advance).
    await tester.pump(const Duration(milliseconds: 250));
    expect(controller.index, 0);

    controller.cycle();
    // Crosses exactly the next tick (at the 300ms mark) and no further.
    await tester.pump(const Duration(milliseconds: 80));
    expect(controller.index, 1);
  });

  testWidgets('onSlide/onSlid fire in order for a controller-driven transition', (tester) async {
    final controller = BsCarouselController(itemCount: 3);
    addTearDown(controller.dispose);
    final events = <String>[];

    await tester.pumpWidget(
      buildCarousel(
        controller: controller,
        interval: null,
        onSlide: () => events.add('slide'),
        onSlid: () => events.add('slid'),
      ),
    );

    controller.next();
    expect(events, ['slide']);
    await tester.pumpAndSettle();
    expect(events, ['slide', 'slid']);
  });

  testWidgets('An organic swipe syncs controller.index and fires onSlide/onSlid', (tester) async {
    final controller = BsCarouselController(itemCount: 3);
    addTearDown(controller.dispose);
    final events = <String>[];

    await tester.pumpWidget(
      buildCarousel(
        controller: controller,
        interval: null,
        onSlide: () => events.add('slide'),
        onSlid: () => events.add('slid'),
      ),
    );

    await tester.fling(find.text('Slide 0'), const Offset(-300, 0), 800);
    await tester.pumpAndSettle();

    expect(controller.index, 1);
    expect(find.text('Slide 1'), findsOneWidget);
    expect(events, ['slide', 'slid']);
  });

  testWidgets('Fade transition: controller-driven navigation and onSlide/onSlid', (tester) async {
    final controller = BsCarouselController(itemCount: 3);
    addTearDown(controller.dispose);
    final events = <String>[];

    await tester.pumpWidget(
      buildCarousel(
        controller: controller,
        interval: null,
        transition: BsCarouselTransition.fade,
        onSlide: () => events.add('slide'),
        onSlid: () => events.add('slid'),
      ),
    );
    expect(find.text('Slide 0'), findsOneWidget);

    controller.next();
    expect(events, ['slide']);
    await tester.pumpAndSettle();
    expect(find.text('Slide 1'), findsOneWidget);
    expect(events, ['slide', 'slid']);
  });
}
