import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'cheatsheet_strings.dart';

/// What each part of the Cheatsheet page needs to know: the direction, and
/// the texts of its examples.
class CsEnv {
  const CsEnv({required this.rtl});

  final bool rtl;

  CheatsheetChrome get chrome => rtl ? cheatsheetChromeAr : cheatsheetChromeEn;

  /// The text nodes of example [i] (`.bd-example`), in document order.
  List<String> s(int i) =>
      (rtl ? cheatsheetExamplesAr : cheatsheetExamplesEn)[i];
}

/// The gap between examples (`.bd-heading + div > * + * { margin-top: 3rem }`).
const double csExampleGap = 48;

/// `p { margin-bottom: 1rem }`.
const double csParagraphGap = 16;

/// The examples of one article, [csExampleGap] apart.
Widget csExamples(List<Widget> examples) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    for (var i = 0; i < examples.length; i++) ...[
      if (i > 0) const SizedBox(height: csExampleGap),
      examples[i],
    ],
  ],
);

/// Layout probe for comparing with the original's geometry: with
/// `--dart-define=CS_DEBUG=1` it logs its box (`CSRECT label x y w h`) once
/// the page has settled. Does nothing otherwise.
class CsProbe extends StatefulWidget {
  const CsProbe({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  State<CsProbe> createState() => _CsProbeState();
}

class _CsProbeState extends State<CsProbe> {
  static const _on = bool.fromEnvironment('CS_DEBUG');

  @override
  void initState() {
    super.initState();
    if (_on) {
      Future<void>.delayed(const Duration(seconds: 3), () {
        if (!mounted) return;
        final box = context.findRenderObject() as RenderBox?;
        if (box == null || !box.hasSize) return;
        final at = box.localToGlobal(Offset.zero);
        debugPrint(
          'CSRECT ${widget.label} ${at.dx.toStringAsFixed(1)} '
          '${at.dy.toStringAsFixed(1)} ${box.size.width.toStringAsFixed(1)} '
          '${box.size.height.toStringAsFixed(1)}',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// A stack of blocks with a `1rem` margin between them (the last one's
/// margin collapses into the gap below the example).
Widget csBlocks(List<Widget> blocks, {double gap = csParagraphGap}) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    for (var i = 0; i < blocks.length; i++) ...[
      if (i > 0) SizedBox(height: gap),
      blocks[i],
    ],
  ],
);

/// A child that reports [by] less height than it has (its bottom margin
/// collapsing out of the example).
class CsTrimBottom extends SingleChildRenderObjectWidget {
  const CsTrimBottom({super.key, required this.by, super.child});

  final double by;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderTrimBottom(by);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) =>
      (renderObject as _RenderTrimBottom).by = by;
}

class _RenderTrimBottom extends RenderShiftedBox {
  _RenderTrimBottom(this._by) : super(null);

  double _by;
  set by(double value) {
    if (_by == value) return;
    _by = value;
    markNeedsLayout();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final size = child!.getDryLayout(constraints);
    return constraints.constrain(Size(size.width, size.height - _by));
  }

  @override
  void performLayout() {
    child!.layout(constraints, parentUsesSize: true);
    size = constraints.constrain(
      Size(child!.size.width, child!.size.height - _by),
    );
  }
}

/// A negative `margin-inline-start` of [by] (`.btn-group > .btn + .btn {
/// margin-left: -1px }`): the child overlaps the box before it, and takes that
/// much less room.
class CsPullStart extends SingleChildRenderObjectWidget {
  const CsPullStart({super.key, required this.by, required super.child});

  final double by;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderPullStart(by, Directionality.of(context));

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _RenderPullStart)
      ..by = by
      ..textDirection = Directionality.of(context);
  }
}

class _RenderPullStart extends RenderShiftedBox {
  _RenderPullStart(this._by, this._textDirection) : super(null);

  double _by;
  set by(double value) {
    if (_by == value) return;
    _by = value;
    markNeedsLayout();
  }

  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final size = child!.getDryLayout(constraints);
    return constraints.constrain(Size(size.width - _by, size.height));
  }

  @override
  void performLayout() {
    child!.layout(constraints, parentUsesSize: true);
    size = constraints.constrain(
      Size(child!.size.width - _by, child!.size.height),
    );
    (child!.parentData! as BoxParentData).offset = Offset(
      _textDirection == TextDirection.ltr ? -_by : 0,
      0,
    );
  }
}
