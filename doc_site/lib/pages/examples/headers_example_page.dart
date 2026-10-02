import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

/// The "Headers" example: a faithful port of Bootstrap's own
/// `examples/headers` page — the same brand text, nav items, and flex-wrap
/// reflow behavior as the original, which builds every header from plain
/// flex utility classes rather than the `.navbar` component (so none of
/// these collapse behind a hamburger toggle; they just reflow).
class HeadersExamplePage extends StatelessWidget {
  const HeadersExamplePage({super.key});

  static const _mainLabels = ['Home', 'Features', 'Pricing', 'FAQs', 'About'];
  static const _dashboardLabels = ['Overview', 'Inventory', 'Customers', 'Products'];
  static const _px2 = BsNavStyle(linkPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _simpleHeader(context),
        const _ExampleDivider(),
        _centeredNav(context),
        const _ExampleDivider(),
        _ctaHeader(context),
        const _ExampleDivider(),
        _darkSearchHeader(context),
        const _ExampleDivider(),
        _dropdownHeader(context),
        const _ExampleDivider(),
        _gridDropdownSection(context),
        const _ExampleDivider(),
        _doubleHeader(context),
        const _ExampleDivider(),
        _iconNavHeader(context),
        const _ExampleDivider(),
      ],
    );
  }

  // --- Section bodies, in the same order as Bootstrap's own page ---

  static Widget _simpleHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BsBorders.colorOf(context)))),
      child: BsContainer(
        child: _flexHeader(
          breakpoint: BsBreakpoint.md,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _BootstrapMark(),
                const SizedBox(width: 8),
                Text('Simple header', style: TextStyle(fontSize: 20, color: BsBody.emphasisColorOf(context))),
              ],
            ),
            BsNav(variant: BsNavVariant.pills, items: _pillNavItems(_mainLabels)),
          ],
        ),
      ),
    );
  }

  static Widget _centeredNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: BsContainer(child: Center(child: BsNav(variant: BsNavVariant.pills, items: _pillNavItems(_mainLabels)))),
    );
  }

  static Widget _ctaHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BsBorders.colorOf(context)))),
      child: BsContainer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const brand = _BootstrapMark();
            final nav = BsNav(
              variant: BsNavVariant.plain,
              style: _px2,
              items: _plainNavItems(_mainLabels, firstColor: BsBody.secondaryColorOf(context)),
            );
            final buttons = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                BsButton(variant: BsVariant.primary, outline: true, onPressed: () {}, child: const Text('Login')),
                const SizedBox(width: 8),
                BsButton(variant: BsVariant.primary, onPressed: () {}, child: const Text('Sign-up')),
              ],
            );
            if (constraints.maxWidth < BsBreakpoint.md.minWidth) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [brand, const SizedBox(height: 16), nav, const SizedBox(height: 16), buttons],
              );
            }
            return Row(children: [brand, Expanded(child: Center(child: nav)), buttons]);
          },
        ),
      ),
    );
  }

  static Widget _darkSearchHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: BsColors.gray900,
      child: BsContainer(
        child: _flexHeader(
          breakpoint: BsBreakpoint.lg,
          spacerAfterIndex: 1,
          children: [
            const _BootstrapMark(),
            BsNav(
              variant: BsNavVariant.plain,
              style: _px2,
              items: _plainNavItems(_mainLabels, firstColor: BsColors.gray500, restColor: BsColors.white),
            ),
            const SizedBox(width: 200, child: BsFormControl(placeholder: 'Search', style: _darkFormStyle)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                BsButton(variant: BsVariant.light, outline: true, onPressed: () {}, child: const Text('Login')),
                const SizedBox(width: 8),
                BsButton(variant: BsVariant.warning, onPressed: () {}, child: const Text('Sign-up')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _dropdownHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BsBorders.colorOf(context)))),
      child: BsContainer(
        child: _flexHeader(
          breakpoint: BsBreakpoint.lg,
          spacerAfterIndex: 1,
          children: [
            const _BootstrapMark(),
            BsNav(
              variant: BsNavVariant.plain,
              style: _px2,
              items: _plainNavItems(
                _dashboardLabels,
                firstColor: BsBody.secondaryColorOf(context),
                restColor: BsBody.emphasisColorOf(context),
              ),
            ),
            const SizedBox(width: 200, child: BsFormControl(placeholder: 'Search')),
            BsDropdown(
              alignEnd: true,
              toggleBuilder: (context, toggle, isOpen) => MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(onTap: toggle, child: const _GithubAvatar()),
              ),
              items: _avatarMenuItems(),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _gridDropdownSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [_gridDropdownHeader(context), const SizedBox(height: 16), _gridPlaceholderBlocks(context)],
    );
  }

  static Widget _gridDropdownHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BsBorders.colorOf(context)))),
      child: BsContainer.fluid(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: BsDropdown(
                  toggleBuilder: (context, toggle, isOpen) => MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(onTap: toggle, child: const _BootstrapMark()),
                  ),
                  items: _logoMenuItems(),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Expanded(child: BsFormControl(placeholder: 'Search')),
                  const SizedBox(width: 12),
                  BsDropdown(
                    alignEnd: true,
                    toggleBuilder: (context, toggle, isOpen) => MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(onTap: toggle, child: const _GithubAvatar()),
                    ),
                    items: _avatarMenuItems(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _gridPlaceholderBlocks(BuildContext context) {
    return BsContainer.fluid(
      child: Row(
        children: [
          Expanded(child: _placeholderBlock(context)),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: _placeholderBlock(context)),
        ],
      ),
    );
  }

  static Widget _placeholderBlock(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: BsBody.tertiaryBackgroundOf(context),
        border: Border.all(color: BsBorders.colorOf(context)),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  static Widget _doubleHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: BsBody.tertiaryBackgroundOf(context),
            border: Border(bottom: BorderSide(color: BsBorders.colorOf(context))),
          ),
          child: BsContainer(
            child: _flexHeader(
              breakpoint: BsBreakpoint.xs,
              children: [
                BsNav(
                  variant: BsNavVariant.plain,
                  style: _px2,
                  items: _plainNavItems(
                    _mainLabels,
                    firstColor: BsBody.emphasisColorOf(context),
                    restColor: BsBody.emphasisColorOf(context),
                  ),
                ),
                BsNav(
                  variant: BsNavVariant.plain,
                  style: _px2,
                  items: [
                    BsNavItem(
                      child: Text('Login', style: TextStyle(color: BsBody.emphasisColorOf(context))),
                      onTap: () {},
                    ),
                    BsNavItem(
                      child: Text('Sign up', style: TextStyle(color: BsBody.emphasisColorOf(context))),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BsBorders.colorOf(context)))),
          child: BsContainer(
            child: _flexHeader(
              breakpoint: BsBreakpoint.lg,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _BootstrapMark(),
                    const SizedBox(width: 8),
                    Text('Double header', style: TextStyle(fontSize: 20, color: BsBody.emphasisColorOf(context))),
                  ],
                ),
                const SizedBox(width: 240, child: BsFormControl(placeholder: 'Search')),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget _iconNavHeader(BuildContext context) {
    const icons = [
      (_GlyphIcon.home, 'Home'),
      (_GlyphIcon.dashboard, 'Dashboard'),
      (_GlyphIcon.orders, 'Orders'),
      (_GlyphIcon.products, 'Products'),
      (_GlyphIcon.customers, 'Customers'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: BsColors.gray900,
            border: Border(bottom: BorderSide(color: BsBorders.colorOf(context))),
          ),
          child: _flexHeader(
            breakpoint: BsBreakpoint.lg,
            children: [
              const _BootstrapMark(),
              Wrap(
                runSpacing: 8,
                children: [
                  for (final (icon, label) in icons)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _Glyph(icon, color: label == 'Home' ? BsColors.gray500 : BsColors.white),
                          const SizedBox(height: 2),
                          Text(label, style: TextStyle(fontSize: 12, color: label == 'Home' ? BsColors.gray500 : BsColors.white)),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BsBorders.colorOf(context)))),
          child: _flexHeader(
            breakpoint: BsBreakpoint.lg,
            children: [
              const SizedBox(width: 240, child: BsFormControl(placeholder: 'Search')),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BsButton(variant: BsVariant.light, onPressed: () {}, child: const Text('Login')),
                  const SizedBox(width: 8),
                  BsButton(variant: BsVariant.primary, onPressed: () {}, child: const Text('Sign-up')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Shared nav/menu builders ---

  static List<BsNavItem> _pillNavItems(List<String> labels) => [
    for (var i = 0; i < labels.length; i++) BsNavItem(child: Text(labels[i]), active: i == 0, onTap: () {}),
  ];

  static List<BsNavItem> _plainNavItems(List<String> labels, {Color? firstColor, Color? restColor}) => [
    for (var i = 0; i < labels.length; i++)
      BsNavItem(
        child: Text(labels[i], style: TextStyle(color: i == 0 ? firstColor : restColor)),
        active: i == 0,
        onTap: () {},
      ),
  ];

  static List<BsDropdownEntry> _avatarMenuItems() => const [
    BsDropdownItem(child: Text('New project...')),
    BsDropdownItem(child: Text('Settings')),
    BsDropdownItem(child: Text('Profile')),
    BsDropdownDivider(),
    BsDropdownItem(child: Text('Sign out')),
  ];

  static List<BsDropdownEntry> _logoMenuItems() => const [
    BsDropdownItem(child: Text('Overview'), active: true),
    BsDropdownItem(child: Text('Inventory')),
    BsDropdownItem(child: Text('Customers')),
    BsDropdownItem(child: Text('Products')),
    BsDropdownDivider(),
    BsDropdownItem(child: Text('Reports')),
    BsDropdownItem(child: Text('Analytics')),
  ];

  static const _darkFormStyle = BsFormStyle(
    inputColor: BsColors.white,
    inputBackground: Color(0x1AFFFFFF),
    inputBorderColor: Color(0x1AFFFFFF),
    inputPlaceholderColor: Color(0x80FFFFFF),
  );
}

/// Lays [children] out left-to-right with the free space after
/// [spacerAfterIndex] distributed to its right — the same effect Bootstrap's
/// real headers get from an `me-*-auto` class on one child — collapsing to
/// a centered, wrapped column below [breakpoint].
Widget _flexHeader({
  required List<Widget> children,
  required BsBreakpoint breakpoint,
  int spacerAfterIndex = 0,
  double spacing = 16,
  double runSpacing = 12,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < breakpoint.minWidth) {
        return Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: spacing,
          runSpacing: runSpacing,
          children: children,
        );
      }
      final row = <Widget>[];
      for (var i = 0; i < children.length; i++) {
        row.add(children[i]);
        if (i == children.length - 1) continue;
        row.add(i == spacerAfterIndex ? const Spacer() : SizedBox(width: spacing));
      }
      return Row(crossAxisAlignment: CrossAxisAlignment.center, children: row);
    },
  );
}

/// Bootstrap's own `.b-example-divider`: a plain, inset-shadowed gray band
/// separating stacked examples on the same page — the real page has no
/// label or description between sections, just this.
class _ExampleDivider extends StatelessWidget {
  const _ExampleDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: Color(0x1A000000),
        border: Border.symmetric(horizontal: BorderSide(color: Color(0x26000000))),
      ),
    );
  }
}

/// A simplified stand-in for Bootstrap's own logo mark — this package has
/// no SVG/icon asset pipeline, so the real multi-path `<svg>` glyph is
/// approximated with a plain lettermark rather than transcribed by hand.
class _BootstrapMark extends StatelessWidget {
  const _BootstrapMark({this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 0.8,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: BsColors.blue, borderRadius: BorderRadius.circular(size * 0.22)),
      child: Text(
        'B',
        style: TextStyle(color: BsColors.white, fontWeight: FontWeight.w700, fontSize: size * 0.5, height: 1),
      ),
    );
  }
}

/// The same `github.com/mdo.png` avatar Bootstrap's own dropdown examples
/// use.
class _GithubAvatar extends StatelessWidget {
  const _GithubAvatar({this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.network(
        'https://github.com/mdo.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          color: BsColors.gray400,
          child: Text('M', style: TextStyle(color: BsColors.white, fontSize: size * 0.42, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

/// The five Bootstrap Icons glyphs (home, speedometer2, table, grid,
/// people-circle) the icon-nav header uses, hand-approximated with
/// [CustomPainter] paths rather than transcribed from their real SVG data —
/// this package draws every icon it needs (close buttons, carets, chevrons)
/// the same way, with no bundled icon font or asset pipeline.
enum _GlyphIcon { home, dashboard, orders, products, customers }

class _Glyph extends StatelessWidget {
  const _Glyph(this.icon, {required this.color, this.size = 20});

  final _GlyphIcon icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size.square(size), painter: _GlyphPainter(icon, color));
}

class _GlyphPainter extends CustomPainter {
  _GlyphPainter(this.icon, this.color);

  final _GlyphIcon icon;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()..color = color;

    switch (icon) {
      case _GlyphIcon.home:
        final path = Path()
          ..moveTo(w * 0.5, h * 0.1)
          ..lineTo(w * 0.9, h * 0.42)
          ..lineTo(w * 0.9, h * 0.9)
          ..lineTo(w * 0.58, h * 0.9)
          ..lineTo(w * 0.58, h * 0.6)
          ..lineTo(w * 0.42, h * 0.6)
          ..lineTo(w * 0.42, h * 0.9)
          ..lineTo(w * 0.1, h * 0.9)
          ..lineTo(w * 0.1, h * 0.42)
          ..close();
        canvas.drawPath(path, stroke);
      case _GlyphIcon.dashboard:
        canvas.drawArc(Rect.fromLTWH(w * 0.1, h * 0.1, w * 0.8, h * 0.8), 3.4, 2.7, false, stroke);
        canvas.drawLine(Offset(w * 0.5, h * 0.5), Offset(w * 0.74, h * 0.3), stroke);
        canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.05, fill);
      case _GlyphIcon.orders:
        final rect = Rect.fromLTWH(w * 0.12, h * 0.18, w * 0.76, h * 0.64);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(w * 0.06)), stroke);
        canvas.drawLine(Offset(w * 0.12, h * 0.44), Offset(w * 0.88, h * 0.44), stroke);
        canvas.drawLine(Offset(w * 0.5, h * 0.18), Offset(w * 0.5, h * 0.82), stroke);
      case _GlyphIcon.products:
        for (final dx in [0.14, 0.54]) {
          for (final dy in [0.14, 0.54]) {
            canvas.drawRRect(
              RRect.fromRectAndRadius(Rect.fromLTWH(w * dx, h * dy, w * 0.32, h * 0.32), Radius.circular(w * 0.05)),
              stroke,
            );
          }
        }
      case _GlyphIcon.customers:
        canvas.drawCircle(Offset(w * 0.5, h * 0.38), w * 0.16, stroke);
        final body = Path()
          ..moveTo(w * 0.22, h * 0.86)
          ..quadraticBezierTo(w * 0.5, h * 0.56, w * 0.78, h * 0.86);
        canvas.drawPath(body, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _GlyphPainter oldDelegate) => oldDelegate.icon != icon || oldDelegate.color != color;
}
