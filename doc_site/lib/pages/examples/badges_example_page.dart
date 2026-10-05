import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/example_divider.dart';
import '../../src/github_avatar.dart';

/// The "Badges" example: a port of Bootstrap's own `examples/badges` page —
/// six rows of pill badges in the eight theme colors: solid, subtle, subtle
/// with a border, with an avatar, with a dismiss icon, and with an avatar and
/// a `.vr` before the dismiss icon.
class BadgesExamplePage extends StatelessWidget {
  const BadgesExamplePage({super.key});

  static const _variants = [
    (BsVariant.primary, 'Primary'),
    (BsVariant.secondary, 'Secondary'),
    (BsVariant.success, 'Success'),
    (BsVariant.danger, 'Danger'),
    (BsVariant.warning, 'Warning'),
    (BsVariant.info, 'Info'),
    (BsVariant.light, 'Light'),
    (BsVariant.dark, 'Dark'),
  ];

  /// `<div class="d-flex gap-2 justify-content-center py-5">`.
  static Widget _row(List<Widget> badges) {
    return BsBox(
      py: BsSpacing.s5,
      child: BsFlex(
        gap: BsSpacing.s2,
        justifyContent: BsJustify.center,
        // (`.badge { white-space: nowrap }`: they keep their width and overflow)
        children: [
          for (final badge in badges)
            BsFlexItem(flexShrink: false, child: badge),
        ],
      ),
    );
  }

  /// `<a href="#"><svg class="bi" width="16" height="16">`: `.badge > a`
  /// takes the badge's text color.
  static Widget _dismiss() =>
      const BootstrapIcon(BootstrapIconData.xCircleFill, width: 16, height: 16);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // text-bg-*
        _row([
          for (final (variant, label) in _variants)
            BsBadge(variant: variant, pill: true, child: Text(label)),
        ]),
        const ExampleDivider(),
        // bg-*-subtle text-*-emphasis
        _row([
          for (final (variant, label) in _variants)
            BsBadge(
              variant: variant,
              pill: true,
              subtle: true,
              child: Text(label),
            ),
        ]),
        const ExampleDivider(),
        // … border border-*-subtle
        _row([
          for (final (variant, label) in _variants)
            BsBadge(
              variant: variant,
              pill: true,
              subtle: true,
              border: true,
              child: Text(label),
            ),
        ]),
        const ExampleDivider(),
        // d-flex align-items-center p-1 pe-2 + an avatar
        _row([
          for (final (variant, label) in _variants)
            _avatarBadge(variant, label, trailing: null),
        ]),
        const ExampleDivider(),
        // d-flex p-2 align-items-center + a dismiss icon
        _row([
          _dismissBadge('Primary 1', solid: true, border: false),
          _dismissBadge('Primary 2', solid: false, border: false),
          _dismissBadge('Primary 3', solid: false, border: true),
        ]),
        const ExampleDivider(),
        // an avatar, a .vr and a dismiss icon
        _row([
          for (final (variant, label) in _variants)
            _avatarBadge(variant, label, trailing: _dismiss()),
        ]),
      ],
    );
  }

  /// `badge d-flex align-items-center p-1 pe-2 text-*-emphasis bg-*-subtle
  /// border border-*-subtle rounded-pill`: `<img class="rounded-circle me-1">`
  /// then the label, and — with [trailing] — `<span class="vr mx-2">` and the
  /// dismiss link. The "Light" badge is `text-dark-emphasis`/`border-dark-subtle`
  /// (and `text-light-emphasis` with a dismiss icon).
  static Widget _avatarBadge(
    BsVariant variant,
    String label, {
    required Widget? trailing,
  }) {
    final light = variant == BsVariant.light;
    return BsBadge(
      variant: variant,
      pill: true,
      subtle: true,
      border: true,
      emphasis: light && trailing == null ? BsVariant.dark : null,
      borderVariant: light ? BsVariant.dark : null,
      p: BsSpacing.s1,
      pe: BsSpacing.s2,
      child: BsFlex(
        inline: true,
        alignItems: BsAlign.center,
        children: [
          const BsFlexItem(me: BsSpacing.s1, child: GithubAvatar(size: 24)),
          Text(label),
          if (trailing != null) ...[
            const BsFlexItem(
              mx: BsSpacing.s2,
              alignSelf: BsAlign.stretch,
              child: BsVr(),
            ),
            trailing,
          ],
        ],
      ),
    );
  }

  /// `badge d-flex p-2 align-items-center …`: `<span class="px-1">` and the
  /// dismiss link (`ms-1`).
  static Widget _dismissBadge(
    String label, {
    required bool solid,
    required bool border,
  }) {
    return BsBadge(
      pill: true,
      subtle: !solid,
      border: border,
      p: BsSpacing.s2,
      child: BsFlex(
        inline: true,
        alignItems: BsAlign.center,
        children: [
          BsFlexItem(px: BsSpacing.s1, child: Text(label)),
          BsFlexItem(ms: BsSpacing.s1, child: _dismiss()),
        ],
      ),
    );
  }
}
