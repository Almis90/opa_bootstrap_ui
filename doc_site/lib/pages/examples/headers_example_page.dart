import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/dropdown_caret.dart';

/// The "Headers" example: a faithful port of Bootstrap's own
/// `examples/headers` page — the same brand text, nav items, and flex-wrap
/// reflow behavior as the original, which builds every header from plain
/// flex utility classes rather than the `.navbar` component (so none of
/// these collapse behind a hamburger toggle; they just reflow).
class HeadersExamplePage extends StatelessWidget {
  const HeadersExamplePage({super.key});

  static const _mainLabels = ['Home', 'Features', 'Pricing', 'FAQs', 'About'];
  static const _dashboardLabels = ['Overview', 'Inventory', 'Customers', 'Products'];

  /// A `<input type="search" class="form-control">` in a `.col-lg-auto` form:
  /// its width is the browser's intrinsic one for `size=20`, which depends on
  /// the font — 193px in Roboto (201px in San Francisco).
  static const _searchWidth = 193.0;

  /// `.me-2` (8px) plus the ~4px of inline whitespace the original's two
  /// adjacent `<button>`s are separated by in the markup.
  static const _buttonGap = 12.4;

  /// `.dropdown-menu.text-small.shadow` — Bootstrap's menus have no shadow
  /// of their own, so the original asks for one; `.text-small` is `85%`.
  static const _menuStyle = BsDropdownStyle(boxShadow: BsShadows.shadow, fontSize: 13.6);

  /// `.dropdown-menu.text-small` without `.shadow`.
  static const _textSmallMenuStyle = BsDropdownStyle(fontSize: 13.6);

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

  /// `.fs-4`: `calc(1.275rem + .3vw)` until `xl`, then a flat `1.5rem`.
  static double _fs4(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= BsBreakpoint.xl.minWidth ? 24.0 : 20.4 + width * 0.003;
  }

  static Widget _simpleHeader(BuildContext context) {
    final brandFontSize = _fs4(context);
    // The `<header>` (with its `border-bottom` and `mb-4`) lives *inside* the
    // `.container`, so the rule spans the container's content width, not the
    // page, and 1.5rem of margin separates it from the divider below.
    return _Container(
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: BsBorders.colorOf(context))),
        ),
        child: _flexHeader(
          breakpoint: BsBreakpoint.md,
          // brand `.mb-3` (`.mb-md-0` is moot: it's a row from md up)
          stacked: const {0: _Stacked(bottom: 16)},
          children: [
            _HomeLink(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _BootstrapMark(),
                  const SizedBox(width: 8),
                  Text(
                    'Simple header',
                    style: TextStyle(fontSize: brandFontSize, color: BsBody.emphasisColorOf(context)),
                  ),
                ],
              ),
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
      child: _Container(
        child: Center(
          child: BsNav(variant: BsNavVariant.pills, items: _pillNavItems(_mainLabels)),
        ),
      ),
    );
  }

  static Widget _ctaHeader(BuildContext context) {
    // As in the first header, the `<header>`'s `border-bottom`/`mb-4` sit
    // inside the `.container`.
    return _Container(
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: BsBorders.colorOf(context))),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            const brand = _HomeLink(child: _BootstrapMark());
            final nav = BsNav(
              variant: BsNavVariant.plain,
              alignment: WrapAlignment.center, // `.justify-content-center`
              style: _px2,
              items: _plainNavItems(_mainLabels, firstColor: BsColors.gray600),
            );
            final buttons = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                BsButton(variant: BsVariant.primary, outline: true, onPressed: () {}, child: const Text('Login')),
                const SizedBox(width: _buttonGap),
                BsButton(variant: BsVariant.primary, onPressed: () {}, child: const Text('Sign-up')),
              ],
            );
            if (MediaQuery.sizeOf(context).width < BsBreakpoint.md.minWidth) {
              // logo `.mb-2`; nav `.col-12.mb-2`; buttons
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // As in the wide layout the logo's column is taller than the logo:
                  // the line box under an inline-flex `<a>` adds the strut's descent
                  // (6.6px for Roboto at 16px/24px).
                  Padding(padding: const EdgeInsets.only(bottom: 6.6), child: brand),
                  const SizedBox(height: 8),
                  SizedBox(width: double.infinity, child: nav),
                  const SizedBox(height: 8),
                  buttons,
                ],
              );
            }
            // `.col-md-3` on each side (`.text-end` on the buttons) with
            // `justify-content-between`, so the nav lands dead-centre.
            final side = constraints.maxWidth * 0.25;
            return Row(
              children: [
                // The logo sits in an inline-flex `<a>` inside a block `.col-md-3`, so
                // it rests on the line's baseline with the strut's ~5.5px descent
                // below it, and the whole column is what's centred in the row — the
                // logo ends up at the row's top rather than its middle.
                SizedBox(
                  width: side,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(padding: const EdgeInsets.only(bottom: 5.5), child: brand),
                  ),
                ),
                Expanded(child: Center(child: nav)),
                SizedBox(
                  width: side,
                  child: Align(alignment: Alignment.centerRight, child: buttons),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static Widget _darkSearchHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: BsColors.gray900,
      child: _Container(
        child: _flexHeader(
          breakpoint: BsBreakpoint.lg,
          spacerAfterIndex: 1,
          // nav `.me-lg-auto`, form `.me-lg-3` (the logo's `.me-2` is part of its link, see _LogoLink)
          gaps: const {0: 0, 2: 16},
          // logo `.mb-2`; nav `.col-12.mb-2.mb-md-0`; form `.col-12.mb-3`
          stacked: const {
            0: _Stacked(bottom: 8),
            1: _Stacked(fullWidth: true, bottom: 8, bottomMd: 0),
            2: _Stacked(fullWidth: true, bottom: 16),
          },
          children: [
            const _LogoLink(white: true),
            BsNav(
              variant: BsNavVariant.plain,
              alignment: WrapAlignment.center, // `.justify-content-center`
              style: _px2,
              items: _plainNavItems(_mainLabels, firstColor: BsColors.gray600, restColor: BsColors.white),
            ),
            SizedBox(
              width: _searchWidth,
              child: BsFormControl(placeholder: 'Search...', style: _darkFormStyle(context)),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                BsButton(variant: BsVariant.light, outline: true, onPressed: () {}, child: const Text('Login')),
                const SizedBox(width: _buttonGap),
                BsButton(variant: BsVariant.warning, onPressed: () {}, child: const Text('Sign-up')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _dropdownHeader(BuildContext context) {
    // `<header class="p-3 mb-3 border-bottom">`: the 1rem margin keeps the rule
    // clear of the divider below.
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: BsBorders.colorOf(context))),
      ),
      child: _Container(
        child: _flexHeader(
          breakpoint: BsBreakpoint.lg,
          spacerAfterIndex: 1,
          // nav `.me-lg-auto`, form `.me-lg-3` (the logo's `.me-2` is part of its link, see _LogoLink)
          gaps: const {0: 0, 2: 16},
          // logo `.mb-2`; nav `.col-12.mb-2.mb-md-0`; form `.col-12.mb-3`
          stacked: const {
            0: _Stacked(bottom: 8),
            1: _Stacked(fullWidth: true, bottom: 8, bottomMd: 0),
            2: _Stacked(fullWidth: true, bottom: 16),
          },
          children: [
            const _LogoLink(),
            BsNav(
              variant: BsNavVariant.plain,
              alignment: WrapAlignment.center, // `.justify-content-center`
              style: _px2,
              items: _plainNavItems(
                _dashboardLabels,
                firstColor: BsColors.gray600,
                restColor: BsBody.emphasisColorOf(context),
              ),
            ),
            const SizedBox(
              width: _searchWidth,
              child: BsFormControl(placeholder: 'Search...'),
            ),
            BsDropdown(
              style: _textSmallMenuStyle, // this header's menu has no `.shadow`
              toggleBuilder: (context, toggle, isOpen) => MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(onTap: toggle, child: const _AvatarToggle()),
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
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: BsBorders.colorOf(context))),
      ),
      child: BsContainer.fluid(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                // `.mb-2.mb-lg-0` on the logo's `<a>`: below lg its margin box is
                // 8px taller than the logo, which sets the grid row's height.
                padding: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).width < BsBreakpoint.lg.minWidth ? 8 : 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: BsDropdown(
                    style: _menuStyle,
                    toggleBuilder: (context, toggle, isOpen) => MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: toggle,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const _BootstrapMark(),
                            // `.me-2` on the svg, then the caret's own margin.
                            const SizedBox(width: 8 + DropdownCaret.marginStart),
                            DropdownCaret(color: BsBody.emphasisColorOf(context)),
                          ],
                        ),
                      ),
                    ),
                    items: _logoMenuItems(),
                  ),
                ),
              ),
            ),
            // `d-grid gap-3`
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Expanded(child: BsFormControl(placeholder: 'Search...')),
                  // `.me-3` on the form
                  const SizedBox(width: 16),
                  BsDropdown(
                    style: _menuStyle,
                    toggleBuilder: (context, toggle, isOpen) => MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(onTap: toggle, child: const _AvatarToggle()),
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
    // `.container-fluid.pb-3`
    return BsContainer.fluid(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
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
      height: 242, // ten `<br>`s at 1.5 line-height, plus the 1px borders
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
          child: _Container(
            child: _flexHeader(
              breakpoint: BsBreakpoint.xs,
              // `.container.d-flex.flex-wrap`: the two navs (314 + 124px) wrap,
              // left-aligned, once they stop fitting on one line.
              minContentWidth: 438.7,
              wrapAlignment: WrapAlignment.start,
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
        // `<header class="py-3 mb-4 border-bottom">`
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: BsBorders.colorOf(context))),
          ),
          child: _Container(
            child: _flexHeader(
              breakpoint: BsBreakpoint.lg,
              // brand `.mb-3`; form `.col-12.mb-3`
              stacked: const {0: _Stacked(bottom: 16), 1: _Stacked(fullWidth: true, bottom: 16)},
              children: [
                _HomeLink(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _BootstrapMark(),
                      const SizedBox(width: 8),
                      Text(
                        'Double header',
                        style: TextStyle(fontSize: _fs4(context), color: BsBody.emphasisColorOf(context)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: _searchWidth,
                  child: BsFormControl(placeholder: 'Search...'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget _iconNavHeader(BuildContext context) {
    const icons = [
      (BootstrapIconData.home, 'Home'),
      (BootstrapIconData.speedometer2, 'Dashboard'),
      (BootstrapIconData.table, 'Orders'),
      (BootstrapIconData.grid, 'Products'),
      (BootstrapIconData.peopleCircle, 'Customers'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // `<div class="px-3 py-2 text-bg-dark border-bottom">` around a `.container`
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: BsColors.gray900,
            border: Border(bottom: BorderSide(color: BsBorders.colorOf(context))),
          ),
          child: _Container(
            child: _flexHeader(
              breakpoint: BsBreakpoint.lg,
              // logo `.my-2`; nav `.col-12.my-2.my-md-0.justify-content-center`
              stacked: const {
                0: _Stacked(top: 8, bottom: 8),
                1: _Stacked(fullWidth: true, top: 8, bottom: 8, topMd: 0, bottomMd: 0),
              },
              children: [
                const _LogoLink(white: true),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    for (final (icon, label) in icons)
                      _HomeLink(
                        child: Padding(
                          // `.nav-link`: .5rem 1rem
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              BootstrapIcon(
                                icon,
                                width: 24,
                                height: 24,
                                color: label == 'Home' ? BsColors.gray600 : BsColors.white,
                              ),
                              const SizedBox(height: 4), // `.mb-1`
                              Text(
                                label,
                                // `.text-small`: 85%
                                style: TextStyle(
                                  fontSize: 13.6,
                                  color: label == 'Home' ? BsColors.gray600 : BsColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // `<div class="px-3 py-2 border-bottom mb-3">` around a `.container`
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: BsBorders.colorOf(context))),
          ),
          child: _Container(
            child: _flexHeader(
              breakpoint: BsBreakpoint.lg,
              // form `.col-12.mb-2`
              stacked: const {0: _Stacked(fullWidth: true, bottom: 8)},
              children: [
                const SizedBox(
                  width: _searchWidth,
                  child: BsFormControl(placeholder: 'Search...'),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BsButton(variant: BsVariant.light, onPressed: () {}, child: const Text('Login')),
                    const SizedBox(width: _buttonGap),
                    BsButton(variant: BsVariant.primary, onPressed: () {}, child: const Text('Sign-up')),
                  ],
                ),
              ],
            ),
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

  /// `.form-control.form-control-dark.text-bg-dark`: white text on the
  /// header's own `#212529`, a `--bs-gray` border that turns white (with a
  /// translucent white ring) on focus. The placeholder keeps the page theme's
  /// `--bs-secondary-color` — which is why it vanishes into the dark field in
  /// light mode, exactly as in the original.
  static BsFormStyle _darkFormStyle(BuildContext context) => BsFormStyle(
    inputColor: BsColors.white,
    inputBackground: BsColors.gray900,
    inputBorderColor: BsColors.gray600,
    inputPlaceholderColor: BsBody.secondaryColorOf(context),
    inputFocusBorderColor: BsColors.white,
    inputFocusBoxShadow: const [BoxShadow(color: Color(0x40FFFFFF), spreadRadius: 4)],
  );
}

/// How one child of a [_flexHeader] behaves once the header has collapsed
/// below its breakpoint, where the original's `col-12`/`mb-*`/`my-*` classes
/// take over: [fullWidth] is `.col-12` (it takes a whole row, so whatever
/// follows wraps beneath it), and [top]/[bottom] are its margins, with [topMd]/[bottomMd] where a
/// `-md-0` class zeroes them again from `md` up.
class _Stacked {
  const _Stacked({this.fullWidth = false, this.top = 0, this.bottom = 0, this.topMd, this.bottomMd});

  final bool fullWidth;
  final double top;
  final double bottom;
  final double? topMd;
  final double? bottomMd;
}

/// Lays [children] out left-to-right with the free space after
/// [spacerAfterIndex] distributed to its right — the same effect Bootstrap's
/// real headers get from an `me-*-auto` class on one child — collapsing to
/// a centered, wrapped column below [breakpoint]. [gaps] overrides the
/// default [spacing] after the child at a given index (a `.me-*` margin), and
/// [stacked] describes each child's `col-12`/margins in the collapsed layout,
/// and [wrapAlignment] is that layout's `justify-content`.
///
/// The breakpoint is compared with the *viewport*, as CSS media queries are,
/// not with the width the header happens to be given.
Widget _flexHeader({
  required List<Widget> children,
  required BsBreakpoint breakpoint,
  int spacerAfterIndex = 0,
  Map<int, double> gaps = const {},
  Map<int, _Stacked> stacked = const {},
  double spacing = 16,
  double? minContentWidth,
  WrapAlignment wrapAlignment = WrapAlignment.center,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final viewport = MediaQuery.sizeOf(context).width;
      // A bare `flex-wrap` container (no breakpoint classes) wraps once its
      // children no longer fit side by side: [minContentWidth] is their combined
      // natural width.
      final tooNarrow = minContentWidth != null && constraints.maxWidth < minContentWidth;
      if (viewport < breakpoint.minWidth || tooNarrow) {
        final md = viewport >= BsBreakpoint.md.minWidth;
        return Wrap(
          alignment: wrapAlignment,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (var i = 0; i < children.length; i++)
              () {
                final spec = stacked[i] ?? const _Stacked();
                Widget child = children[i];
                if (spec.fullWidth) child = SizedBox(width: double.infinity, child: child);
                return Padding(
                  padding: EdgeInsets.only(
                    top: md ? (spec.topMd ?? spec.top) : spec.top,
                    bottom: md ? (spec.bottomMd ?? spec.bottom) : spec.bottom,
                  ),
                  child: child,
                );
              }(),
          ],
        );
      }
      final row = <Widget>[];
      for (var i = 0; i < children.length; i++) {
        row.add(children[i]);
        if (i == children.length - 1) continue;
        row.add(i == spacerAfterIndex ? const Spacer() : SizedBox(width: gaps[i] ?? spacing));
      }
      return Row(crossAxisAlignment: CrossAxisAlignment.center, children: row);
    },
  );
}

/// Bootstrap's own `.b-example-divider`: a 3rem gray band with a translucent
/// fill, a 1px top/bottom border, and two inset shadows (`inset 0 .5em 1.5em`
/// at .1 and `inset 0 .125em .5em` at .15) separating stacked examples on the
/// same page — the real page has no label or description between sections,
/// just this.
class _ExampleDivider extends StatelessWidget {
  const _ExampleDivider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 48,
      width: double.infinity,
      child: CustomPaint(painter: _DividerPainter()),
    );
  }
}

/// Flutter's [BoxShadow] has no CSS-style `inset`, so the shadows are drawn
/// by hand: the area *outside* the padding box, shifted by the shadow's
/// offset and blurred, clipped back to the padding box.
class _DividerPainter extends CustomPainter {
  const _DividerPainter();

  static const _border = Color(0x26000000);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0x1A000000));

    final inner = Rect.fromLTRB(0, 1, size.width, size.height - 1); // inside the borders
    canvas.save();
    canvas.clipRect(inner);
    // (offset y, blur radius, alpha); CSS draws the first shadow on top.
    for (final (dy, blur, alpha) in const [(2.0, 8.0, 0.15), (8.0, 24.0, 0.1)]) {
      final outside = Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(inner.inflate(blur * 3 + dy))
        ..addRect(inner.shift(Offset(0, dy)));
      canvas.drawPath(
        outside,
        Paint()
          ..color = Color.fromRGBO(0, 0, 0, alpha)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur / 2),
      );
    }
    canvas.restore();

    final border = Paint()..color = _border;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 1), border);
    canvas.drawRect(Rect.fromLTWH(0, size.height - 1, size.width, 1), border);
  }

  @override
  bool shouldRepaint(covariant _DividerPainter oldDelegate) => false;
}

/// Anything that's an `<a href>` in the original: shows the pointer cursor.
/// The example has nowhere to navigate, so a tap does nothing.
class _HomeLink extends StatelessWidget {
  const _HomeLink({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(onTap: () {}, child: child),
  );
}

/// `.container`: its max-width follows the *viewport's* breakpoint, as CSS media
/// queries do. [BsContainer] picks it from the width it is given instead, which
/// is narrower wherever the page puts padding around the container (the
/// original's `<header class="p-3">` around a `.container`): at a 1000px
/// viewport that's 968px — below `lg` — so it would pick the 720px `md`
/// container the original doesn't use.
class _Container extends StatelessWidget {
  const _Container({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final breakpoint = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: BsGrid.containerMaxWidthFor(breakpoint) ?? double.infinity),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: BsGrid.containerPaddingX),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// The logo as the original's headers 4, 5 and 8 have it: an `<a>` around an
/// `<svg class="bi me-2">`, so the link is the logo *plus* 8px on its right —
/// which is what a centred (stacked) layout centres, putting the logo 4px left
/// of true centre.
class _LogoLink extends StatelessWidget {
  const _LogoLink({this.white = false});

  final bool white;

  @override
  Widget build(BuildContext context) => _HomeLink(
    child: Padding(
      padding: const EdgeInsets.only(right: 8),
      child: _BootstrapMark(white: white),
    ),
  );
}

/// Bootstrap's own logo (`<svg class="bi" width="40" height="32">`), drawn
/// from the example's own `<symbol id="bootstrap">` path data. Fills with
/// `currentColor`: `link-body-emphasis` by default, `text-white` when [white].
class _BootstrapMark extends StatelessWidget {
  const _BootstrapMark({this.white = false});

  final bool white;

  @override
  Widget build(BuildContext context) => BootstrapIcon(
    BootstrapIconData.bootstrap,
    width: 40,
    height: 32,
    color: white ? BsColors.white : BsBody.emphasisColorOf(context),
  );
}

/// An avatar `.dropdown-toggle`: the image with the CSS caret after it, in
/// `link-body-emphasis`. Reboot gives `img` `vertical-align: middle`, and the
/// caret is an inline-block raised `.255em` off the baseline — which puts its
/// bottom edge level with the image's vertical centre, so it hangs in the
/// upper half beside the avatar.
class _AvatarToggle extends StatelessWidget {
  const _AvatarToggle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const _GithubAvatar(),
        // The caret's own margin, plus the space character the markup leaves
        // between `<img>` and the `::after` caret (3.9px in Roboto at 16px).
        const SizedBox(width: DropdownCaret.marginStart + 3.92),
        // Bottom padding equal to the caret's height centres the pair on the
        // avatar, leaving the caret's bottom edge on the avatar's midline.
        Padding(
          padding: EdgeInsets.only(bottom: DropdownCaret.heightFor(context)),
          child: DropdownCaret(color: BsBody.emphasisColorOf(context)),
        ),
      ],
    );
  }
}

/// The same avatar Bootstrap's own dropdown examples use (`github.com/mdo.png`).
/// That URL redirects to `avatars.githubusercontent.com` without CORS headers
/// on the redirect, which Flutter web's canvas image loader needs, so the
/// final URL is used directly.
class _GithubAvatar extends StatelessWidget {
  const _GithubAvatar({this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.network(
        'https://avatars.githubusercontent.com/u/98681?v=4',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          color: BsColors.gray400,
          child: Text(
            'M',
            style: TextStyle(color: BsColors.white, fontSize: size * 0.42, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
