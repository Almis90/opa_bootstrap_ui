import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/example_navbar_page.dart';
import '../../src/float_end_text.dart';
import '../../src/placeholder_image.dart';

/// The "Carousel" example: a port of Bootstrap's own `examples/carousel`
/// page — a `fixed-top` dark navbar (see [fixed]) over a 32rem carousel of
/// three slides with captions, three columns of marketing text with round
/// placeholders, three alternating featurettes and a footer. The page's CSS
/// (`carousel.css`) is translated where it is used.
class CarouselExamplePage extends StatelessWidget {
  const CarouselExamplePage({super.key});

  static const _expand = BsBreakpoint.md;

  /// The `position: fixed; top: 0; right: 0; left: 0` navbar.
  static Widget fixed(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: NavbarExampleBar(
        brand: 'Carousel',
        expandBreakpoint: _expand,
        items: navbarExampleItems(),
        trailing: const [NavbarSearchForm()],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // body { padding: 3rem 0 } (and `color: rgb(var(--bs-tertiary-color-rgb))`,
    // which is the body color: its rgb without the alpha)
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _carousel(context),
          BsContainer(child: _marketing(context)),
          BsContainer(child: _footer(context)),
        ],
      ),
    );
  }

  // --- <div id="myCarousel" class="carousel slide"> ---

  Widget _carousel(BuildContext context) {
    // `@media (min-width: 40em)`: a bigger caption paragraph.
    final wide = MediaQuery.sizeOf(context).width >= 640;
    final secondary = BsTextColor.bodySecondary.of(context);

    Widget caption(
      String title,
      String text,
      String button, {
      TextAlign align = TextAlign.center,
      bool faded = false,
    }) {
      Widget paragraph(Widget child) => Padding(
        padding: EdgeInsets.only(bottom: wide ? 20 : 16),
        child: DefaultTextStyle.merge(
          style: TextStyle(
            fontSize: wide ? 20 : null,
            height: wide ? 1.4 : null,
          ),
          child: child,
        ),
      );
      return DefaultTextStyle.merge(
        textAlign: align,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BsHeading(BsHeadingLevel.h1, child: Text(title)),
            paragraph(Opacity(opacity: faded ? 0.75 : 1, child: Text(text))),
            paragraph(
              Align(
                alignment: switch (align) {
                  TextAlign.start => Alignment.centerLeft,
                  TextAlign.end => Alignment.centerRight,
                  _ => Alignment.center,
                },
                child: BsButton(
                  size: BsSize.lg,
                  onPressed: () {},
                  child: Text(button),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final placeholder = ColoredBox(color: secondary);
    return Padding(
      // .carousel { margin-bottom: 4rem }
      padding: const EdgeInsets.only(bottom: 64),
      child: SizedBox(
        // .carousel-item { height: 32rem }
        height: 512,
        child: BsCarousel(
          style: const BsCarouselStyle(captionSpacer: 48),
          items: [
            BsCarouselItem(
              child: placeholder,
              caption: caption(
                'Example headline.',
                'Some representative placeholder content for the first slide '
                    'of the carousel.',
                'Sign up today',
                align: TextAlign.start,
                faded: true,
              ),
            ),
            BsCarouselItem(
              child: placeholder,
              caption: caption(
                'Another example headline.',
                'Some representative placeholder content for the second slide '
                    'of the carousel.',
                'Learn more',
              ),
            ),
            BsCarouselItem(
              child: placeholder,
              caption: caption(
                'One more for good measure.',
                'Some representative placeholder content for the third slide '
                    'of this carousel.',
                'Browse gallery',
                align: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- <div class="container marketing"> ---

  Widget _marketing(BuildContext context) {
    final secondary = BsTextColor.bodySecondary.of(context);
    Widget column(String text) {
      return BsFlexItem(
        col: const BsResponsiveValue(xs: BsCol(12), lg: BsCol(4)),
        // .marketing .col-lg-4 { margin-bottom: 1.5rem; text-align: center }
        mb: BsSpacing.s4,
        child: BsBox(
          textAlign: BsTextAlign.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // <svg width="140" height="140" class="rounded-circle">
              Align(
                alignment: Alignment.topCenter,
                child: ClipOval(
                  child: PlaceholderImage(
                    width: 140,
                    height: 140,
                    background: secondary,
                  ),
                ),
              ),
              const BsHeading(
                BsHeadingLevel.h2,
                fw: BsFw.normal,
                child: Text('Heading'),
              ),
              // .marketing .col-lg-4 p { margin: 0 .75rem 1rem }
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                child: Text(text),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: BsButton(
                    variant: BsVariant.secondary,
                    onPressed: () {},
                    child: const Text('View details »'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget divider() => const Padding(
      // .featurette-divider { margin: 5rem 0 }
      padding: EdgeInsets.symmetric(vertical: 80),
      child: BsHr(my: BsSpacing.s0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BsRow(
          children: [
            column(
              'Some representative placeholder content for the three columns '
              'of text below the carousel. This is the first column.',
            ),
            column(
              'Another exciting bit of representative placeholder content. '
              "This time, we've moved on to the second column.",
            ),
            column(
              'And lastly this, the third column of representative '
              'placeholder content.',
            ),
          ],
        ),
        divider(),
        _featurette(
          context,
          'First featurette heading. ',
          'It’ll blow your mind.',
          'Some great placeholder content for the first featurette here. '
              'Imagine some exciting prose here.',
          imageFirst: false,
        ),
        divider(),
        _featurette(
          context,
          'Oh yeah, it’s that good. ',
          'See for yourself.',
          'Another featurette? Of course. More placeholder content here to give '
              'you an idea of how this layout would work with some actual '
              'real-world content in place.',
          imageFirst: true,
        ),
        divider(),
        _featurette(
          context,
          'And lastly, this one. ',
          'Checkmate.',
          'And yes, this is the last block of representative placeholder '
              'content. Again, not really intended to be actually read, simply '
              'here to give you a better view of what this would look like '
              'with some actual content. Your content.',
          imageFirst: false,
        ),
        divider(),
      ],
    );
  }

  /// `<div class="row featurette">`: a `col-md-7` heading and lead, and a
  /// `col-md-5` placeholder (first, from `md`, with `order-md-1`/`2`).
  Widget _featurette(
    BuildContext context,
    String heading,
    String muted,
    String lead, {
    required bool imageFirst,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    final md = width >= BsBreakpoint.md.minWidth;
    final lg = width >= BsBreakpoint.lg.minWidth;
    final secondary = BsTextColor.bodySecondary.of(context);
    return BsRow(
      direction: BsResponsiveValue(
        xs: BsFlexDirection.row,
        md: imageFirst ? BsFlexDirection.rowReverse : BsFlexDirection.row,
      ),
      children: [
        BsFlexItem(
          col: const BsResponsiveValue(xs: BsCol(12), md: BsCol(7)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // .featurette-heading { letter-spacing: -.05rem; font-size: 50px
              // from 40em; margin-top: 7rem from 62em }
              Padding(
                padding: EdgeInsets.only(top: lg ? 112 : 0),
                child: _featuretteHeading(
                  width >= 640,
                  heading,
                  muted,
                  secondary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: BsLead(child: Text(lead)),
              ),
            ],
          ),
        ),
        BsFlexItem(
          col: const BsResponsiveValue(xs: BsCol(12), md: BsCol(5)),
          child: Align(
            alignment: Alignment.topCenter,
            child: AspectRatio(
              aspectRatio: 1,
              child: LayoutBuilder(
                builder: (context, constraints) => PlaceholderImage(
                  height: constraints.maxHeight,
                  text: '500x500',
                  fontSize: md ? 56 : 18,
                  background: BsBody.secondaryBackgroundOf(context),
                  color: secondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// `<h2 class="featurette-heading fw-normal lh-1">`: `50px` from `40em`,
  /// `letter-spacing: -.05rem`.
  static Widget _featuretteHeading(
    bool wide,
    String heading,
    String muted,
    Color secondary,
  ) {
    final text = Text.rich(
      TextSpan(
        style: const TextStyle(letterSpacing: -0.8),
        children: [
          TextSpan(text: heading),
          TextSpan(
            text: muted,
            style: TextStyle(color: secondary),
          ),
        ],
      ),
    );
    if (!wide) {
      return BsHeading(
        BsHeadingLevel.h2,
        fw: BsFw.normal,
        lh: BsLh.lh1,
        child: text,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DefaultTextStyle.merge(
        style: const TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.w400,
          height: 1,
        ),
        child: text,
      ),
    );
  }

  // --- <footer class="container"> ---

  Widget _footer(BuildContext context) {
    final link = BsLink.colorOf(context);
    TextSpan anchor(String text) => TextSpan(
      text: text,
      style: TextStyle(color: link, decoration: TextDecoration.underline),
    );
    return FloatEndText(
      floatText: 'Back to top',
      floatStyle: TextStyle(color: link, decoration: TextDecoration.underline),
      floatMarginBottom: 16,
      bottomMargin: 16,
      span: TextSpan(
        children: [
          TextSpan(text: '© 2017–${DateTime.now().year} Company, Inc. · '),
          anchor('Privacy'),
          const TextSpan(text: ' · '),
          anchor('Terms'),
        ],
      ),
    );
  }
}
