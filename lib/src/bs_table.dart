import 'package:flutter/widgets.dart';

import 'bs_colors.dart';
import 'bs_theme.dart';
import 'bs_variant.dart';
import 'tokens/bs_table_style.dart';

/// A single row's cells, plus the row-level modifiers: a [variant] tint and the active
/// highlight.
class BsTableRow {
  const BsTableRow({
    required this.cells,
    this.variant,
    this.active = false,
    this.groupStart = false,
  });

  /// One widget per column, typically [Text].
  final List<Widget> cells;

  /// Tints this row with [BsVariant.bgSubtle].
  final BsVariant? variant;

  /// Darkens this row via [BsTableStyle.activeBackgroundOpacity].
  final bool active;

  /// Opens a new row group: a 2 logical pixel rule is drawn above this row.
  final bool groupStart;
}

/// A Bootstrap table.
///
/// Renders with Flutter's [Table], so columns auto-size to their widest cell by default; pass
/// [columnWidths] for per-column control (for example `{0: FixedColumnWidth(120)}`). Cells sit at
/// the top of their row and the head cells at the bottom, as in Bootstrap.
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

  /// Header cells. Omit for a table with no header row.
  final List<Widget>? columns;

  /// Body rows.
  final List<BsTableRow> rows;

  /// Tints every other row via [BsTableStyle.stripedBackgroundOpacity].
  final bool striped;

  /// Adds borders on all sides of every cell, not just horizontal rules between rows.
  final bool bordered;

  /// Removes all borders, including the horizontal rules between rows.
  final bool borderless;

  /// Tints whichever row the pointer is over via [BsTableStyle.hoverBackgroundOpacity].
  final bool hover;

  /// Halves the cell padding to [BsTableStyle.cellPaddingSm].
  final bool small;

  /// Inverts to a dark background with light text.
  final bool dark;

  /// Per-column sizing, keyed by column index. Defaults to [IntrinsicColumnWidth] for every
  /// column.
  final Map<int, TableColumnWidth>? columnWidths;

  /// An optional summary rendered below the table, tinted with [BsTableStyle.captionColor].
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
    final style = (isDark ? BsTableStyle.darkDefaults : BsTableStyle.defaults)
        .merge(widget.style);
    final padding = widget.small
        ? (style.cellPaddingSm ?? BsTableStyle.defaultCellPaddingSm)
        : (style.cellPadding ?? BsTableStyle.defaultCellPadding);
    final borderWidth = style.borderWidth ?? BsTableStyle.defaultBorderWidth;
    final background = widget.dark
        ? BsColors.gray900
        : (style.background ?? BsTableStyle.defaultBackground);
    final color = widget.dark
        ? BsColors.white
        : (style.color ?? BsTableStyle.defaultColor);
    // A dark table's rules are its text color mixed 20% into its background, as in Bootstrap,
    // unless the style says otherwise.
    final borderColor = widget.dark
        ? widget.style?.borderColor ??
              Color.alphaBlend(color.withValues(alpha: 0.2), background)
        : style.borderColor ?? BsTableStyle.defaultBorderColor;
    final accentBackground =
        style.accentBackground ?? BsTableStyle.defaultAccentBackground;

    // Rows tinted by a variant have borders of their own color
    // (`mix(text, background, 20%)`), so the rules are drawn per row.
    final perRowRules =
        !widget.borderless &&
        !widget.bordered &&
        widget.rows.any((row) => row.variant != null);

    final border = widget.borderless || perRowRules
        ? const TableBorder()
        : widget.bordered
        ? TableBorder.all(color: borderColor, width: borderWidth)
        : TableBorder(
            // (every cell, the last row's included, has a bottom rule)
            bottom: BorderSide(color: borderColor, width: borderWidth),
            horizontalInside: BorderSide(
              color: borderColor,
              width: borderWidth,
            ),
          );

    // Every cell has a bottom border (collapsed with the next row's top one) that
    // takes room: Flutter's [Table] only paints its rules, so make it.
    final rule = widget.borderless ? 0.0 : borderWidth;
    final cellPadding = padding.add(EdgeInsets.only(bottom: rule));
    // Bordered: the table's own top rule takes room too.
    final firstRowPadding = widget.bordered
        ? cellPadding.add(EdgeInsets.only(top: borderWidth))
        : cellPadding;
    final rows = <TableRow>[
      if (widget.columns != null)
        TableRow(
          decoration: _SnappedRowDecoration(
            color: Color.alphaBlend(accentBackground, background),
            bottom: perRowRules
                ? BorderSide(color: borderColor, width: borderWidth)
                : null,
          ),
          children: [
            for (final cell in widget.columns!)
              _cell(
                cell,
                padding: firstRowPadding,
                fontWeight: FontWeight.bold,
                alignment: TableCellVerticalAlignment.bottom,
              ),
          ],
        ),
      for (var i = 0; i < widget.rows.length; i++)
        _buildRow(
          i,
          widget.rows[i],
          style,
          background,
          i == 0 && widget.columns == null ? firstRowPadding : cellPadding,
          ruleColor: color,
          rowRule: perRowRules
              ? BorderSide(color: borderColor, width: borderWidth)
              : null,
        ),
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

    // Caption: rendered below the table, padded like a cell and tinted with the caption color.
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
            textAlign: TextAlign.start,
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
    EdgeInsetsGeometry padding, {
    required Color ruleColor,
    BorderSide? rowRule,
  }) {
    var rowColor = background;
    // A variant row's own text color: the contrast of its background (the tints are light;
    // the dark and light variants are the theme colors themselves). As in Bootstrap, the
    // rows keep these colors in dark mode too, unlike the subtle colors of an alert.
    Color? rowText;
    final variant = row.variant;
    if (variant == BsVariant.dark) {
      rowColor = BsColors.gray900;
      rowText = BsColors.white;
    } else if (variant == BsVariant.light) {
      rowColor = BsColors.gray100;
      rowText = BsColors.black;
    } else if (variant != null) {
      rowColor = variant.bgSubtle;
      rowText = BsColors.black;
    }
    // The stripe, hover and active tints are of the row's text color: black over the light tint
    // of a variant even in dark mode, white over a dark table or row.
    Color tint(Color? styleColor) =>
        rowText ??
        (widget.dark
            ? BsColors.white
            : styleColor ?? BsTableStyle.defaultColor);
    if (widget.striped && index.isEven) {
      rowColor = _blend(
        rowColor,
        tint(style.stripedColor),
        style.stripedBackgroundOpacity ??
            BsTableStyle.defaultStripedBackgroundOpacity,
      );
    }
    if (widget.hover && _hoveredRow == index) {
      rowColor = _blend(
        rowColor,
        tint(style.hoverColor),
        style.hoverBackgroundOpacity ??
            BsTableStyle.defaultHoverBackgroundOpacity,
      );
    }
    if (row.active) {
      rowColor = _blend(
        rowColor,
        tint(style.activeColor),
        style.activeBackgroundOpacity ??
            BsTableStyle.defaultActiveBackgroundOpacity,
      );
    }
    rowColor = Color.alphaBlend(
      style.accentBackground ?? BsTableStyle.defaultAccentBackground,
      rowColor,
    );

    // Group divider: a 2 logical pixel rule in the text color above a row group, 1px more than
    // the ordinary rule it replaces.
    final groupStart = !widget.bordered && !widget.borderless && row.groupStart;
    // Under a variant row the rule is the text color mixed 20% into the row's background.
    final bottom = rowRule == null
        ? null
        : rowText == null
        ? rowRule
        : BorderSide(
            color: Color.alphaBlend(rowText.withValues(alpha: 0.2), rowColor),
            width: rowRule.width,
          );
    return TableRow(
      decoration: _SnappedRowDecoration(
        color: rowColor,
        top: groupStart ? BorderSide(color: ruleColor, width: 2) : null,
        bottom: bottom,
      ),
      children: [
        for (final cell in row.cells)
          _cell(
            cell,
            padding: groupStart
                ? padding.add(const EdgeInsets.only(top: 1))
                : padding,
            hoverRow: widget.hover ? index : null,
            color: rowText,
          ),
      ],
    );
  }

  Widget _cell(
    Widget child, {
    required EdgeInsetsGeometry padding,
    FontWeight? fontWeight,
    int? hoverRow,
    Color? color,
    TableCellVerticalAlignment alignment = TableCellVerticalAlignment.top,
  }) {
    Widget cell = Padding(
      padding: padding,
      child: fontWeight == null && color == null
          ? child
          : DefaultTextStyle.merge(
              style: TextStyle(fontWeight: fontWeight, color: color),
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
    return TableCell(verticalAlignment: alignment, child: cell);
  }

  Color _blend(Color base, Color tint, double opacity) =>
      Color.alphaBlend(tint.withValues(alpha: opacity), base);
}

/// A row's background, with an optional rule along its top and bottom edges, painted the way
/// a browser paints table cells: every edge snapped to a whole device pixel, so that a 1px rule
/// is one crisp row (layout is fractional, and Flutter would blur the rule over two rows).
class _SnappedRowDecoration extends Decoration {
  const _SnappedRowDecoration({required this.color, this.top, this.bottom});

  final Color color;
  final BorderSide? top;
  final BorderSide? bottom;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _SnappedRowPainter(this);

  @override
  bool operator ==(Object other) =>
      other is _SnappedRowDecoration &&
      other.color == color &&
      other.top == top &&
      other.bottom == bottom;

  @override
  int get hashCode => Object.hash(color, top, bottom);
}

class _SnappedRowPainter extends BoxPainter {
  _SnappedRowPainter(this.decoration);

  final _SnappedRowDecoration decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size;
    if (size == null) return;
    // Device pixels per logical pixel, and where the canvas's origin is.
    final m = canvas.getTransform();
    final sx = m[0] == 0 ? 1.0 : m[0];
    final sy = m[5] == 0 ? 1.0 : m[5];
    double snapX(double x) => ((m[12] + x * sx).roundToDouble() - m[12]) / sx;
    double snapY(double y) => ((m[13] + y * sy).roundToDouble() - m[13]) / sy;

    final left = snapX(offset.dx);
    final right = snapX(offset.dx + size.width);
    final top = snapY(offset.dy);
    final bottom = snapY(offset.dy + size.height);

    if (decoration.color.a > 0) {
      canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom),
        Paint()..color = decoration.color,
      );
    }
    final topRule = decoration.top;
    if (topRule != null && topRule.width > 0) {
      final h =
          (topRule.width * sy).roundToDouble().clamp(1, double.infinity) / sy;
      canvas.drawRect(
        Rect.fromLTRB(left, top, right, top + h),
        Paint()..color = topRule.color,
      );
    }
    final bottomRule = decoration.bottom;
    if (bottomRule != null && bottomRule.width > 0) {
      final h =
          (bottomRule.width * sy).roundToDouble().clamp(1, double.infinity) /
          sy;
      canvas.drawRect(
        Rect.fromLTRB(left, bottom - h, right, bottom),
        Paint()..color = bottomRule.color,
      );
    }
  }
}
