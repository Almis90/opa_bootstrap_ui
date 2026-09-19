import 'package:flutter/widgets.dart';

import 'bs_color_utils.dart';
import 'bs_size.dart';
import 'bs_variant.dart';

/// Per-[BsSize] geometry, mirroring Bootstrap's `$btn-padding-*`,
/// `$btn-font-size-*` and `$btn-border-radius-*` variables (assuming the
/// default `1rem == 16px` root font size).
class _BsButtonGeometry {
  const _BsButtonGeometry({
    required this.padding,
    required this.fontSize,
    required this.borderRadius,
  });

  final EdgeInsets padding;
  final double fontSize;
  final double borderRadius;

  static const Map<BsSize, _BsButtonGeometry> byBsSize = {
    BsSize.sm: _BsButtonGeometry(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      fontSize: 14,
      borderRadius: 4,
    ),
    BsSize.normal: _BsButtonGeometry(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      fontSize: 16,
      borderRadius: 6,
    ),
    BsSize.lg: _BsButtonGeometry(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      fontSize: 20,
      borderRadius: 8,
    ),
  };
}

/// Resolved colors for a button in a given interaction state, mirroring the
/// custom properties Bootstrap's `button-variant`/`button-outline-variant`
/// Sass mixins emit (`--bs-btn-bg`, `--bs-btn-hover-bg`, etc).
class _BsButtonColors {
  const _BsButtonColors({
    required this.background,
    required this.border,
    required this.foreground,
  });

  final Color background;
  final Color border;
  final Color foreground;

  /// Solid button colors: filled background in the variant color, per
  /// Bootstrap's `button-variant` mixin.
  factory _BsButtonColors.solid(Color base, {double shade = 0, double tint = 0}) {
    final background = shade > 0
        ? BsColorUtils.shade(base, shade)
        : (tint > 0 ? BsColorUtils.tint(base, tint) : base);
    return _BsButtonColors(
      background: background,
      border: background,
      foreground: BsColorUtils.contrast(background),
    );
  }

  /// Outline button colors: transparent (or filled-on-interaction)
  /// background with a colored border/text, per Bootstrap's
  /// `button-outline-variant` mixin.
  factory _BsButtonColors.outlineIdle(Color base) {
    return _BsButtonColors(
      background: const Color(0x00000000),
      border: base,
      foreground: base,
    );
  }

  factory _BsButtonColors.outlineFilled(Color base) {
    return _BsButtonColors(
      background: base,
      border: base,
      foreground: BsColorUtils.contrast(base),
    );
  }
}

/// A Bootstrap-styled button (`.btn`).
///
/// Supports the solid (`.btn-primary`) and outline (`.btn-outline-primary`)
/// variants, Bootstrap's three button sizes, and hover/active/focus/disabled
/// states, replicating the shade/tint math from Bootstrap's
/// `button-variant`/`button-outline-variant` Sass mixins.
class BsButton extends StatefulWidget {
  const BsButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.variant = BsVariant.primary,
    this.outline = false,
    this.size = BsSize.normal,
    this.noWrap = false,
    this.focusNode,
    this.autofocus = false,
  });

  /// The button's content, typically a [Text].
  final Widget child;

  /// Called when the button is tapped. The button is rendered disabled
  /// (and ignores input) when this is null.
  final VoidCallback? onPressed;

  /// The Bootstrap contextual color, e.g. [BsVariant.primary].
  final BsVariant variant;

  /// Whether to render the outline style (`.btn-outline-*`) instead of the
  /// solid style (`.btn-*`).
  final bool outline;

  /// The button's size.
  final BsSize size;

  /// Whether to prevent the button's text from wrapping onto multiple
  /// lines, mirroring Bootstrap's `$btn-white-space: nowrap` option.
  final bool noWrap;

  final FocusNode? focusNode;
  final bool autofocus;

  bool get _enabled => onPressed != null;

  @override
  State<BsButton> createState() => _BsButtonState();
}

class _BsButtonState extends State<BsButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  void _setHovered(bool value) {
    if (_hovered != value) setState(() => _hovered = value);
  }

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  void _setFocused(bool value) {
    if (_focused != value) setState(() => _focused = value);
  }

  _BsButtonColors _resolveColors() {
    final base = widget.variant.color;

    if (widget.outline) {
      return _pressed || _hovered
          ? _BsButtonColors.outlineFilled(base)
          : _BsButtonColors.outlineIdle(base);
    }

    if (_pressed) return _BsButtonColors.solid(base, shade: 0.20);
    if (_hovered) return _BsButtonColors.solid(base, shade: 0.15);
    return _BsButtonColors.solid(base);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget._enabled;
    final geometry = _BsButtonGeometry.byBsSize[widget.size]!;
    final colors = _resolveColors();

    final opacity = enabled ? 1.0 : 0.65;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: enabled ? (_) => _setHovered(true) : null,
      onExit: enabled ? (_) => _setHovered(false) : null,
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onFocusChange: _setFocused,
        child: GestureDetector(
          onTapDown: enabled ? (_) => _setPressed(true) : null,
          onTapUp: enabled ? (_) => _setPressed(false) : null,
          onTapCancel: enabled ? () => _setPressed(false) : null,
          onTap: enabled ? widget.onPressed : null,
          child: Opacity(
            opacity: opacity,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              padding: geometry.padding,
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(geometry.borderRadius),
                border: Border.all(color: colors.border, width: 1),
                boxShadow: _focused
                    ? [
                        BoxShadow(
                          color: widget.variant.color.withValues(alpha: 0.25),
                          blurRadius: 0,
                          spreadRadius: 4,
                        ),
                      ]
                    : null,
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: colors.foreground,
                  fontSize: geometry.fontSize,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
                child: widget.noWrap
                    ? Row(mainAxisSize: MainAxisSize.min, children: [widget.child])
                    : widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
