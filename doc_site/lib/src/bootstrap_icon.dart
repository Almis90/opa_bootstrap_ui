import 'package:flutter/widgets.dart';

/// A Bootstrap Icons glyph (or any inline SVG symbol), drawn from the very
/// same path data Bootstrap's docs embed (`<symbol>`s in
/// `site/src/layouts/partials/Icons.astro` and each example's own `<svg>`
/// sprite) — not a hand-approximation. Fills with the ambient
/// [DefaultTextStyle] color unless [color] is given, matching
/// `.bi { fill: currentColor }`.
class BootstrapIcon extends StatelessWidget {
  const BootstrapIcon(this.icon, {super.key, this.width = 16, this.height = 16, this.color});

  final BootstrapIconData icon;

  /// `.bi`'s box (`width`/`height` attributes, or `1em` when unset). The
  /// glyph is fit inside it like SVG's default `xMidYMid meet`.
  final double width;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final fill = color ?? DefaultTextStyle.of(context).style.color ?? const Color(0xFF000000);
    return CustomPaint(size: Size(width, height), painter: _IconPainter(icon, fill));
  }
}

/// One `<path>` of an SVG symbol.
class BootstrapIconPath {
  const BootstrapIconPath(this.d, {this.evenOdd = false});

  /// The `d` attribute.
  final String d;

  /// `fill-rule="evenodd"`; the SVG default is nonzero.
  final bool evenOdd;
}

/// An SVG `<symbol>`: its paths and `viewBox` size (origin is always 0,0).
class BootstrapIconData {
  const BootstrapIconData(this.paths, {this.viewBox = const Size(16, 16)});

  final List<BootstrapIconPath> paths;
  final Size viewBox;

  static const check2 = BootstrapIconData([
      BootstrapIconPath('M13.854 3.646a.5.5 0 0 1 0 .708l-7 7a.5.5 0 0 1-.708 0l-3.5-3.5a.5.5 0 1 1 .708-.708L6.5 10.293l6.646-6.647a.5.5 0 0 1 .708 0z'),
  ]);

  static const circleHalf = BootstrapIconData([
      BootstrapIconPath('M8 15A7 7 0 1 0 8 1v14zm0 1A8 8 0 1 1 8 0a8 8 0 0 1 0 16z'),
  ]);

  static const moonStarsFill = BootstrapIconData([
      BootstrapIconPath('M6 .278a.768.768 0 0 1 .08.858 7.208 7.208 0 0 0-.878 3.46c0 4.021 3.278 7.277 7.318 7.277.527 0 1.04-.055 1.533-.16a.787.787 0 0 1 .81.316.733.733 0 0 1-.031.893A8.349 8.349 0 0 1 8.344 16C3.734 16 0 12.286 0 7.71 0 4.266 2.114 1.312 5.124.06A.752.752 0 0 1 6 .278z'),
      BootstrapIconPath('M10.794 3.148a.217.217 0 0 1 .412 0l.387 1.162c.173.518.579.924 1.097 1.097l1.162.387a.217.217 0 0 1 0 .412l-1.162.387a1.734 1.734 0 0 0-1.097 1.097l-.387 1.162a.217.217 0 0 1-.412 0l-.387-1.162A1.734 1.734 0 0 0 9.31 6.593l-1.162-.387a.217.217 0 0 1 0-.412l1.162-.387a1.734 1.734 0 0 0 1.097-1.097l.387-1.162zM13.863.099a.145.145 0 0 1 .274 0l.258.774c.115.346.386.617.732.732l.774.258a.145.145 0 0 1 0 .274l-.774.258a1.156 1.156 0 0 0-.732.732l-.258.774a.145.145 0 0 1-.274 0l-.258-.774a1.156 1.156 0 0 0-.732-.732l-.774-.258a.145.145 0 0 1 0-.274l.774-.258c.346-.115.617-.386.732-.732L13.863.1z'),
  ]);

  static const sunFill = BootstrapIconData([
      BootstrapIconPath('M8 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM8 0a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 0zm0 13a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 13zm8-5a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2a.5.5 0 0 1 .5.5zM3 8a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2A.5.5 0 0 1 3 8zm10.657-5.657a.5.5 0 0 1 0 .707l-1.414 1.415a.5.5 0 1 1-.707-.708l1.414-1.414a.5.5 0 0 1 .707 0zm-9.193 9.193a.5.5 0 0 1 0 .707L3.05 13.657a.5.5 0 0 1-.707-.707l1.414-1.414a.5.5 0 0 1 .707 0zm9.193 2.121a.5.5 0 0 1-.707 0l-1.414-1.414a.5.5 0 0 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .707zM4.464 4.465a.5.5 0 0 1-.707 0L2.343 3.05a.5.5 0 1 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .708z'),
  ]);

  static const bootstrap = BootstrapIconData([
      BootstrapIconPath('M24.509 0c-6.733 0-11.715 5.893-11.492 12.284.214 6.14-.064 14.092-2.066 20.577C8.943 39.365 5.547 43.485 0 44.014v5.972c5.547.529 8.943 4.649 10.951 11.153 2.002 6.485 2.28 14.437 2.066 20.577C12.794 88.106 17.776 94 24.51 94H93.5c6.733 0 11.714-5.893 11.491-12.284-.214-6.14.064-14.092 2.066-20.577 2.009-6.504 5.396-10.624 10.943-11.153v-5.972c-5.547-.529-8.934-4.649-10.943-11.153-2.002-6.484-2.28-14.437-2.066-20.577C105.214 5.894 100.233 0 93.5 0H24.508zM80 57.863C80 66.663 73.436 72 62.543 72H44a2 2 0 01-2-2V24a2 2 0 012-2h18.437c9.083 0 15.044 4.92 15.044 12.474 0 5.302-4.01 10.049-9.119 10.88v.277C75.317 46.394 80 51.21 80 57.863zM60.521 28.34H49.948v14.934h8.905c6.884 0 10.68-2.772 10.68-7.727 0-4.643-3.264-7.207-9.012-7.207zM49.948 49.2v16.458H60.91c7.167 0 10.964-2.876 10.964-8.281 0-5.406-3.903-8.178-11.425-8.178H49.948z', evenOdd: true),
  ], viewBox: Size(118, 94));

  static const home = BootstrapIconData([
      BootstrapIconPath('M8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4.5a.5.5 0 0 0 .5-.5v-4h2v4a.5.5 0 0 0 .5.5H14a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146zM2.5 14V7.707l5.5-5.5 5.5 5.5V14H10v-4a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5v4H2.5z'),
  ]);

  static const speedometer2 = BootstrapIconData([
      BootstrapIconPath('M8 4a.5.5 0 0 1 .5.5V6a.5.5 0 0 1-1 0V4.5A.5.5 0 0 1 8 4zM3.732 5.732a.5.5 0 0 1 .707 0l.915.914a.5.5 0 1 1-.708.708l-.914-.915a.5.5 0 0 1 0-.707zM2 10a.5.5 0 0 1 .5-.5h1.586a.5.5 0 0 1 0 1H2.5A.5.5 0 0 1 2 10zm9.5 0a.5.5 0 0 1 .5-.5h1.5a.5.5 0 0 1 0 1H12a.5.5 0 0 1-.5-.5zm.754-4.246a.389.389 0 0 0-.527-.02L7.547 9.31a.91.91 0 1 0 1.302 1.258l3.434-4.297a.389.389 0 0 0-.029-.518z'),
      BootstrapIconPath('M0 10a8 8 0 1 1 15.547 2.661c-.442 1.253-1.845 1.602-2.932 1.25C11.309 13.488 9.475 13 8 13c-1.474 0-3.31.488-4.615.911-1.087.352-2.49.003-2.932-1.25A7.988 7.988 0 0 1 0 10zm8-7a7 7 0 0 0-6.603 9.329c.203.575.923.876 1.68.63C4.397 12.533 6.358 12 8 12s3.604.532 4.923.96c.757.245 1.477-.056 1.68-.631A7 7 0 0 0 8 3z', evenOdd: true),
  ]);

  static const table = BootstrapIconData([
      BootstrapIconPath('M0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V2zm15 2h-4v3h4V4zm0 4h-4v3h4V8zm0 4h-4v3h3a1 1 0 0 0 1-1v-2zm-5 3v-3H6v3h4zm-5 0v-3H1v2a1 1 0 0 0 1 1h3zm-4-4h4V8H1v3zm0-4h4V4H1v3zm5-3v3h4V4H6zm4 4H6v3h4V8z'),
  ]);

  static const grid = BootstrapIconData([
      BootstrapIconPath('M1 2.5A1.5 1.5 0 0 1 2.5 1h3A1.5 1.5 0 0 1 7 2.5v3A1.5 1.5 0 0 1 5.5 7h-3A1.5 1.5 0 0 1 1 5.5v-3zM2.5 2a.5.5 0 0 0-.5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 0-.5-.5h-3zm6.5.5A1.5 1.5 0 0 1 10.5 1h3A1.5 1.5 0 0 1 15 2.5v3A1.5 1.5 0 0 1 13.5 7h-3A1.5 1.5 0 0 1 9 5.5v-3zm1.5-.5a.5.5 0 0 0-.5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 0-.5-.5h-3zM1 10.5A1.5 1.5 0 0 1 2.5 9h3A1.5 1.5 0 0 1 7 10.5v3A1.5 1.5 0 0 1 5.5 15h-3A1.5 1.5 0 0 1 1 13.5v-3zm1.5-.5a.5.5 0 0 0-.5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 0-.5-.5h-3zm6.5.5A1.5 1.5 0 0 1 10.5 9h3a1.5 1.5 0 0 1 1.5 1.5v3a1.5 1.5 0 0 1-1.5 1.5h-3A1.5 1.5 0 0 1 9 13.5v-3zm1.5-.5a.5.5 0 0 0-.5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 0-.5-.5h-3z'),
  ]);

  static const peopleCircle = BootstrapIconData([
      BootstrapIconPath('M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z'),
      BootstrapIconPath('M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z', evenOdd: true),
  ]);
}

class _IconPainter extends CustomPainter {
  _IconPainter(this.icon, this.color);

  final BootstrapIconData icon;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final vb = icon.viewBox;
    final scale = size.width / vb.width < size.height / vb.height ? size.width / vb.width : size.height / vb.height;
    canvas.translate((size.width - vb.width * scale) / 2, (size.height - vb.height * scale) / 2);
    canvas.scale(scale);
    final paint = Paint()..color = color;
    for (final p in icon.paths) {
      canvas.drawPath(parseSvgPath(p.d)..fillType = p.evenOdd ? PathFillType.evenOdd : PathFillType.nonZero, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _IconPainter oldDelegate) => oldDelegate.icon != icon || oldDelegate.color != color;
}

/// Minimal SVG path-data parser: every command Bootstrap's glyphs use
/// (`M L H V C S Q T A Z`, absolute and relative), with implicit command
/// repetition, the compact `.5.5`/`1-2` number forms, and arc flags written
/// without separators (`a2 2 0 01-2-2`).
Path parseSvgPath(String d) {
  final scan = _PathScanner(d);
  final path = Path();
  var x = 0.0, y = 0.0; // current point
  var startX = 0.0, startY = 0.0; // current subpath start
  var lastCtrlX = 0.0, lastCtrlY = 0.0; // previous control point, for S/T
  var prev = '';
  String? cmd;

  while (scan.skipSeparators()) {
    if (scan.atCommand) cmd = scan.command();
    final c = cmd;
    if (c == null) throw FormatException('Path data must start with a command', d);
    final rel = c == c.toLowerCase();
    final dx = rel ? x : 0.0, dy = rel ? y : 0.0;
    switch (c.toUpperCase()) {
      case 'M':
        final nx = scan.number() + dx, ny = scan.number() + dy;
        path.moveTo(nx, ny);
        x = startX = nx;
        y = startY = ny;
        // Extra coordinate pairs after a moveto are implicit linetos.
        cmd = rel ? 'l' : 'L';
      case 'L':
        final nx = scan.number() + dx, ny = scan.number() + dy;
        path.lineTo(nx, ny);
        x = nx;
        y = ny;
      case 'H':
        final nx = scan.number() + dx;
        path.lineTo(nx, y);
        x = nx;
      case 'V':
        final ny = scan.number() + dy;
        path.lineTo(x, ny);
        y = ny;
      case 'C':
        final x1 = scan.number() + dx, y1 = scan.number() + dy;
        final x2 = scan.number() + dx, y2 = scan.number() + dy;
        final nx = scan.number() + dx, ny = scan.number() + dy;
        path.cubicTo(x1, y1, x2, y2, nx, ny);
        lastCtrlX = x2;
        lastCtrlY = y2;
        x = nx;
        y = ny;
      case 'S':
        final x2 = scan.number() + dx, y2 = scan.number() + dy;
        final nx = scan.number() + dx, ny = scan.number() + dy;
        final reflect = 'CcSs'.contains(prev);
        path.cubicTo(reflect ? 2 * x - lastCtrlX : x, reflect ? 2 * y - lastCtrlY : y, x2, y2, nx, ny);
        lastCtrlX = x2;
        lastCtrlY = y2;
        x = nx;
        y = ny;
      case 'Q':
        final x1 = scan.number() + dx, y1 = scan.number() + dy;
        final nx = scan.number() + dx, ny = scan.number() + dy;
        path.quadraticBezierTo(x1, y1, nx, ny);
        lastCtrlX = x1;
        lastCtrlY = y1;
        x = nx;
        y = ny;
      case 'T':
        final nx = scan.number() + dx, ny = scan.number() + dy;
        final reflect = 'QqTt'.contains(prev);
        final x1 = reflect ? 2 * x - lastCtrlX : x, y1 = reflect ? 2 * y - lastCtrlY : y;
        path.quadraticBezierTo(x1, y1, nx, ny);
        lastCtrlX = x1;
        lastCtrlY = y1;
        x = nx;
        y = ny;
      case 'A':
        final rx = scan.number(), ry = scan.number(), rotation = scan.number();
        final large = scan.flag(), sweep = scan.flag();
        final nx = scan.number() + dx, ny = scan.number() + dy;
        path.arcToPoint(
          Offset(nx, ny),
          radius: Radius.elliptical(rx, ry),
          rotation: rotation,
          largeArc: large,
          clockwise: sweep,
        );
        x = nx;
        y = ny;
      case 'Z':
        path.close();
        x = startX;
        y = startY;
      default:
        throw FormatException('Unsupported SVG path command "$c"', d);
    }
    prev = c;
  }
  return path;
}

class _PathScanner {
  _PathScanner(this.s);

  final String s;
  int i = 0;

  static final _number = RegExp(r'[-+]?(?:\d+\.?\d*|\.\d+)(?:[eE][-+]?\d+)?');

  /// Skips whitespace/commas; false at the end of the data.
  bool skipSeparators() {
    while (i < s.length && (s[i] == ' ' || s[i] == ',' || s[i] == '\n' || s[i] == '\t' || s[i] == '\r')) {
      i++;
    }
    return i < s.length;
  }

  bool get atCommand => RegExp(r'[A-Za-z]').hasMatch(s[i]);

  String command() => s[i++];

  double number() {
    skipSeparators();
    final m = _number.matchAsPrefix(s, i);
    if (m == null) throw FormatException('Expected a number at offset $i', s);
    i = m.end;
    return double.parse(m.group(0)!);
  }

  /// An arc flag: a single `0`/`1` character, possibly unseparated from what follows.
  bool flag() {
    skipSeparators();
    final c = s[i++];
    if (c != '0' && c != '1') throw FormatException('Expected an arc flag at offset ${i - 1}', s);
    return c == '1';
  }
}
