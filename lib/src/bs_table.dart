import 'package:flutter/widgets.dart';

import 'bs_colors.dart';
import 'bs_theme.dart';
import 'bs_variant.dart';
import 'tokens/bs_table_style.dart';

/// A single `<tr>`'s cells, plus the row-level modifiers Bootstrap applies
/// via `.table-{variant}`/`.table-active`.
class BsTableRow {
  const BsTableRow({required this.cells, this.variant, this.active = false});

  /// One widget per column, typically [Text].
  final List<Widget> cells;

  /// `.table-{variant}`: tints this row with [BsVariant.bgSubtle].
  final BsVariant? variant;

  /// `.table-active`: darkens this row via
  /// [BsTableStyle.activeBackgroundOpacity].
  final bool active;
}

/// A Bootstrap table (`.table`).
///
/// Renders with Flutter's [Table], so columns auto-size to their widest
/// cell by default — pass [columnWidths] for Bootstrap's `.table>:not(caption)>*>*`
/// per-column control (e.g. `{0: FixedColumnWidth(120)}`).
class BsTable extends StatefulWidget {
  const BsTable({
    super.key,
    this.columns,
    required this.rows,
    this.striped = false,
    this.bordered = false,
    this.borderless = false,
    this.hover = false,
    this.small = false,
    this.dark = false,
    this.columnWidths,
    this.caption,
    this.style,
  });

  /// `<thead>` header cells. Omit for a table with no header row.
  final List<Widget>? columns;

  /// `<tbody>` rows.
  final List<BsTableRow> rows;

  /// `.table-striped`: tints every other row via
  /// [BsTableStyle.stripedBackgroundOpacity].
  final bool striped;

  /// `.table-bordered`: adds borders on all sides of every cell, not just
  /// horizontal rules between rows.
  final bool bordered;

  /// `.table-borderless`: removes all borders, including the horizontal
  /// rules between rows.
  final bool borderless;

  /// `.table-hover`: tints whichever row the pointer is over via
  /// [BsTableStyle.hoverBackgroundOpacity].
  final bool hover;

  /// `.table-sm`: halves cell padding to [BsTableStyle.cellPaddingSm].
  final bool small;

  /// `.table-dark`: inverts to a dark background with light text.
  final bool dark;

  /// Per-column sizing, keyed by column index. Defaults to
  /// [IntrinsicColumnWidth] for every column, like an unstyled HTML table.
  final Map<int, TableColumnWidth>? columnWidths;

  /// `<caption>`: an optional summary rendered below the table (Bootstrap's
  /// default `caption-side: bottom`), tinted with
  /// [BsTableStyle.captionColor].
  final Widget? caption;

  /// Style overrides layered on top of [BsTableStyle.defaults].
  final BsTableStyle? style;

  @override
  State<BsTable> createState() => _BsTableState();
}

class _BsTableState extends State<BsTable> {
  int? _hoveredRow;

  void _setHovered(int? row) {
    if (_hoveredRow != row) setState(() => _hoveredRow = row);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsTableStyle.darkDefaults : BsTableStyle.defaults).merge(widget.style);
    final padding = widget.small
        ? (style.cellPaddingSm ?? BsTableStyle.defaultCellPaddingSm)
        : (style.cellPadding ?? BsTableStyle.defaultCellPadding);
    final borderColor = style.borderColor ?? BsTableStyle.defaultBorderColor;
    final borderWidth = style.borderWidth ?? BsTableStyle.defaultBorderWidth;
    final background = widget.dark
        ? BsColors.gray900
        : (style.background ?? BsTableStyle.defaultBackground);
    final color = widget.dark
        ? BsColors.white
        : (style.color ?? BsTableStyle.defaultColor);
    final accentBackground =
        style.accentBackground ?? BsTableStyle.defaultAccentBackground;

    final border = widget.borderless
        ? const TableBorder()
        : widget.bordered
        ? TableBorder.all(color: borderColor, width: borderWidth)
        : TableBorder(
            horizontalInside: BorderSide(
              color: borderColor,
              width: borderWidth,
            ),
          );

    final rows = <TableRow>[
      if (widget.columns != null)
        TableRow(
          decoration: BoxDecoration(
            color: Color.alphaBlend(accentBackground, background),
          ),
          children: [
            for (final cell in widget.columns!)
              _cell(cell, padding: padding, fontWeight: FontWeight.bold),
          ],
        ),
      for (var i = 0; i < widget.rows.length; i++)
        _buildRow(i, widget.rows[i], style, background, padding, isDark),
    ];

    final table = DefaultTextStyle.merge(
      style: TextStyle(color: color),
      child: Table(
        border: border,
        defaultColumnWidth: const IntrinsicColumnWidth(),
        columnWidths: widget.columnWidths,
        children: rows,
      ),
    );

    if (widget.caption == null) return table;

    // `<caption>`: rendered below the table (Bootstrap's default
    // `caption-side: bottom`), padded by `$table-cell-padding-y` and tinted
    // with `$table-caption-color`.
    final captionPaddingY = padding.vertical / 2;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        table,
        Padding(
          padding: EdgeInsets.symmetric(vertical: captionPaddingY),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color: style.captionColor ?? BsTableStyle.defaultCaptionColor,
            ),
            textAlign: TextAlign.left,
            child: widget.caption!,
          ),
        ),
      ],
    );
  }

  TableRow _buildRow(
    int index,
    BsTableRow row,
    BsTableStyle style,
    Color background,
    EdgeInsetsGeometry padding,
    bool isDark,
  ) {
    var rowColor = background;
    if (row.variant != null) {
      rowColor = isDark ? row.variant!.darkBgSubtle : row.variant!.bgSubtle;
    }
    if (widget.striped && index.isEven) {
      rowColor = _blend(
        rowColor,
        style.stripedColor ?? BsTableStyle.defaultColor,
        style.stripedBackgroundOpacity ??
            BsTableStyle.defaultStripedBackgroundOpacity,
      );
    }
    if (widget.hover && _hoveredRow == index) {
      rowColor = _blend(
        rowColor,
        style.hoverColor ?? BsTableStyle.defaultColor,
        style.hoverBackgroundOpacity ??
            BsTableStyle.defaultHoverBackgroundOpacity,
      );
    }
    if (row.active) {
      rowColor = _blend(
        rowColor,
        style.activeColor ?? BsTableStyle.defaultColor,
        style.activeBackgroundOpacity ??
            BsTableStyle.defaultActiveBackgroundOpacity,
      );
    }
    rowColor = Color.alphaBlend(
      style.accentBackground ?? BsTableStyle.defaultAccentBackground,
      rowColor,
    );

    return TableRow(
      decoration: BoxDecoration(color: rowColor),
      children: [
        for (final cell in row.cells)
          _cell(cell, padding: padding, hoverRow: widget.hover ? index : null),
      ],
    );
  }

  Widget _cell(
    Widget child, {
    required EdgeInsetsGeometry padding,
    FontWeight? fontWeight,
    int? hoverRow,
  }) {
    Widget cell = Padding(
      padding: padding,
      child: fontWeight == null
          ? child
          : DefaultTextStyle.merge(
              style: TextStyle(fontWeight: fontWeight),
              child: child,
            ),
    );
    if (hoverRow != null) {
      cell = MouseRegion(
        onEnter: (_) => _setHovered(hoverRow),
        onExit: (_) =>
            _setHovered(_hoveredRow == hoverRow ? null : _hoveredRow),
        child: cell,
      );
    }
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: cell,
    );
  }

  Color _blend(Color base, Color tint, double opacity) =>
      Color.alphaBlend(tint.withValues(alpha: opacity), base);
}
