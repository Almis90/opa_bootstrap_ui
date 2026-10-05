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
  const BootstrapIconData(
    this.paths, {
    this.viewBox = const Size(16, 16),
    this.strokeWidth,
  });

  final List<BootstrapIconPath> paths;
  final Size viewBox;

  /// For a line icon (`fill="none" stroke="currentColor" stroke-width="2"
  /// stroke-linecap="round" stroke-linejoin="round"`): the stroke's width,
  /// instead of filling the paths.
  final double? strokeWidth;

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

  static const arrowRightShort = BootstrapIconData([
      BootstrapIconPath('M4 8a.5.5 0 0 1 .5-.5h5.793L8.146 5.354a.5.5 0 1 1 .708-.708l3 3a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708-.708L10.293 8.5H4.5A.5.5 0 0 1 4 8z', evenOdd: true),
  ]);

  static const check2Circle = BootstrapIconData([
      BootstrapIconPath('M2.5 8a5.5 5.5 0 0 1 8.25-4.764.5.5 0 0 0 .5-.866A6.5 6.5 0 1 0 14.5 8a.5.5 0 0 0-1 0 5.5 5.5 0 1 1-11 0z'),
      BootstrapIconPath('M15.354 3.354a.5.5 0 0 0-.708-.708L8 9.293 5.354 6.646a.5.5 0 1 0-.708.708l3 3a.5.5 0 0 0 .708 0l7-7z'),
  ]);

  static const calendarEvent = BootstrapIconData([
      BootstrapIconPath('M11 6.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1z'),
      BootstrapIconPath('M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z'),
  ]);

  static const alarm = BootstrapIconData([
      BootstrapIconPath('M8.5 5.5a.5.5 0 0 0-1 0v3.362l-1.429 2.38a.5.5 0 1 0 .858.515l1.5-2.5A.5.5 0 0 0 8.5 9V5.5z'),
      BootstrapIconPath('M6.5 0a.5.5 0 0 0 0 1H7v1.07a7.001 7.001 0 0 0-3.273 12.474l-.602.602a.5.5 0 0 0 .707.708l.746-.746A6.97 6.97 0 0 0 8 16a6.97 6.97 0 0 0 3.422-.892l.746.746a.5.5 0 0 0 .707-.708l-.601-.602A7.001 7.001 0 0 0 9 2.07V1h.5a.5.5 0 0 0 0-1h-3zm1.038 3.018a6.093 6.093 0 0 1 .924 0 6 6 0 1 1-.924 0zM0 3.5c0 .753.333 1.429.86 1.887A8.035 8.035 0 0 1 4.387 1.86 2.5 2.5 0 0 0 0 3.5zM13.5 1c-.753 0-1.429.333-1.887.86a8.035 8.035 0 0 1 3.527 3.527A2.5 2.5 0 0 0 13.5 1z'),
  ]);

  static const listCheck = BootstrapIconData([
      BootstrapIconPath('M5 11.5a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9a.5.5 0 0 1-.5-.5zM3.854 2.146a.5.5 0 0 1 0 .708l-1.5 1.5a.5.5 0 0 1-.708 0l-.5-.5a.5.5 0 1 1 .708-.708L2 3.293l1.146-1.147a.5.5 0 0 1 .708 0zm0 4a.5.5 0 0 1 0 .708l-1.5 1.5a.5.5 0 0 1-.708 0l-.5-.5a.5.5 0 1 1 .708-.708L2 7.293l1.146-1.147a.5.5 0 0 1 .708 0zm0 4a.5.5 0 0 1 0 .708l-1.5 1.5a.5.5 0 0 1-.708 0l-.5-.5a.5.5 0 0 1 .708-.708l.146.147 1.146-1.147a.5.5 0 0 1 .708 0z', evenOdd: true),
  ]);

  static const bookmarkStar = BootstrapIconData([
      BootstrapIconPath('M7.84 4.1a.178.178 0 0 1 .32 0l.634 1.285a.178.178 0 0 0 .134.098l1.42.206c.145.021.204.2.098.303L9.42 6.993a.178.178 0 0 0-.051.158l.242 1.414a.178.178 0 0 1-.258.187l-1.27-.668a.178.178 0 0 0-.165 0l-1.27.668a.178.178 0 0 1-.257-.187l.242-1.414a.178.178 0 0 0-.05-.158l-1.03-1.001a.178.178 0 0 1 .098-.303l1.42-.206a.178.178 0 0 0 .134-.098L7.84 4.1z'),
      BootstrapIconPath('M2 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v13.5a.5.5 0 0 1-.777.416L8 13.101l-5.223 2.815A.5.5 0 0 1 2 15.5V2zm2-1a1 1 0 0 0-1 1v12.566l4.723-2.482a.5.5 0 0 1 .554 0L13 14.566V2a1 1 0 0 0-1-1H4z'),
  ]);

  static const gridFill = BootstrapIconData([
      BootstrapIconPath('M1 2.5A1.5 1.5 0 0 1 2.5 1h3A1.5 1.5 0 0 1 7 2.5v3A1.5 1.5 0 0 1 5.5 7h-3A1.5 1.5 0 0 1 1 5.5v-3zm8 0A1.5 1.5 0 0 1 10.5 1h3A1.5 1.5 0 0 1 15 2.5v3A1.5 1.5 0 0 1 13.5 7h-3A1.5 1.5 0 0 1 9 5.5v-3zm-8 8A1.5 1.5 0 0 1 2.5 9h3A1.5 1.5 0 0 1 7 10.5v3A1.5 1.5 0 0 1 5.5 15h-3A1.5 1.5 0 0 1 1 13.5v-3zm8 0A1.5 1.5 0 0 1 10.5 9h3a1.5 1.5 0 0 1 1.5 1.5v3a1.5 1.5 0 0 1-1.5 1.5h-3A1.5 1.5 0 0 1 9 13.5v-3z'),
  ]);

  static const film = BootstrapIconData([
      BootstrapIconPath('M0 1a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v14a1 1 0 0 1-1 1H1a1 1 0 0 1-1-1V1zm4 0v6h8V1H4zm8 8H4v6h8V9zM1 1v2h2V1H1zm2 3H1v2h2V4zM1 7v2h2V7H1zm2 3H1v2h2v-2zm-2 3v2h2v-2H1zM15 1h-2v2h2V1zm-2 3v2h2V4h-2zm2 3h-2v2h2V7zm-2 3v2h2v-2h-2zm2 3h-2v2h2v-2z'),
  ]);

  static const google = BootstrapIconData([
      BootstrapIconPath('M15.545 6.558a9.4 9.4 0 0 1 .139 1.626c0 2.434-.87 4.492-2.384 5.885h.002C11.978 15.292 10.158 16 8 16A8 8 0 1 1 8 0a7.7 7.7 0 0 1 5.352 2.082l-2.284 2.284A4.35 4.35 0 0 0 8 3.166c-2.087 0-3.86 1.408-4.492 3.304a4.8 4.8 0 0 0 0 3.063h.003c.635 1.893 2.405 3.301 4.492 3.301 1.078 0 2.004-.276 2.722-.764h-.003a3.7 3.7 0 0 0 1.599-2.431H8v-3.08z'),
  ]);

  static const github = BootstrapIconData([
      BootstrapIconPath('M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.012 8.012 0 0 0 16 8c0-4.42-3.58-8-8-8z'),
  ]);

  static const facebook = BootstrapIconData([
      BootstrapIconPath('M16 8.049c0-4.446-3.582-8.05-8-8.05C3.58 0-.002 3.603-.002 8.05c0 4.017 2.926 7.347 6.75 7.951v-5.625h-2.03V8.05H6.75V6.275c0-2.017 1.195-3.131 3.022-3.131.876 0 1.791.157 1.791.157v1.98h-1.009c-.993 0-1.303.621-1.303 1.258v1.51h2.218l-.354 2.326H9.25V16c3.824-.604 6.75-3.934 6.75-7.951z'),
  ]);

  /// `assets/brand/bootstrap-logo-white.svg`: the badge with the "B" cut out.
  static const bootstrapLogo = BootstrapIconData([
      BootstrapIconPath('M106.342 0c-29.214 0-50.827 25.58-49.86 53.32.927 26.647-.278 61.165-8.966 89.31C38.802 170.862 24.07 188.707 0 191v26c24.069 2.293 38.802 20.138 47.516 48.37 8.688 28.145 9.893 62.663 8.965 89.311C55.515 382.42 77.128 408 106.342 408h299.353c29.214 0 50.827-25.58 49.861-53.319-.928-26.648.277-61.166 8.964-89.311 8.715-28.232 23.411-46.077 47.48-48.37v-26c-24.069-2.293-38.765-20.138-47.48-48.37-8.687-28.145-9.892-62.663-8.964-89.31C456.522 25.58 434.909 0 405.695 0H106.342zm236.559 251.102c0 38.197-28.501 61.355-75.798 61.355h-87.202a2 2 0 01-2-2v-213a2 2 0 012-2h86.74c39.439 0 65.322 21.354 65.322 54.138 0 23.008-17.409 43.61-39.594 47.219v1.203c30.196 3.309 50.532 24.212 50.532 53.085zm-84.58-128.125h-45.91v64.814h38.669c29.888 0 46.373-12.03 46.373-33.535 0-20.151-14.174-31.279-39.132-31.279zm-45.91 90.53v71.431h47.605c31.12 0 47.605-12.482 47.605-35.941 0-23.46-16.947-35.49-49.608-35.49h-45.602z'),
  ], viewBox: Size(512, 408));

  /// Product example's `#aperture`: a line icon, `viewBox="0 0 24 24"`.
  static const aperture = BootstrapIconData(
    [
      BootstrapIconPath('M12 2a10 10 0 1 0 0 20a10 10 0 1 0 0-20z'),
      BootstrapIconPath('M14.31 8l5.74 9.94M9.69 8h11.48M7.38 12l5.74-9.94M9.69 16L3.95 6.06M14.31 16H2.83m13.79-4l-5.74 9.94'),
    ],
    viewBox: Size(24, 24),
    strokeWidth: 2,
  );

  static const cart = BootstrapIconData([
      BootstrapIconPath('M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .49.598l-1 5a.5.5 0 0 1-.465.401l-9.397.472L4.415 11H13a.5.5 0 0 1 0 1H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5zM3.102 4l.84 4.479 9.144-.459L13.89 4H3.102zM5 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm7 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm-7 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2zm7 0a1 1 0 1 1 0 2 1 1 0 0 1 0-2z'),
  ]);

  static const chevronRight = BootstrapIconData([
      BootstrapIconPath('M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708z', evenOdd: true),
  ]);

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

  static const arrowRightCircle = BootstrapIconData([
      BootstrapIconPath('M8 0a8 8 0 1 1 0 16A8 8 0 0 1 8 0zM4.5 7.5a.5.5 0 0 0 0 1h5.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3a.5.5 0 0 0 0-.708l-3-3a.5.5 0 1 0-.708.708L10.293 7.5H4.5z'),
  ]);

  /// Album example's camera: a line icon, `viewBox="0 0 24 24"`.
  static const camera = BootstrapIconData(
    [
      BootstrapIconPath('M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z'),
      BootstrapIconPath('M12 9a4 4 0 1 0 0 8a4 4 0 1 0 0-8z'),
    ],
    viewBox: Size(24, 24),
    strokeWidth: 2,
  );

  /// Sidebars example's `.btn-toggle::before` chevron: a line icon.
  static const chevronToggle = BootstrapIconData(
    [BootstrapIconPath('M5 14l6-6-6-6')],
    strokeWidth: 2,
  );

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
    if (icon.strokeWidth != null) {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = icon.strokeWidth!
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
    }
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
