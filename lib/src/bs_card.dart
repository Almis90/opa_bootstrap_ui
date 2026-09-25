import 'package:flutter/widgets.dart';

import 'bs_breakpoint.dart';
import 'tokens/bs_card_style.dart';
import 'tokens/bs_link.dart';

/// Where a [BsCardImg] sits relative to a card's other content.
enum BsCardImgPosition {
  /// `.card-img` — rounds all four corners, meant to be a card's only child.
  full,

  /// `.card-img-top` — rounds only the top corners.
  top,

  /// `.card-img-bottom` — rounds only the bottom corners.
  bottom,
}

/// A Bootstrap card (`.card`): a flexible content container.
///
/// Compose it from [BsCardHeader], [BsCardImg], [BsCardBody],
/// [BsCardFooter], etc. — Bootstrap's card has no fixed structure, so this
/// widget is just the bordered/rounded shell.
class BsCard extends StatelessWidget {
  const BsCard({super.key, required this.child, this.style}) : _groupLeftJoin = false, _groupRightJoin = false;

  /// Used by [BsCardGroup] to square off the corners/border shared with a
  /// neighboring card.
  const BsCard._grouped({
    super.key,
    required this.child,
    this.style,
    required this._groupLeftJoin,
    required this._groupRightJoin,
  });

  /// The card's content, typically a [Column] of header/body/footer/image
  /// widgets.
  final Widget child;

  /// Style overrides layered on top of [BsCardStyle.defaults].
  final BsCardStyle? style;

  /// Whether this card shares its left edge with a preceding card in a
  /// [BsCardGroup]: squares off the left corners and drops the left border,
  /// so the seam reads as the neighbor's single shared border.
  final bool _groupLeftJoin;

  /// Whether this card shares its right edge with a following card in a
  /// [BsCardGroup]: squares off the right corners only, since this card's
  /// own right border becomes the shared seam.
  final bool _groupRightJoin;

  @override
  Widget build(BuildContext context) {
    final style = BsCardStyle.defaults.merge(this.style);
    final borderWidth = style.borderWidth ?? BsCardStyle.defaultBorderWidth;
    final borderRadius = style.borderRadius ?? BsCardStyle.defaultBorderRadius;
    final borderColor = style.borderColor ?? BsCardStyle.defaultBorderColor;
    final radius = Radius.circular(borderRadius);
    final outerBorderRadius = BorderRadius.only(
      topLeft: _groupLeftJoin ? Radius.zero : radius,
      bottomLeft: _groupLeftJoin ? Radius.zero : radius,
      topRight: _groupRightJoin ? Radius.zero : radius,
      bottomRight: _groupRightJoin ? Radius.zero : radius,
    );

    return _BsCardScope(
      style: style,
      groupLeftJoin: _groupLeftJoin,
      groupRightJoin: _groupRightJoin,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: style.background ?? BsCardStyle.defaultBackground,
          border: Border(
            top: BorderSide(color: borderColor, width: borderWidth),
            right: BorderSide(color: borderColor, width: borderWidth),
            bottom: BorderSide(color: borderColor, width: borderWidth),
            left: _groupLeftJoin ? BorderSide.none : BorderSide(color: borderColor, width: borderWidth),
          ),
          borderRadius: outerBorderRadius,
          boxShadow: style.boxShadow,
        ),
        child: ClipRRect(
          borderRadius: outerBorderRadius,
          child: DefaultTextStyle.merge(
            style: TextStyle(color: style.color),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [child]),
          ),
        ),
      ),
    );
  }
}

/// Propagates the enclosing [BsCard]'s resolved style to its cap/image
/// children, which need [BsCardStyle.innerBorderRadius] and
/// [BsCardStyle.borderWidth]/[BsCardStyle.borderColor] to align their own
/// corners and dividers with the card's outer border.
class _BsCardScope extends InheritedWidget {
  const _BsCardScope({
    required this.style,
    required this.groupLeftJoin,
    required this.groupRightJoin,
    required super.child,
  });

  final BsCardStyle style;
  final bool groupLeftJoin;
  final bool groupRightJoin;

  static BsCardStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_BsCardScope>()?.style;

  static _BsCardScope? _maybeScopeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_BsCardScope>();

  @override
  bool updateShouldNotify(_BsCardScope oldWidget) =>
      style != oldWidget.style ||
      groupLeftJoin != oldWidget.groupLeftJoin ||
      groupRightJoin != oldWidget.groupRightJoin;
}

/// `.card-header`: an optional top cap, e.g. for a title or nav.
class BsCardHeader extends StatelessWidget {
  const BsCardHeader({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scope = _BsCardScope._maybeScopeOf(context);
    final style = scope?.style ?? BsCardStyle.defaults;
    final innerRadius = style.innerBorderRadius ?? BsCardStyle.defaultInnerBorderRadius;
    final radius = Radius.circular(innerRadius);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.capBackground ?? BsCardStyle.defaultCapBackground,
        borderRadius: BorderRadius.only(
          topLeft: scope?.groupLeftJoin ?? false ? Radius.zero : radius,
          topRight: scope?.groupRightJoin ?? false ? Radius.zero : radius,
        ),
        border: Border(
          bottom: BorderSide(
            color: style.borderColor ?? BsCardStyle.defaultBorderColor,
            width: style.borderWidth ?? BsCardStyle.defaultBorderWidth,
          ),
        ),
      ),
      child: Padding(
        padding: style.capPadding ?? BsCardStyle.defaultCapPadding,
        child: DefaultTextStyle.merge(style: TextStyle(color: style.capColor), child: child),
      ),
    );
  }
}

/// `.card-footer`: an optional bottom cap.
class BsCardFooter extends StatelessWidget {
  const BsCardFooter({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scope = _BsCardScope._maybeScopeOf(context);
    final style = scope?.style ?? BsCardStyle.defaults;
    final innerRadius = style.innerBorderRadius ?? BsCardStyle.defaultInnerBorderRadius;
    final radius = Radius.circular(innerRadius);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.capBackground ?? BsCardStyle.defaultCapBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: scope?.groupLeftJoin ?? false ? Radius.zero : radius,
          bottomRight: scope?.groupRightJoin ?? false ? Radius.zero : radius,
        ),
        border: Border(
          top: BorderSide(
            color: style.borderColor ?? BsCardStyle.defaultBorderColor,
            width: style.borderWidth ?? BsCardStyle.defaultBorderWidth,
          ),
        ),
      ),
      child: Padding(
        padding: style.capPadding ?? BsCardStyle.defaultCapPadding,
        child: DefaultTextStyle.merge(style: TextStyle(color: style.capColor), child: child),
      ),
    );
  }
}

/// `.card-body`: the card's main content block.
class BsCardBody extends StatelessWidget {
  const BsCardBody({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final style = _BsCardScope.maybeOf(context) ?? BsCardStyle.defaults;

    return Padding(
      padding: style.spacing ?? BsCardStyle.defaultSpacing,
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

/// `.card-title`.
class BsCardTitle extends StatelessWidget {
  const BsCardTitle({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final style = _BsCardScope.maybeOf(context) ?? BsCardStyle.defaults;

    return Padding(
      padding: EdgeInsets.only(bottom: style.titleSpacerY ?? BsCardStyle.defaultTitleSpacerY),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: style.titleColor, fontWeight: FontWeight.bold),
        child: child,
      ),
    );
  }
}

/// `.card-subtitle`.
class BsCardSubtitle extends StatelessWidget {
  const BsCardSubtitle({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final style = _BsCardScope.maybeOf(context) ?? BsCardStyle.defaults;
    final titleSpacerY = style.titleSpacerY ?? BsCardStyle.defaultTitleSpacerY;

    return Transform.translate(
      offset: Offset(0, -0.5 * titleSpacerY),
      child: DefaultTextStyle.merge(style: TextStyle(color: style.subtitleColor), child: child),
    );
  }
}

/// `.card-text`.
class BsCardText extends StatelessWidget {
  const BsCardText({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

/// `.card-link`: an inline link within a card, spaced from a preceding
/// sibling like Bootstrap's `.card-link + .card-link`.
class BsCardLink extends StatefulWidget {
  const BsCardLink({super.key, required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  State<BsCardLink> createState() => _BsCardLinkState();
}

class _BsCardLinkState extends State<BsCardLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: _hovered ? BsLink.hoverColor : BsLink.color,
            decoration: _hovered ? (BsLink.hoverDecoration ?? BsLink.decoration) : BsLink.decoration,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// `.card-img`/`.card-img-top`/`.card-img-bottom`: a full-bleed image with
/// corners rounded to match the card, per [position].
class BsCardImg extends StatelessWidget {
  const BsCardImg({super.key, required this.child, this.position = BsCardImgPosition.top});

  /// Typically an [Image].
  final Widget child;

  final BsCardImgPosition position;

  @override
  Widget build(BuildContext context) {
    final scope = _BsCardScope._maybeScopeOf(context);
    final style = scope?.style ?? BsCardStyle.defaults;
    final innerRadius = style.innerBorderRadius ?? BsCardStyle.defaultInnerBorderRadius;
    final radius = Radius.circular(innerRadius);
    final squareLeft = scope?.groupLeftJoin ?? false;
    final squareRight = scope?.groupRightJoin ?? false;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: position != BsCardImgPosition.bottom && !squareLeft ? radius : Radius.zero,
        topRight: position != BsCardImgPosition.bottom && !squareRight ? radius : Radius.zero,
        bottomLeft: position != BsCardImgPosition.top && !squareLeft ? radius : Radius.zero,
        bottomRight: position != BsCardImgPosition.top && !squareRight ? radius : Radius.zero,
      ),
      child: child,
    );
  }
}

/// `.card-img-overlay`: positions content over a [BsCardImg], e.g. for a
/// text caption on top of a background image. Stack this with a
/// [BsCardImg] inside a [Stack].
class BsCardImgOverlay extends StatelessWidget {
  const BsCardImgOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final style = _BsCardScope.maybeOf(context) ?? BsCardStyle.defaults;
    final innerRadius = style.innerBorderRadius ?? BsCardStyle.defaultInnerBorderRadius;

    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(innerRadius),
        child: Padding(
          padding: EdgeInsets.all(style.imgOverlayPadding ?? BsCardStyle.defaultImgOverlayPadding),
          child: child,
        ),
      ),
    );
  }
}

/// `.card-group`: lays a row of [BsCard]s out as a single visual block —
/// equal widths, a shared border at each seam, and only the group's
/// outermost corners left rounded.
///
/// Below the `sm` breakpoint, Bootstrap stacks `.card-group` into separate
/// full-width cards (each keeping its own rounded corners) spaced by
/// `$card-group-margin`; this mirrors that with a [LayoutBuilder].
class BsCardGroup extends StatelessWidget {
  const BsCardGroup({super.key, required this.children, this.margin});

  /// The cards to group. Each keeps its own [BsCard.style]/[BsCard.child];
  /// only corner rounding and the shared border are adjusted by the group.
  final List<BsCard> children;

  /// `$card-group-margin`, the gap between cards when stacked below `sm`.
  final double? margin;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    if (children.length == 1) return children.single;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < BsBreakpoint.sm.minWidth) {
          final margin = this.margin ?? BsCardStyle.defaultGroupMargin;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < children.length; i++)
                Padding(padding: EdgeInsets.only(bottom: i == children.length - 1 ? 0 : margin), child: children[i]),
            ],
          );
        }

        // IntrinsicHeight gives the row a finite height (the tallest card's),
        // which crossAxisAlignment.stretch then needs to equalize every
        // card's height — a bare Row would otherwise inherit the unbounded
        // height of an enclosing scroll view and crash.
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < children.length; i++)
                Expanded(
                  child: BsCard._grouped(
                    key: children[i].key,
                    style: children[i].style,
                    groupLeftJoin: i != 0,
                    groupRightJoin: i != children.length - 1,
                    child: children[i].child,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
