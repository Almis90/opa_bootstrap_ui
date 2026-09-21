import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Placeholders',
      children: [
        DemoSection(
          title: 'Basic (paragraph)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BsPlaceholder(width: 280),
              const SizedBox(height: 8),
              const BsPlaceholder(),
              const SizedBox(height: 8),
              BsPlaceholder(width: 180),
            ],
          ),
        ),
        DemoSection(
          title: 'Sizes',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BsPlaceholder(height: 6),
              const SizedBox(height: 8),
              const BsPlaceholder(height: 8),
              const SizedBox(height: 8),
              const BsPlaceholder(height: 16),
              const SizedBox(height: 8),
              const BsPlaceholder(height: 24),
            ],
          ),
        ),
        DemoSection(
          title: 'Glow animation',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BsPlaceholder(width: 280, animation: BsPlaceholderAnimation.glow),
              const SizedBox(height: 8),
              const BsPlaceholder(animation: BsPlaceholderAnimation.glow),
            ],
          ),
        ),
        DemoSection(
          title: 'Wave animation',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BsPlaceholder(width: 280, animation: BsPlaceholderAnimation.wave),
              const SizedBox(height: 8),
              const BsPlaceholder(animation: BsPlaceholderAnimation.wave),
            ],
          ),
        ),
        DemoSection(
          title: 'Card placeholder',
          child: SizedBox(
            width: 280,
            child: BsCard(
              child: Column(
                children: [
                  const BsCardImg(
                    child: BsPlaceholder(height: 140, borderRadius: 0, animation: BsPlaceholderAnimation.glow),
                  ),
                  BsCardBody(
                    children: [
                      const SizedBox(height: 4),
                      const BsPlaceholder(height: 12, animation: BsPlaceholderAnimation.glow),
                      const SizedBox(height: 8),
                      BsPlaceholder(width: 200, height: 10, animation: BsPlaceholderAnimation.glow),
                      const SizedBox(height: 4),
                      BsPlaceholder(width: 150, height: 10, animation: BsPlaceholderAnimation.glow),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
