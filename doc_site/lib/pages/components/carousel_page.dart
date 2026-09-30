import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';
import '../../src/doc_style_table.dart';

class CarouselPage extends StatelessWidget {
  const CarouselPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Carousel',
      lead:
          'BsCarousel cycles through a list of BsCarouselItem slides with swipeable/animated transitions, built-in '
          'previous/next controls, and position indicators — no external timer or PageController required.',
      examples: [
        DocExample(
          title: 'Basic',
          description: 'The default slide transition with controls and indicators enabled.',
          code: '''
BsCarousel(
  items: [
    BsCarouselItem(child: ColoredBox(color: Color(0xFF495057))),
    BsCarouselItem(child: ColoredBox(color: Color(0xFF6C757D))),
    BsCarouselItem(child: ColoredBox(color: Color(0xFFADB5BD))),
  ],
)''',
          preview: SizedBox(
            height: 220,
            child: BsCarousel(
              items: const [
                BsCarouselItem(child: ColoredBox(color: Color(0xFF495057))),
                BsCarouselItem(child: ColoredBox(color: Color(0xFF6C757D))),
                BsCarouselItem(child: ColoredBox(color: Color(0xFFADB5BD))),
              ],
            ),
          ),
        ),
        DocExample(
          title: 'Captions',
          description: 'caption overlays a widget (typically a heading and blurb) at the bottom of a slide.',
          code: '''
BsCarousel(
  items: [
    BsCarouselItem(
      child: ColoredBox(color: Color(0xFF495057)),
      caption: Column(
        children: [
          Text('First slide label', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Some representative placeholder content for the first slide.'),
        ],
      ),
    ),
  ],
)''',
          preview: SizedBox(
            height: 220,
            child: BsCarousel(
              items: [
                BsCarouselItem(
                  child: const ColoredBox(color: Color(0xFF495057)),
                  caption: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('First slide label', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Some representative placeholder content for the first slide.'),
                    ],
                  ),
                ),
                BsCarouselItem(
                  child: const ColoredBox(color: Color(0xFF6C757D)),
                  caption: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Second slide label', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Some representative placeholder content for the second slide.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        DocExample(
          title: 'Fade transition',
          description: 'transition: BsCarouselTransition.fade cross-fades slides instead of sliding them horizontally.',
          code: '''
BsCarousel(
  transition: BsCarouselTransition.fade,
  items: [
    BsCarouselItem(child: ColoredBox(color: Color(0xFF495057))),
    BsCarouselItem(child: ColoredBox(color: Color(0xFF6C757D))),
    BsCarouselItem(child: ColoredBox(color: Color(0xFFADB5BD))),
  ],
)''',
          preview: SizedBox(
            height: 220,
            child: BsCarousel(
              transition: BsCarouselTransition.fade,
              items: const [
                BsCarouselItem(child: ColoredBox(color: Color(0xFF495057))),
                BsCarouselItem(child: ColoredBox(color: Color(0xFF6C757D))),
                BsCarouselItem(child: ColoredBox(color: Color(0xFFADB5BD))),
              ],
            ),
          ),
        ),
        DocExample(
          title: 'Dark variant',
          description: 'style overrides controlColor and indicatorActiveBackground to suit a light slide background.',
          code: '''
BsCarousel(
  style: BsCarouselStyle(
    controlColor: BsColors.black,
    indicatorActiveBackground: BsColors.black,
  ),
  items: [
    BsCarouselItem(child: ColoredBox(color: Color(0xFFE9ECEF))),
    BsCarouselItem(child: ColoredBox(color: Color(0xFFDEE2E6))),
    BsCarouselItem(child: ColoredBox(color: Color(0xFFCED4DA))),
  ],
)''',
          preview: SizedBox(
            height: 220,
            child: BsCarousel(
              style: const BsCarouselStyle(controlColor: BsColors.black, indicatorActiveBackground: BsColors.black),
              items: const [
                BsCarouselItem(child: ColoredBox(color: Color(0xFFE9ECEF))),
                BsCarouselItem(child: ColoredBox(color: Color(0xFFDEE2E6))),
                BsCarouselItem(child: ColoredBox(color: Color(0xFFCED4DA))),
              ],
            ),
          ),
        ),
        DocExample(
          title: 'No controls or indicators',
          description: 'showControls and showIndicators can each be turned off independently for a bare slideshow.',
          code: '''
BsCarousel(
  showControls: false,
  showIndicators: false,
  items: [
    BsCarouselItem(child: ColoredBox(color: Color(0xFF495057))),
    BsCarouselItem(child: ColoredBox(color: Color(0xFF6C757D))),
  ],
)''',
          preview: SizedBox(
            height: 220,
            child: BsCarousel(
              showControls: false,
              showIndicators: false,
              items: const [
                BsCarouselItem(child: ColoredBox(color: Color(0xFF495057))),
                BsCarouselItem(child: ColoredBox(color: Color(0xFF6C757D))),
              ],
            ),
          ),
        ),
        DocExample(
          title: 'Programmatic control',
          description:
              'A BsCarouselController lets code outside next()/previous()/goTo() the carousel, or pause()/cycle() '
              'autoplay independently of pauseOnHover — needs itemCount up front (the same tradeoff '
              "Flutter's own TabController makes with length) since navigation resolves wraparound.",
          code: '''
final controller = BsCarouselController(itemCount: 3);

Column(
  children: [
    Wrap(
      spacing: 8,
      children: [
        BsButton(onPressed: controller.previous, child: Text('Previous')),
        BsButton(onPressed: controller.next, child: Text('Next')),
        BsButton(onPressed: controller.pause, child: Text('Pause')),
        BsButton(onPressed: controller.cycle, child: Text('Resume')),
      ],
    ),
    SizedBox(
      height: 220,
      child: BsCarousel(
        controller: controller,
        items: [
          BsCarouselItem(child: ColoredBox(color: Color(0xFF495057))),
          BsCarouselItem(child: ColoredBox(color: Color(0xFF6C757D))),
          BsCarouselItem(child: ColoredBox(color: Color(0xFFADB5BD))),
        ],
      ),
    ),
  ],
)''',
          preview: const _ControllerDemo(),
        ),
        DocExample(
          title: 'Events',
          description:
              'onSlide fires as soon as a transition to a new slide is triggered — by autoplay, a control, an '
              'indicator, or a swipe — before it starts animating; onSlid fires once it visually finishes. '
              "Mirrors Bootstrap's slide.bs.carousel/slid.bs.carousel.",
          code: '''
BsCarousel(
  interval: null,
  onSlide: () => log('slide'),
  onSlid: () => log('slid'),
  items: [
    BsCarouselItem(child: ColoredBox(color: Color(0xFF495057))),
    BsCarouselItem(child: ColoredBox(color: Color(0xFF6C757D))),
    BsCarouselItem(child: ColoredBox(color: Color(0xFFADB5BD))),
  ],
)''',
          preview: const _EventsDemo(),
        ),
      ],
      children: const [
        DocStyleTable(
          styleClass: 'BsCarouselStyle',
          rows: [
            DocStyleRow(field: 'controlColor', defaultValue: 'BsColors.white'),
            DocStyleRow(field: 'controlWidthFraction', defaultValue: '0.15 (15% of the carousel width, each side)'),
            DocStyleRow(field: 'controlOpacity', defaultValue: '0.5'),
            DocStyleRow(field: 'controlHoverOpacity', defaultValue: '0.9'),
            DocStyleRow(field: 'controlTransitionDuration', defaultValue: '150ms'),
            DocStyleRow(field: 'controlIconSize', defaultValue: '32'),
            DocStyleRow(field: 'indicatorWidth', defaultValue: '30'),
            DocStyleRow(field: 'indicatorHeight', defaultValue: '3'),
            DocStyleRow(field: 'indicatorHitAreaHeight', defaultValue: '10'),
            DocStyleRow(field: 'indicatorSpacer', defaultValue: '3'),
            DocStyleRow(field: 'indicatorOpacity', defaultValue: '0.5'),
            DocStyleRow(field: 'indicatorActiveBackground', defaultValue: 'BsColors.white'),
            DocStyleRow(field: 'indicatorActiveOpacity', defaultValue: '1'),
            DocStyleRow(field: 'indicatorTransitionDuration', defaultValue: '600ms'),
            DocStyleRow(field: 'captionWidthFraction', defaultValue: '0.7 (70% of the carousel width)'),
            DocStyleRow(field: 'captionColor', defaultValue: 'BsColors.white'),
            DocStyleRow(field: 'captionPaddingY', defaultValue: '20'),
            DocStyleRow(field: 'captionSpacer', defaultValue: '20'),
            DocStyleRow(field: 'transitionDuration', defaultValue: '600ms'),
          ],
        ),
      ],
    );
  }
}

class _ControllerDemo extends StatefulWidget {
  const _ControllerDemo();

  @override
  State<_ControllerDemo> createState() => _ControllerDemoState();
}

class _ControllerDemoState extends State<_ControllerDemo> {
  late final BsCarouselController _controller = BsCarouselController(itemCount: 3);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            BsButton(size: BsSize.sm, onPressed: _controller.previous, child: const Text('Previous')),
            BsButton(size: BsSize.sm, onPressed: _controller.next, child: const Text('Next')),
            BsButton(
              size: BsSize.sm,
              variant: BsVariant.secondary,
              onPressed: _controller.pause,
              child: const Text('Pause'),
            ),
            BsButton(
              size: BsSize.sm,
              variant: BsVariant.secondary,
              onPressed: _controller.cycle,
              child: const Text('Resume'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          width: double.infinity,
          child: BsCarousel(
            controller: _controller,
            items: const [
              BsCarouselItem(child: ColoredBox(color: Color(0xFF495057))),
              BsCarouselItem(child: ColoredBox(color: Color(0xFF6C757D))),
              BsCarouselItem(child: ColoredBox(color: Color(0xFFADB5BD))),
            ],
          ),
        ),
      ],
    );
  }
}

class _EventsDemo extends StatefulWidget {
  const _EventsDemo();

  @override
  State<_EventsDemo> createState() => _EventsDemoState();
}

class _EventsDemoState extends State<_EventsDemo> {
  final _events = <String>[];

  void _log(String event) => setState(() => _events.add(event));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
          width: double.infinity,
          child: BsCarousel(
            interval: null,
            onSlide: () => _log('slide'),
            onSlid: () => _log('slid'),
            items: const [
              BsCarouselItem(child: ColoredBox(color: Color(0xFF495057))),
              BsCarouselItem(child: ColoredBox(color: Color(0xFF6C757D))),
              BsCarouselItem(child: ColoredBox(color: Color(0xFFADB5BD))),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_events.isEmpty)
          Text(
            'No events yet — use the controls or swipe above.',
            style: TextStyle(color: BsBody.secondaryColorOf(context)),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final event in _events) BsBadge(variant: BsVariant.secondary, child: Text(event))],
          ),
      ],
    );
  }
}
