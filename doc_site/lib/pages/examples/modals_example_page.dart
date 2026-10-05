import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/example_divider.dart';

/// The "Modals" example: a port of Bootstrap's own `examples/modals` page — four
/// modal *sheets* shown in place (`modal position-static d-block`), not as
/// overlays, so they are built from the modal's own CSS (`.modal-dialog`,
/// `.modal-content`, `.modal-header`, …, each noted where it is used) and the
/// utility classes the page puts on them, not from [BsModal].
class ModalsExamplePage extends StatelessWidget {
  const ModalsExamplePage({super.key});

  static const _p4PyMd5 = BsResponsiveValue(md: BsSpacing.s5);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sheet(context, _signSheet(context)),
        const ExampleDivider(),
        _sheet(context, _choice(context)),
        const ExampleDivider(),
        _sheet(context, _tour(context)),
        const ExampleDivider(),
        _sheet(context, _signin(context)),
        const ExampleDivider(),
      ],
    );
  }

  // <div class="modal modal-sheet position-static d-block bg-body-secondary p-4 py-md-5">
  //   <div class="modal-dialog"> (380px wide: `.modal-sheet .modal-dialog`)
  static Widget _sheet(BuildContext context, Widget content) {
    final sm =
        BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width).index >=
        BsBreakpoint.sm.index;
    // (`.modal` has `overflow-y: auto`, so what overflows it sideways is clipped.)
    return ClipRect(
      child: BsBox(
        bg: BsBg.bodySecondary,
        p: BsSpacing.s4,
        py: _p4PyMd5,
        // `.modal-dialog`: margin `.5rem` (`1.75rem` above and below from `sm`,
        // and centred then); a fixed width that overflows a narrower container.
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: sm ? 28 : 8,
            horizontal: sm ? 0 : 8,
          ),
          child: _FixedWidth(
            width: 380,
            alignment: sm ? Alignment.topCenter : Alignment.topLeft,
            child: content,
          ),
        ),
      ),
    );
  }

  /// `.modal-content rounded-* shadow`: the body-coloured, translucently
  /// bordered, clipped shell.
  static Widget _content(
    BuildContext context, {
    required BsRounded rounded,
    required Widget child,
  }) {
    final radius = BorderRadius.circular(rounded.radius);
    final inner = BorderRadius.circular(rounded.radius - BsBorders.width);
    return BsDecoratedContainer(
      decoration: BoxDecoration(
        color: BsBody.backgroundOf(context),
        border: Border.all(color: BsBorders.colorTranslucent),
        borderRadius: radius,
        boxShadow: BsShadows.shadow,
      ),
      child: ClipRRect(
        borderRadius: inner,
        child: DefaultTextStyle.merge(
          style: TextStyle(color: BsBody.colorOf(context)),
          child: child,
        ),
      ),
    );
  }

  /// `.modal-header`: a flex row, padded by [padding] (`1rem` by default,
  /// `p-5 pb-4` on the sign-up sheet), with a `border-bottom` unless
  /// `border-bottom-0`; its `.btn-close` is a 32px target with `-.5rem`
  /// margins, so the glyph sits on the padding edge.
  static Widget _header(
    BuildContext context, {
    required Widget title,
    EdgeInsets padding = const EdgeInsets.all(16),
    bool border = true,
  }) {
    return BsDecoratedContainer(
      decoration: BoxDecoration(
        border: border
            ? Border(bottom: BorderSide(color: BsBorders.colorOf(context)))
            : null,
      ),
      padding: padding,
      child: BsFlex(
        alignItems: BsAlign.center,
        justifyContent: BsJustify.between,
        children: [
          title,
          BsFlexItem(
            ms: BsSpacing.auto,
            flexShrink: false,
            child: SizedBox(
              width: 16,
              height: 16,
              child: OverflowBox(
                minWidth: 32,
                maxWidth: 32,
                minHeight: 32,
                maxHeight: 32,
                child: BsCloseButton(
                  onPressed: () {},
                  style: const BsCloseButtonStyle(padding: EdgeInsets.all(8)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// `.modal-footer`: `calc(1rem - .5 * .5rem)` of padding around children that
  /// each have the `.25rem` margin of `.modal-footer > *`, above a border-top
  /// unless `border-top-0`.
  static Widget _footer(
    BuildContext context, {
    required List<Widget> children,
    EdgeInsets padding = const EdgeInsets.all(12),
    bool border = true,
    bool wrap = true,
    BsResponsive<BsFlexDirection>? direction,
    BsAlign? alignItems,
    BsSpacing? gap,
    bool margins = true,
  }) {
    return BsDecoratedContainer(
      decoration: BoxDecoration(
        border: border
            ? Border(top: BorderSide(color: BsBorders.colorOf(context)))
            : null,
      ),
      padding: padding,
      child: BsFlex(
        wrap: wrap,
        direction: direction,
        alignItems: alignItems ?? BsAlign.center,
        justifyContent: BsJustify.end,
        gap: gap,
        children: [
          for (final child in children)
            margins ? BsBox(m: BsSpacing.s1, child: child) : child,
        ],
      ),
    );
  }

  // --- 1. Modal sheet ---

  static Widget _signSheet(BuildContext context) {
    return _content(
      context,
      rounded: BsRounded.r4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // <div class="modal-header border-bottom-0">
          _header(
            context,
            border: false,
            // <h1 class="modal-title fs-5">
            title: const BsBox(
              fs: BsFs.fs5,
              fw: BsFw.medium,
              lh: BsLh.base,
              child: Text('Modal title'),
            ),
          ),
          // <div class="modal-body py-0"><p>
          const BsBox(
            px: BsSpacing.s3,
            child: BsBox(
              mb: BsSpacing.s3,
              child: Text(
                'This is a modal sheet, a variation of the modal that docs '
                'itself to the bottom of the viewport like the newer share '
                'sheets in iOS.',
              ),
            ),
          ),
          // <div class="modal-footer flex-column align-items-stretch w-100 gap-2 pb-3 border-top-0">
          _footer(
            context,
            border: false,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
            direction: BsFlexDirection.column,
            alignItems: BsAlign.stretch,
            gap: BsSpacing.s2,
            children: [
              BsButton(
                size: BsSize.lg,
                onPressed: () {},
                child: const Text('Save changes'),
              ),
              BsButton(
                variant: BsVariant.secondary,
                size: BsSize.lg,
                onPressed: () {},
                child: const Text('Close'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 2. Choice ---

  /// `<button class="btn btn-lg btn-link fs-6 text-decoration-none col-6 py-3 m-0
  /// rounded-0 [border-end]">`: a link-coloured half of the footer.
  static Widget _linkButton(
    BuildContext context,
    Widget label, {
    bool borderEnd = false,
  }) {
    return BsFlexItem(
      col: const BsCol(6),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          // .btn: 1px transparent border; `border-end` makes the right one
          // visible.
          child: BsDecoratedContainer(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: borderEnd
                      ? BsBorders.colorOf(context)
                      : const Color(0x00000000),
                ),
                top: const BorderSide(color: Color(0x00000000)),
                bottom: const BorderSide(color: Color(0x00000000)),
                left: const BorderSide(color: Color(0x00000000)),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: DefaultTextStyle.merge(
              style: TextStyle(color: BsLink.colorOf(context)),
              textAlign: TextAlign.center,
              child: label,
            ),
          ),
        ),
      ),
    );
  }

  static Widget _choice(BuildContext context) {
    return _content(
      context,
      rounded: BsRounded.r3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // <div class="modal-body p-4 text-center">
          BsBox(
            p: BsSpacing.s4,
            textAlign: BsTextAlign.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                BsHeading(
                  BsHeadingLevel.h5,
                  mb: BsSpacing.s0,
                  child: Text('Enable this setting?'),
                ),
                Text(
                  'You can always change your mind in your account settings.',
                ),
              ],
            ),
          ),
          // <div class="modal-footer flex-nowrap p-0">
          _footer(
            context,
            padding: EdgeInsets.zero,
            wrap: false,
            margins: false,
            alignItems: BsAlign.stretch,
            children: [
              _linkButton(
                context,
                const BsBox(fw: BsFw.bold, child: Text('Yes, enable')),
                borderEnd: true,
              ),
              _linkButton(context, const Text('No thanks')),
            ],
          ),
        ],
      ),
    );
  }

  // --- 3. Tour ---

  static Widget _tour(BuildContext context) {
    Widget item(
      BootstrapIconData icon,
      Color color,
      String title,
      String text,
    ) {
      // <li class="d-flex gap-4">
      return BsFlex(
        gap: BsSpacing.s4,
        children: [
          // <svg class="bi … flex-shrink-0" width="48" height="48">
          BsFlexItem(
            flexShrink: false,
            // (an <svg height="48"> has a height: a flex line doesn't stretch it)
            alignSelf: BsAlign.start,
            child: BootstrapIcon(icon, width: 48, height: 48, color: color),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BsHeading(
                BsHeadingLevel.h5,
                mb: BsSpacing.s0,
                child: Text(title),
              ),
              Text(text),
            ],
          ),
        ],
      );
    }

    return _content(
      context,
      rounded: BsRounded.r4,
      // <div class="modal-body p-5">
      child: BsBox(
        p: BsSpacing.s5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // <h2 class="fw-bold mb-0">
            const BsHeading(
              BsHeadingLevel.h2,
              fw: BsFw.bold,
              mb: BsSpacing.s0,
              child: Text("What's new"),
            ),
            // <ul class="d-grid gap-4 my-5 list-unstyled small">
            BsBox(
              my: BsSpacing.s5,
              child: BsSmall(
                block: true,
                child: BsFlex(
                  direction: BsFlexDirection.column,
                  gap: BsSpacing.s4,
                  children: [
                    item(
                      BootstrapIconData.gridFill,
                      BsTextColor.bodySecondary.of(context),
                      'Grid view',
                      'Not into lists? Try the new grid view.',
                    ),
                    item(
                      BootstrapIconData.bookmarkStar,
                      BsTextColor.warning.of(context),
                      'Bookmarks',
                      'Save items you love for easy access later.',
                    ),
                    item(
                      BootstrapIconData.film,
                      BsTextColor.primary.of(context),
                      'Video embeds',
                      'Share videos wherever you go.',
                    ),
                  ],
                ),
              ),
            ),
            // <button class="btn btn-lg btn-primary mt-5 w-100">
            BsBox(
              mt: BsSpacing.s5,
              child: BsButton(
                size: BsSize.lg,
                onPressed: () {},
                child: const Text('Great, thanks!'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 4. Sign up ---

  static Widget _signin(BuildContext context) {
    // <button class="w-100 py-2 mb-2 btn btn-outline-* rounded-3">
    Widget provider(BsVariant variant, BootstrapIconData icon, String label) {
      return BsBox(
        mb: BsSpacing.s2,
        child: BsButton(
          variant: variant,
          outline: true,
          py: BsSpacing.s2,
          rounded: BsRounded.r3,
          onPressed: () {},
          child: Center(
            child: BsFlex(
              inline: true,
              alignItems: BsAlign.start,
              children: [
                // <svg class="bi me-1" width="16" height="16">: `.bi` hangs 2px
                // below the baseline of the 24px line.
                BsFlexItem(
                  me: BsSpacing.s1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: BootstrapIcon(icon, width: 16, height: 16),
                  ),
                ),
                Text(label),
              ],
            ),
          ),
        ),
      );
    }

    const rounded3 = BsFormStyle(inputBorderRadius: 8);
    return _content(
      context,
      rounded: BsRounded.r4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // <div class="modal-header p-5 pb-4 border-bottom-0">
          _header(
            context,
            border: false,
            padding: const EdgeInsets.fromLTRB(48, 48, 48, 24),
            // <h1 class="fw-bold mb-0 fs-2">
            title: const BsHeading(
              BsHeadingLevel.h1,
              fs: BsFs.fs2,
              fw: BsFw.bold,
              mb: BsSpacing.s0,
              child: Text('Sign up for free'),
            ),
          ),
          // <div class="modal-body p-5 pt-0"><form>
          BsBox(
            p: BsSpacing.s5,
            pt: BsSpacing.s0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BsBox(
                  mb: BsSpacing.s3,
                  child: BsFormFloating(
                    label: Text('Email address'),
                    keyboardType: TextInputType.emailAddress,
                    style: rounded3,
                  ),
                ),
                const BsBox(
                  mb: BsSpacing.s3,
                  child: BsFormFloating(
                    label: Text('Password'),
                    obscureText: true,
                    style: rounded3,
                  ),
                ),
                // <button class="w-100 mb-2 btn btn-lg rounded-3 btn-primary">
                BsBox(
                  mb: BsSpacing.s2,
                  child: BsButton(
                    size: BsSize.lg,
                    rounded: BsRounded.r3,
                    onPressed: () {},
                    child: const Text('Sign up'),
                  ),
                ),
                // <small class="text-body-secondary">
                const BsBox(
                  textColor: BsTextColor.bodySecondary,
                  child: BsSmall(
                    child: Text(
                      'By clicking Sign up, you agree to the terms of use.',
                    ),
                  ),
                ),
                const BsHr(my: BsSpacing.s4),
                // <h2 class="fs-5 fw-bold mb-3">
                const BsHeading(
                  BsHeadingLevel.h2,
                  fs: BsFs.fs5,
                  fw: BsFw.bold,
                  mb: BsSpacing.s3,
                  child: Text('Or use a third-party'),
                ),
                provider(
                  BsVariant.secondary,
                  BootstrapIconData.google,
                  'Sign up with Google',
                ),
                provider(
                  BsVariant.primary,
                  BootstrapIconData.facebook,
                  'Sign up with Facebook',
                ),
                provider(
                  BsVariant.secondary,
                  BootstrapIconData.github,
                  'Sign up with GitHub',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A box of exactly [width], whatever room it is given: it overflows a
/// narrower parent (and is aligned within a wider one).
class _FixedWidth extends SingleChildRenderObjectWidget {
  const _FixedWidth({
    required this.width,
    required this.alignment,
    required super.child,
  });

  final double width;
  final Alignment alignment;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderFixedWidth(width, alignment);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderFixedWidth renderObject,
  ) {
    renderObject
      ..width = width
      ..alignment = alignment;
  }
}

class _RenderFixedWidth extends RenderAligningShiftedBox {
  _RenderFixedWidth(this._width, Alignment alignment)
    : super(alignment: alignment, textDirection: TextDirection.ltr);

  double _width;
  set width(double v) {
    if (v != _width) {
      _width = v;
      markNeedsLayout();
    }
  }

  BoxConstraints get _inner => BoxConstraints.tightFor(width: _width);

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final size = child?.getDryLayout(_inner) ?? Size.zero;
    return constraints.constrain(
      Size(
        constraints.hasBoundedWidth ? constraints.maxWidth : size.width,
        size.height,
      ),
    );
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child.layout(_inner, parentUsesSize: true);
    size = constraints.constrain(
      Size(
        constraints.hasBoundedWidth ? constraints.maxWidth : child.size.width,
        child.size.height,
      ),
    );
    alignChild();
  }
}
