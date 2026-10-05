import 'package:flutter/widgets.dart';

/// `table { width: 100%; table-layout: auto }`: the width left over is shared
/// out between the columns in proportion to each one's max-content width — its
/// widest cell (the header's in bold) and the padding on either side — which
/// is what [FlexColumnWidth]s of those widths do.
Map<int, TableColumnWidth> proportionalTableColumns(
  BuildContext context,
  List<String> head,
  List<List<String>> rows, {
  double cellPadding = 16,
  List<FontWeight?>? rowHeadWeights,
}) {
  final style = DefaultTextStyle.of(context).style;
  double measure(String text, FontWeight? weight) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: style.copyWith(fontWeight: weight),
      ),
      textDirection: Directionality.of(context),
    )..layout();
    return painter.width;
  }

  return {
    for (var i = 0; i < head.length; i++)
      i: FlexColumnWidth(
        [
              measure(head[i], FontWeight.w700),
              for (final row in rows) measure(row[i], rowHeadWeights?[i]),
            ].reduce((a, b) => a > b ? a : b) +
            cellPadding,
      ),
  };
}
