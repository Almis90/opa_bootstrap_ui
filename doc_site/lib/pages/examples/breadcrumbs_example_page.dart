import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/example_divider.dart';
import '../../src/inline_line.dart';

/// The "Breadcrumbs" example: a port of Bootstrap's own `examples/breadcrumbs`
/// page — four breadcrumbs in `.container.my-5`: the default one on a
/// tertiary background, one with a home icon, one with a chevron divider
/// (`.breadcrumb-chevron`) and a segmented one with arrow tips
/// (`.breadcrumb-custom`).
class BreadcrumbsExamplePage extends StatelessWidget {
  const BreadcrumbsExamplePage({super.key});

  /// `<div class="container my-5"><nav><ol class="breadcrumb …">`.
  static Widget _section(Widget breadcrumb) =>
      BsContainer(my: BsSpacing.s5, child: breadcrumb);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _section(_plain(context)),
        const ExampleDivider(),
        _section(_withIcon(context)),
        const ExampleDivider(),
        _section(_chevron(context)),
        const ExampleDivider(),
        _section(_custom(context)),
        const ExampleDivider(),
      ],
    );
  }

  // `breadcrumb p-3 bg-body-tertiary rounded-3` (its `mb-3` is swallowed by
  // the container's `my-5`)
  static BsBreadcrumbStyle _boxed(BuildContext context) => BsBreadcrumbStyle(
    padding: const EdgeInsets.all(16),
    marginBottom: 0,
    background: BsBody.tertiaryBackgroundOf(context),
    borderRadius: 8,
  );

  Widget _plain(BuildContext context) {
    return BsBreadcrumb(
      style: _boxed(context),
      items: [
        BsBreadcrumbItem(label: const Text('Home'), onTap: () {}),
        BsBreadcrumbItem(label: const Text('Library'), onTap: () {}),
        const BsBreadcrumbItem(label: Text('Data')),
      ],
    );
  }

  /// `<a class="link-body-emphasis"><svg class="bi"> <span class="visually-hidden">`.
  static Widget _homeIcon(BuildContext context) => InlineIcon(
    icon: BootstrapIconData.houseDoorFill,
    color: BsTextColor.bodyEmphasis.of(context),
  );

  /// `<a class="link-body-emphasis fw-semibold text-decoration-none">`.
  static Widget _semibold(BuildContext context, String text) => Text(
    text,
    style: TextStyle(
      color: BsTextColor.bodyEmphasis.of(context),
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.none,
    ),
  );

  Widget _withIcon(BuildContext context) {
    return BsBreadcrumb(
      style: _boxed(context),
      items: [
        BsBreadcrumbItem(label: _homeIcon(context), onTap: () {}),
        BsBreadcrumbItem(label: _semibold(context, 'Library'), onTap: () {}),
        const BsBreadcrumbItem(label: Text('Data')),
      ],
    );
  }

  Widget _chevron(BuildContext context) {
    final secondary = BsTextColor.bodySecondary.of(context);
    // `.breadcrumb-item::before { content: <chevron svg>; width/height: 1rem }`
    final divider = BootstrapIcon(
      BootstrapIconData.chevronRight,
      color: const Color(0xFF6C757D),
    );
    Widget item(Widget content, {bool first = false}) {
      return BsFlex(
        inline: true,
        gap: BsSpacing.s2,
        alignItems: BsAlign.center,
        children: [if (!first) divider, content],
      );
    }

    return BsBox(
      p: BsSpacing.s3,
      bg: BsBg.bodyTertiary,
      rounded: BsRounded.r3,
      child: DefaultTextStyle.merge(
        // line-height: 1
        style: const TextStyle(height: 1),
        child: BsFlex(
          gap: BsSpacing.s2,
          alignItems: BsAlign.center,
          children: [
            // (the icon hangs 2px below the baseline: a line of 17px)
            item(
              SizedBox(
                width: 16,
                height: 17,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: BootstrapIcon(
                    BootstrapIconData.houseDoorFill,
                    color: BsTextColor.bodyEmphasis.of(context),
                  ),
                ),
              ),
              first: true,
            ),
            item(_semibold(context, 'Library')),
            item(Text('Data', style: TextStyle(color: secondary))),
          ],
        ),
      ),
    );
  }

  Widget _custom(BuildContext context) {
    // (`text-center`; widthFactor: the item is as wide as its text until the
    // flex row grows it)
    Widget label(Widget child) => Center(widthFactor: 1, child: child);
    final home = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InlineIcon(
          icon: BootstrapIconData.houseDoorFill,
          color: BsTextColor.bodyEmphasis.of(context),
        ),
        const SizedBox(width: InlineIconLabel.inlineSpace),
        _semibold(context, 'Home'),
      ],
    );
    final items = <Widget>[
      _CustomCrumb(first: true, child: label(home)),
      _CustomCrumb(child: label(_semibold(context, 'Library'))),
      _CustomCrumb(
        last: true,
        child: label(
          Text(
            'Data',
            style: TextStyle(color: BsTextColor.bodySecondary.of(context)),
          ),
        ),
      ),
    ];
    return BsBox(
      bg: BsBg.bodyTertiary,
      border: true,
      rounded: BsRounded.r3,
      overflowHidden: true,
      textAlign: BsTextAlign.center,
      // .breadcrumb { display: flex; flex-wrap: wrap }
      child: BsFlex(wrap: true, children: items),
    );
  }
}

/// `.breadcrumb-custom .breadcrumb-item`: `flex-grow: 1; padding: .75rem 3rem`
/// (`1.5rem` at the ends) and, but for the last, an arrow tip on its right
/// edge: a rotated, scaled rounded square (`::after`) in the tertiary
/// background with a `1px` border-colored edge.
class _CustomCrumb extends StatelessWidget {
  const _CustomCrumb({
    required this.child,
    this.first = false,
    this.last = false,
  });

  final Widget child;
  final bool first;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return BsFlexItem(
      flexGrow: true,
      flexShrink: false,
      child: CustomPaint(
        foregroundPainter: last
            ? null
            : _ArrowPainter(
                fill: BsBody.tertiaryBackgroundOf(context),
                edge: BsBorders.colorOf(context),
              ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(first ? 24 : 48, 12, last ? 24 : 48, 12),
          child: child,
        ),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  const _ArrowPainter({required this.fill, required this.edge});

  final Color fill;
  final Color edge;

  @override
  void paint(Canvas canvas, Size size) {
    // top: 50%; right: -25px; width/height: 50px; margin-top: -25px
    canvas.save();
    canvas.translate(size.width, size.height / 2);
    // transform: scale(.707) rotate(45deg)
    canvas.scale(0.707);
    canvas.rotate(math.pi / 4);
    const box = Rect.fromLTRB(-25, -25, 25, 25);
    // border-top-right-radius: .5rem
    RRect rrect(Rect r) =>
        RRect.fromRectAndCorners(r, topRight: const Radius.circular(8));
    // box-shadow: 1px -1px var(--bs-border-color)
    canvas.drawRRect(
      rrect(box.shift(const Offset(1, -1))),
      Paint()..color = edge,
    );
    canvas.drawRRect(rrect(box), Paint()..color = fill);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ArrowPainter old) => old.fill != fill || old.edge != edge;
}
