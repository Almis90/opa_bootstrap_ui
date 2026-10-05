import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/example_line_chart.dart';

/// The "Dashboard" example: a port of Bootstrap's own `examples/dashboard`
/// page — a `sticky-top` dark header (see [fixed]) with the brand, a search
/// field (a collapse, behind an icon, below `md`) and, below `md`, a menu button
/// opening the sidebar as an offcanvas; a bordered sidebar of nav links; and
/// the main column: a toolbar, a line chart and a striped table. The page's CSS
/// (`dashboard.css`) is translated where it is used.
class DashboardExamplePage extends StatefulWidget {
  const DashboardExamplePage({super.key, this.rtl = false});

  /// The `dashboard-rtl` page: `dir="rtl"`, in Arabic.
  final bool rtl;

  /// Whether the `#navbarSearch` collapse is open (below `md`): the header is
  /// then a line taller, and the page under it moves down.
  static final searchOpen = ValueNotifier<bool>(false);

  /// The `position: sticky; top: 0` header.
  static Widget fixed(BuildContext context, {bool rtl = false}) {
    final header = Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: _Header(strings: rtl ? _Strings.ar : _Strings.en),
    );
    return rtl
        ? Positioned.fill(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Stack(children: [header]),
            ),
          )
        : header;
  }

  @override
  State<DashboardExamplePage> createState() => _DashboardExamplePageState();
}

class _DashboardExamplePageState extends State<DashboardExamplePage> {
  _Strings get _t => widget.rtl ? _Strings.ar : _Strings.en;

  @override
  void initState() {
    super.initState();
    DashboardExamplePage.searchOpen.value = false;
    DashboardExamplePage.searchOpen.addListener(_onSearch);
  }

  @override
  void dispose() {
    DashboardExamplePage.searchOpen.removeListener(_onSearch);
    super.dispose();
  }

  void _onSearch() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final md = MediaQuery.sizeOf(context).width >= BsBreakpoint.md.minWidth;
    final searchOpen = !md && DashboardExamplePage.searchOpen.value;
    final page = Padding(
      // (the sticky header's own height)
      padding: EdgeInsets.only(top: searchOpen ? 96 : 48),
      child: BsContainer.fluid(
        child: BsRow(
          children: [
            // <div class="sidebar border border-end col-md-3 col-lg-2 p-0 bg-body-tertiary">
            BsFlexItem(
              col: const BsResponsiveValue(
                xs: BsCol(12),
                md: BsCol(3),
                lg: BsCol(2),
              ),
              p: BsSpacing.s0,
              child: BsBox(
                border: true,
                bg: BsBg.bodyTertiary,
                child: md ? _Sidebar(strings: _t, offcanvas: false) : null,
              ),
            ),
            // <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            BsFlexItem(
              col: const BsResponsiveValue(
                xs: BsCol(12),
                md: BsCol(9),
                lg: BsCol(10),
              ),
              ms: const BsResponsiveValue(sm: BsSpacing.auto),
              px: const BsResponsiveValue(md: BsSpacing.s4),
              child: _Main(strings: _t),
            ),
          ],
        ),
      ),
    );
    return widget.rtl
        ? Directionality(textDirection: TextDirection.rtl, child: page)
        : page;
  }
}

// --- <header class="navbar sticky-top bg-dark flex-md-nowrap p-0 shadow"> ---

class _Header extends StatefulWidget {
  const _Header({required this.strings});

  final _Strings strings;

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  @override
  void initState() {
    super.initState();
    DashboardExamplePage.searchOpen.addListener(_onSearch);
  }

  @override
  void dispose() {
    DashboardExamplePage.searchOpen.removeListener(_onSearch);
    super.dispose();
  }

  void _onSearch() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final md = width >= BsBreakpoint.md.minWidth;
    final lg = width >= BsBreakpoint.lg.minWidth;
    final t = widget.strings;
    final search = BsFormControl(
      showBorder: false,
      placeholder: t.search,
      // .navbar .form-control { padding: .75rem 1rem }
      style: const BsFormStyle(
        inputPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
    Widget iconButton(BootstrapIconData icon, VoidCallback onTap) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InlineIconBox(icon: icon),
          ),
        ),
      );
    }

    return BsTheme(
      brightness: Brightness.dark,
      child: BsBox(
        bg: BsBg.dark,
        // shadow
        shadow: BsShadow.normal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // <a class="navbar-brand col-md-3 col-lg-2 me-0 px-3 fs-6 text-white">
                SizedBox(
                  width: md ? width * (lg ? 2 / 12 : 3 / 12) : null,
                  child: _Brand(text: t.company),
                ),
                if (!md) ...[
                  const Spacer(),
                  // <ul class="navbar-nav flex-row d-md-none">
                  iconButton(
                    BootstrapIconData.search,
                    () => DashboardExamplePage.searchOpen.value =
                        !DashboardExamplePage.searchOpen.value,
                  ),
                  iconButton(
                    BootstrapIconData.list,
                    () => showBsOffcanvas<void>(
                      context: context,
                      placement: BsOffcanvasPlacement.end,
                      // <div class="offcanvas-md offcanvas-end bg-body-tertiary">
                      builder: (context) => BsOffcanvas(
                        placement: BsOffcanvasPlacement.end,
                        style: BsOffcanvasStyle(
                          background: BsBody.tertiaryBackgroundOf(context),
                        ),
                        header: BsOffcanvasHeader(
                          onClose: () => Navigator.of(context).pop(),
                          child: Text(t.company),
                        ),
                        // <div class="offcanvas-body … p-0 overflow-y-auto">
                        body: BsOffcanvasBody(
                          style: const BsOffcanvasStyle(
                            padding: EdgeInsets.zero,
                          ),
                          child: SingleChildScrollView(
                            child: _Sidebar(strings: t, offcanvas: true),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (!md && DashboardExamplePage.searchOpen.value) search,
          ],
        ),
      ),
    );
  }
}

/// `.navbar-brand` of this page: `padding: .75rem 1rem`, `fs-6`, white text on
/// `rgba(0, 0, 0, .25)` with an inset `1px` line on its end edge.
class _Brand extends StatelessWidget {
  const _Brand({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _BrandPainter(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(text, style: const TextStyle(color: Color(0xFFFFFFFF))),
      ),
    );
  }
}

class _BrandPainter extends CustomPainter {
  const _BrandPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0x40000000),
    );
    // box-shadow: inset -1px 0 0 rgba(0, 0, 0, .25)
    canvas.drawRect(
      Rect.fromLTWH(size.width - 1, 0, 1, size.height),
      Paint()..color = const Color(0x40000000),
    );
  }

  @override
  bool shouldRepaint(_BrandPainter oldDelegate) => false;
}

/// A 16px `svg.bi` on the baseline of a line of text (`.bi { display:
/// inline-block; width: 1rem; height: 1rem }`, and reboot's `vertical-align:
/// middle`) in a `24px` line.
class InlineIconBox extends StatelessWidget {
  const InlineIconBox({super.key, required this.icon});

  final BootstrapIconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 24,
      child: Center(
        child: BootstrapIcon(
          icon,
          width: 16,
          height: 16,
          color: const Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}

// --- the sidebar ---

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.strings, required this.offcanvas});

  final _Strings strings;

  /// Shown inside the offcanvas (below `md`): `offcanvas-body p-0`, without the
  /// `pt-lg-3` of the in-page one.
  final bool offcanvas;

  @override
  Widget build(BuildContext context) {
    final t = strings;
    final lg = MediaQuery.sizeOf(context).width >= BsBreakpoint.lg.minWidth;
    Widget links(List<(BootstrapIconData, String, bool)> items) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (icon, label, active) in items)
            _SideLink(icon: icon, label: label, active: active),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // p-0 pt-lg-3
        SizedBox(height: !offcanvas && lg ? 16 : 0),
        links([
          (BootstrapIconData.houseFill, t.dashboard, true),
          (BootstrapIconData.fileEarmark, t.orders, false),
          (BootstrapIconData.cart, t.products, false),
          (BootstrapIconData.people, t.customers, false),
          (BootstrapIconData.graphUp, t.reports, false),
          (BootstrapIconData.puzzle, t.integrations, false),
        ]),
        // <h6 class="sidebar-heading d-flex justify-content-between
        // align-items-center px-3 mt-4 mb-1 text-body-secondary text-uppercase">
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color: BsTextColor.bodySecondary.of(context),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
            child: SizedBox(
              height: 17.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(t.saved.toUpperCase()),
                  BootstrapIcon(
                    BootstrapIconData.plusCircle,
                    color: BsTextColor.secondary.of(context),
                  ),
                ],
              ),
            ),
          ),
        ),
        links([
          for (final label in [t.current, t.quarter, t.social, t.yearEnd])
            (BootstrapIconData.fileEarmarkText, label, false),
        ]),
        const BsHr(my: BsSpacing.s3),
        links([
          (BootstrapIconData.gearWideConnected, t.settings, false),
          (BootstrapIconData.doorClosed, t.signOut, false),
        ]),
      ],
    );
  }
}

/// `.sidebar .nav-link.d-flex.align-items-center.gap-2`: `.875rem` medium text,
/// a 16px icon, the link color (`#2470dc` when active).
class _SideLink extends StatefulWidget {
  const _SideLink({
    required this.icon,
    required this.label,
    required this.active,
  });

  final BootstrapIconData icon;
  final String label;
  final bool active;

  @override
  State<_SideLink> createState() => _SideLinkState();
}

class _SideLinkState extends State<_SideLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.active
        ? const Color(0xFF2470DC)
        : _hovered
        ? BsLink.hoverColorOf(context)
        : BsLink.colorOf(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BootstrapIcon(widget.icon, color: color),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- the main column ---

class _Main extends StatelessWidget {
  const _Main({required this.strings});

  final _Strings strings;

  static const _rows = [
    ['1,001', 'random', 'data', 'placeholder', 'text'],
    ['1,002', 'placeholder', 'irrelevant', 'visual', 'layout'],
    ['1,003', 'data', 'rich', 'dashboard', 'tabular'],
    ['1,003', 'information', 'placeholder', 'illustrative', 'data'],
    ['1,004', 'text', 'random', 'layout', 'dashboard'],
    ['1,005', 'dashboard', 'irrelevant', 'text', 'placeholder'],
    ['1,006', 'dashboard', 'illustrative', 'rich', 'data'],
    ['1,007', 'placeholder', 'tabular', 'information', 'irrelevant'],
    ['1,008', 'random', 'data', 'placeholder', 'text'],
    ['1,009', 'placeholder', 'irrelevant', 'visual', 'layout'],
    ['1,010', 'data', 'rich', 'dashboard', 'tabular'],
    ['1,011', 'information', 'placeholder', 'illustrative', 'data'],
    ['1,012', 'text', 'placeholder', 'layout', 'dashboard'],
    ['1,013', 'dashboard', 'irrelevant', 'text', 'visual'],
    ['1,014', 'dashboard', 'illustrative', 'rich', 'data'],
    ['1,015', 'random', 'tabular', 'information', 'text'],
  ];

  @override
  Widget build(BuildContext context) {
    final t = strings;
    final md = MediaQuery.sizeOf(context).width >= BsBreakpoint.md.minWidth;
    BsButton small(String label) => BsButton(
      variant: BsVariant.secondary,
      outline: true,
      size: BsSize.sm,
      onPressed: () {},
      child: Text(label),
    );

    // <div class="btn-toolbar mb-2 mb-md-0">
    final toolbar = BsFlexItem(
      mb: BsResponsiveValue(xs: BsSpacing.s2, md: BsSpacing.s0),
      child: BsFlex(
        inline: true,
        children: [
          BsFlexItem(
            me: BsSpacing.s2,
            child: BsButtonGroup(
              children: [
                BsButton(
                  variant: BsVariant.secondary,
                  outline: true,
                  size: BsSize.sm,
                  onPressed: () {},
                  child: Text(t.share),
                ),
                BsButton(
                  variant: BsVariant.secondary,
                  outline: true,
                  size: BsSize.sm,
                  onPressed: () {},
                  child: Text(t.export),
                ),
              ],
            ),
          ),
          // <button class="btn btn-sm btn-outline-secondary dropdown-toggle
          // d-flex align-items-center gap-1">
          small('').copyWithChild(
            BsFlex(
              inline: true,
              gap: BsSpacing.s1,
              alignItems: BsAlign.center,
              children: [
                const BootstrapIcon(BootstrapIconData.calendar3),
                Text(t.week),
                const BsFlexItem(
                  ms: BsSpacing.s0,
                  child: Padding(
                    padding: EdgeInsets.only(left: 3.57),
                    child: BsDropdownCaret(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // <div class="d-flex justify-content-between flex-wrap flex-md-nowrap
        // align-items-center pt-3 pb-2 mb-3 border-bottom">
        BsBox(
          pt: BsSpacing.s3,
          pb: BsSpacing.s2,
          borderBottom: true,
          child: BsFlex(
            wrap: !md,
            justifyContent: BsJustify.between,
            alignItems: BsAlign.center,
            children: [
              BsFlexItem(
                child: BsHeading(BsHeadingLevel.h2, child: Text(t.title)),
              ),
              toolbar,
            ],
          ),
        ),
        // <canvas class="my-4 w-100"> (its margin-top swallows the header's `mb-3`)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: ExampleLineChart(
            labels: const [
              'Sunday',
              'Monday',
              'Tuesday',
              'Wednesday',
              'Thursday',
              'Friday',
              'Saturday',
            ],
            values: const [15339, 21345, 18483, 24003, 23489, 24092, 12034],
          ),
        ),
        BsHeading(BsHeadingLevel.h2, child: Text(t.section)),
        // <div class="table-responsive small"><table class="table table-striped table-sm">
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DefaultTextStyle.merge(
            style: const TextStyle(fontSize: 14),
            child: BsTable(
              small: true,
              striped: true,
              columnWidths: const {
                0: FlexColumnWidth(117.7),
                1: FlexColumnWidth(225.3),
                2: FlexColumnWidth(225.3),
                3: FlexColumnWidth(225.3),
                4: FlexColumnWidth(225.3),
              },
              columns: [
                const Text('#'),
                for (var i = 0; i < 4; i++) Text(t.header),
              ],
              rows: [
                for (final row in _rows)
                  BsTableRow(cells: [for (final cell in row) Text(cell)]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

extension on BsButton {
  BsButton copyWithChild(Widget child) => BsButton(
    variant: variant,
    outline: outline,
    size: size,
    onPressed: onPressed,
    child: child,
  );
}

/// The page's texts: the English original and the `dashboard-rtl` Arabic one.
class _Strings {
  const _Strings({
    required this.company,
    required this.search,
    required this.dashboard,
    required this.orders,
    required this.products,
    required this.customers,
    required this.reports,
    required this.integrations,
    required this.saved,
    required this.current,
    required this.quarter,
    required this.social,
    required this.yearEnd,
    required this.settings,
    required this.signOut,
    required this.title,
    required this.share,
    required this.export,
    required this.week,
    required this.section,
    required this.header,
  });

  final String company, search;
  final String dashboard, orders, products, customers, reports, integrations;
  final String saved, current, quarter, social, yearEnd;
  final String settings, signOut;
  final String title, share, export, week, section, header;

  static const en = _Strings(
    company: 'Company name',
    search: 'Search',
    dashboard: 'Dashboard',
    orders: 'Orders',
    products: 'Products',
    customers: 'Customers',
    reports: 'Reports',
    integrations: 'Integrations',
    saved: 'Saved reports',
    current: 'Current month',
    quarter: 'Last quarter',
    social: 'Social engagement',
    yearEnd: 'Year-end sale',
    settings: 'Settings',
    signOut: 'Sign out',
    title: 'Dashboard',
    share: 'Share',
    export: 'Export',
    week: 'This week',
    section: 'Section title',
    header: 'Header',
  );

  static const ar = _Strings(
    company: 'اسم الشركة',
    search: 'بحث',
    dashboard: 'لوحة القيادة',
    orders: 'الطلبات',
    products: 'المنتجات',
    customers: 'الزبائن',
    reports: 'التقارير',
    integrations: 'التكاملات',
    saved: 'التقارير المحفوظة',
    current: 'الشهر الحالي',
    quarter: 'الربع الأخير',
    social: 'التفاعل الإجتماعي',
    yearEnd: 'مبيعات نهاية العام',
    settings: 'إعدادات',
    signOut: 'خروج',
    title: 'لوحة القيادة',
    share: 'مشاركة',
    export: 'تصدير',
    week: 'هذا الأسبوع',
    section: 'عنوان القسم',
    header: 'عنوان',
  );
}
