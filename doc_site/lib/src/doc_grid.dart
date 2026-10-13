import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

const _fill = Color(0x26702CF9);
const _line = Color(0x4D702CF9);

/// A tinted box for the columns of the grid examples: the way Bootstrap's
/// docs draw `.bd-example-row` columns, with the gutter inside the box.
class DocGridCell extends StatelessWidget {
  const DocGridCell(
    this.label, {
    super.key,
    this.gutter = 24,
    this.child,
    this.textAlign = TextAlign.center,
  });

  final String label;

  /// The gutter of the row it is in: half of it pads each side.
  final double gutter;

  /// Shown in place of [label] (nested rows).
  final Widget? child;

  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _fill,
        border: Border.all(color: _line),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: gutter / 2, vertical: 12),
        child: child ?? Text(label, textAlign: textAlign),
      ),
    );
  }
}

/// A column of a row with a [DocGridCell] in it. The item's own padding is
/// taken away, since the cell draws the gutter.
BsFlexItem docCol(
  String label, {
  BsResponsive<BsCol>? col,
  BsResponsive<BsCol>? offset,
  BsResponsive<BsAlign>? alignSelf,
  double gutter = 24,
  Widget? child,
}) {
  return BsFlexItem(
    col: col,
    offset: offset,
    alignSelf: alignSelf,
    p: BsSpacing.s0,
    child: DocGridCell(label, gutter: gutter, child: child),
  );
}
