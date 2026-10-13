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
    this.height,
  });

  final String label;

  /// The gutter of the row it is in: half of it pads each side.
  final double gutter;

  /// Shown in place of [label] (nested rows).
  final Widget? child;

  final TextAlign textAlign;

  /// A fixed height, for the tall column of the alignment examples.
  final double? height;

  @override
  Widget build(BuildContext context) {
    final content = child ?? Text(label, textAlign: textAlign);
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _fill,
          border: Border.all(color: _line),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: gutter / 2, vertical: 12),
          child: height == null ? content : Center(child: content),
        ),
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
  BsResponsive<BsSpacing>? ms,
  BsResponsive<BsSpacing>? me,
  double gutter = 24,
  double? height,
  Widget? child,
}) {
  return BsFlexItem(
    col: col,
    offset: offset,
    alignSelf: alignSelf,
    ms: ms,
    me: me,
    p: BsSpacing.s0,
    child: DocGridCell(label, gutter: gutter, height: height, child: child),
  );
}
