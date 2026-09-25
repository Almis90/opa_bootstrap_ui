import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'pages/components/accordion_page.dart';
import 'pages/components/alerts_page.dart';
import 'pages/components/badge_page.dart';
import 'pages/components/breadcrumb_page.dart';
import 'pages/components/button_group_page.dart';
import 'pages/components/buttons_page.dart';
import 'pages/components/card_page.dart';
import 'pages/components/carousel_page.dart';
import 'pages/components/close_button_page.dart';
import 'pages/components/collapse_page.dart';
import 'pages/components/dropdowns_page.dart';
import 'pages/components/list_group_page.dart';
import 'pages/components/modal_page.dart';
import 'pages/components/navbar_page.dart';
import 'pages/components/navs_tabs_page.dart';
import 'pages/components/offcanvas_page.dart';
import 'pages/components/pagination_page.dart';
import 'pages/components/placeholders_page.dart';
import 'pages/components/popovers_page.dart';
import 'pages/components/progress_page.dart';
import 'pages/components/scrollspy_page.dart';
import 'pages/components/spinners_page.dart';
import 'pages/components/toasts_page.dart';
import 'pages/components/tooltips_page.dart';
import 'pages/content/figures_page.dart';
import 'pages/content/tables_page.dart';
import 'pages/content/typography_page.dart';
import 'pages/forms/checks_radios_page.dart';
import 'pages/forms/floating_labels_page.dart';
import 'pages/forms/form_control_page.dart';
import 'pages/forms/input_group_page.dart';
import 'pages/forms/range_page.dart';
import 'pages/forms/select_page.dart';
import 'pages/getting_started/introduction_page.dart';
import 'pages/layout/breakpoints_page.dart';
import 'pages/layout/containers_page.dart';
import 'src/doc_nav.dart';
import 'src/doc_shell.dart';

void main() {
  runApp(const DocApp());
}

class DocApp extends StatefulWidget {
  const DocApp({super.key});

  @override
  State<DocApp> createState() => _DocAppState();
}

class _DocAppState extends State<DocApp> {
  Brightness _brightness = Brightness.light;

  void _toggleBrightness() {
    setState(() {
      _brightness = _brightness == Brightness.light ? Brightness.dark : Brightness.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BsApp(
      brightness: _brightness,
      home: DocShell(sections: _sections, brightness: _brightness, onToggleBrightness: _toggleBrightness),
    );
  }
}

final _sections = [
  DocNavSection('Getting started', [DocNavPage('Introduction', (_) => const IntroductionPage())]),
  DocNavSection('Layout', [
    DocNavPage('Breakpoints', (_) => const BreakpointsPage()),
    DocNavPage('Containers', (_) => const ContainersPage()),
  ]),
  DocNavSection('Content', [
    DocNavPage('Figures', (_) => const FiguresPage()),
    DocNavPage('Tables', (_) => const TablesPage()),
    DocNavPage('Typography', (_) => const TypographyPage()),
  ]),
  DocNavSection('Forms', [
    DocNavPage('Checks & radios', (_) => const ChecksRadiosPage()),
    DocNavPage('Floating labels', (_) => const FloatingLabelsPage()),
    DocNavPage('Form control', (_) => const FormControlPage()),
    DocNavPage('Input group', (_) => const InputGroupPage()),
    DocNavPage('Range', (_) => const RangePage()),
    DocNavPage('Select', (_) => const SelectPage()),
  ]),
  DocNavSection('Components', [
    DocNavPage('Accordion', (_) => const AccordionPage()),
    DocNavPage('Alerts', (_) => const AlertsPage()),
    DocNavPage('Badge', (_) => const BadgePage()),
    DocNavPage('Breadcrumb', (_) => const BreadcrumbPage()),
    DocNavPage('Button group', (_) => const ButtonGroupPage()),
    DocNavPage('Buttons', (_) => const ButtonsPage()),
    DocNavPage('Card', (_) => const CardPage()),
    DocNavPage('Carousel', (_) => const CarouselPage()),
    DocNavPage('Close button', (_) => const CloseButtonPage()),
    DocNavPage('Collapse', (_) => const CollapsePage()),
    DocNavPage('Dropdowns', (_) => const DropdownsPage()),
    DocNavPage('List group', (_) => const ListGroupPage()),
    DocNavPage('Modal', (_) => const ModalPage()),
    DocNavPage('Navbar', (_) => const NavbarPage()),
    DocNavPage('Navs & tabs', (_) => const NavsTabsPage()),
    DocNavPage('Offcanvas', (_) => const OffcanvasPage()),
    DocNavPage('Pagination', (_) => const PaginationPage()),
    DocNavPage('Placeholders', (_) => const PlaceholdersPage()),
    DocNavPage('Popovers', (_) => const PopoversPage()),
    DocNavPage('Progress', (_) => const ProgressPage()),
    DocNavPage('Scrollspy', (_) => const ScrollspyPage()),
    DocNavPage('Spinners', (_) => const SpinnersPage()),
    DocNavPage('Toasts', (_) => const ToastsPage()),
    DocNavPage('Tooltips', (_) => const TooltipsPage()),
  ]),
];
