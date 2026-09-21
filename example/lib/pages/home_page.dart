import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'accordion_page.dart';
import 'alert_page.dart';
import 'badge_page.dart';
import 'breadcrumb_page.dart';
import 'breakpoints_page.dart';
import 'button_group_page.dart';
import 'button_page.dart';
import 'card_page.dart';
import 'carousel_page.dart';
import 'close_button_page.dart';
import 'collapse_page.dart';
import 'container_page.dart';
import 'demo_page.dart';
import 'dropdown_page.dart';
import 'figure_page.dart';
import 'list_group_page.dart';
import 'modal_page.dart';
import 'nav_page.dart';
import 'navbar_page.dart';
import 'offcanvas_page.dart';
import 'pagination_page.dart';
import 'placeholder_page.dart';
import 'popover_page.dart';
import 'progress_page.dart';
import 'scrollspy_page.dart';
import 'spinner_page.dart';
import 'table_page.dart';
import 'toast_page.dart';
import 'tooltip_page.dart';
import 'typography_page.dart';

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
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      entry.builder(context),
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
  _PageEntry('Breakpoints', _buildBreakpointsPage),
  _PageEntry('Button', _buildButtonPage),
  _PageEntry('Button group', _buildButtonGroupPage),
  _PageEntry('Card', _buildCardPage),
  _PageEntry('Carousel', _buildCarouselPage),
  _PageEntry('Close button', _buildCloseButtonPage),
  _PageEntry('Collapse', _buildCollapsePage),
  _PageEntry('Container', _buildContainerPage),
  _PageEntry('Dropdown', _buildDropdownPage),
  _PageEntry('Figure', _buildFigurePage),
  _PageEntry('List group', _buildListGroupPage),
  _PageEntry('Modal', _buildModalPage),
  _PageEntry('Navbar', _buildNavbarPage),
  _PageEntry('Navs and tabs', _buildNavPage),
  _PageEntry('Offcanvas', _buildOffcanvasPage),
  _PageEntry('Pagination', _buildPaginationPage),
  _PageEntry('Placeholders', _buildPlaceholderPage),
  _PageEntry('Popovers', _buildPopoverPage),
  _PageEntry('Progress', _buildProgressPage),
  _PageEntry('Scrollspy', _buildScrollspyPage),
  _PageEntry('Spinners', _buildSpinnerPage),
  _PageEntry('Tables', _buildTablePage),
  _PageEntry('Toasts', _buildToastPage),
  _PageEntry('Tooltips', _buildTooltipPage),
  _PageEntry('Typography', _buildTypographyPage),
];

Widget _buildButtonPage(BuildContext context) => const ButtonPage();
Widget _buildButtonGroupPage(BuildContext context) => const ButtonGroupPage();
Widget _buildCardPage(BuildContext context) => const CardPage();
Widget _buildCarouselPage(BuildContext context) => const CarouselPage();
Widget _buildCloseButtonPage(BuildContext context) => const CloseButtonPage();
Widget _buildCollapsePage(BuildContext context) => const CollapsePage();
Widget _buildContainerPage(BuildContext context) => const ContainerPage();
Widget _buildDropdownPage(BuildContext context) => const DropdownPage();
Widget _buildFigurePage(BuildContext context) => const FigurePage();
Widget _buildListGroupPage(BuildContext context) => const ListGroupPage();
Widget _buildModalPage(BuildContext context) => const ModalPage();
Widget _buildNavbarPage(BuildContext context) => const NavbarPage();
Widget _buildNavPage(BuildContext context) => const NavPage();
Widget _buildOffcanvasPage(BuildContext context) => const OffcanvasPage();
Widget _buildPaginationPage(BuildContext context) => const PaginationPage();
Widget _buildPlaceholderPage(BuildContext context) => const PlaceholderPage();
Widget _buildPopoverPage(BuildContext context) => const PopoverPage();
Widget _buildProgressPage(BuildContext context) => const ProgressPage();
Widget _buildScrollspyPage(BuildContext context) => const ScrollspyPage();
Widget _buildSpinnerPage(BuildContext context) => const SpinnerPage();
Widget _buildTablePage(BuildContext context) => const TablePage();
Widget _buildToastPage(BuildContext context) => const ToastPage();
Widget _buildTooltipPage(BuildContext context) => const TooltipPage();
Widget _buildTypographyPage(BuildContext context) => const TypographyPage();
Widget _buildAccordionPage(BuildContext context) => const AccordionPage();
Widget _buildAlertPage(BuildContext context) => const AlertPage();
Widget _buildBadgePage(BuildContext context) => const BadgePage();
Widget _buildBreadcrumbPage(BuildContext context) => const BreadcrumbPage();
Widget _buildBreakpointsPage(BuildContext context) => const BreakpointsPage();
