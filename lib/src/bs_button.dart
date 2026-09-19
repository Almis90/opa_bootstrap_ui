import 'package:flutter/widgets.dart';

import 'bs_button_style.dart';
import 'bs_size.dart';
import 'bs_variant.dart';

/// A Bootstrap-styled button (`.btn`).
///
/// Supports the solid (`.btn-primary`) and outline (`.btn-outline-primary`)
/// variants, Bootstrap's three button sizes, and hover/active/focus/disabled
/// states, via [BsButtonStyle] (which replicates the shade/tint math from
/// Bootstrap's `button-variant`/`button-outline-variant`/`button-size` Sass
/// mixins). Pass [style] to override individual style "variables" on top of
/// the [variant]/[outline]/[size] defaults, the same way a custom `.btn-*`
/// class in Bootstrap reassigns only the CSS custom properties it needs.
class BsButton extends StatefulWidget {
  const BsButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.variant = BsVariant.primary,
    this.outline = false,
    this.size = BsSize.normal,
    this.style,
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

  /// Style overrides layered on top of the [variant]/[outline]/[size]
  /// defaults. Only the fields set here are overridden; everything else
  /// falls back to the default style, mirroring how a custom `.btn-*` class
  /// in Bootstrap only reassigns the CSS variables it needs.
  final BsButtonStyle? style;

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

  @override
  Widget build(BuildContext context) {
    final enabled = widget._enabled;
    final style = BsButtonStyle.forVariant(
      widget.variant,
      outline: widget.outline,
      size: widget.size,
    ).merge(widget.style);

    final Color background;
    final Color borderColor;
    final Color color;
    if (_pressed) {
      background = style.activeBackground!;
      borderColor = style.activeBorderColor!;
      color = style.activeColor!;
    } else if (_hovered) {
      background = style.hoverBackground!;
      borderColor = style.hoverBorderColor!;
      color = style.hoverColor!;
    } else {
      background = style.background!;
      borderColor = style.borderColor!;
      color = style.color!;
    }

    final opacity = enabled ? 1.0 : (style.disabledOpacity ?? BsButtonStyle.defaultDisabledOpacity);

    final boxShadow = <BoxShadow>[
      ...?(_pressed ? style.activeShadow : style.boxShadow),
      if (_focused)
        BoxShadow(
          color: (style.focusRingColor ?? style.borderColor)!.withValues(alpha: 0.5),
          spreadRadius: style.focusRingWidth ?? BsButtonStyle.defaultFocusRingWidth,
        ),
    ];

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
              duration: style.transitionDuration ?? BsButtonStyle.defaultTransitionDuration,
              curve: style.transitionCurve ?? BsButtonStyle.defaultTransitionCurve,
              padding: style.padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(style.borderRadius ?? BsButtonStyle.borderRadiusBase),
                border: Border.all(
                  color: borderColor,
                  width: style.borderWidth ?? BsButtonStyle.defaultBorderWidth,
                ),
                boxShadow: boxShadow.isEmpty ? null : boxShadow,
              ),
              child: DefaultTextStyle(
                style: (style.textStyle ?? const TextStyle()).copyWith(color: color),
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
