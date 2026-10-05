import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

/// The "Cover" example: a port of Bootstrap's own `examples/cover` page — a
/// full-viewport dark page (`body.d-flex.h-100.text-center.text-bg-dark`, with
/// an inset glow and a soft text shadow on all text) around a `42em` column:
/// a masthead, a centred call to action and a footer.
class CoverExamplePage extends StatelessWidget {
  const CoverExamplePage({super.key});

  /// `body { text-shadow: 0 .05rem .1rem rgba(0, 0, 0, .5) }`.
  static const _textShadow = Shadow(
    color: Color(0x80000000),
    offset: Offset(0, 0.8),
    blurRadius: 1.6,
  );

  @override
  Widget build(BuildContext context) {
    final md = MediaQuery.sizeOf(context).width >= BsBreakpoint.md.minWidth;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: BsBox(
        textBg: BsVariant.dark,
        textAlign: BsTextAlign.center,
        child: CustomPaint(
          // body { box-shadow: inset 0 0 5rem rgba(0, 0, 0, .5) }
          painter: const _InsetGlow(),
          child: DefaultTextStyle.merge(
            style: const TextStyle(shadows: [_textShadow]),
            child: Align(
              alignment: Alignment.topCenter,
              // .cover-container { max-width: 42em } with p-3
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 672),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _header(md),
                      // (`mb-auto` on the header, `mt-auto` on the footer)
                      const Spacer(),
                      _main(context),
                      const Spacer(),
                      _footer(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- <header class="mb-auto"> ---

  Widget _header(bool md) {
    final title = const BsHeading(
      BsHeadingLevel.h3,
      mb: BsSpacing.s0,
      child: Text('Cover'),
    );
    final nav = Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        _MastheadLink('Home', active: true),
        SizedBox(width: 16),
        _MastheadLink('Features'),
        SizedBox(width: 16),
        _MastheadLink('Contact'),
      ],
    );
    // `float-md-start` / `float-md-end`: side by side from `md`, stacked (the
    // nav centred) below it.
    return md
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [title, nav],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              title,
              Align(alignment: Alignment.topCenter, child: nav),
            ],
          );
  }

  // --- <main class="px-3"> ---

  Widget _main(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BsHeading(BsHeadingLevel.h1, child: Text('Cover your page.')),
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: BsLead(
              child: Text(
                'Cover is a one-page template for building simple and '
                'beautiful home pages. Download, edit the text, and add your '
                'own fullscreen background photo to make it your own.',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: BsLead(
              child: Center(
                child: BsButton(
                  variant: BsVariant.light,
                  size: BsSize.lg,
                  fw: BsFw.bold,
                  // btn-light … border-white bg-white, with `color: #333`
                  style: const BsButtonStyle(
                    color: Color(0xFF333333),
                    background: Color(0xFFFFFFFF),
                    borderColor: Color(0xFFFFFFFF),
                    hoverColor: Color(0xFF333333),
                    hoverBackground: Color(0xFFFFFFFF),
                    hoverBorderColor: Color(0xFFFFFFFF),
                    activeColor: Color(0xFF333333),
                  ),
                  onPressed: () {},
                  child: const Text('Learn more'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- <footer class="mt-auto text-white-50"> ---

  Widget _footer(BuildContext context) {
    const white = Color(0xFFFFFFFF);
    const link = TextStyle(
      color: white,
      decoration: TextDecoration.underline,
      decorationColor: white,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: Color(0x80FFFFFF)),
        child: Text.rich(
          const TextSpan(
            children: [
              TextSpan(text: 'Cover template for '),
              TextSpan(text: 'Bootstrap', style: link),
              TextSpan(text: ', by '),
              TextSpan(text: '@mdo', style: link),
              TextSpan(text: '.'),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// `.nav-masthead .nav-link`: bold, `rgba(255, 255, 255, .5)` text with a
/// `.25rem` transparent bottom border (white when `.active`, `25%` white on
/// hover), `py-1 px-0`.
class _MastheadLink extends StatefulWidget {
  const _MastheadLink(this.label, {this.active = false});

  final String label;
  final bool active;

  @override
  State<_MastheadLink> createState() => _MastheadLinkState();
}

class _MastheadLinkState extends State<_MastheadLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.active;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: BsDecoratedContainer(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 4,
                color: active
                    ? const Color(0xFFFFFFFF)
                    : _hovered
                    ? const Color(0x40FFFFFF)
                    : const Color(0x00FFFFFF),
              ),
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: active ? const Color(0xFFFFFFFF) : const Color(0x80FFFFFF),
            ),
          ),
        ),
      ),
    );
  }
}

/// `box-shadow: inset 0 0 5rem rgba(0, 0, 0, .5)`: a dark glow around the
/// inside of the page's edges.
class _InsetGlow extends CustomPainter {
  const _InsetGlow();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.save();
    canvas.clipRect(rect);
    canvas.drawPath(
      Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(rect.inflate(80 * 3))
        ..addRect(rect),
      Paint()
        ..color = const Color(0x80000000)
        // blur 5rem: sigma 40
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_InsetGlow oldDelegate) => false;
}
