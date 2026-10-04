import 'package:flutter/widgets.dart';

/// A Bootstrap Icons glyph, drawn from the very same SVG path data Bootstrap's
/// own docs embed (`site/src/layouts/partials/Icons.astro`) — not a
/// hand-approximation. Fills with the ambient [DefaultTextStyle] color unless
/// [color] is given, matching `.bi { fill: currentColor }`.
class BootstrapIcon extends StatelessWidget {
  const BootstrapIcon(this.icon, {super.key, this.size = 16, this.color});

  final BootstrapIconData icon;

  /// `.bi { width: 1em; height: 1em }` — the glyphs' viewBox is 16x16.
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final fill = color ?? DefaultTextStyle.of(context).style.color ?? const Color(0xFF000000);
    return CustomPaint(size: Size.square(size), painter: _IconPainter(icon, fill));
  }
}

/// One or more SVG `d` strings sharing a 16x16 viewBox.
class BootstrapIconData {
  const BootstrapIconData(this.paths);

  final List<String> paths;

  static const check2 = BootstrapIconData([
    'M13.854 3.646a.5.5 0 0 1 0 .708l-7 7a.5.5 0 0 1-.708 0l-3.5-3.5a.5.5 0 1 1 .708-.708L6.5 10.293l6.646-6.647a.5.5 0 0 1 .708 0z',
  ]);

  static const circleHalf = BootstrapIconData(['M8 15A7 7 0 1 0 8 1v14zm0 1A8 8 0 1 1 8 0a8 8 0 0 1 0 16z']);

  static const moonStarsFill = BootstrapIconData([
    'M6 .278a.768.768 0 0 1 .08.858 7.208 7.208 0 0 0-.878 3.46c0 4.021 3.278 7.277 7.318 7.277.527 0 1.04-.055 1.533-.16a.787.787 0 0 1 .81.316.733.733 0 0 1-.031.893A8.349 8.349 0 0 1 8.344 16C3.734 16 0 12.286 0 7.71 0 4.266 2.114 1.312 5.124.06A.752.752 0 0 1 6 .278z',
    'M10.794 3.148a.217.217 0 0 1 .412 0l.387 1.162c.173.518.579.924 1.097 1.097l1.162.387a.217.217 0 0 1 0 .412l-1.162.387a1.734 1.734 0 0 0-1.097 1.097l-.387 1.162a.217.217 0 0 1-.412 0l-.387-1.162A1.734 1.734 0 0 0 9.31 6.593l-1.162-.387a.217.217 0 0 1 0-.412l1.162-.387a1.734 1.734 0 0 0 1.097-1.097l.387-1.162zM13.863.099a.145.145 0 0 1 .274 0l.258.774c.115.346.386.617.732.732l.774.258a.145.145 0 0 1 0 .274l-.774.258a1.156 1.156 0 0 0-.732.732l-.258.774a.145.145 0 0 1-.274 0l-.258-.774a1.156 1.156 0 0 0-.732-.732l-.774-.258a.145.145 0 0 1 0-.274l.774-.258c.346-.115.617-.386.732-.732L13.863.1z',
  ]);

  static const sunFill = BootstrapIconData([
    'M8 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM8 0a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 0zm0 13a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 13zm8-5a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2a.5.5 0 0 1 .5.5zM3 8a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2A.5.5 0 0 1 3 8zm10.657-5.657a.5.5 0 0 1 0 .707l-1.414 1.415a.5.5 0 1 1-.707-.708l1.414-1.414a.5.5 0 0 1 .707 0zm-9.193 9.193a.5.5 0 0 1 0 .707L3.05 13.657a.5.5 0 0 1-.707-.707l1.414-1.414a.5.5 0 0 1 .707 0zm9.193 2.121a.5.5 0 0 1-.707 0l-1.414-1.414a.5.5 0 0 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .707zM4.464 4.465a.5.5 0 0 1-.707 0L2.343 3.05a.5.5 0 1 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .708z',
  ]);
}

class _IconPainter extends CustomPainter {
  _IconPainter(this.icon, this.color);

  final BootstrapIconData icon;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 16, size.height / 16);
    final paint = Paint()..color = color;
    for (final d in icon.paths) {
      canvas.drawPath(parseSvgPath(d), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _IconPainter oldDelegate) => oldDelegate.icon != icon || oldDelegate.color != color;
}

final _tokenPattern = RegExp(r'[MmLlHhVvCcSsQqTtAaZz]|-?(?:\d+\.?\d*|\.\d+)(?:[eE][-+]?\d+)?');

/// Minimal SVG path-data parser: every command Bootstrap Icons' glyphs use
/// (`M L H V C S Q T A Z`, absolute and relative), with implicit command
/// repetition and the compact `.5.5` number form.
Path parseSvgPath(String d) {
  final tokens = _tokenPattern.allMatches(d).map((m) => m.group(0)!).toList();
  final path = Path();
  var i = 0;
  var x = 0.0, y = 0.0; // current point
  var startX = 0.0, startY = 0.0; // current subpath start
  var lastCtrlX = 0.0, lastCtrlY = 0.0; // previous control point, for S/T
  var prev = '';
  String? cmd;

  double num() => double.parse(tokens[i++]);
  bool isCmd(String t) => RegExp(r'^[A-Za-z]$').hasMatch(t);

  while (i < tokens.length) {
    if (isCmd(tokens[i])) cmd = tokens[i++];
    final c = cmd!;
    final rel = c == c.toLowerCase();
    switch (c.toUpperCase()) {
      case 'M':
        var nx = num(), ny = num();
        if (rel) {
          nx += x;
          ny += y;
        }
        path.moveTo(nx, ny);
        x = startX = nx;
        y = startY = ny;
        // Extra coordinate pairs after a moveto are implicit linetos.
        cmd = rel ? 'l' : 'L';
      case 'L':
        var nx = num(), ny = num();
        if (rel) {
          nx += x;
          ny += y;
        }
        path.lineTo(nx, ny);
        x = nx;
        y = ny;
      case 'H':
        final nx = rel ? x + num() : num();
        path.lineTo(nx, y);
        x = nx;
      case 'V':
        final ny = rel ? y + num() : num();
        path.lineTo(x, ny);
        y = ny;
      case 'C':
        final dx = rel ? x : 0.0, dy = rel ? y : 0.0;
        final x1 = num() + dx, y1 = num() + dy, x2 = num() + dx, y2 = num() + dy, nx = num() + dx, ny = num() + dy;
        path.cubicTo(x1, y1, x2, y2, nx, ny);
        lastCtrlX = x2;
        lastCtrlY = y2;
        x = nx;
        y = ny;
      case 'S':
        final dx = rel ? x : 0.0, dy = rel ? y : 0.0;
        final x2 = num() + dx, y2 = num() + dy, nx = num() + dx, ny = num() + dy;
        final reflect = 'CcSs'.contains(prev);
        final x1 = reflect ? 2 * x - lastCtrlX : x, y1 = reflect ? 2 * y - lastCtrlY : y;
        path.cubicTo(x1, y1, x2, y2, nx, ny);
        lastCtrlX = x2;
        lastCtrlY = y2;
        x = nx;
        y = ny;
      case 'Q':
        final dx = rel ? x : 0.0, dy = rel ? y : 0.0;
        final x1 = num() + dx, y1 = num() + dy, nx = num() + dx, ny = num() + dy;
        path.quadraticBezierTo(x1, y1, nx, ny);
        lastCtrlX = x1;
        lastCtrlY = y1;
        x = nx;
        y = ny;
      case 'T':
        final dx = rel ? x : 0.0, dy = rel ? y : 0.0;
        final nx = num() + dx, ny = num() + dy;
        final reflect = 'QqTt'.contains(prev);
        final x1 = reflect ? 2 * x - lastCtrlX : x, y1 = reflect ? 2 * y - lastCtrlY : y;
        path.quadraticBezierTo(x1, y1, nx, ny);
        lastCtrlX = x1;
        lastCtrlY = y1;
        x = nx;
        y = ny;
      case 'A':
        final rx = num(), ry = num(), rotation = num();
        final large = num() != 0, sweep = num() != 0;
        var nx = num(), ny = num();
        if (rel) {
          nx += x;
          ny += y;
        }
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
