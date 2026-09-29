import 'package:flutter/widgets.dart';

import 'bs_breakpoint.dart';
import 'bs_theme.dart';
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
  const BsCard({super.key, required this.child, this.style}) : _groupStartJoin = false, _groupEndJoin = false;

  /// Used by [BsCardGroup] to square off the corners/border shared with a
  /// neighboring card.
  const BsCard._grouped({
    super.key,
    required this.child,
    this.style,
    required this._groupStartJoin,
    required this._groupEndJoin,
  });

  /// The card's content, typically a [Column] of header/body/footer/image
  /// widgets.
  final Widget child;

  /// Style overrides layered on top of [BsCardStyle.defaults].
  final BsCardStyle? style;

  /// Whether this card shares its start edge (left in LTR, right in RTL)
  /// with a preceding card in a [BsCardGroup]: squares off the start
  /// corners and drops the start border, so the seam reads as the
  /// neighbor's single shared border.
  final bool _groupStartJoin;

  /// Whether this card shares its end edge (right in LTR, left in RTL)
  /// with a following card in a [BsCardGroup]: squares off the end
  /// corners only, since this card's own end border becomes the shared
  /// seam.
  final bool _groupEndJoin;

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsCardStyle.darkDefaults : BsCardStyle.defaults).merge(this.style);
    final borderWidth = style.borderWidth ?? BsCardStyle.defaultBorderWidth;
    final borderRadius = style.borderRadius ?? BsCardStyle.defaultBorderRadius;
    final borderColor = style.borderColor ?? BsCardStyle.defaultBorderColor;
    final background = style.background ?? BsCardStyle.defaultBackground;
    final radius = Radius.circular(borderRadius);
    // BorderRadiusDirectional/BorderDirectional so the shared seam always
    // lands on the actual edge two adjacent cards touch — left in LTR,
    // right in RTL — instead of assuming list order always reads left to
    // right the way Border(left:)/Border(right:) would.
    final outerBorderRadius = BorderRadiusDirectional.only(
      topStart: _groupStartJoin ? Radius.zero : radius,
      bottomStart: _groupStartJoin ? Radius.zero : radius,
      topEnd: _groupEndJoin ? Radius.zero : radius,
      bottomEnd: _groupEndJoin ? Radius.zero : radius,
    );

    return _BsCardScope(
      style: style,
      groupStartJoin: _groupStartJoin,
      groupEndJoin: _groupEndJoin,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: BorderDirectional(
            top: BorderSide(color: borderColor, width: borderWidth),
            end: BorderSide(color: borderColor, width: borderWidth),
            bottom: BorderSide(color: borderColor, width: borderWidth),
            // BorderSide.none won't do here: unlike Border.paint(),
            // BorderDirectional.paint() requires every side to share the
            // same color whenever borderRadius is non-null, even sides
            // with style: BorderStyle.none — BorderSide.none's own
            // default color (opaque black) doesn't match borderColor, so
            // it fails that check. An explicit color keeps it invisible
            // (style: none) while satisfying the uniform-color rule.
            start: _groupStartJoin
                ? BorderSide(color: borderColor, style: BorderStyle.none)
                : BorderSide(color: borderColor, width: borderWidth),
          ),
          // A card sandwiched between two neighbors (both joined) squares
          // off every corner, i.e. a geometrically-zero radius — but unlike
          // Border.paint(), BorderDirectional.paint() only special-cases a
          // *null* borderRadius for a non-uniform-style border (this one
          // has a style: none side), not one that's merely zero-valued.
          // Passing null instead sidesteps that assertion; visually a zero
          // radius and no radius already look identical.
          borderRadius: (_groupStartJoin && _groupEndJoin) ? null : outerBorderRadius,
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
    required this.groupStartJoin,
    required this.groupEndJoin,
    required super.child,
  });

  final BsCardStyle style;
  final bool groupStartJoin;
  final bool groupEndJoin;

  static BsCardStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_BsCardScope>()?.style;

  static _BsCardScope? _maybeScopeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_BsCardScope>();

  @override
  bool updateShouldNotify(_BsCardScope oldWidget) =>
      style != oldWidget.style ||
      groupStartJoin != oldWidget.groupStartJoin ||
      groupEndJoin != oldWidget.groupEndJoin;
}

/// `.card-header`: an optional top cap, e.g. for a title or nav.
class BsCardHeader extends StatelessWidget {
  const BsCardHeader({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scope = _BsCardScope._maybeScopeOf(context);
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = scope?.style ?? (isDark ? BsCardStyle.darkDefaults : BsCardStyle.defaults);
    final innerRadius = style.innerBorderRadius ?? BsCardStyle.defaultInnerBorderRadius;
    final radius = Radius.circular(innerRadius);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.capBackground ?? BsCardStyle.defaultCapBackground,
        borderRadius: BorderRadiusDirectional.only(
          topStart: scope?.groupStartJoin ?? false ? Radius.zero : radius,
          topEnd: scope?.groupEndJoin ?? false ? Radius.zero : radius,
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
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = scope?.style ?? (isDark ? BsCardStyle.darkDefaults : BsCardStyle.defaults);
    final innerRadius = style.innerBorderRadius ?? BsCardStyle.defaultInnerBorderRadius;
    final radius = Radius.circular(innerRadius);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.capBackground ?? BsCardStyle.defaultCapBackground,
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: scope?.groupStartJoin ?? false ? Radius.zero : radius,
          bottomEnd: scope?.groupEndJoin ?? false ? Radius.zero : radius,
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
    final squareStart = scope?.groupStartJoin ?? false;
    final squareEnd = scope?.groupEndJoin ?? false;

    return ClipRRect(
      borderRadius: BorderRadiusDirectional.only(
        topStart: position != BsCardImgPosition.bottom && !squareStart ? radius : Radius.zero,
        topEnd: position != BsCardImgPosition.bottom && !squareEnd ? radius : Radius.zero,
        bottomStart: position != BsCardImgPosition.top && !squareStart ? radius : Radius.zero,
        bottomEnd: position != BsCardImgPosition.top && !squareEnd ? radius : Radius.zero,
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
                    groupStartJoin: i != 0,
                    groupEndJoin: i != children.length - 1,
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
