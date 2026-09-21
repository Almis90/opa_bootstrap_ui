import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'accordion_page.dart';
import 'alert_page.dart';
import 'badge_page.dart';
import 'breadcrumb_page.dart';
import 'button_group_page.dart';
import 'button_page.dart';
import 'card_page.dart';
import 'carousel_page.dart';
import 'close_button_page.dart';
import 'demo_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'opa_bootstrap_ui',
      children: [
        for (final entry in _pages)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: BsButton(
              outline: true,
              onPressed: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => entry.builder(context),
                ),
              ),
              child: SizedBox(width: 200, child: Text(entry.title)),
            ),
          ),
      ],
    );
  }
}

class _PageEntry {
  const _PageEntry(this.title, this.builder);

  final String title;
  final WidgetBuilder builder;
}

const _pages = [
  _PageEntry('Accordion', _buildAccordionPage),
  _PageEntry('Alert', _buildAlertPage),
  _PageEntry('Badge', _buildBadgePage),
  _PageEntry('Breadcrumb', _buildBreadcrumbPage),
  _PageEntry('Button', _buildButtonPage),
  _PageEntry('Button group', _buildButtonGroupPage),
  _PageEntry('Card', _buildCardPage),
  _PageEntry('Carousel', _buildCarouselPage),
  _PageEntry('Close button', _buildCloseButtonPage),
];

Widget _buildButtonPage(BuildContext context) => const ButtonPage();
Widget _buildButtonGroupPage(BuildContext context) => const ButtonGroupPage();
Widget _buildCardPage(BuildContext context) => const CardPage();
Widget _buildCarouselPage(BuildContext context) => const CarouselPage();
Widget _buildCloseButtonPage(BuildContext context) => const CloseButtonPage();
Widget _buildAccordionPage(BuildContext context) => const AccordionPage();
Widget _buildAlertPage(BuildContext context) => const AlertPage();
Widget _buildBadgePage(BuildContext context) => const BadgePage();
Widget _buildBreadcrumbPage(BuildContext context) => const BreadcrumbPage();
