import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/example_divider.dart';

/// The "Dropdowns" example: a port of Bootstrap's own `examples/dropdowns`
/// page — `.dropdown-menu`s laid out statically (`position-static`), each in a
/// light and a dark (`data-bs-theme`) version: action lists, a filterable list
/// with colored dots, a list with icons, calendars and two-column "mega" menus.
/// The page's CSS (`dropdowns.css`) is translated where it is used.
class DropdownsExamplePage extends StatelessWidget {
  const DropdownsExamplePage({super.key});

  /// `<div class="d-flex flex-column flex-md-row p-4 gap-4 py-md-5 align-items-center justify-content-center">`
  static Widget _row(List<Widget> children) {
    return BsBox(
      p: BsSpacing.s4,
      py: const BsResponsiveValue(xs: BsSpacing.s4, md: BsSpacing.s5),
      child: BsFlex(
        direction: const BsResponsiveValue(
          xs: BsFlexDirection.column,
          md: BsFlexDirection.row,
        ),
        gap: BsSpacing.s4,
        alignItems: BsAlign.center,
        justifyContent: BsJustify.center,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _row([
          for (final dark in [false, true]) _ActionMenu(dark: dark),
        ]),
        const ExampleDivider(),
        _row([
          for (final dark in [false, true]) _FilterMenu(dark: dark),
        ]),
        const ExampleDivider(),
        _row([
          for (final dark in [false, true]) _IconMenu(dark: dark),
        ]),
        const ExampleDivider(),
        _row([
          for (final dark in [false, true]) _CalendarMenu(dark: dark),
        ]),
        const ExampleDivider(),
        _row([
          for (final dark in [false, true]) _MegaMenu(dark: dark),
        ]),
      ],
    );
  }
}

/// A static `.dropdown-menu`: the menu's colors for the theme it is in
/// (`data-bs-theme`), a `1px` translucent border (none with `border-0`), a
/// radius, a shadow, [padding] and [child].
class _Menu extends StatelessWidget {
  const _Menu({
    required this.dark,
    this.width,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.radius = 6,
    this.border = true,
    this.shadow = BsShadow.normal,
    this.clip = false,
    required this.child,
  });

  final bool dark;
  final double? width;
  final EdgeInsets padding;
  final double radius;
  final bool border;
  final BsShadow shadow;

  /// `overflow-hidden`.
  final bool clip;
  final Widget child;

  static BsDropdownStyle styleOf(bool dark) =>
      dark ? BsDropdownStyle.darkDefaults : BsDropdownStyle.defaults;

  @override
  Widget build(BuildContext context) {
    final style = styleOf(dark);
    final shape = BorderRadius.circular(radius);
    Widget content = Padding(padding: padding, child: child);
    if (clip) content = ClipRRect(borderRadius: shape, child: content);
    final text = DefaultTextStyle.merge(
      style: TextStyle(color: style.color),
      child: content,
    );
    // `.dropdown-menu` has `background-clip: padding-box`: the translucent border
    // is painted over what is behind the menu, so the background is the box
    // inside it.
    return BsTheme(
      brightness: dark ? Brightness.dark : Brightness.light,
      child: SizedBox(
        width: width,
        child: border
            ? BsDecoratedContainer(
                decoration: BoxDecoration(
                  border: Border.all(color: style.borderColor!),
                  borderRadius: shape,
                  boxShadow: shadow.shadows,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: BsDecoratedContainer(
                    decoration: BoxDecoration(
                      color: style.background,
                      borderRadius: BorderRadius.circular(
                        radius > 1 ? radius - 1 : 0,
                      ),
                    ),
                    child: text,
                  ),
                ),
              )
            : BsDecoratedContainer(
                decoration: BoxDecoration(
                  color: style.background,
                  borderRadius: shape,
                  boxShadow: shadow.shadows,
                ),
                child: text,
              ),
      ),
    );
  }
}

/// `.dropdown-item`: `.25rem 1rem` of padding, hover and `.active` backgrounds,
/// [radius] corners (`rounded-2`), and [danger] for `.dropdown-item-danger`.
class _Item extends StatefulWidget {
  const _Item({
    required this.dark,
    required this.child,
    this.active = false,
    this.danger = false,
    this.radius = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  });

  final bool dark;
  final Widget child;
  final bool active;
  final bool danger;
  final double radius;
  final EdgeInsets padding;

  @override
  State<_Item> createState() => _ItemState();
}

class _ItemState extends State<_Item> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final style = _Menu.styleOf(widget.dark);
    final red = BsColors.red;
    Color? background;
    Color color = style.linkColor!;
    if (widget.active) {
      background = style.linkActiveBackground;
      color = style.linkActiveColor!;
    } else if (widget.danger) {
      color = _hovered ? const Color(0xFFFFFFFF) : red;
      if (_hovered) background = red;
    } else if (_hovered) {
      background = style.linkHoverBackground;
    }
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: BsDecoratedContainer(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(widget.radius),
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: color),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// `<hr class="dropdown-divider">` in its `<li>`.
class _Divider extends StatelessWidget {
  const _Divider({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 1,
        child: ColoredBox(color: _Menu.styleOf(dark).dividerColor!),
      ),
    );
  }
}

// --- 1. `d-grid gap-1 p-2 rounded-3` ---

class _ActionMenu extends StatelessWidget {
  const _ActionMenu({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    Widget item(String text, {bool active = false}) =>
        _Item(dark: dark, active: active, radius: 6, child: Text(text));
    return _Menu(
      dark: dark,
      width: 220,
      padding: const EdgeInsets.all(8),
      radius: 8,
      // (the dark one is `border-0`)
      border: !dark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          item('Action', active: true),
          const SizedBox(height: 4),
          item('Another action'),
          const SizedBox(height: 4),
          item('Something else here'),
          const SizedBox(height: 4),
          _Divider(dark: dark),
          const SizedBox(height: 4),
          item('Separated link'),
        ],
      ),
    );
  }
}

// --- 2. a search field over dots ---

class _FilterMenu extends StatelessWidget {
  const _FilterMenu({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    Widget item(Color dot, String text) => _Item(
      dark: dark,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // <span class="d-inline-block bg-success rounded-circle p-1">
          SizedBox(
            width: 8,
            height: 8,
            child: DecoratedBox(
              decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
    return _Menu(
      dark: dark,
      width: 280,
      // pt-0 (and `border-0` on the dark one)
      padding: const EdgeInsets.only(bottom: 8),
      radius: 8,
      border: !dark,
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // <form class="p-2 mb-2 bg-body-tertiary border-bottom">
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: BsBox(
              p: BsSpacing.s2,
              bg: dark ? BsBg.dark : BsBg.bodyTertiary,
              borderBottom: true,
              child: BsFormControl(
                placeholder: 'Type to filter...',
                style: dark
                    ? const BsFormStyle(inputBackground: BsColors.gray900)
                    : null,
              ),
            ),
          ),
          item(BsVariant.success.color, 'Action'),
          item(BsVariant.primary.color, 'Another action'),
          item(BsVariant.danger.color, 'Something else here'),
          item(BsVariant.info.color, 'Separated link'),
        ],
      ),
    );
  }
}

// --- 3. icons ---

class _IconMenu extends StatelessWidget {
  const _IconMenu({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    Widget item(BootstrapIconData icon, String text, {bool danger = false}) =>
        _Item(
          dark: dark,
          danger: danger,
          child: Row(
            children: [
              BootstrapIcon(icon),
              const SizedBox(width: 8),
              Text(text),
            ],
          ),
        );
    return _Menu(
      dark: dark,
      width: 220,
      border: !dark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          item(BootstrapIconData.files, 'Documents'),
          item(BootstrapIconData.imageFill, 'Photos'),
          item(BootstrapIconData.film, 'Movies'),
          item(BootstrapIconData.musicNoteBeamed, 'Music'),
          item(BootstrapIconData.joystick, 'Games'),
          _Divider(dark: dark),
          // (`dropdown-item-danger` on the light menu's only)
          item(BootstrapIconData.trash, 'Trash', danger: !dark),
        ],
      ),
    );
  }
}

// --- 4. a calendar ---

class _CalendarMenu extends StatelessWidget {
  const _CalendarMenu({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    Widget cell(Widget child, {int flex = 1}) => Expanded(
      flex: flex,
      child: SizedBox(height: 48, child: Center(child: child)),
    );
    Widget day(int n, {bool disabled = false}) => cell(
      _CalButton(disabled: disabled, dark: dark, child: Text(n.toString())),
    );
    Widget arrow(BootstrapIconData icon) =>
        cell(_CalButton(dark: dark, child: BootstrapIcon(icon)));
    final days = <Widget>[];
    // June: the 30th and 31st of the month before, then 1–30 and the 31st (of
    // the 1st–31st grid).
    final numbers = [30, 31, for (var i = 1; i <= 31; i++) i];
    for (var r = 0; r < 5; r++) {
      final rowNumbers = numbers.skip(r * 7).take(7).toList();
      days.add(
        Row(
          children: [
            for (var c = 0; c < 7; c++)
              if (c < rowNumbers.length)
                day(rowNumbers[c], disabled: r == 0 && c < 2)
              else
                const Expanded(child: SizedBox(height: 48)),
          ],
        ),
      );
    }
    return _Menu(
      dark: dark,
      width: 340,
      padding: const EdgeInsets.all(8),
      radius: 8,
      child: Builder(
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                arrow(BootstrapIconData.arrowLeftShort),
                cell(
                  const Text(
                    'June',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  flex: 5,
                ),
                arrow(BootstrapIconData.arrowRightShort),
              ],
            ),
            DefaultTextStyle.merge(
              style: TextStyle(color: BsTextColor.bodySecondary.of(context)),
              child: Row(
                children: [
                  for (final d in [
                    'Sun',
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                  ])
                    cell(Text(d)),
                ],
              ),
            ),
            ...days,
          ],
        ),
      ),
    );
  }
}

/// `.btn.cal-btn`: medium weight, emphasis colored, a secondary-bg hover; a
/// `disabled` one is at half opacity.
class _CalButton extends StatefulWidget {
  const _CalButton({
    required this.dark,
    required this.child,
    this.disabled = false,
  });

  final bool dark;
  final bool disabled;
  final Widget child;

  @override
  State<_CalButton> createState() => _CalButtonState();
}

class _CalButtonState extends State<_CalButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final emphasis = BsBody.emphasisColorOf(context);
    return MouseRegion(
      cursor: widget.disabled
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.disabled ? null : () {},
        child: Opacity(
          opacity: widget.disabled ? 0.5 : 1,
          child: SizedBox.expand(
            child: ColoredBox(
              color: _hovered && !widget.disabled
                  ? BsBody.secondaryBackgroundOf(context)
                  : const Color(0x00000000),
              child: Center(
                child: DefaultTextStyle.merge(
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: widget.disabled ? null : emphasis,
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- 5. a mega menu ---

class _MegaMenu extends StatelessWidget {
  const _MegaMenu({required this.dark});

  final bool dark;

  static const _products = [
    (
      BootstrapIconData.imageFill,
      'Main product',
      'Take a tour through the product',
    ),
    (
      BootstrapIconData.musicNoteBeamed,
      'Another product',
      'Explore this other product we offer',
    ),
    (
      BootstrapIconData.questionCircle,
      'Support',
      'Get help from our support crew',
    ),
  ];

  static const _links = [
    'Documentation',
    'Use cases',
    'API status',
    'Partners',
    'Resources',
  ];

  @override
  Widget build(BuildContext context) {
    final lg = MediaQuery.sizeOf(context).width >= BsBreakpoint.lg.minWidth;
    final style = _Menu.styleOf(dark);
    final nav = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < _products.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          _MegaItem(dark: dark, product: _products[i]),
        ],
        // ul { margin-bottom: 1rem }
        const SizedBox(height: 16),
      ],
    );
    // (the menu's own theme: this context is outside the `_Menu`'s BsTheme, so
    // `BsLink.colorOf(context)` would be the page's, not the dark menu's)
    final link = dark ? BsLink.darkColor : BsLink.color;
    final linkHover = dark ? BsLink.darkHoverColor : BsLink.hoverColor;
    final links = DefaultTextStyle.merge(
      style: const TextStyle(fontSize: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < _links.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            _UnderlinedLink(_links[i], color: link, hoverColor: linkHover),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
    final vr = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: 1,
        child: ColoredBox(
          // `.vr.opacity-10`: `.opacity-10` replaces `.vr`'s own `.25`
          color: (style.color ?? const Color(0xFF000000)).withValues(
            alpha: 0.1 * (style.color?.a ?? 1),
          ),
        ),
      ),
    );
    return _Menu(
      dark: dark,
      padding: const EdgeInsets.all(16),
      radius: 8,
      shadow: BsShadow.lg,
      child: lg
          ? SizedBox(
              width: 441.1,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // col-lg-8: two thirds of the menu's content
                    SizedBox(width: 294.1, child: nav),
                    vr,
                    // (`col-lg-auto pe-3`, `111.5px` wide, of which `13.5px` overflow
                    // the menu: its width is its widest content, `col-lg-8`'s
                    // two thirds of which take more than the links leave)
                    SizedBox(
                      width: 98,
                      child: OverflowBox(
                        alignment: AlignmentDirectional.topStart,
                        minWidth: 0,
                        maxWidth: 140,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: links,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SizedBox(
              width: 280.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  nav,
                  // <hr class="d-lg-none">
                  const BsHr(),
                  links,
                ],
              ),
            ),
    );
  }
}

/// `a.btn.btn-hover-light.rounded-2.d-flex.align-items-start.gap-2.py-2.px-3
/// .lh-sm.text-start`.
class _MegaItem extends StatefulWidget {
  const _MegaItem({required this.dark, required this.product});

  final bool dark;
  final (BootstrapIconData, String, String) product;

  @override
  State<_MegaItem> createState() => _MegaItemState();
}

class _MegaItemState extends State<_MegaItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final style = _Menu.styleOf(widget.dark);
    final (icon, title, text) = widget.product;
    final color = _hovered ? BsLink.hoverColorOf(context) : style.color!;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: BsDecoratedContainer(
          // .btn { border: 1px solid transparent }
          padding: const EdgeInsets.fromLTRB(17, 9, 17, 9),
          decoration: BoxDecoration(
            color: _hovered ? style.linkHoverBackground : style.background,
            borderRadius: BorderRadius.circular(6),
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: color, height: 1.25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BootstrapIcon(icon, width: 24, height: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      // (`small` is inline: its line, in the div, is 20px)
                      SizedBox(
                        height: 20,
                        child: Text(text, style: const TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// `link-offset-2 link-underline link-underline-opacity-25
/// link-underline-opacity-75-hover`: a link whose underline sits `.25em` lower,
/// at 25% opacity (75% under the pointer).
class _UnderlinedLink extends StatefulWidget {
  const _UnderlinedLink(
    this.text, {
    required this.color,
    required this.hoverColor,
  });

  final String text;
  final Color color;

  /// `a:hover { color: var(--bs-link-hover-color) }`; the underline stays the
  /// link color, at `link-underline-opacity-75-hover`.
  final Color hoverColor;

  @override
  State<_UnderlinedLink> createState() => _UnderlinedLinkState();
}

class _UnderlinedLinkState extends State<_UnderlinedLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () {},
          child: CustomPaint(
            painter: _UnderlinePainter(
              widget.color.withValues(alpha: _hovered ? 0.75 : 0.25),
            ),
            child: Text(
              widget.text,
              style: TextStyle(
                color: _hovered ? widget.hoverColor : widget.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UnderlinePainter extends CustomPainter {
  _UnderlinePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // `text-underline-offset: .25em` of 14px below the baseline
    canvas.drawRect(
      Rect.fromLTWH(0, size.height - 2, size.width, 1),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_UnderlinePainter oldDelegate) =>
      oldDelegate.color != color;
}
