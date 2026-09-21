import 'package:flutter/widgets.dart';

import 'bs_close_button.dart';
import 'tokens/bs_modal_style.dart';

/// `$modal-sm`/`$modal-md` (implicit default)/`$modal-lg`/`$modal-xl`: how
/// wide a [BsModalDialog] grows.
enum BsModalSize { small, medium, large, extraLarge }

/// Opens a Bootstrap modal (`.modal`), the same way [showDialog]/
/// `showCupertinoDialog` build on [showGeneralDialog] — a route with an
/// animated backdrop and a custom enter/exit transition matching
/// Bootstrap's `.modal.fade` (a fade plus a slight downward slide).
///
/// [builder] typically returns a [BsModalDialog] wrapping a [BsModal].
/// Dismiss by popping the route (e.g. `Navigator.of(context).pop()`), the
/// same as any other Flutter dialog.
Future<T?> showBsModal<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  String barrierLabel = 'Dismiss',
  BsModalStyle? style,
}) {
  final resolvedStyle = BsModalStyle.defaults.merge(style);
  final backdropOpacity = resolvedStyle.backdropOpacity ?? BsModalStyle.defaultBackdropOpacity;
  final backdropColor = (resolvedStyle.backdropColor ?? BsModalStyle.defaultBackdropColor).withValues(
    alpha: backdropOpacity,
  );

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: backdropColor,
    transitionDuration: resolvedStyle.transitionDuration ?? BsModalStyle.defaultTransitionDuration,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return FadeTransition(
        opacity: curved,
        child: AnimatedBuilder(
          animation: curved,
          builder: (context, child) => Transform.translate(offset: Offset(0, (1 - curved.value) * -50), child: child),
          child: child,
        ),
      );
    },
  );
}

/// `.modal-dialog`: sizes, centers, and (optionally) internally scrolls a
/// [BsModal] within the viewport [showBsModal] opens it over.
class BsModalDialog extends StatelessWidget {
  const BsModalDialog({
    super.key,
    required this.child,
    this.size = BsModalSize.medium,
    this.centered = false,
    this.style,
  });

  /// Typically a [BsModal].
  final Widget child;

  final BsModalSize size;

  /// `.modal-dialog-centered`: vertically centers the dialog instead of
  /// anchoring it near the top of the viewport.
  final bool centered;

  final BsModalStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsModalStyle.defaults.merge(this.style);
    final maxWidth = switch (size) {
      BsModalSize.small => style.smallSize ?? BsModalStyle.defaultSmallSize,
      BsModalSize.medium => style.mediumSize ?? BsModalStyle.defaultMediumSize,
      BsModalSize.large => style.largeSize ?? BsModalStyle.defaultLargeSize,
      BsModalSize.extraLarge => style.extraLargeSize ?? BsModalStyle.defaultExtraLargeSize,
    };
    final margin = style.dialogMargin ?? BsModalStyle.defaultDialogMargin;

    return Align(
      alignment: centered ? Alignment.center : Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: margin, horizontal: margin),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: MediaQuery.sizeOf(context).height - margin * 2,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// `.modal-content`: the bordered, rounded shell holding [header], [body],
/// and [footer].
class BsModal extends StatelessWidget {
  const BsModal({super.key, this.header, required this.body, this.footer, this.scrollableBody = false, this.style});

  /// Typically a [BsModalHeader].
  final Widget? header;

  /// Typically a [BsModalBody].
  final Widget body;

  /// Typically a [BsModalFooter].
  final Widget? footer;

  /// `.modal-dialog-scrollable`: keeps [header]/[footer] fixed and scrolls
  /// only [body] when it overflows. Needs a bounded height from an
  /// ancestor (e.g. [BsModalDialog]).
  final bool scrollableBody;

  final BsModalStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsModalStyle.defaults.merge(this.style);
    final borderRadius = BorderRadius.circular(style.contentBorderRadius ?? BsModalStyle.defaultContentBorderRadius);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.contentBackground ?? BsModalStyle.defaultContentBackground,
        border: Border.all(
          color: style.contentBorderColor ?? BsModalStyle.defaultContentBorderColor,
          width: style.contentBorderWidth ?? BsModalStyle.defaultContentBorderWidth,
        ),
        borderRadius: borderRadius,
        boxShadow: style.contentBoxShadow ?? BsModalStyle.defaultContentBoxShadow,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: DefaultTextStyle.merge(
          style: TextStyle(color: style.contentColor),
          child: Column(
            mainAxisSize: scrollableBody ? MainAxisSize.max : MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ?header,
              scrollableBody ? Expanded(child: SingleChildScrollView(child: body)) : body,
              ?footer,
            ],
          ),
        ),
      ),
    );
  }
}

/// `.modal-header`: [child] (typically a title) plus an optional close
/// button, above a divider.
class BsModalHeader extends StatelessWidget {
  const BsModalHeader({super.key, required this.child, this.onClose, this.style});

  final Widget child;

  /// Shows a [BsCloseButton] calling this when tapped. Omit to hide it.
  final VoidCallback? onClose;

  final BsModalStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsModalStyle.defaults.merge(this.style);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: style.headerBorderColor ?? BsModalStyle.defaultHeaderBorderColor,
            width: style.headerBorderWidth ?? BsModalStyle.defaultContentBorderWidth,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(style.innerPadding ?? BsModalStyle.defaultInnerPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: style.titleLineHeight ?? BsModalStyle.defaultTitleLineHeight,
                ),
                child: child,
              ),
            ),
            if (onClose != null) ...[const SizedBox(width: 16), BsCloseButton(onPressed: onClose)],
          ],
        ),
      ),
    );
  }
}

/// `.modal-body`: the modal's main content area.
class BsModalBody extends StatelessWidget {
  const BsModalBody({super.key, required this.child, this.style});

  final Widget child;
  final BsModalStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsModalStyle.defaults.merge(this.style);
    return Padding(padding: EdgeInsets.all(style.innerPadding ?? BsModalStyle.defaultInnerPadding), child: child);
  }
}

/// `.modal-footer`: right-aligned, wrapping action buttons above a divider.
class BsModalFooter extends StatelessWidget {
  const BsModalFooter({super.key, required this.children, this.style});

  final List<Widget> children;
  final BsModalStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsModalStyle.defaults.merge(this.style);
    final gap = style.footerMarginBetween ?? BsModalStyle.defaultFooterMarginBetween;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: style.footerBorderColor ?? BsModalStyle.defaultHeaderBorderColor,
            width: style.footerBorderWidth ?? BsModalStyle.defaultContentBorderWidth,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(style.innerPadding ?? BsModalStyle.defaultInnerPadding),
        child: Wrap(alignment: WrapAlignment.end, spacing: gap, runSpacing: gap, children: children),
      ),
    );
  }
}
