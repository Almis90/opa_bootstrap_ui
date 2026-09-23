import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

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
      ],
    );
  }
}
