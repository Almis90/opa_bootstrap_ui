import 'package:flutter/widgets.dart';

import 'bs_box.dart';
import 'bs_button_style.dart';
import 'bs_focusable.dart';
import 'bs_size.dart';
import 'bs_spacing.dart';
import 'bs_variant.dart';
import 'tokens/bs_link.dart';
import 'tokens/bs_transitions.dart';
import 'bs_decorated_box.dart';

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
    this.link = false,
    this.size = BsSize.normal,
    this.style,
    this.active = false,
    this.noWrap = false,
    this.px,
    this.py,
    this.fw,
    this.rounded,
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

  /// `.btn-link`: a link-colored, underlined button with no background or
  /// border ([variant] and [outline] are ignored).
  final bool link;

  /// The button's size.
  final BsSize size;

  /// Style overrides layered on top of the [variant]/[outline]/[size]
  /// defaults. Only the fields set here are overridden; everything else
  /// falls back to the default style, mirroring how a custom `.btn-*` class
  /// in Bootstrap only reassigns the CSS variables it needs.
  final BsButtonStyle? style;

  /// Whether to render the persistent `.active` state (e.g. the current
  /// item in a `.btn-group`/pagination, a toggled button), which uses the
  /// same `--bs-btn-active-*` colors/shadow as the transient pressed state.
  final bool active;

  /// Whether to prevent the button's text from wrapping onto multiple
  /// lines, mirroring Bootstrap's `$btn-white-space: nowrap` option.
  final bool noWrap;

  /// `px-*`: horizontal padding in place of the [size]'s (`btn btn-lg px-4`).
  final BsSpacing? px;

  /// `py-*`: vertical padding in place of the [size]'s.
  final BsSpacing? py;

  /// `fw-*`: the text's weight (`btn fw-bold`).
  final BsFw? fw;

  /// `rounded-*` (`btn rounded-pill`): the corners, in place of the [size]'s.
  final BsRounded? rounded;

  final FocusNode? focusNode;
  final bool autofocus;

  bool get _enabled => onPressed != null;

  @override
  State<BsButton> createState() => _BsButtonState();
}

class _BsButtonState extends State<BsButton> {
  bool _hovered = false;
  bool _pressed = false;

  void _setHovered(bool value) {
    if (_hovered != value) setState(() => _hovered = value);
  }

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget._enabled;
    final style =
        (widget.link
                ? BsButtonStyle.link(
                    color: BsLink.colorOf(context),
                    hoverColor: BsLink.hoverColorOf(context),
                  ).merge(BsButtonStyle.size(widget.size))
                : BsButtonStyle.forVariant(
                    widget.variant,
                    outline: widget.outline,
                    size: widget.size,
                  ))
            .merge(widget.style);
    final borderRadius = widget.rounded == null
        ? style.borderRadius
        : BorderRadius.circular(widget.rounded!.radius);
    final padding = style.padding?.resolve(Directionality.of(context));
    final effectivePadding = widget.px == null && widget.py == null
        ? style.padding
        : EdgeInsets.symmetric(
            horizontal:
                widget.px?.size ?? padding?.left ?? BsButtonStyle.paddingXBase,
            vertical:
                widget.py?.size ?? padding?.top ?? BsButtonStyle.paddingYBase,
          );

    final isActive = widget.active || _pressed;

    final Color background;
    final Color borderColor;
    final Color color;
    if (isActive) {
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

    final opacity = enabled
        ? 1.0
        : (style.disabledOpacity ?? BsButtonStyle.defaultDisabledOpacity);

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: enabled ? (_) => _setHovered(true) : null,
      onExit: enabled ? (_) => _setHovered(false) : null,
      child: BsFocusableBuilder(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        builder: (context, focused) {
          final boxShadow = <BoxShadow>[
            ...?(isActive ? style.activeShadow : style.boxShadow),
            if (focused)
              BoxShadow(
                color: (style.focusRingColor ?? style.borderColor)!.withValues(
                  alpha: 0.5,
                ),
                spreadRadius:
                    style.focusRingWidth ?? BsButtonStyle.defaultFocusRingWidth,
              ),
          ];

          return GestureDetector(
            onTapDown: enabled ? (_) => _setPressed(true) : null,
            onTapUp: enabled ? (_) => _setPressed(false) : null,
            onTapCancel: enabled ? () => _setPressed(false) : null,
            onTap: enabled ? widget.onPressed : null,
            child: Opacity(
              opacity: opacity,
              child: BsAnimatedContainer(
                duration: BsTransitions.resolve(
                  context,
                  style.transitionDuration ??
                      BsButtonStyle.defaultTransitionDuration,
                ),
                curve:
                    style.transitionCurve ??
                    BsButtonStyle.defaultTransitionCurve,
                padding:
                    effectivePadding ??
                    const EdgeInsets.symmetric(
                      horizontal: BsButtonStyle.paddingXBase,
                      vertical: BsButtonStyle.paddingYBase,
                    ),
                decoration: BoxDecoration(
                  color: background,
                  borderRadius:
                      borderRadius ??
                      BorderRadius.circular(BsButtonStyle.borderRadiusBase),
                  border: Border.all(
                    color: borderColor,
                    width:
                        style.borderWidth ?? BsButtonStyle.defaultBorderWidth,
                  ),
                  boxShadow: boxShadow.isEmpty ? null : boxShadow,
                ),
                child: DefaultTextStyle(
                  style: (style.textStyle ?? const TextStyle()).copyWith(
                    color: color,
                    fontWeight: widget.fw?.weight,
                    // (this replaces the ambient style, but not its fonts: a
                    // button's text uses the page's, fallbacks included)
                    fontFamily:
                        style.textStyle?.fontFamily ??
                        DefaultTextStyle.of(context).style.fontFamily,
                    fontFamilyFallback:
                        style.textStyle?.fontFamilyFallback ??
                        DefaultTextStyle.of(context).style.fontFamilyFallback,
                  ),
                  textAlign: TextAlign.center,
                  child: widget.noWrap
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [widget.child],
                        )
                      : widget.child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
