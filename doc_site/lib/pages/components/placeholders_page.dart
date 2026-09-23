import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class PlaceholdersPage extends StatelessWidget {
  const PlaceholdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Placeholders',
      lead:
          'BsPlaceholder draws a solid or animated block in place of content that has not loaded yet, sized by '
          'width and height and, optionally, pulsed with a glow or wave animation.',
      examples: [
        DocExample(
          title: 'Basic (paragraph)',
          description: 'A column of BsPlaceholders of varying widths mimics loading lines of text.',
          code: '''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    BsPlaceholder(width: 280),
    SizedBox(height: 8),
    BsPlaceholder(),
    SizedBox(height: 8),
    BsPlaceholder(width: 180),
  ],
)''',
          preview: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BsPlaceholder(width: 280),
              SizedBox(height: 8),
              BsPlaceholder(),
              SizedBox(height: 8),
              BsPlaceholder(width: 180),
            ],
          ),
        ),
        DocExample(
          title: 'Sizes',
          description: 'height controls how tall a single placeholder block renders.',
          code: '''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    BsPlaceholder(height: 6),
    SizedBox(height: 8),
    BsPlaceholder(height: 8),
    SizedBox(height: 8),
    BsPlaceholder(height: 16),
    SizedBox(height: 8),
    BsPlaceholder(height: 24),
  ],
)''',
          preview: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BsPlaceholder(height: 6),
              SizedBox(height: 8),
              BsPlaceholder(height: 8),
              SizedBox(height: 8),
              BsPlaceholder(height: 16),
              SizedBox(height: 8),
              BsPlaceholder(height: 24),
            ],
          ),
        ),
        DocExample(
          title: 'Glow animation',
          description: 'animation: BsPlaceholderAnimation.glow fades the block\'s opacity in and out.',
          code: '''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    BsPlaceholder(width: 280, animation: BsPlaceholderAnimation.glow),
    SizedBox(height: 8),
    BsPlaceholder(animation: BsPlaceholderAnimation.glow),
  ],
)''',
          preview: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BsPlaceholder(width: 280, animation: BsPlaceholderAnimation.glow),
              SizedBox(height: 8),
              BsPlaceholder(animation: BsPlaceholderAnimation.glow),
            ],
          ),
        ),
        DocExample(
          title: 'Wave animation',
          description: 'animation: BsPlaceholderAnimation.wave sweeps a highlight across the block left to right.',
          code: '''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    BsPlaceholder(width: 280, animation: BsPlaceholderAnimation.wave),
    SizedBox(height: 8),
    BsPlaceholder(animation: BsPlaceholderAnimation.wave),
  ],
)''',
          preview: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BsPlaceholder(width: 280, animation: BsPlaceholderAnimation.wave),
              SizedBox(height: 8),
              BsPlaceholder(animation: BsPlaceholderAnimation.wave),
            ],
          ),
        ),
        DocExample(
          title: 'Card placeholder',
          description: 'Placeholders composed inside a BsCard preview what a still-loading card looks like.',
          code: '''
BsCard(
  child: Column(
    children: [
      BsCardImg(
        child: BsPlaceholder(height: 140, borderRadius: 0, animation: BsPlaceholderAnimation.glow),
      ),
      BsCardBody(
        children: [
          BsPlaceholder(height: 12, animation: BsPlaceholderAnimation.glow),
          SizedBox(height: 8),
          BsPlaceholder(width: 200, height: 10, animation: BsPlaceholderAnimation.glow),
          SizedBox(height: 4),
          BsPlaceholder(width: 150, height: 10, animation: BsPlaceholderAnimation.glow),
        ],
      ),
    ],
  ),
)''',
          preview: SizedBox(
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
