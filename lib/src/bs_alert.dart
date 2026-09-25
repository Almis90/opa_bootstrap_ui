import 'package:flutter/widgets.dart';

import 'bs_close_button.dart';
import 'bs_theme.dart';
import 'bs_variant.dart';
import 'tokens/bs_alert_style.dart';

/// A Bootstrap alert (`.alert`): a contextual, dismissible message box.
///
/// Colors are derived from [variant] via [BsVariant.textEmphasis]/
/// [BsVariant.bgSubtle]/[BsVariant.borderSubtle], per Bootstrap's
/// `alert-variant()` Sass mixin. Pass [dismissible] to show a close button;
/// [BsAlert] fades and collapses itself out before calling [onDismissed],
/// mirroring Bootstrap's `.fade`/`.show` collapse transition.
class BsAlert extends StatefulWidget {
  const BsAlert({
    super.key,
    required this.child,
    this.variant = BsVariant.primary,
    this.dismissible = false,
    this.onClose,
    this.onDismissed,
    this.style,
  });

  /// The alert's content, typically a [Text] or a [Column] mixing text and
  /// an `.alert-heading`-style heading.
  final Widget child;

  /// The Bootstrap contextual color, e.g. [BsVariant.primary].
  final BsVariant variant;

  /// Whether to show a close button (`.alert-dismissible`).
  final bool dismissible;

  /// Called immediately when the close button is tapped, before the fade/
  /// collapse animation starts — mirrors Bootstrap's `close.bs.alert` event.
  final VoidCallback? onClose;

  /// Called once the alert has finished fading/collapsing out, after a tap
  /// on the close button — mirrors Bootstrap's `closed.bs.alert` event
  /// (and Flutter's own [Dismissible.onDismissed], which fires at the same
  /// point in its own dismiss animation). The caller is responsible for
  /// actually removing the alert (e.g. from a list) at that point.
  final VoidCallback? onDismissed;

  /// Style overrides layered on top of [BsAlertStyle.defaults].
  final BsAlertStyle? style;

  @override
  State<BsAlert> createState() => _BsAlertState();
}

class _BsAlertState extends State<BsAlert> {
  static const _duration = Duration(milliseconds: 150);

  bool _dismissed = false;

  void _dismiss() {
    widget.onClose?.call();
    setState(() => _dismissed = true);
    Future.delayed(_duration, () {
      if (mounted) widget.onDismissed?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = BsAlertStyle.defaults.merge(widget.style);
    final isDark = BsTheme.of(context) == Brightness.dark;

    // No -dark override exists for $alert-bg-scale/-border-scale/-color-scale
    // in Bootstrap's SCSS — alerts get dark mode entirely through
    // BsVariant's own dark getters (the same var(--bs-*-text-emphasis)/
    // -bg-subtle/-border-subtle custom properties the CSS cascade swaps).
    final color = style.color ?? (isDark ? widget.variant.darkTextEmphasis : widget.variant.textEmphasis);
    final background = style.background ?? (isDark ? widget.variant.darkBgSubtle : widget.variant.bgSubtle);
    final borderColor = style.borderColor ?? (isDark ? widget.variant.darkBorderSubtle : widget.variant.borderSubtle);
    final borderWidth = style.borderWidth ?? BsAlertStyle.defaultBorderWidth;
    final borderRadius = style.borderRadius ?? BsAlertStyle.defaultBorderRadius;
    final padding = style.padding ?? BsAlertStyle.defaultPadding;
    final resolvedPadding = padding.resolve(TextDirection.ltr);
    // `.alert-link`'s `--bs-alert-link-color` (defaults to `color`, the
    // same "alert-color" custom property) and `$alert-link-font-weight`,
    // handed down to any [BsAlertLink] nested in [widget.child].
    final linkColor = style.linkColor ?? color;
    final linkFontWeight = style.linkFontWeight ?? BsAlertStyle.defaultLinkFontWeight;

    return AnimatedOpacity(
      duration: _duration,
      opacity: _dismissed ? 0 : 1,
      child: AnimatedSize(
        duration: _duration,
        child: _dismissed
            ? const SizedBox(width: double.infinity, height: 0)
            : Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: style.marginBottom ?? BsAlertStyle.defaultMarginBottom),
                decoration: BoxDecoration(
                  color: background,
                  border: Border.all(color: borderColor, width: borderWidth),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                // The close button is a Stack sibling, not nested inside the
                // padded content, so its own padding doesn't shrink the
                // alert's content area. It's vertically centered against
                // the alert's actual rendered height — simpler and more
                // robust than replicating Bootstrap's CSS padding math,
                // which assumes exact text-line metrics Flutter doesn't
                // guarantee.
                child: Stack(
                  children: [
                    Padding(
                      padding: widget.dismissible
                          ? padding.add(
                              EdgeInsets.only(
                                right: style.dismissiblePaddingEnd ?? BsAlertStyle.defaultDismissiblePaddingEnd,
                              ),
                            )
                          : padding,
                      child: DefaultTextStyle.merge(
                        style: TextStyle(color: color),
                        child: _BsAlertScope(
                          linkColor: linkColor,
                          linkFontWeight: linkFontWeight,
                          child: widget.child,
                        ),
                      ),
                    ),
                    if (widget.dismissible)
                      Positioned.fill(
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: resolvedPadding.right),
                            child: BsCloseButton(onPressed: _dismiss),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Propagates the enclosing [BsAlert]'s resolved `--bs-alert-link-color`/
/// `$alert-link-font-weight` to any [BsAlertLink] nested in its [child].
class _BsAlertScope extends InheritedWidget {
  const _BsAlertScope({
    required this.linkColor,
    required this.linkFontWeight,
    required super.child,
  });

  final Color linkColor;
  final FontWeight linkFontWeight;

  static _BsAlertScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_BsAlertScope>();

  @override
  bool updateShouldNotify(_BsAlertScope oldWidget) =>
      linkColor != oldWidget.linkColor || linkFontWeight != oldWidget.linkFontWeight;
}

/// `.alert-link`: a link styled to match the enclosing [BsAlert]'s
/// contextual color, in [BsAlertStyle.defaultLinkFontWeight]. Nest this
/// inside a [BsAlert]'s `child` around any tappable text that should read
/// as a link, e.g. `BsAlert(child: Text.rich(TextSpan(children: [
/// TextSpan(text: 'An example link'), ])))` — wrap just the link's span
/// in a [BsAlertLink].
class BsAlertLink extends StatelessWidget {
  const BsAlertLink({super.key, required this.child, this.onTap});

  /// Typically a [Text].
  final Widget child;

  /// Called on tap. [BsAlertLink] itself only supplies Bootstrap's
  /// `.alert-link` color/weight, not `<a>`'s navigation behavior.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scope = _BsAlertScope.maybeOf(context);
    final color = scope?.linkColor ?? BsVariant.primary.textEmphasis;
    final fontWeight = scope?.linkFontWeight ?? BsAlertStyle.defaultLinkFontWeight;

    final styledChild = DefaultTextStyle.merge(
      style: TextStyle(color: color, fontWeight: fontWeight),
      child: child,
    );

    return onTap == null
        ? styledChild
        : GestureDetector(
            onTap: onTap,
            child: MouseRegion(cursor: SystemMouseCursors.click, child: styledChild),
          );
  }
}
