import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/example_code.dart';
import '../../src/placeholder_image.dart';

/// The "Masonry" example: a port of Bootstrap's own `examples/masonry` page.
///
/// `<div class="row" data-masonry='{"percentPosition": true }'>` is `BsRow(
/// masonry: true)`, which packs each column into the shortest stack as the
/// Masonry plugin does; the cards are [BsCard]s with the page's utilities
/// (`p-3`, `text-bg-primary`, `text-center`, `text-end`) on them.
class MasonryExamplePage extends StatelessWidget {
  const MasonryExamplePage({super.key});

  static const _scriptTag =
      '\n<script src="https://cdn.jsdelivr.net/npm/masonry-layout@4.2.2/dist/masonry.pkgd.min.js" '
      'integrity="sha384-GNFwBvfVxBkLMJpYMOABq3c+d3KnQxudP/mGPkzpZSTYykLBNsZEnG2D9G/X/+7D" '
      'crossorigin="anonymous" async></script>\n  ';

  static const _quote =
      'A well-known quote, contained in a blockquote element.';

  /// A `<p>`'s own margin: `1rem` below.
  static Widget _p(Widget child) => BsBox(mb: BsSpacing.s3, child: child);

  @override
  Widget build(BuildContext context) {
    final link = TextStyle(
      color: BsLink.colorOf(context),
      decoration: TextDecoration.underline,
      decorationColor: BsLink.colorOf(context),
    );
    // <main class="container py-5">
    return BsContainer(
      py: BsSpacing.s5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BsHeading(
            BsHeadingLevel.h1,
            child: Text('Bootstrap and Masonry'),
          ),
          // <p class="lead">
          _p(
            BsLead(
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Integrate '),
                    TextSpan(text: 'Masonry', style: link),
                    const TextSpan(
                      text: ' with the Bootstrap grid system and cards component.',
                    ),
                  ],
                ),
              ),
            ),
          ),
          _p(
            const Text(
              'Masonry is not included in Bootstrap. Add it by including the '
              'JavaScript plugin manually, or using a CDN like so:',
            ),
          ),
          // <pre><code>…</code></pre>
          BsBox(
            mb: BsSpacing.s3,
            child: BsPre(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(_scriptTag, softWrap: false),
              ),
            ),
          ),
          _p(
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'By adding '),
                  codeSpan(
                    context,
                    'data-masonry=\'{"percentPosition": true }\'',
                  ),
                  const TextSpan(text: ' to the '),
                  codeSpan(context, '.row'),
                  const TextSpan(
                    text:
                        " wrapper, we can combine the powers of Bootstrap's "
                        "responsive grid and Masonry's positioning.",
                  ),
                ],
              ),
            ),
          ),
          // <hr class="my-5">
          const BsHr(my: BsSpacing.s5),
          _row(context),
        ],
      ),
    );
  }

  // <div class="row" data-masonry='{"percentPosition": true }'>
  static Widget _row(BuildContext context) {
    // <div class="col-sm-6 col-lg-4 mb-4">
    Widget col(Widget card) => BsFlexItem(
      col: const BsResponsiveValue(sm: BsCol(6), lg: BsCol(4)),
      mb: BsSpacing.s4,
      child: card,
    );

    return BsRow(
      masonry: true,
      children: [
        col(
          _imageCard(
            context,
            height: 200,
            title: 'Card title that wraps to a new line',
            text:
                'This is a longer card with supporting text below as a '
                'natural lead-in to additional content. This content is a '
                'little bit longer.',
          ),
        ),
        // <div class="card p-3"><figure class="p-3 mb-0">
        col(
          BsCard(
            child: BsBox(
              p: BsSpacing.s3,
              child: BsBox(
                p: BsSpacing.s3,
                child: _figure(
                  context,
                  color: BsTextColor.bodySecondary.of(context),
                ),
              ),
            ),
          ),
        ),
        col(
          _imageCard(
            context,
            height: 200,
            title: 'Card title',
            text:
                'This card has supporting text below as a natural lead-in to '
                'additional content.',
            updated: true,
          ),
        ),
        // <div class="card text-bg-primary text-center p-3"><figure class="mb-0">
        col(
          BsCard(
            style: BsCardStyle(background: BsVariant.primary.color),
            child: BsBox(
              p: BsSpacing.s3,
              textColor: BsTextColor.white,
              textAlign: BsTextAlign.center,
              child: _figure(context, color: BsColors.white),
            ),
          ),
        ),
        // <div class="card text-center"><div class="card-body">
        col(
          BsCard(
            child: BsBox(
              textAlign: BsTextAlign.center,
              child: _body(
                context,
                title: 'Card title',
                text:
                    'This card has a regular title and short paragraph of '
                    'text below it.',
                updated: true,
              ),
            ),
          ),
        ),
        // <div class="card"><Placeholder class="card-img" height="260" text="Card image">
        col(
          const BsCard(
            child: BsCardImg(
              position: BsCardImgPosition.full,
              child: PlaceholderImage(height: 260, text: 'Card image'),
            ),
          ),
        ),
        // <div class="card p-3 text-end"><figure class="mb-0">
        col(
          BsCard(
            child: BsBox(
              p: BsSpacing.s3,
              textAlign: BsTextAlign.end,
              child: _figure(
                context,
                color: BsTextColor.bodySecondary.of(context),
              ),
            ),
          ),
        ),
        col(
          BsCard(
            child: _body(
              context,
              title: 'Card title',
              text:
                  'This is another card with title and supporting text below. '
                  'This card has some additional content to make it slightly '
                  'taller overall.',
              updated: true,
            ),
          ),
        ),
      ],
    );
  }

  // <figure class="mb-0"><blockquote class="blockquote"><p>…</p></blockquote>
  // <figcaption class="blockquote-footer mb-0 …">Someone famous in <cite>
  static Widget _figure(BuildContext context, {required Color color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const BsBlockquote(child: Text(_quote)),
        BsBlockquoteFooter(
          standalone: true,
          color: color,
          child: const Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Someone famous in '),
                TextSpan(
                  text: 'Source Title',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // <div class="card"><Placeholder class="card-img-top" …><div class="card-body">
  static Widget _imageCard(
    BuildContext context, {
    required double height,
    required String title,
    required String text,
    bool updated = false,
  }) {
    return BsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BsCardImg(
            child: PlaceholderImage(height: height, text: 'Image cap'),
          ),
          _body(context, title: title, text: text, updated: updated),
        ],
      ),
    );
  }

  // <div class="card-body"><h5 class="card-title">…<p class="card-text">…
  static Widget _body(
    BuildContext context, {
    required String title,
    required String text,
    bool updated = false,
  }) {
    // (A block: its lines fill the card, so `text-center` centres the title.)
    return BsBox(
      p: BsSpacing.s3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BsHeading(BsHeadingLevel.h5, child: Text(title)),
          // .card-text: a paragraph (1rem below) unless it is the last child.
          BsBox(mb: updated ? BsSpacing.s3 : BsSpacing.s0, child: Text(text)),
          if (updated)
            const BsBox(
              textColor: BsTextColor.bodySecondary,
              child: BsSmall(child: Text('Last updated 3 mins ago')),
            ),
        ],
      ),
    );
  }
}
