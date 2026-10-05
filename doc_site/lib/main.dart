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
import 'pages/content/thumbnails_page.dart';
import 'pages/content/typography_page.dart';
import 'pages/forms/checks_radios_page.dart';
import 'pages/forms/floating_labels_page.dart';
import 'pages/forms/form_control_page.dart';
import 'pages/forms/input_group_page.dart';
import 'pages/forms/range_page.dart';
import 'pages/forms/select_page.dart';
import 'pages/examples/headers_example_page.dart';
import 'pages/examples/heroes_example_page.dart';
import 'pages/examples/jumbotron_example_page.dart';
import 'pages/examples/jumbotrons_example_page.dart';
import 'pages/examples/list_groups_example_page.dart';
import 'pages/examples/masonry_example_page.dart';
import 'pages/examples/modals_example_page.dart';
import 'pages/examples/navbar_bottom_example_page.dart';
import 'pages/examples/navbar_fixed_example_page.dart';
import 'pages/examples/navbar_static_example_page.dart';
import 'pages/examples/navbars_example_page.dart';
import 'pages/examples/navbars_offcanvas_example_page.dart';
import 'pages/examples/offcanvas_navbar_example_page.dart';
import 'pages/examples/pricing_example_page.dart';
import 'pages/examples/product_example_page.dart';
import 'pages/examples/sidebars_example_page.dart';
import 'pages/examples/sign_in_example_page.dart';
import 'pages/examples/starter_template_example_page.dart';
import 'pages/getting_started/introduction_page.dart';
import 'pages/layout/breakpoints_page.dart';
import 'pages/layout/containers_page.dart';
import 'pages/layout/flex_page.dart';
import 'pages/layout/utilities_page.dart';
import 'src/doc_nav.dart';
import 'src/doc_shell.dart';
import 'src/example_entry.dart';

void main() {
  runApp(const DocApp());
}

class DocApp extends StatefulWidget {
  const DocApp({super.key});

  @override
  State<DocApp> createState() => _DocAppState();
}

class _DocAppState extends State<DocApp> with WidgetsBindingObserver {
  /// Bootstrap's `data-bs-theme`; null is `auto` (follow the OS).
  Brightness? _themeMode = Brightness.light;

  /// [_themeMode] with `auto` resolved against the OS.
  Brightness get _brightness => _themeMode ?? WidgetsBinding.instance.platformDispatcher.platformBrightness;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() => setState(() {});

  void _toggleBrightness() {
    setState(() {
      _themeMode = _brightness == Brightness.light ? Brightness.dark : Brightness.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BsApp(
      brightness: _themeMode,
      debugShowCheckedModeBanner: false,
      home: DocShell(
        sections: _sections,
        examples: _examples,
        brightness: _brightness,
        onToggleBrightness: _toggleBrightness,
        themeMode: _themeMode,
        onThemeModeChanged: (mode) => setState(() => _themeMode = mode),
      ),
    );
  }
}

final _sections = [
  DocNavSection('Getting started', [DocNavPage('Introduction', (_) => const IntroductionPage())]),
  DocNavSection('Layout', [
    DocNavPage('Breakpoints', (_) => const BreakpointsPage()),
    DocNavPage('Containers', (_) => const ContainersPage()),
    DocNavPage('Flex', (_) => const FlexPage()),
    DocNavPage('Utilities', (_) => const UtilitiesPage()),
  ]),
  DocNavSection('Content', [
    DocNavPage('Figures', (_) => const FiguresPage()),
    DocNavPage('Tables', (_) => const TablesPage()),
    DocNavPage('Thumbnails', (_) => const ThumbnailsPage()),
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

final _examples = [
  ExampleEntry(
    title: 'Headers',
    description: 'Eight header layouts, from a bare brand-and-nav bar to a two-tier icon navigation bar.',
    builder: (_) => const HeadersExamplePage(),
  ),
  ExampleEntry(
    title: 'Heroes',
    description: 'Six hero sections: centered, with a screenshot, with an image, a sign-up form, bordered, and dark.',
    builder: (_) => const HeroesExamplePage(),
  ),
  ExampleEntry(
    title: 'Jumbotron',
    description: 'A jumbotron rebuilt from utilities, with two equal-height variations beneath it.',
    builder: (_) => const JumbotronExamplePage(),
  ),
  ExampleEntry(
    title: 'Jumbotrons',
    description: 'Four jumbotron variations: with an icon, faded placeholder, full-width, and basic.',
    builder: (_) => const JumbotronsExamplePage(),
  ),
  ExampleEntry(
    title: 'List groups',
    description: 'Custom list groups: linked rows with avatars, check and radio rows, checkable cards, and a radio grid.',
    builder: (_) => const ListGroupsExamplePage(),
  ),
  ExampleEntry(
    title: 'Masonry',
    description: 'Cards packed into the shortest column with a masonry layout inside the Bootstrap grid.',
    builder: (_) => const MasonryExamplePage(),
  ),
  ExampleEntry(
    title: 'Modals',
    description: 'Four modal sheets shown in place: a bottom sheet, a choice, a feature tour and a sign-up form.',
    builder: (_) => const ModalsExamplePage(),
  ),
  ExampleEntry(
    title: 'Navbar bottom',
    description: 'A navbar fixed to the bottom of the viewport, with a dropup.',
    builder: (_) => const NavbarBottomExamplePage(),
    fixed: NavbarBottomExamplePage.fixed,
  ),
  ExampleEntry(
    title: 'Navbar fixed',
    description: 'A navbar fixed to the top of the viewport over a long page.',
    builder: (_) => const NavbarFixedExamplePage(),
    fixed: NavbarFixedExamplePage.fixed,
  ),
  ExampleEntry(
    title: 'Navbar static',
    description: 'A top navbar that scrolls away with the page.',
    builder: (_) => const NavbarStaticExamplePage(),
  ),
  ExampleEntry(
    title: 'Navbars',
    description: 'Thirteen navbars: never, always and per-breakpoint expansion, containers and centred navs.',
    builder: (_) => const NavbarsExamplePage(),
  ),
  ExampleEntry(
    title: 'Navbars offcanvas',
    description: 'Navbars whose toggler opens an offcanvas menu, one of them responsive.',
    builder: (_) => const NavbarsOffcanvasExamplePage(),
  ),
  ExampleEntry(
    title: 'Offcanvas navbar',
    description: 'A fixed navbar whose menu slides in below lg, a scrolling secondary nav and update cards.',
    builder: (_) => const OffcanvasNavbarExamplePage(),
    fixed: OffcanvasNavbarExamplePage.fixed,
  ),
  ExampleEntry(
    title: 'Pricing',
    description: 'A pricing table: three plan cards and a feature comparison table.',
    builder: (_) => const PricingExamplePage(),
  ),
  ExampleEntry(
    title: 'Product',
    description: 'A product landing page: a sticky navbar, a hero with rotated devices and rows of panels.',
    builder: (_) => const ProductExamplePage(),
    fixed: ProductExamplePage.fixed,
  ),
  ExampleEntry(
    title: 'Sidebars',
    description: 'Five sidebars: nav pills, icon-only, collapsible and a list group.',
    builder: (_) => const SidebarsExamplePage(),
  ),
  ExampleEntry(
    title: 'Sign-in',
    description: 'A centered sign-in form with floating labels.',
    builder: (_) => const SignInExamplePage(),
  ),
  ExampleEntry(
    title: 'Starter template',
    description: 'A barebones starter page: header, intro and two columns of links.',
    builder: (_) => const StarterTemplateExamplePage(),
  ),
];
