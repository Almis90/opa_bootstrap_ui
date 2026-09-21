import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Card',
      children: [
        DemoSection(
          title: 'Basic',
          child: SizedBox(
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
        DemoSection(
          title: 'Header and footer',
          child: SizedBox(
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
                        child: BsCardText(
                          child: Text('With supporting text below as a natural lead-in to additional content.'),
                        ),
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
        DemoSection(
          title: 'Image caps',
          child: SizedBox(
            width: 320,
            child: BsCard(
              child: Column(
                children: [
                  const BsCardImg(
                    position: BsCardImgPosition.top,
                    child: ColoredBox(
                      color: Color(0xFFADB5BD),
                      child: SizedBox(height: 140, width: double.infinity),
                    ),
                  ),
                  BsCardBody(
                    children: [
                      const BsCardTitle(child: Text('Card title')),
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: BsCardText(
                          child: Text('Some quick example text to build on the card title.'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        DemoSection(
          title: 'Image overlay',
          child: SizedBox(
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
        DemoSection(
          title: 'Card group',
          child: BsCardGroup(
            children: [
              BsCard(
                child: Column(
                  children: [
                    const BsCardImg(
                      position: BsCardImgPosition.top,
                      child: ColoredBox(
                        color: Color(0xFFADB5BD),
                        child: SizedBox(height: 140, width: double.infinity),
                      ),
                    ),
                    BsCardBody(
                      children: const [
                        BsCardTitle(child: Text('Card title 1')),
                        BsCardText(child: Text('This is a wider card with supporting text.')),
                      ],
                    ),
                    const BsCardFooter(child: Text('Last updated 3 mins ago')),
                  ],
                ),
              ),
              BsCard(
                child: Column(
                  children: [
                    const BsCardImg(
                      position: BsCardImgPosition.top,
                      child: ColoredBox(
                        color: Color(0xFFADB5BD),
                        child: SizedBox(height: 140, width: double.infinity),
                      ),
                    ),
                    BsCardBody(
                      children: const [
                        BsCardTitle(child: Text('Card title 2')),
                        BsCardText(child: Text('This card has supporting text below as a natural lead-in.')),
                      ],
                    ),
                    const BsCardFooter(child: Text('Last updated 3 mins ago')),
                  ],
                ),
              ),
              BsCard(
                child: Column(
                  children: [
                    const BsCardImg(
                      position: BsCardImgPosition.top,
                      child: ColoredBox(
                        color: Color(0xFFADB5BD),
                        child: SizedBox(height: 140, width: double.infinity),
                      ),
                    ),
                    BsCardBody(
                      children: const [
                        BsCardTitle(child: Text('Card title 3')),
                        BsCardText(child: Text('This is a wider card with supporting text below.')),
                      ],
                    ),
                    const BsCardFooter(child: Text('Last updated 3 mins ago')),
                  ],
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Custom style',
          child: SizedBox(
            width: 320,
            child: BsCard(
              style: const BsCardStyle(
                borderColor: BsColors.blue,
                background: Color(0xFFF4F8FF),
                capBackground: BsColors.blue,
                capColor: BsColors.white,
              ),
              child: Column(
                children: [
                  const BsCardHeader(child: Text('Header')),
                  const BsCardBody(children: [BsCardText(child: Text('This card has custom colors.'))]),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
