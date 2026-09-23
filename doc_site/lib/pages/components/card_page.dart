import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Card',
      lead:
          'BsCard is a flexible content container built from a handful of composable pieces — '
          'BsCardBody, BsCardHeader/Footer, BsCardImg(Overlay), and BsCardGroup — rather than one '
          'monolithic widget with a dozen optional slots.',
      examples: [
        DocExample(
          title: 'Basic',
          description: 'BsCardBody lays out title, subtitle, text, and links with Bootstrap\'s standard card spacing.',
          code: '''
BsCard(
  child: BsCardBody(
    children: [
      BsCardTitle(child: Text('Card title')),
      BsCardSubtitle(child: Text('Card subtitle')),
      BsCardText(child: Text("Some quick example text.")),
      Wrap(
        spacing: 16,
        children: [
          BsCardLink(onTap: () {}, child: Text('Card link')),
          BsCardLink(onTap: () {}, child: Text('Another link')),
        ],
      ),
    ],
  ),
)''',
          preview: SizedBox(
            width: 320,
            child: BsCard(
              child: BsCardBody(
                children: [
                  const BsCardTitle(child: Text('Card title')),
                  const BsCardSubtitle(child: Text('Card subtitle')),
                  const Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    child: BsCardText(
                      child: Text('Some quick example text to build on the card title and make up the bulk of the card\'s content.'),
                    ),
                  ),
                  Wrap(
                    spacing: 16,
                    children: [
                      BsCardLink(onTap: () {}, child: const Text('Card link')),
                      BsCardLink(onTap: () {}, child: const Text('Another link')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        DocExample(
          title: 'Header and footer',
          description: 'BsCardHeader and BsCardFooter bracket the body with a tinted, bordered strip.',
          code: '''
BsCard(
  child: Column(
    children: [
      BsCardHeader(child: Text('Featured')),
      BsCardBody(children: [
        BsCardTitle(child: Text('Special title treatment')),
        BsCardText(child: Text('With supporting text below.')),
        BsButton(onPressed: () {}, child: Text('Go somewhere')),
      ]),
      BsCardFooter(child: Text('2 days ago')),
    ],
  ),
)''',
          preview: SizedBox(
            width: 320,
            child: BsCard(
              child: Column(
                children: [
                  const BsCardHeader(child: Text('Featured')),
                  BsCardBody(
                    children: [
                      const BsCardTitle(child: Text('Special title treatment')),
                      const Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 12),
                        child: BsCardText(child: Text('With supporting text below as a natural lead-in to additional content.')),
                      ),
                      BsButton(onPressed: () {}, child: const Text('Go somewhere')),
                    ],
                  ),
                  const BsCardFooter(child: Text('2 days ago')),
                ],
              ),
            ),
          ),
        ),
        DocExample(
          title: 'Image caps',
          description: 'BsCardImg with position: top or bottom caps the card above or below the body.',
          code: '''
BsCard(
  child: Column(
    children: [
      BsCardImg(position: BsCardImgPosition.top, child: image),
      BsCardBody(children: [
        BsCardTitle(child: Text('Card title')),
        BsCardText(child: Text('Some quick example text.')),
      ]),
    ],
  ),
)''',
          preview: SizedBox(
            width: 320,
            child: BsCard(
              child: Column(
                children: [
                  const BsCardImg(
                    position: BsCardImgPosition.top,
                    child: ColoredBox(color: Color(0xFFADB5BD), child: SizedBox(height: 140, width: double.infinity)),
                  ),
                  BsCardBody(
                    children: [
                      const BsCardTitle(child: Text('Card title')),
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: BsCardText(child: Text('Some quick example text to build on the card title.')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        DocExample(
          title: 'Image overlay',
          description: 'BsCardImgOverlay stacks text directly over an image, rather than beside it.',
          code: '''
BsCard(
  child: Stack(
    children: [
      image,
      BsCardImgOverlay(
        child: DefaultTextStyle.merge(
          style: TextStyle(color: BsColors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BsCardTitle(child: Text('Card title')),
              BsCardText(child: Text('Supporting text.')),
            ],
          ),
        ),
      ),
    ],
  ),
)''',
          preview: SizedBox(
            width: 320,
            height: 180,
            child: BsCard(
              child: Stack(
                children: [
                  const ColoredBox(color: Color(0xFF495057), child: SizedBox(height: 180, width: double.infinity)),
                  BsCardImgOverlay(
                    child: DefaultTextStyle.merge(
                      style: const TextStyle(color: BsColors.white),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BsCardTitle(child: Text('Card title')),
                          BsCardText(child: Text('This is a wider card with supporting text as a natural lead-in.')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        DocExample(
          title: 'Card group',
          description: 'BsCardGroup renders a row of equal-height cards with shared, collapsed borders.',
          code: '''
BsCardGroup(
  children: [
    BsCard(child: ...),
    BsCard(child: ...),
    BsCard(child: ...),
  ],
)''',
          preview: BsCardGroup(
            children: [
              for (final n in [1, 2, 3])
                BsCard(
                  child: Column(
                    children: [
                      const BsCardImg(
                        position: BsCardImgPosition.top,
                        child: ColoredBox(color: Color(0xFFADB5BD), child: SizedBox(height: 140, width: double.infinity)),
                      ),
                      BsCardBody(
                        children: [
                          BsCardTitle(child: Text('Card title $n')),
                          const BsCardText(child: Text('This is a wider card with supporting text.')),
                        ],
                      ),
                      const BsCardFooter(child: Text('Last updated 3 mins ago')),
                    ],
                  ),
                ),
            ],
          ),
        ),
        DocExample(
          title: 'Custom style',
          description: 'style layers a BsCardStyle for one-off border, background, and cap colors.',
          code: '''
BsCard(
  style: const BsCardStyle(
    borderColor: BsColors.blue,
    background: Color(0xFFF4F8FF),
    capBackground: BsColors.blue,
    capColor: BsColors.white,
  ),
  child: Column(
    children: [
      BsCardHeader(child: Text('Header')),
      BsCardBody(children: [BsCardText(child: Text('This card has custom colors.'))]),
    ],
  ),
)''',
          preview: SizedBox(
            width: 320,
            child: BsCard(
              style: const BsCardStyle(
                borderColor: BsColors.blue,
                background: Color(0xFFF4F8FF),
                capBackground: BsColors.blue,
                capColor: BsColors.white,
              ),
              child: const Column(
                children: [
                  BsCardHeader(child: Text('Header')),
                  BsCardBody(children: [BsCardText(child: Text('This card has custom colors.'))]),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
