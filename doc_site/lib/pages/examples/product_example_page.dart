import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/example_container960.dart';
import '../../src/inline_line.dart';

/// The "Product" example: a port of Bootstrap's own `examples/product` page —
/// a `sticky-top` navbar (see [fixed]), a hero with two rotated "devices" and
/// rows of equal-width panels. The page's CSS (`.container { max-width: 960px }`,
/// `.icon-link`, `.product-device`, `.flex-md-equal`) is translated where it
/// is used.
class ProductExamplePage extends StatelessWidget {
  const ProductExamplePage({super.key});

  static const _expand = BsBreakpoint.md;
  static const _dummyDevice = Color(0xFF333333);

  static List<BsNavbarItem> _items() {
    // <a class="nav-link"><svg class="bi" width="24" height="24"> (hangs 2px below the baseline)
    Widget icon(BootstrapIconData data) => InlineLine(
      lowered: 2,
      child: BootstrapIcon(data, width: 24, height: 24),
    );
    return [
      BsNavbarItem(onTap: () {}, child: icon(BootstrapIconData.aperture)),
      for (final label in const [
        'Tour',
        'Product',
        'Features',
        'Enterprise',
        'Support',
        'Pricing',
      ])
        BsNavbarItem(onTap: () {}, child: Text(label)),
      BsNavbarItem(onTap: () {}, child: icon(BootstrapIconData.cart)),
    ];
  }

  /// `navbar navbar-expand-md bg-dark sticky-top border-bottom`, which sticks
  /// to the top of the viewport.
  static Widget fixed(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: BsTheme(
        brightness: Brightness.dark,
        child: BsBox(
          bg: BsBg.dark,
          borderBottom: true,
          child: Container960(
            child: BsNavbar(
              colorScheme: BsNavbarColorScheme.dark,
              expandBreakpoint: _expand,
              spreadItems: true,
              hideBrandWhenExpanded: true,
              // <a class="navbar-brand d-md-none"><svg class="bi" …> Aperture
              brand: const BsFlex(
                inline: true,
                alignItems: BsAlign.center,
                children: [
                  BootstrapIcon(
                    BootstrapIconData.aperture,
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 4),
                  Text('Aperture'),
                ],
              ),
              items: _items(),
              offcanvasBuilder: (context, links) => BsTheme(
                brightness: Brightness.dark,
                child: BsOffcanvas(
                  placement: BsOffcanvasPlacement.end,
                  header: BsOffcanvasHeader(
                    child: const Text('Aperture'),
                    onClose: () => Navigator.of(context).pop(),
                  ),
                  body: BsOffcanvasBody(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: links,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The sticky navbar is 62px tall expanded (icons hang below the text
    // baseline) and 57px collapsed.
    final expanded = MediaQuery.sizeOf(context).width >= _expand.minWidth;
    return Padding(
      padding: EdgeInsets.only(top: expanded ? 62 : 57),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _hero(context),
          // (`my-3 py-3` is `padX: false`, `my-3 p-3` is `padX: true`)
          _panels(context, const [
            (_Panel.textBgDark, false),
            (_Panel.tertiaryOnDark, true),
          ]),
          _panels(context, const [
            (_Panel.tertiaryOnDark, true),
            (_Panel.primary, false),
          ]),
          _panels(context, const [
            (_Panel.tertiaryOnBody, true),
            (_Panel.tertiaryOnBody, false),
          ]),
          _panels(context, const [
            (_Panel.tertiaryOnBody, true),
            (_Panel.tertiaryOnBody, false),
          ]),
          _footer(context),
        ],
      ),
    );
  }

  // --- hero ---

  static Widget _hero(BuildContext context) {
    final md =
        BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width).index >=
        BsBreakpoint.md.index;
    return BsBox(
      // position-relative overflow-hidden p-3 p-md-5 m-md-3 text-center bg-body-tertiary
      m: const BsResponsiveValue(md: BsSpacing.s3),
      textAlign: BsTextAlign.center,
      bg: BsBg.bodyTertiary,
      // (overflow clips at the padding box, so the padding sits inside it)
      child: ClipRect(
        child: Stack(
          children: [
            BsBox(
              p: const BsResponsiveValue(xs: BsSpacing.s3, md: BsSpacing.s5),
              child: _heroContent(context),
            ),
            if (md)
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, c) => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // .product-device { right: 10%; bottom: -30% }
                      Positioned(
                        right: c.maxWidth * 0.10,
                        bottom: -c.maxHeight * 0.30,
                        child: const _Device(color: _dummyDevice),
                      ),
                      // .product-device-2 { top: -25%; left: 5% }, #e5e5e5
                      Positioned(
                        left: c.maxWidth * 0.05,
                        top: -c.maxHeight * 0.25,
                        child: const _Device(color: Color(0xFFE5E5E5)),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Widget _heroContent(BuildContext context) {
    return BsBox(
      col: const BsResponsiveValue(md: BsCol(6)),
      p: const BsResponsiveValue(lg: BsSpacing.s5),
      mx: BsSpacing.auto,
      my: BsSpacing.s5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BsBox(
            mb: BsSpacing.s2,
            child: BsDisplayHeading(
              BsDisplayLevel.d3,
              fw: BsFw.bold,
              child: Text('Designed for engineers'),
            ),
          ),
          BsHeading(
            BsHeadingLevel.h3,
            fw: BsFw.normal,
            mb: BsSpacing.s3,
            child: DefaultTextStyle.merge(
              style: TextStyle(color: BsTextColor.bodySecondary.of(context)),
              child: const Text('Build anything you want with Aperture'),
            ),
          ),
          // <div class="d-flex gap-3 justify-content-center lead fw-normal">
          BsLead(
            child: BsBox(
              fw: BsFw.normal,
              child: BsFlex(
                gap: BsSpacing.s3,
                justifyContent: BsJustify.center,
                children: [
                  _iconLink(context, 'Learn more'),
                  _iconLink(context, 'Buy'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// `<a class="icon-link">Learn more <svg class="bi">` (`.75em` icon in the
  /// product page's CSS): `inline-flex`, a `.375rem` gap, underlined text.
  static Widget _iconLink(BuildContext context, String text) {
    final color = BsLink.colorOf(context);
    return BsFlex(
      inline: true,
      alignItems: BsAlign.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: color,
            decoration: TextDecoration.underline,
            decorationColor: color.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(width: 6),
        BootstrapIcon(
          BootstrapIconData.chevronRight,
          width: 15,
          height: 15,
          color: color,
        ),
      ],
    );
  }

  // --- the rows of panels ---

  static Widget _panels(BuildContext context, List<(_Panel, bool)> panels) {
    // <div class="d-md-flex flex-md-equal w-100 my-md-3 ps-md-3"> (its top
    // margin collapses into the previous section's bottom margin)
    return BsBox(
      mb: const BsResponsiveValue(md: BsSpacing.s3),
      ps: const BsResponsiveValue(md: BsSpacing.s3),
      child: BsFlex(
        direction: const BsResponsiveValue(
          xs: BsFlexDirection.column,
          md: BsFlexDirection.row,
        ),
        children: [
          for (final (kind, padX) in panels)
            BsFlexItem(
              col: const BsResponsiveValue(md: BsCol.equal),
              me: const BsResponsiveValue(md: BsSpacing.s3),
              child: _panel(context, kind, padX: padX),
            ),
        ],
      ),
    );
  }

  static Widget _panel(
    BuildContext context,
    _Panel kind, {
    required bool padX,
  }) {
    final device = switch (kind) {
      _Panel.textBgDark => BsBg.bodyTertiary,
      _Panel.primary => BsBg.bodyTertiary,
      _Panel.tertiaryOnDark => BsBg.dark,
      _Panel.tertiaryOnBody => BsBg.body,
    };
    return BsBox(
      textBg: switch (kind) {
        _Panel.textBgDark => BsVariant.dark,
        _Panel.primary => BsVariant.primary,
        _ => null,
      },
      bg: kind == _Panel.tertiaryOnDark || kind == _Panel.tertiaryOnBody
          ? BsBg.bodyTertiary
          : null,
      pt: const BsResponsiveValue(xs: BsSpacing.s3, md: BsSpacing.s5),
      px: const BsResponsiveValue(xs: BsSpacing.s3, md: BsSpacing.s5),
      textAlign: BsTextAlign.center,
      overflowHidden: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // <div class="my-3 py-3|p-3"><h2 class="display-5">…<p class="lead">
          BsBox(
            my: BsSpacing.s3,
            py: BsSpacing.s3,
            px: padX ? BsSpacing.s3 : null,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BsBox(
                  mb: BsSpacing.s2,
                  child: BsDisplayHeading(
                    BsDisplayLevel.d5,
                    child: Text('Another headline'),
                  ),
                ),
                BsBox(
                  mb: BsSpacing.s3,
                  child: BsLead(child: Text('And an even wittier subheading.')),
                ),
              ],
            ),
          ),
          // <div class="bg-dark shadow-sm mx-auto" style="width: 80%; height: 300px;
          //      border-radius: 21px 21px 0 0;">
          Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Builder(
                builder: (context) => BsDecoratedContainer(
                  height: 300,
                  decoration: BoxDecoration(
                    color: device.of(context),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(21),
                    ),
                    boxShadow: BsShadows.shadowSm,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- <footer class="container py-5"> ---

  static Widget _footer(BuildContext context) {
    Widget links(String title, List<String> items) => BsFlexItem(
      col: const BsResponsiveValue(xs: BsCol(6), md: BsCol.equal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BsHeading(BsHeadingLevel.h5, child: Text(title)),
          BsBox(
            mb: BsSpacing.s3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final item in items)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: BsAnchor(
                      textDecorationNone: true,
                      linkColor: BsTextColor.secondary,
                      child: Text(item),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    return Container960(
      py: BsSpacing.s5,
      child: BsRow(
        children: [
          BsFlexItem(
            col: const BsResponsiveValue(xs: BsCol(12), md: BsCol.equal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // <svg class="d-block mb-2" width="24" height="24" stroke…>
                const BsBox(
                  mb: BsSpacing.s2,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: BootstrapIcon(
                      BootstrapIconData.aperture,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                BsBox(
                  mb: BsSpacing.s3,
                  textColor: BsTextColor.bodySecondary,
                  child: BsSmall(
                    block: true,
                    child: Text('© 2017–${DateTime.now().year}'),
                  ),
                ),
              ],
            ),
          ),
          links('Features', const [
            'Cool stuff',
            'Random feature',
            'Team feature',
            'Stuff for developers',
            'Another one',
            'Last time',
          ]),
          links('Resources', const [
            'Resource name',
            'Resource',
            'Another resource',
            'Final resource',
          ]),
          links('Resources', const [
            'Business',
            'Education',
            'Government',
            'Gaming',
          ]),
          links('About', const ['Team', 'Locations', 'Privacy', 'Terms']),
        ],
      ),
    );
  }
}

enum _Panel { textBgDark, tertiaryOnDark, primary, tertiaryOnBody }

/// `.product-device`: a 300×540 rounded slab turned 30°, with its translucent
/// "screen" (`::before`: inset 10% top and bottom, 10px at the sides).
class _Device extends StatelessWidget {
  const _Device({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 30 * math.pi / 180,
      child: SizedBox(
        width: 300,
        height: 540,
        child: BsDecoratedContainer(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(21),
            boxShadow: BsShadows.shadowSm,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 54),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0x1AFFFFFF),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }
}
