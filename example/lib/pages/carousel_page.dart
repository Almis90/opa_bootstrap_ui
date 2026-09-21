import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class CarouselPage extends StatelessWidget {
  const CarouselPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Carousel',
      children: [
        DemoSection(
          title: 'Basic',
          child: SizedBox(
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
        DemoSection(
          title: 'Captions',
          child: SizedBox(
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
        DemoSection(
          title: 'Fade transition',
          child: SizedBox(
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
        DemoSection(
          title: 'Dark variant',
          child: SizedBox(
            height: 220,
            child: BsCarousel(
              style: const BsCarouselStyle(
                controlColor: BsColors.black,
                indicatorActiveBackground: BsColors.black,
              ),
              items: const [
                BsCarouselItem(child: ColoredBox(color: Color(0xFFE9ECEF))),
                BsCarouselItem(child: ColoredBox(color: Color(0xFFDEE2E6))),
                BsCarouselItem(child: ColoredBox(color: Color(0xFFCED4DA))),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'No controls or indicators',
          child: SizedBox(
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
