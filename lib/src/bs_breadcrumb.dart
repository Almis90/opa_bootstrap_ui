import 'package:flutter/widgets.dart';

import 'bs_theme.dart';
import 'tokens/bs_breadcrumb_style.dart';
import 'tokens/bs_link.dart';

/// One crumb in a [BsBreadcrumb].
class BsBreadcrumbItem {
  const BsBreadcrumbItem({required this.label, this.onTap});

  /// The crumb's content, typically a [Text].
  final Widget label;

  /// Called when tapped. Ignored on the last item, which is always
  /// rendered as the current page (Bootstrap's `.active`) — non-interactive,
  /// in [BsBreadcrumbStyle.activeColor].
  final VoidCallback? onTap;
}

/// A Bootstrap breadcrumb (`.breadcrumb`): a trail of page links ending in
/// the current page.
class BsBreadcrumb extends StatelessWidget {
  const BsBreadcrumb({super.key, required this.items, this.style, this.dividerBuilder});

  /// The crumbs, from root to current page. The last one is always
  /// rendered as the current page; see [BsBreadcrumbItem.onTap].
  final List<BsBreadcrumbItem> items;

  /// Style overrides layered on top of [BsBreadcrumbStyle.defaults]. Use
  /// [BsBreadcrumbStyle.divider] for a custom text/character divider (e.g.
  /// `'>'`), or an empty string to remove it — mirroring Bootstrap's
  /// `--bs-breadcrumb-divider` CSS variable / `$breadcrumb-divider` Sass
  /// variable.
  final BsBreadcrumbStyle? style;

  /// Overrides the divider between crumbs entirely with an arbitrary
  /// widget (e.g. an [Icon] or custom-painted glyph) instead of
  /// [BsBreadcrumbStyle.divider]'s text — mirroring Bootstrap's example of
  /// setting `--bs-breadcrumb-divider` to an embedded SVG. Called once per
  /// gap between crumbs.
  final WidgetBuilder? dividerBuilder;

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsBreadcrumbStyle.darkDefaults : BsBreadcrumbStyle.defaults).merge(this.style);
    final itemSpacing = style.itemSpacing ?? BsBreadcrumbStyle.defaultItemSpacing;
    final dividerColor = style.dividerColor ?? BsBreadcrumbStyle.defaultDividerColor;
    final divider = style.divider ?? BsBreadcrumbStyle.defaultDivider;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: style.marginBottom ?? BsBreadcrumbStyle.defaultMarginBottom),
      padding: style.padding ?? BsBreadcrumbStyle.defaultPadding,
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: style.borderRadius == null ? null : BorderRadius.circular(style.borderRadius!),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: itemSpacing),
                child: dividerBuilder?.call(context) ??
                    Text(divider, style: TextStyle(color: dividerColor)),
              ),
            _BsBreadcrumbItemView(
              item: items[i],
              isActive: i == items.length - 1,
              activeColor: style.activeColor ?? BsBreadcrumbStyle.defaultActiveColor,
            ),
          ],
        ],
      ),
    );
  }
}

class _BsBreadcrumbItemView extends StatefulWidget {
  const _BsBreadcrumbItemView({required this.item, required this.isActive, required this.activeColor});

  final BsBreadcrumbItem item;
  final bool isActive;
  final Color activeColor;

  @override
  State<_BsBreadcrumbItemView> createState() => _BsBreadcrumbItemViewState();
}

class _BsBreadcrumbItemViewState extends State<_BsBreadcrumbItemView> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isActive) {
      return DefaultTextStyle.merge(
        style: TextStyle(color: widget.activeColor),
        child: widget.item.label,
      );
    }

    final enabled = widget.item.onTap != null;
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: enabled ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(
        onTap: widget.item.onTap,
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: _hovered ? BsLink.hoverColor : BsLink.color,
            decoration: _hovered ? (BsLink.hoverDecoration ?? BsLink.decoration) : BsLink.decoration,
          ),
          child: widget.item.label,
        ),
      ),
    );
  }
}
