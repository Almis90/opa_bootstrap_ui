import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/example_icon_link.dart';
import '../../src/placeholder_image.dart';
import '../../src/table_columns.dart';
import 'blog_example_content.dart';

/// The "Blog" example: a port of Bootstrap's own `examples/blog` page — a
/// masthead (Subscribe / logo / search + Sign up) over a scrolling category
/// nav, a featured post and two wide cards, then the posts beside a sidebar
/// (About, Recent posts, Archives, Elsewhere), and a footer. Headings are set
/// in Playfair Display (Amiri in the right-to-left page).
class BlogExamplePage extends StatelessWidget {
  const BlogExamplePage({super.key, this.rtl = false});

  /// The `blog-rtl` page: `dir="rtl"`, in Arabic.
  final bool rtl;

  BlogContent get _t => rtl ? BlogContent.ar : BlogContent.en;

  /// `h1`-`h6`, `.blog-header-logo`: `font-family: "Playfair Display",
  /// Georgia, "Times New Roman", serif` (`Amiri` in the RTL page).
  TextStyle get _serif => TextStyle(
    fontFamily: rtl ? 'Amiri' : 'Playfair Display',
    fontFamilyFallback: const ['Georgia', 'Times New Roman', 'serif'],
  );

  /// `.blog-post-meta { color: #727272 }`.
  static const _metaColor = Color(0xFF727272);

  @override
  Widget build(BuildContext context) {
    final page = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BsContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [_header(context), _scroller(context)],
          ),
        ),
        BsContainer(child: _main(context)),
        _footer(context),
      ],
    );
    return rtl
        ? Directionality(textDirection: TextDirection.rtl, child: page)
        : page;
  }

  // --- header ---

  /// `<header class="border-bottom lh-1 py-3">`
  Widget _header(BuildContext context) {
    final secondary = BsTextColor.secondary.of(context);
    return BsBox(
      borderBottom: true,
      lh: BsLh.lh1,
      py: BsSpacing.s3,
      child: BsRow(
        alignItems: BsAlign.center,
        justifyContent: BsJustify.between,
        children: [
          // <div class="col-4 pt-1"><a class="link-secondary">Subscribe</a>
          BsFlexItem(
            col: const BsCol(4),
            pt: BsSpacing.s1,
            child: Text(
              _t.subscribe,
              style: TextStyle(
                color: secondary,
                decoration: TextDecoration.underline,
                decorationColor: secondary,
              ),
            ),
          ),
          // <div class="col-4 text-center"><a class="blog-header-logo …">
          BsFlexItem(
            col: const BsCol(4),
            child: Text(
              _t.logo,
              textAlign: TextAlign.center,
              style: _serif.copyWith(
                fontSize: 36,
                color: BsTextColor.bodyEmphasis.of(context),
              ),
            ),
          ),
          // <div class="col-4 d-flex justify-content-end align-items-center">
          BsFlexItem(
            col: const BsCol(4),
            child: BsFlex(
              justifyContent: BsJustify.end,
              alignItems: BsAlign.center,
              children: [
                // <a class="link-secondary"><svg class="mx-3" …>
                BsFlexItem(
                  flexShrink: false,
                  mx: BsSpacing.s3,
                  child: BootstrapIcon(
                    BootstrapIconData.blogSearch,
                    width: 20,
                    height: 20,
                    color: secondary,
                  ),
                ),
                BsButton(
                  variant: BsVariant.secondary,
                  outline: true,
                  size: BsSize.sm,
                  onPressed: () {},
                  child: Text(_t.signUp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// `<div class="nav-scroller py-1 mb-3 border-bottom">`: 2.75rem high
  /// (padding and border included), clipping a nav that scrolls sideways.
  Widget _scroller(BuildContext context) {
    return BsBox(
      mb: BsSpacing.s3,
      child: SizedBox(
        height: 44,
        child: BsBox(
          borderBottom: true,
          child: ClipRect(
            child: OverflowBox(
              alignment: AlignmentDirectional.topStart,
              maxHeight: double.infinity,
              child: Padding(
                // `py-1`, less the nav's `margin-top: -1px`.
                padding: const EdgeInsets.only(top: 3),
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: IntrinsicWidth(
                        child: BsNav(
                          variant: BsNavVariant.underline,
                          nowrap: true,
                          justifyContent: const BsResponsiveValue.all(
                            BsJustify.between,
                          ),
                          items: [
                            for (var i = 0; i < _t.nav.length; i++)
                              BsNavItem(
                                active: i == 0,
                                textColor: BsTextColor.bodyEmphasis,
                                onTap: () {},
                                child: Text(_t.nav[i], softWrap: false),
                              ),
                          ],
                        ),
                      ),
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

  // --- main ---

  Widget _main(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _featured(context),
        // <div class="row mb-2">
        BsBox(
          mb: BsSpacing.s2,
          child: BsRow(
            children: [
              for (var i = 0; i < _t.cards.length; i++)
                BsFlexItem(
                  col: const BsResponsiveValue(xs: BsCol(12), md: BsCol(6)),
                  child: _card(context, _t.cards[i], i),
                ),
            ],
          ),
        ),
        BsRow(
          g: BsSpacing.s5,
          children: [
            BsFlexItem(
              col: const BsResponsiveValue(xs: BsCol(12), md: BsCol(8)),
              child: _posts(context),
            ),
            BsFlexItem(
              col: const BsResponsiveValue(xs: BsCol(12), md: BsCol(4)),
              child: _sidebar(context),
            ),
          ],
        ),
      ],
    );
  }

  /// `<div class="p-4 p-md-5 mb-4 rounded text-body-emphasis bg-body-secondary">`
  Widget _featured(BuildContext context) {
    final emphasis = BsTextColor.bodyEmphasis.of(context);
    return BsBox(
      p: const BsResponsiveValue(xs: BsSpacing.s4, md: BsSpacing.s5),
      mb: BsSpacing.s4,
      rounded: BsRounded.r2,
      textColor: BsTextColor.bodyEmphasis,
      bg: BsBg.bodySecondary,
      // <div class="col-lg-6 px-0">
      child: BsBox(
        col: const BsResponsiveValue(lg: BsCol(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // <h1 class="display-4 fst-italic">
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DefaultTextStyle.merge(
                style: _serif.copyWith(fontStyle: FontStyle.italic),
                child: BsDisplayHeading(
                  BsDisplayLevel.d4,
                  child: Text(_t.featuredTitle),
                ),
              ),
            ),
            // <p class="lead my-3">
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: BsLead(child: Text(_t.featuredLede)),
            ),
            // <p class="lead mb-0"><a class="text-body-emphasis fw-bold">
            BsLead(
              child: Text(
                _t.featuredLink,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: emphasis,
                  decoration: TextDecoration.underline,
                  decorationColor: emphasis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// `<div class="row g-0 border rounded overflow-hidden flex-md-row mb-4
  /// shadow-sm h-md-250 position-relative">`
  Widget _card(BuildContext context, BlogCard card, int index) {
    final width = MediaQuery.sizeOf(context).width;
    final dark = BsTheme.of(context) == Brightness.dark;
    final tall = width >= 768;
    final variant = index == 0 ? BsVariant.primary : BsVariant.success;
    final categoryColor = dark
        ? variant.darkTextEmphasis
        : variant.textEmphasis;
    final body = BsFlexItem(
      col: BsCol.equal,
      p: BsSpacing.s4,
      // <div class="… d-flex flex-column">, stretched to the card's height
      // (the 248px inside its borders — or, with the 250px thumbnail beside it,
      // that — less the 1.5rem of padding above and below).
      child: SizedBox(
        height: tall ? (width >= 992 ? 202 : 200) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // <strong class="d-inline-block mb-2 text-primary-emphasis">
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                card.category,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: categoryColor,
                ),
              ),
            ),
            // <h3 class="mb-0">
            DefaultTextStyle.merge(
              style: _serif,
              child: BsHeading(
                BsHeadingLevel.h3,
                mb: BsSpacing.s0,
                child: Text(card.title),
              ),
            ),
            // <div class="mb-1 text-body-secondary">
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                card.date,
                style: TextStyle(color: BsTextColor.bodySecondary.of(context)),
              ),
            ),
            // <p class="mb-auto">: takes the free height of the 250px card.
            if (tall) Expanded(child: Text(card.text)) else Text(card.text),
            // <a class="icon-link gap-1 icon-link-hover stretched-link">
            ExampleIconLink(
              text: card.link,
              icon: BootstrapIconData.chevronRight,
              gap: 4,
            ),
          ],
        ),
      ),
    );
    return BsBox(
      border: true,
      rounded: BsRounded.r2,
      overflowHidden: true,
      shadow: BsShadow.sm,
      mb: BsSpacing.s4,
      child: SizedBox(
        // (`box-sizing: border-box`: 250px with the 1px borders)
        height: tall ? 248 : null,
        child: BsRow(
          g: BsSpacing.s0,
          children: [
            body,
            // <div class="col-auto d-none d-lg-block">
            if (width >= 992)
              BsFlexItem(
                col: BsCol.auto,
                child: PlaceholderImage(
                  width: 200,
                  height: 250,
                  text: _t.thumbnail,
                  background: const Color(0xFF55595C),
                  color: const Color(0xFFECEEEF),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- posts ---

  Widget _posts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // <h3 class="pb-4 mb-4 fst-italic border-bottom">
        BsBox(
          pb: BsSpacing.s4,
          mb: BsSpacing.s4,
          borderBottom: true,
          child: DefaultTextStyle.merge(
            style: _serif.copyWith(fontStyle: FontStyle.italic),
            child: BsHeading(
              BsHeadingLevel.h3,
              mb: BsSpacing.s0,
              child: Text(_t.firehose),
            ),
          ),
        ),
        for (final post in _t.posts) _post(context, post),
        // <nav class="blog-pagination">
        Padding(
          padding: const EdgeInsets.only(bottom: 64),
          child: Wrap(
            spacing: 3.92,
            children: [
              BsButton(
                variant: BsVariant.primary,
                outline: true,
                rounded: BsRounded.pill,
                onPressed: () {},
                child: Text(_t.older),
              ),
              BsButton(
                variant: BsVariant.secondary,
                outline: true,
                rounded: BsRounded.pill,
                onPressed: null,
                child: Text(_t.newer),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// `<article class="blog-post">` (`margin-bottom: 4rem`).
  Widget _post(BuildContext context, BlogPost post) {
    return Padding(
      // (the last block's `margin-bottom: 1rem` collapses into the 4rem)
      padding: const EdgeInsets.only(bottom: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // <h2 class="display-5 link-body-emphasis mb-1">
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: DefaultTextStyle.merge(
              style: _serif.copyWith(
                color: BsTextColor.bodyEmphasis.of(context),
              ),
              child: BsDisplayHeading(
                BsDisplayLevel.d5,
                child: Text(post.title),
              ),
            ),
          ),
          // <p class="blog-post-meta">
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text.rich(
              TextSpan(
                style: const TextStyle(color: _metaColor),
                children: _spans(context, post.meta),
              ),
            ),
          ),
          for (var i = 0; i < post.blocks.length; i++)
            _block(
              context,
              post.blocks[i],
              // The paragraph's `margin-bottom` and the `hr`'s `margin-top`
              // collapse into one.
              collapseBottom:
                  i + 1 < post.blocks.length && post.blocks[i + 1] is BlogRule,
            ),
        ],
      ),
    );
  }

  List<InlineSpan> _spans(BuildContext context, List<BlogInline> inlines) {
    final link = BsLink.colorOf(context);
    final dark = BsTheme.of(context) == Brightness.dark;
    return [
      for (final i in inlines)
        switch (i.kind) {
          BlogInlineKind.text => TextSpan(text: i.text),
          BlogInlineKind.link => TextSpan(
            text: i.text,
            style: TextStyle(
              color: link,
              decoration: TextDecoration.underline,
              decorationColor: link,
            ),
          ),
          BlogInlineKind.strong => TextSpan(
            text: i.text,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          BlogInlineKind.em || BlogInlineKind.cite => TextSpan(
            text: i.text,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          BlogInlineKind.code => TextSpan(
            text: i.text,
            style: TextStyle(
              fontFamily: BsTypography.fontFamilyMonospace.first,
              fontFamilyFallback: BsTypography.fontFamilyMonospace
                  .skip(1)
                  .toList(),
              fontSize: BsCodeStyle.defaultCodeFontSize,
              color: dark
                  ? BsCodeStyle.defaultDarkCodeColor
                  : BsCodeStyle.defaultCodeColor,
            ),
          ),
          // abbr[title] { text-decoration: underline dotted }
          BlogInlineKind.abbr => TextSpan(
            text: i.text,
            style: const TextStyle(
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dotted,
            ),
          ),
          BlogInlineKind.del => TextSpan(
            text: i.text,
            style: const TextStyle(decoration: TextDecoration.lineThrough),
          ),
          BlogInlineKind.ins => TextSpan(
            text: i.text,
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
          // sub, sup { font-size: .75em; line-height: 0; position: relative }
          BlogInlineKind.sup || BlogInlineKind.sub => WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Transform.translate(
              offset: Offset(0, i.kind == BlogInlineKind.sup ? -8 : 4),
              child: Text(
                i.text,
                style: const TextStyle(fontSize: 12, height: 0),
              ),
            ),
          ),
        },
    ];
  }

  Widget _paragraph(
    BuildContext context,
    List<BlogInline> inlines, {
    bool collapseBottom = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: collapseBottom ? 0 : 16),
      child: Text.rich(TextSpan(children: _spans(context, inlines))),
    );
  }

  Widget _block(
    BuildContext context,
    BlogBlock block, {
    bool collapseBottom = false,
  }) {
    switch (block) {
      case BlogParagraph(:final inlines):
        return _paragraph(context, inlines, collapseBottom: collapseBottom);
      case BlogHeading(:final level, :final text):
        return DefaultTextStyle.merge(
          style: _serif,
          child: BsHeading(
            level == 2 ? BsHeadingLevel.h2 : BsHeadingLevel.h3,
            child: Text(text),
          ),
        );
      case BlogRule():
        return const BsHr();
      case BlogQuote(:final styled, :final inlines):
        return styled
            ? BsBlockquote(
                child: Text.rich(TextSpan(children: _spans(context, inlines))),
              )
            : _paragraph(context, inlines);
      case BlogList(:final ordered, :final items):
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < items.length; i++)
                _listItem(context, ordered ? '${i + 1}. ' : null, items[i]),
            ],
          ),
        );
      case BlogDefinitionList(:final entries):
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, (term, description)) in entries.indexed) ...[
                DefaultTextStyle.merge(
                  style: const TextStyle(fontWeight: FontWeight.w700),
                  child: Text.rich(TextSpan(children: _spans(context, term))),
                ),
                Padding(
                  // (the last `dd`'s margin collapses into the `dl`'s)
                  padding: EdgeInsets.only(
                    bottom: index == entries.length - 1 ? 0 : 8,
                  ),
                  child: Text.rich(
                    TextSpan(children: _spans(context, description)),
                  ),
                ),
              ],
            ],
          ),
        );
      case BlogPre(:final text):
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: BsPre(child: Text(text)),
        );
      case BlogTable(:final head, :final body, :final foot):
        final rows = [...body, ...foot];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: BsTable(
            columns: [for (final cell in head.first) Text(cell)],
            rows: [
              for (final row in rows)
                BsTableRow(cells: [for (final cell in row) Text(cell)]),
            ],
            columnWidths: proportionalTableColumns(context, head.first, rows),
          ),
        );
    }
  }

  /// A `<li>` of a `ul` (a disc) or `ol` (a `1. `): the marker sits outside the
  /// text, in the list's 2rem of padding.
  Widget _listItem(BuildContext context, String? number, List<BlogInline> i) {
    final color = DefaultTextStyle.of(context).style.color;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 32,
          height: 24,
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: number != null
                ? Text(number)
                : Padding(
                    padding: const EdgeInsetsDirectional.only(end: 9),
                    child: SizedBox(
                      width: 5,
                      height: 5,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        Expanded(child: Text.rich(TextSpan(children: _spans(context, i)))),
      ],
    );
  }

  // --- sidebar ---

  Widget _sidebar(BuildContext context) {
    Widget heading(String text) => DefaultTextStyle.merge(
      style: _serif.copyWith(fontStyle: FontStyle.italic),
      child: BsHeading(BsHeadingLevel.h4, child: Text(text)),
    );
    final link = BsLink.colorOf(context);
    Widget anchor(String text) => Text(
      text,
      style: TextStyle(
        color: link,
        decoration: TextDecoration.underline,
        decorationColor: link,
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // <div class="p-4 mb-3 bg-body-tertiary rounded">
        BsBox(
          p: BsSpacing.s4,
          mb: BsSpacing.s3,
          bg: BsBg.bodyTertiary,
          rounded: BsRounded.r2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [heading(_t.aboutTitle), Text(_t.aboutText)],
          ),
        ),
        // <div><h4 class="fst-italic">Recent posts</h4><ul class="list-unstyled">
        heading(_t.recentTitle),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (title, date) in _t.recent)
                _recent(context, title, date),
            ],
          ),
        ),
        // <div class="p-4"><h4 class="fst-italic">Archives</h4>
        BsBox(
          p: BsSpacing.s4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              heading(_t.archivesTitle),
              for (final month in _t.archives)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: anchor(month),
                ),
            ],
          ),
        ),
        // <div class="p-4"><h4 class="fst-italic">Elsewhere</h4>
        BsBox(
          p: BsSpacing.s4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              heading(_t.elsewhereTitle),
              for (final name in _t.elsewhere)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: anchor(name),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  /// `<a class="d-flex flex-column flex-lg-row gap-3 align-items-start
  /// align-items-lg-center py-3 link-body-emphasis text-decoration-none
  /// border-top">`
  Widget _recent(BuildContext context, String title, String date) {
    return BsBox(
      borderTop: true,
      py: BsSpacing.s3,
      textColor: BsTextColor.bodyEmphasis,
      child: BsFlex(
        direction: const BsResponsiveValue(
          xs: BsFlexDirection.column,
          lg: BsFlexDirection.row,
        ),
        gap: const BsResponsiveValue.all(BsSpacing.s3),
        alignItems: const BsResponsiveValue(
          xs: BsAlign.start,
          lg: BsAlign.center,
        ),
        children: [
          // <svg width="100%" height="96" …>
          const BsFlexItem(
            w: BsResponsiveValue.all(BsWidth.w100),
            child: PlaceholderImage(height: 96, background: Color(0xFF777777)),
          ),
          // <div class="col-lg-8">
          BsFlexItem(
            col: const BsResponsiveValue(lg: BsCol(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BsHeading(
                  BsHeadingLevel.h6,
                  mb: BsSpacing.s0,
                  child: DefaultTextStyle.merge(
                    style: _serif,
                    child: Text(title),
                  ),
                ),
                BsBox(
                  textColor: BsTextColor.bodySecondary,
                  child: BsSmall(child: Text(date)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- footer ---

  /// `<footer class="py-5 text-center text-body-secondary bg-body-tertiary">`
  Widget _footer(BuildContext context) {
    return BsBox(
      py: BsSpacing.s5,
      textAlign: const BsResponsiveValue.all(BsTextAlign.center),
      textColor: BsTextColor.bodySecondary,
      bg: BsBg.bodyTertiary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _paragraph(context, _t.footerText),
          // <p class="mb-0"><a href="#">Back to top</a></p>
          Text.rich(
            TextSpan(
              children: _spans(context, [
                BlogInline(BlogInlineKind.link, _t.backToTop),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
