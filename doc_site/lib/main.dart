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
import 'pages/content/reboot_page.dart';
import 'pages/content/tables_page.dart';
import 'pages/content/thumbnails_page.dart';
import 'pages/content/typography_page.dart';
import 'pages/forms/checks_radios_page.dart';
import 'pages/forms/floating_labels_page.dart';
import 'pages/forms/form_control_page.dart';
import 'pages/forms/input_group_page.dart';
import 'pages/forms/range_page.dart';
import 'pages/forms/select_page.dart';
import 'pages/customize/color_modes_page.dart';
import 'pages/customize/components_page.dart';
import 'pages/customize/color_page.dart';
import 'pages/customize/optimize_page.dart';
import 'pages/customize/options_page.dart';
import 'pages/customize/overview_page.dart';
import 'pages/customize/style_classes_page.dart';
import 'pages/customize/tokens_page.dart';
import 'pages/examples/album_example_page.dart';
import 'pages/examples/badges_example_page.dart';
import 'pages/examples/blog_example_page.dart';
import 'pages/examples/breadcrumbs_example_page.dart';
import 'pages/examples/buttons_example_page.dart';
import 'pages/examples/carousel_example_page.dart';
import 'pages/examples/cheatsheet_example_page.dart';
import 'pages/examples/checkout_example_page.dart';
import 'pages/examples/cover_example_page.dart';
import 'pages/examples/dashboard_example_page.dart';
import 'pages/examples/dropdowns_example_page.dart';
import 'pages/examples/features_example_page.dart';
import 'pages/examples/footers_example_page.dart';
import 'pages/examples/grid_example_page.dart';
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
import 'pages/examples/sticky_footer_example_page.dart';
import 'pages/examples/sticky_footer_navbar_example_page.dart';
import 'pages/getting_started/accessibility_page.dart';
import 'pages/getting_started/contents_page.dart';
import 'pages/getting_started/contribute_page.dart';
import 'pages/getting_started/installation_page.dart';
import 'pages/getting_started/interactivity_page.dart';
import 'pages/getting_started/introduction_page.dart';
import 'pages/getting_started/platforms_page.dart';
import 'pages/getting_started/rfs_page.dart';
import 'pages/getting_started/rtl_page.dart';
import 'pages/layout/breakpoints_page.dart';
import 'pages/layout/columns_page.dart';
import 'pages/layout/containers_page.dart';
import 'pages/layout/flex_page.dart';
import 'pages/layout/grid_page.dart';
import 'pages/layout/gutters_page.dart';
import 'pages/layout/utilities_page.dart';
import 'pages/layout/z_index_page.dart';
import 'src/bootstrap_icon.dart';
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

  @override
  Widget build(BuildContext context) {
    return BsApp(
      // The Arabic pages' font, bundled (see pubspec.yaml).
      extraFontFamilyFallback: const ['Noto Sans Arabic'],
      brightness: _themeMode,
      debugShowCheckedModeBanner: false,
      home: DocShell(
        sections: _sections,
        examples: _examples,
        themeMode: _themeMode,
        onThemeModeChanged: (mode) => setState(() => _themeMode = mode),
      ),
    );
  }
}

final _sections = [
  DocNavSection(
    'Getting started',
    icon: BootstrapIconData.bookHalf,
    iconColor: BsColors.indigo,
    [
      DocNavPage('Introduction', (_) => const IntroductionPage()),
      DocNavPage('Installation', (_) => const InstallationPage()),
      DocNavPage('Contents', (_) => const ContentsPage()),
      DocNavPage('Platforms & devices', (_) => const PlatformsPage()),
      DocNavPage('Interactivity', (_) => const InteractivityPage()),
      DocNavPage('Accessibility', (_) => const AccessibilityPage()),
      DocNavPage('RFS', (_) => const RfsPage()),
      DocNavPage('RTL', (_) => const RtlPage()),
      DocNavPage('Contribute', (_) => const ContributePage()),
    ],
  ),
  DocNavSection(
    'Customize',
    icon: BootstrapIconData.palette2,
    iconColor: BsColors.pink,
    [
      DocNavPage('Overview', (_) => const CustomizeOverviewPage()),
      DocNavPage('Tokens', (_) => const TokensPage()),
      DocNavPage('Options', (_) => const OptionsPage()),
      DocNavPage('Color', (_) => const ColorPage()),
      DocNavPage('Color modes', (_) => const ColorModesPage()),
      DocNavPage('Components', (_) => const ComponentsPage()),
      DocNavPage('Style classes', (_) => const StyleClassesPage()),
      DocNavPage('Optimize', (_) => const OptimizePage()),
    ],
  ),
  DocNavSection(
    'Layout',
    icon: BootstrapIconData.gridFill,
    iconColor: BsColors.teal,
    [
      DocNavPage('Breakpoints', (_) => const BreakpointsPage()),
      DocNavPage('Containers', (_) => const ContainersPage()),
      DocNavPage('Grid', (_) => const GridPage()),
      DocNavPage('Columns', (_) => const ColumnsPage()),
      DocNavPage('Gutters', (_) => const GuttersPage()),
      DocNavPage('Utilities', (_) => const UtilitiesPage()),
      DocNavPage('Z-index', (_) => const ZIndexPage()),
    ],
  ),
  DocNavSection(
    'Content',
    icon: BootstrapIconData.fileEarmarkRichtext,
    iconColor: BsColors.gray600,
    [
      DocNavPage('Reboot', (_) => const RebootPage()),
      DocNavPage('Typography', (_) => const TypographyPage()),
      DocNavPage('Images', (_) => const ThumbnailsPage()),
      DocNavPage('Tables', (_) => const TablesPage()),
      DocNavPage('Figures', (_) => const FiguresPage()),
    ],
  ),
  DocNavSection(
    'Forms',
    icon: BootstrapIconData.uiRadios,
    iconColor: BsColors.blue,
    [
      DocNavPage.planned('Overview'),
      DocNavPage('Form control', (_) => const FormControlPage()),
      DocNavPage('Select', (_) => const SelectPage()),
      DocNavPage('Checks & radios', (_) => const ChecksRadiosPage()),
      DocNavPage('Range', (_) => const RangePage()),
      DocNavPage('Input group', (_) => const InputGroupPage()),
      DocNavPage('Floating labels', (_) => const FloatingLabelsPage()),
      DocNavPage.planned('Layout'),
      DocNavPage.planned('Validation'),
    ],
  ),
  DocNavSection(
    'Components',
    icon: BootstrapIconData.menuButtonWideFill,
    iconColor: BsColors.cyan,
    [
      DocNavPage('Accordion', (_) => const AccordionPage()),
      DocNavPage('Alerts', (_) => const AlertsPage()),
      DocNavPage('Badge', (_) => const BadgePage()),
      DocNavPage('Breadcrumb', (_) => const BreadcrumbPage()),
      DocNavPage('Buttons', (_) => const ButtonsPage()),
      DocNavPage('Button group', (_) => const ButtonGroupPage()),
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
    ],
  ),
  DocNavSection(
    'Helpers',
    icon: BootstrapIconData.magic,
    iconColor: BsColors.orange,
    [
      DocNavPage.planned('Clearfix'),
      DocNavPage.planned('Color & background'),
      DocNavPage.planned('Colored links'),
      DocNavPage.planned('Focus ring'),
      DocNavPage.planned('Icon link'),
      DocNavPage.planned('Position'),
      DocNavPage.planned('Ratio'),
      DocNavPage.planned('Stacks'),
      DocNavPage.planned('Stretched link'),
      DocNavPage.planned('Text truncation'),
      DocNavPage.planned('Vertical rule'),
      DocNavPage.planned('Visually hidden'),
    ],
  ),
  DocNavSection(
    'Utilities',
    icon: BootstrapIconData.bracesAsterisk,
    iconColor: BsColors.red,
    [
      DocNavPage.planned('API'),
      DocNavPage.planned('Background'),
      DocNavPage.planned('Borders'),
      DocNavPage.planned('Colors'),
      DocNavPage.planned('Display'),
      DocNavPage('Flex', (_) => const FlexPage()),
      DocNavPage.planned('Float'),
      DocNavPage.planned('Interactions'),
      DocNavPage.planned('Link'),
      DocNavPage.planned('Object fit'),
      DocNavPage.planned('Opacity'),
      DocNavPage.planned('Overflow'),
      DocNavPage.planned('Position'),
      DocNavPage.planned('Shadows'),
      DocNavPage.planned('Sizing'),
      DocNavPage.planned('Spacing'),
      DocNavPage.planned('Text'),
      DocNavPage.planned('Vertical align'),
      DocNavPage.planned('Visibility'),
      DocNavPage.planned('Z-index'),
    ],
  ),
  DocNavSection(
    'Extend',
    icon: BootstrapIconData.tools,
    iconColor: BsColors.blue,
    [DocNavPage.planned('Approach'), DocNavPage.planned('Icons')],
  ),
  DocNavSection(
    'About',
    icon: BootstrapIconData.globe2,
    iconColor: BsColors.indigo,
    [
      DocNavPage.planned('Overview'),
      DocNavPage.planned('Team'),
      DocNavPage.planned('Brand'),
      DocNavPage.planned('License'),
      DocNavPage.planned('Translations'),
    ],
  ),
  DocNavSection.link(DocNavPage.planned('Migration')),
];

final _examples = [
  ExampleEntry(
    title: 'Album',
    description: 'A photo album: a collapsible header, an intro and a grid of thumbnail cards.',
    builder: (_) => const AlbumExamplePage(),
  ),
  ExampleEntry(
    title: 'Album RTL',
    rtl: true,
    description: 'The album page, right to left in Arabic.',
    builder: (_) => const AlbumExamplePage(rtl: true),
  ),
  ExampleEntry(
    title: 'Badges',
    description: 'Pill badges in every color: solid, subtle, with avatars and dismiss icons.',
    builder: (_) => const BadgesExamplePage(),
  ),
  ExampleEntry(
    title: 'Blog',
    description:
        'A blog: masthead, featured post and cards, posts beside a sidebar.',
    builder: (_) => const BlogExamplePage(),
  ),
  ExampleEntry(
    title: 'Blog RTL',
    rtl: true,
    description: 'The blog page, right to left in Arabic.',
    builder: (_) => const BlogExamplePage(rtl: true),
  ),
  ExampleEntry(
    title: 'Breadcrumbs',
    description: 'Breadcrumb trails: default, with icon, chevron dividers and arrow tips.',
    builder: (_) => const BreadcrumbsExamplePage(),
  ),
  ExampleEntry(
    title: 'Buttons',
    description:
        'Buttons: pills, full-width, with icons, loading and circular.',
    builder: (_) => const ButtonsExamplePage(),
  ),
  ExampleEntry(
    title: 'Carousel',
    description: 'A carousel under a fixed navbar, with marketing columns and featurettes.',
    builder: (_) => const CarouselExamplePage(),
    fixed: CarouselExamplePage.fixed,
  ),
  ExampleEntry(
    title: 'Carousel RTL',
    rtl: true,
    description: 'The carousel page, right to left in Arabic.',
    builder: (_) => const CarouselExamplePage(rtl: true),
    fixed: (context) => CarouselExamplePage.fixed(context, rtl: true),
  ),
  ExampleEntry(
    title: 'Cheatsheet',
    description: 'Every component and content style on one page, with a table of contents.',
    builder: (_) => const CheatsheetExamplePage(),
    fixed: (context) => CheatsheetExamplePage.fixed(context),
  ),
  ExampleEntry(
    title: 'Cheatsheet RTL',
    rtl: true,
    description: 'The cheatsheet, right to left in Arabic.',
    builder: (_) => const CheatsheetExamplePage(rtl: true),
    fixed: (context) => CheatsheetExamplePage.fixed(context, rtl: true),
  ),
  ExampleEntry(
    title: 'Checkout',
    description:
        'A checkout form with a cart, billing address and payment sections.',
    builder: (_) => const CheckoutExamplePage(),
  ),
  ExampleEntry(
    title: 'Checkout RTL',
    rtl: true,
    description: 'The checkout form, right to left in Arabic.',
    builder: (_) => const CheckoutExamplePage(rtl: true),
  ),
  ExampleEntry(
    title: 'Cover',
    description: 'A full-page dark cover with a masthead and a call to action.',
    builder: (_) => const CoverExamplePage(),
  ),
  ExampleEntry(
    title: 'Dashboard',
    description:
        'A dashboard: a sticky header, a sidebar, a chart and a table.',
    builder: (_) => const DashboardExamplePage(),
    fixed: DashboardExamplePage.fixed,
  ),
  ExampleEntry(
    title: 'Dashboard RTL',
    rtl: true,
    description: 'The dashboard, right to left in Arabic.',
    builder: (_) => const DashboardExamplePage(rtl: true),
    fixed: (context) => DashboardExamplePage.fixed(context, rtl: true),
  ),
  ExampleEntry(
    title: 'Dropdowns',
    description: 'Static dropdown menus in light and dark: lists, filters, icons, calendars and mega menus.',
    builder: (_) => const DropdownsExamplePage(),
  ),
  ExampleEntry(
    title: 'Features',
    description: 'Feature sections: icon columns, hanging icons, photo cards and an icon grid.',
    builder: (_) => const FeaturesExamplePage(),
  ),
  ExampleEntry(
    title: 'Footers',
    description: 'Footer layouts: logo and nav, social icons, link columns and a newsletter form.',
    builder: (_) => const FootersExamplePage(),
  ),
  ExampleEntry(
    title: 'Grid',
    description: 'Grid layouts with themed columns: tiers, nesting, mixed breakpoints, gutters and containers.',
    builder: (_) => const GridExamplePage(),
  ),
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
    description:
        'A pricing table: three plan cards and a feature comparison table.',
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
    description:
        'Five sidebars: nav pills, icon-only, collapsible and a list group.',
    builder: (_) => const SidebarsExamplePage(),
  ),
  ExampleEntry(
    title: 'Sign-in',
    description: 'A centered sign-in form with floating labels.',
    builder: (_) => const SignInExamplePage(),
  ),
  ExampleEntry(
    title: 'Starter template',
    description:
        'A barebones starter page: header, intro and two columns of links.',
    builder: (_) => const StarterTemplateExamplePage(),
  ),
  ExampleEntry(
    title: 'Sticky footer',
    description: 'A footer pinned to the bottom of the viewport.',
    builder: (_) => const StickyFooterExamplePage(),
  ),
  ExampleEntry(
    title: 'Sticky footer navbar',
    description: 'The sticky footer under a fixed top navbar.',
    builder: (_) => const StickyFooterNavbarExamplePage(),
    fixed: StickyFooterNavbarExamplePage.fixed,
  ),
];
