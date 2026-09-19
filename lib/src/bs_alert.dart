import 'package:flutter/widgets.dart';

import 'bs_close_button.dart';
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

  /// Called once the alert has finished fading/collapsing out, after a tap
  /// on the close button. The caller is responsible for actually removing
  /// the alert (e.g. from a list) at that point.
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
    setState(() => _dismissed = true);
    Future.delayed(_duration, () {
      if (mounted) widget.onDismissed?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = BsAlertStyle.defaults.merge(widget.style);

    final color = style.color ?? widget.variant.textEmphasis;
    final background = style.background ?? widget.variant.bgSubtle;
    final borderColor = style.borderColor ?? widget.variant.borderSubtle;
    final borderWidth = style.borderWidth ?? BsAlertStyle.defaultBorderWidth;
    final borderRadius = style.borderRadius ?? BsAlertStyle.defaultBorderRadius;
    final padding = style.padding ?? BsAlertStyle.defaultPadding;
    final resolvedPadding = padding.resolve(TextDirection.ltr);

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
                      child: DefaultTextStyle.merge(style: TextStyle(color: color), child: widget.child),
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
