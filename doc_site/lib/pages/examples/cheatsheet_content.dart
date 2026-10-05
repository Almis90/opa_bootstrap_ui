import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/placeholder_image.dart';
import '../../src/table_columns.dart';
import 'cheatsheet_env.dart';

/// The "Contents" section of the Cheatsheet: Typography, Images, Tables and
/// Figures (examples 0-14).

/// Typography (`#typography`, examples 0-7).
List<Widget> cheatsheetTypography(BuildContext context, CsEnv env) {
  TextSpan styled(String text, TextStyle style) =>
      TextSpan(text: text, style: style);
  final s3 = env.s(3);
  final s5 = env.s(5);
  final s6 = env.s(6);
  Widget bullet(String text) => CsListItem(circle: true, child: Text(text));
  return [
    // <p class="display-1">…
    csBlocks([
      for (var i = 0; i < 6; i++)
        BsDisplayHeading(BsDisplayLevel.values[i], child: Text(env.s(0)[i])),
    ]),
    // <p class="h1">…
    csBlocks([
      for (var i = 0; i < 6; i++)
        BsHeading(
          BsHeadingLevel.values[i],
          mb: BsSpacing.s0,
          child: Text(env.s(1)[i]),
        ),
    ], gap: 8),
    // <p class="lead">
    BsLead(child: Text(env.s(2)[0])),
    // mark, del, s, ins, u, small, strong, em
    csBlocks([
      Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '${s3[0]} '),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: BsMark(child: Text(s3[1])),
            ),
            TextSpan(text: ' ${s3[2]}'),
          ],
        ),
      ),
      Text.rich(
        styled(s3[3], const TextStyle(decoration: TextDecoration.lineThrough)),
      ),
      Text.rich(
        styled(s3[4], const TextStyle(decoration: TextDecoration.lineThrough)),
      ),
      Text.rich(
        styled(s3[5], const TextStyle(decoration: TextDecoration.underline)),
      ),
      Text.rich(
        styled(s3[6], const TextStyle(decoration: TextDecoration.underline)),
      ),
      BsSmall(child: Text(s3[7])),
      Text.rich(styled(s3[8], const TextStyle(fontWeight: FontWeight.w700))),
      Text.rich(styled(s3[9], const TextStyle(fontStyle: FontStyle.italic))),
    ]),
    // <hr>: its margins collapse into the gap between examples.
    const BsHr(my: BsResponsiveValue.all(BsSpacing.s0)),
    // <blockquote class="blockquote"><p>…</p><footer class="blockquote-footer">
    CsTrimBottom(
      by: 16,
      child: BsBlockquote(
        footer: BsBlockquoteFooter(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '${s5[1]} '),
                styled(s5[2], const TextStyle(fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        ),
        child: Text(s5[0]),
      ),
    ),
    // <ul class="list-unstyled"> with a nested ul
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < 5; i++) Text(s6[i]),
        bullet(s6[5]),
        bullet(s6[6]),
        bullet(s6[7]),
        Text(s6[8]),
      ],
    ),
    // <ul class="list-inline">
    Wrap(
      spacing: 8 + 3.92,
      children: [for (final text in env.s(7)) Text(text)],
    ),
  ];
}

/// A `<li>` of a nested `ul` (a circle) or a `ul` (a disc): the marker sits
/// outside the text, in the list's 2rem of padding.
class CsListItem extends StatelessWidget {
  const CsListItem({super.key, required this.child, this.circle = false});

  final Widget child;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    final color =
        DefaultTextStyle.of(context).style.color ?? const Color(0xFF000000);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 32,
          height: 24,
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 9),
              child: SizedBox(
                width: 5,
                height: 5,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: circle ? null : color,
                    border: circle ? Border.all(color: color) : null,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

/// Images (`#images`, examples 8-9).
List<Widget> cheatsheetImages(BuildContext context, CsEnv env) {
  final width = MediaQuery.sizeOf(context).width;
  return [
    // <Placeholder width="100%" height="250" class="bd-placeholder-img-lg img-fluid" …>
    PlaceholderImage(
      height: 250,
      text: env.s(8)[1],
      fontSize: width >= 768 ? 56 : 18,
    ),
    // <Placeholder width="200" height="200" class="img-thumbnail" …>
    Align(
      alignment: AlignmentDirectional.centerStart,
      child: BsThumbnail(
        // (the 1px border sits inside the box here, not around it)
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: PlaceholderImage(width: 190, height: 190, text: env.s(9)[1]),
        ),
      ),
    ),
  ];
}

/// Tables (`#tables`, examples 10-13).
List<Widget> cheatsheetTables(BuildContext context, CsEnv env) {
  Widget table(
    int example, {
    required int columns,
    bool striped = false,
    bool dark = false,
    bool borderless = false,
    bool hover = false,
    bool small = false,
    bool bordered = false,
    List<BsVariant?>? variants,
  }) {
    final s = env.s(example);
    final head = s.sublist(0, columns);
    final body = [
      for (var i = columns; i < s.length; i += columns)
        s.sublist(i, i + columns),
    ];
    return BsTable(
      striped: striped,
      dark: dark,
      borderless: borderless,
      hover: hover,
      small: small,
      bordered: bordered,
      columns: [for (final h in head) Text(h)],
      rows: [
        for (var r = 0; r < body.length; r++)
          BsTableRow(
            variant: variants?[r],
            cells: [
              for (var c = 0; c < columns; c++)
                // (`<th scope="row">`)
                Text(
                  body[r][c],
                  style: c == 0
                      ? const TextStyle(fontWeight: FontWeight.w700)
                      : null,
                ),
            ],
          ),
      ],
      columnWidths: proportionalTableColumns(
        context,
        head,
        body,
        cellPadding: small ? 8 : 16,
        rowHeadWeights: [
          FontWeight.w700,
          for (var i = 1; i < columns; i++) null,
        ],
      ),
    );
  }

  return [
    table(10, columns: 4, striped: true),
    table(11, columns: 4, dark: true, borderless: true),
    table(
      12,
      columns: 3,
      hover: true,
      variants: [
        null,
        BsVariant.primary,
        BsVariant.secondary,
        BsVariant.success,
        BsVariant.danger,
        BsVariant.warning,
        BsVariant.info,
        BsVariant.light,
        BsVariant.dark,
      ],
    ),
    table(13, columns: 4, small: true, bordered: true),
  ];
}

/// Figures (`#figures`, example 14).
List<Widget> cheatsheetFigures(BuildContext context, CsEnv env) {
  return [
    // `<figure class="figure">`: inline-block, with Reboot's `margin-bottom: 1rem`.
    LayoutBuilder(
      builder: (context, constraints) {
        // `img-fluid`: never wider than the figure's container, keeping its ratio.
        final width = constraints.maxWidth < 400 ? constraints.maxWidth : 400.0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: SizedBox(
              width: width,
              child: BsFigure(
                image: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(BsRounded.r2.radius),
                    child: PlaceholderImage(
                      width: width,
                      height: width * 0.75,
                      text: env.s(14)[1],
                    ),
                  ),
                ),
                caption: BsFigureCaption(child: Text(env.s(14)[2])),
              ),
            ),
          ),
        );
      },
    ),
  ];
}
