import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_logo.dart';
import '../../src/example_divider.dart';

/// The "Heroes" example: a port of Bootstrap's own `examples/heroes` page.
///
/// As in [HeadersExamplePage] each element's class list (kept as a comment
/// above it) is the widget's props under the classes' own names: `px-4 py-5
/// my-5 text-center` is `BsBox(px: s4, py: s5, my: s5, textAlign: center)`,
/// `row flex-lg-row-reverse align-items-center g-5 py-5` is `BsRow(direction:
/// …, alignItems: center, g: s5, py: s5)`, `col-lg-6 mx-auto` is
/// `BsBox(col: BsCol(6) from lg, mx: auto)`.
///
/// Two translations are worth knowing: `d-grid gap-2 d-sm-flex` (a button
/// stack that turns into a row) is `BsFlex(direction: column, then row from
/// sm, gap: s2)` — a one-column grid *is* a column of stretched items — and
/// the inline `style="max-height: 30vh;"`, which isn't a utility, is the
/// private `_MaxHeight`.
class HeroesExamplePage extends StatelessWidget {
  const HeroesExamplePage({super.key});

  static const _lead =
      'Quickly design and customize responsive mobile-first sites with '
      'Bootstrap, the world’s most popular front-end open source toolkit, '
      'featuring Sass variables and mixins, responsive grid system, extensive '
      'prebuilt components, and powerful JavaScript plugins.';

  // `d-grid gap-2 d-sm-flex` / `d-grid gap-2 d-md-flex`: stacked, then a row.
  static const _columnThenRowSm = BsResponsiveValue(
    xs: BsFlexDirection.column,
    sm: BsFlexDirection.row,
  );
  static const _columnThenRowMd = BsResponsiveValue(
    xs: BsFlexDirection.column,
    md: BsFlexDirection.row,
  );
  static const _centerFromSm = BsResponsiveValue(sm: BsJustify.center);
  static const _startFromMd = BsResponsiveValue(md: BsJustify.start);
  static const _me3FromSm = BsResponsiveValue(sm: BsSpacing.s3);
  static const _me2FromMd = BsResponsiveValue(md: BsSpacing.s2);
  static const _col6FromLg = BsResponsiveValue(lg: BsCol(6));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _centeredHero(),
        const ExampleDivider(),
        _centeredScreenshot(),
        const ExampleDivider(),
        _heroWithImage(),
        const ExampleDivider(),
        _signUpHero(),
        const ExampleDivider(),
        _borderHero(),
        const ExampleDivider(),
        _darkHero(),
        const ExampleDivider(),
      ],
    );
  }

  /// `<h1 class="display-5 fw-bold text-body-emphasis …">`; an `h1`'s own
  /// margin (Reboot's `.5rem`) unless the class list overrides it with `mb-3`.
  static Widget _display(
    BsDisplayLevel level,
    String text, {
    BsTextColor color = BsTextColor.bodyEmphasis,
    BsLh? lh,
    BsSpacing mb = BsSpacing.s2,
  }) {
    return BsBox(
      mb: mb,
      textColor: color,
      child: BsDisplayHeading(level, fw: BsFw.bold, lh: lh, child: Text(text)),
    );
  }

  // --- 1. <div class="px-4 py-5 my-5 text-center"> ---

  static Widget _centeredHero() {
    return BsBox(
      px: BsSpacing.s4,
      py: BsSpacing.s5,
      my: BsSpacing.s5,
      textAlign: BsTextAlign.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // <img class="d-block mx-auto mb-4" src="bootstrap-logo.svg" width="72" height="57">
          const BsBox(
            mx: BsSpacing.auto,
            mb: BsSpacing.s4,
            child: BootstrapLogo(width: 72, height: 57),
          ),
          _display(BsDisplayLevel.d5, 'Centered hero'),
          // <div class="col-lg-6 mx-auto">
          BsBox(
            col: _col6FromLg,
            mx: BsSpacing.auto,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // <p class="lead mb-4">
                const BsBox(
                  mb: BsSpacing.s4,
                  child: BsLead(child: Text(_lead)),
                ),
                // <div class="d-grid gap-2 d-sm-flex justify-content-sm-center">
                BsFlex(
                  direction: _columnThenRowSm,
                  gap: BsSpacing.s2,
                  justifyContent: _centerFromSm,
                  children: [
                    // btn btn-primary btn-lg px-4 gap-3
                    BsButton(
                      size: BsSize.lg,
                      px: BsSpacing.s4,
                      onPressed: () {},
                      child: const Text('Primary button'),
                    ),
                    // btn btn-outline-secondary btn-lg px-4
                    BsButton(
                      variant: BsVariant.secondary,
                      outline: true,
                      size: BsSize.lg,
                      px: BsSpacing.s4,
                      onPressed: () {},
                      child: const Text('Secondary'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. <div class="px-4 pt-5 my-5 text-center border-bottom"> ---

  static Widget _centeredScreenshot() {
    return BsBox(
      px: BsSpacing.s4,
      pt: BsSpacing.s5,
      my: BsSpacing.s5,
      textAlign: BsTextAlign.center,
      borderBottom: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _display(BsDisplayLevel.d4, 'Centered screenshot'),
          // <div class="col-lg-6 mx-auto">
          BsBox(
            col: _col6FromLg,
            mx: BsSpacing.auto,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BsBox(
                  mb: BsSpacing.s4,
                  child: BsLead(child: Text(_lead)),
                ),
                // <div class="d-grid gap-2 d-sm-flex justify-content-sm-center mb-5">
                BsBox(
                  mb: BsSpacing.s5,
                  child: BsFlex(
                    direction: _columnThenRowSm,
                    gap: BsSpacing.s2,
                    justifyContent: _centerFromSm,
                    children: [
                      // btn btn-primary btn-lg px-4 me-sm-3
                      BsFlexItem(
                        me: _me3FromSm,
                        child: BsButton(
                          size: BsSize.lg,
                          px: BsSpacing.s4,
                          onPressed: () {},
                          child: const Text('Primary button'),
                        ),
                      ),
                      BsButton(
                        variant: BsVariant.secondary,
                        outline: true,
                        size: BsSize.lg,
                        px: BsSpacing.s4,
                        onPressed: () {},
                        child: const Text('Secondary'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // <div class="overflow-hidden" style="max-height: 30vh;">
          _MaxHeight(
            vh: 30,
            // <div class="container px-5">
            child: BsContainer(
              px: BsSpacing.s5,
              // <img class="img-fluid border rounded-3 shadow-lg mb-4" width="700" height="500">
              child: const BsBox(
                mb: BsSpacing.s4,
                child: BsImage(
                  image: AssetImage(
                    'assets/examples/heroes/bootstrap-docs.png',
                  ),
                  width: 700,
                  fluid: true,
                  border: true,
                  rounded: BsRounded.r3,
                  shadow: BsShadow.lg,
                  alt: 'Example image',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. <div class="container col-xxl-8 px-4 py-5"> ---

  static Widget _heroWithImage() {
    return BsContainer(
      col: const BsResponsiveValue(xxl: BsCol(8)),
      px: BsSpacing.s4,
      py: BsSpacing.s5,
      // <div class="row flex-lg-row-reverse align-items-center g-5 py-5">
      child: BsRow(
        direction: const BsResponsiveValue(
          xs: BsFlexDirection.row,
          lg: BsFlexDirection.rowReverse,
        ),
        alignItems: BsAlign.center,
        g: BsSpacing.s5,
        py: BsSpacing.s5,
        children: [
          // <div class="col-10 col-sm-8 col-lg-6">
          BsFlexItem(
            col: const BsResponsiveValue(
              xs: BsCol(10),
              sm: BsCol(8),
              lg: BsCol(6),
            ),
            // <img class="d-block mx-lg-auto img-fluid" src="bootstrap-themes.png" width="700" height="500">
            child: const BsBox(
              mx: BsResponsiveValue(lg: BsSpacing.auto),
              child: BsImage(
                image: AssetImage(
                  'assets/examples/heroes/bootstrap-themes.png',
                ),
                width: 700,
                fluid: true,
                block: true,
                alt: 'Bootstrap Themes',
              ),
            ),
          ),
          // <div class="col-lg-6">
          BsFlexItem(
            col: _col6FromLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _display(
                  BsDisplayLevel.d5,
                  'Responsive left-aligned hero with image',
                  lh: BsLh.lh1,
                  mb: BsSpacing.s3,
                ),
                // <p class="lead"> (a paragraph's own margin-bottom: 1rem)
                const BsBox(
                  mb: BsSpacing.s3,
                  child: BsLead(child: Text(_lead)),
                ),
                // <div class="d-grid gap-2 d-md-flex justify-content-md-start">
                BsFlex(
                  direction: _columnThenRowMd,
                  gap: BsSpacing.s2,
                  justifyContent: _startFromMd,
                  children: [
                    // btn btn-primary btn-lg px-4 me-md-2
                    BsFlexItem(
                      me: _me2FromMd,
                      child: BsButton(
                        size: BsSize.lg,
                        px: BsSpacing.s4,
                        onPressed: () {},
                        child: const Text('Primary'),
                      ),
                    ),
                    BsButton(
                      variant: BsVariant.secondary,
                      outline: true,
                      size: BsSize.lg,
                      px: BsSpacing.s4,
                      onPressed: () {},
                      child: const Text('Default'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. <div class="container col-xl-10 col-xxl-8 px-4 py-5"> ---

  static Widget _signUpHero() {
    return BsContainer(
      col: const BsResponsiveValue(xl: BsCol(10), xxl: BsCol(8)),
      px: BsSpacing.s4,
      py: BsSpacing.s5,
      // <div class="row align-items-center g-lg-5 py-5">
      child: BsRow(
        alignItems: BsAlign.center,
        g: const BsResponsiveValue(lg: BsSpacing.s5),
        py: BsSpacing.s5,
        children: [
          // <div class="col-lg-7 text-center text-lg-start">
          BsFlexItem(
            col: const BsResponsiveValue(lg: BsCol(7)),
            child: BsBox(
              textAlign: const BsResponsiveValue(
                xs: BsTextAlign.center,
                lg: BsTextAlign.start,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _display(
                    BsDisplayLevel.d4,
                    'Vertically centered hero sign-up form',
                    lh: BsLh.lh1,
                    mb: BsSpacing.s3,
                  ),
                  // <p class="col-lg-10 fs-4">
                  const BsBox(
                    col: BsResponsiveValue(lg: BsCol(10)),
                    fs: BsFs.fs4,
                    mb: BsSpacing.s3,
                    child: Text(
                      'Below is an example form built entirely with Bootstrap’s '
                      'form controls. Each required form group has a validation '
                      'state that can be triggered by attempting to submit the '
                      'form without completing it.',
                    ),
                  ),
                ],
              ),
            ),
          ),
          // <div class="col-md-10 mx-auto col-lg-5">
          const BsFlexItem(
            col: BsResponsiveValue(md: BsCol(10), lg: BsCol(5)),
            mx: BsSpacing.auto,
            child: _SignUpForm(),
          ),
        ],
      ),
    );
  }

  // --- 5. <div class="container my-5"> ---

  static Widget _borderHero() {
    return BsContainer(
      my: BsSpacing.s5,
      // <div class="row p-4 pb-0 pe-lg-0 pt-lg-5 align-items-center rounded-3 border shadow-lg">
      child: BsRow(
        p: BsSpacing.s4,
        pb: BsSpacing.s0,
        pe: const BsResponsiveValue(lg: BsSpacing.s0),
        pt: const BsResponsiveValue(lg: BsSpacing.s5),
        alignItems: BsAlign.center,
        rounded: BsRounded.r3,
        border: true,
        shadow: BsShadow.lg,
        children: [
          // <div class="col-lg-7 p-3 p-lg-5 pt-lg-3">
          BsFlexItem(
            col: const BsResponsiveValue(lg: BsCol(7)),
            p: const BsResponsiveValue(xs: BsSpacing.s3, lg: BsSpacing.s5),
            pt: const BsResponsiveValue(lg: BsSpacing.s3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _display(
                  BsDisplayLevel.d4,
                  'Border hero with cropped image and shadows',
                  lh: BsLh.lh1,
                  mb: BsSpacing.s2,
                ),
                const BsBox(
                  mb: BsSpacing.s3,
                  child: BsLead(child: Text(_lead)),
                ),
                // <div class="d-grid gap-2 d-md-flex justify-content-md-start mb-4 mb-lg-3">
                BsBox(
                  mb: const BsResponsiveValue(
                    xs: BsSpacing.s4,
                    lg: BsSpacing.s3,
                  ),
                  child: BsFlex(
                    direction: _columnThenRowMd,
                    gap: BsSpacing.s2,
                    justifyContent: _startFromMd,
                    children: [
                      // btn btn-primary btn-lg px-4 me-md-2 fw-bold
                      BsFlexItem(
                        me: _me2FromMd,
                        child: BsButton(
                          size: BsSize.lg,
                          px: BsSpacing.s4,
                          fw: BsFw.bold,
                          onPressed: () {},
                          child: const Text('Primary'),
                        ),
                      ),
                      BsButton(
                        variant: BsVariant.secondary,
                        outline: true,
                        size: BsSize.lg,
                        px: BsSpacing.s4,
                        onPressed: () {},
                        child: const Text('Default'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // <div class="col-lg-4 offset-lg-1 p-0 overflow-hidden shadow-lg">
          const BsFlexItem(
            col: BsResponsiveValue(lg: BsCol(4)),
            offset: BsResponsiveValue(lg: BsCol(1)),
            p: BsSpacing.s0,
            child: BsBox(
              overflowHidden: true,
              shadow: BsShadow.lg,
              child: _RoundedLg3(
                // <img class="rounded-lg-3" src="bootstrap-docs.png" width="720">
                child: BsImage(
                  image: AssetImage(
                    'assets/examples/heroes/bootstrap-docs.png',
                  ),
                  width: 720,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 6. <div class="bg-dark text-secondary px-4 py-5 text-center"> ---

  static Widget _darkHero() {
    return BsBox(
      bg: BsBg.dark,
      textColor: BsTextColor.secondary,
      px: BsSpacing.s4,
      py: BsSpacing.s5,
      textAlign: BsTextAlign.center,
      child: BsBox(
        // <div class="py-5">
        py: BsSpacing.s5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _display(
              BsDisplayLevel.d5,
              'Dark color hero',
              color: BsTextColor.white,
            ),
            // <div class="col-lg-6 mx-auto">
            BsBox(
              col: _col6FromLg,
              mx: BsSpacing.auto,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // <p class="fs-5 mb-4">
                  const BsBox(
                    fs: BsFs.fs5,
                    mb: BsSpacing.s4,
                    child: Text(_lead),
                  ),
                  BsFlex(
                    direction: _columnThenRowSm,
                    gap: BsSpacing.s2,
                    justifyContent: _centerFromSm,
                    children: [
                      // btn btn-outline-info btn-lg px-4 me-sm-3 fw-bold
                      BsFlexItem(
                        me: _me3FromSm,
                        child: BsButton(
                          variant: BsVariant.info,
                          outline: true,
                          size: BsSize.lg,
                          px: BsSpacing.s4,
                          fw: BsFw.bold,
                          onPressed: () {},
                          child: const Text('Custom button'),
                        ),
                      ),
                      // btn btn-outline-light btn-lg px-4
                      BsButton(
                        variant: BsVariant.light,
                        outline: true,
                        size: BsSize.lg,
                        px: BsSpacing.s4,
                        onPressed: () {},
                        child: const Text('Secondary'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `<form class="p-4 p-md-5 border rounded-3 bg-body-tertiary">`.
class _SignUpForm extends StatefulWidget {
  const _SignUpForm();

  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  bool _remember = false;

  @override
  Widget build(BuildContext context) {
    return BsBox(
      p: const BsResponsiveValue(xs: BsSpacing.s4, md: BsSpacing.s5),
      border: true,
      rounded: BsRounded.r3,
      bg: BsBg.bodyTertiary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // <div class="form-floating mb-3">
          const BsBox(
            mb: BsSpacing.s3,
            child: BsFormFloating(
              label: Text('Email address'),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          const BsBox(
            mb: BsSpacing.s3,
            child: BsFormFloating(label: Text('Password'), obscureText: true),
          ),
          // <div class="form-check mb-3">
          BsBox(
            mb: BsSpacing.s3,
            child: BsFormCheck(
              value: _remember,
              onChanged: (value) => setState(() => _remember = value),
              label: const Text('Remember me'),
            ),
          ),
          // <button class="w-100 btn btn-lg btn-primary" type="submit">
          BsButton(
            size: BsSize.lg,
            onPressed: () {},
            child: const Text('Sign up'),
          ),
          // <hr class="my-4">
          const BsHr(my: BsSpacing.s4),
          // <small class="text-body-secondary">
          const BsBox(
            textColor: BsTextColor.bodySecondary,
            child: BsSmall(
              child: Text(
                'By clicking Sign up, you agree to the terms of use.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// `heroes.css`' `.rounded-lg-3`: `border-radius: .3rem` from `lg` up (not a
/// Bootstrap class).
class _RoundedLg3 extends StatelessWidget {
  const _RoundedLg3({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final lg =
        BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width).index >=
        BsBreakpoint.lg.index;
    return ClipRRect(
      borderRadius: BorderRadius.circular(lg ? 4.8 : 0),
      child: child,
    );
  }
}

/// `<div class="overflow-hidden" style="max-height: 30vh;">`: a box at most
/// [vh] percent of the viewport's height, clipping what doesn't fit.
class _MaxHeight extends StatelessWidget {
  const _MaxHeight({required this.vh, required this.child});

  final double vh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: _RenderMaxHeight(
        maxHeight: MediaQuery.sizeOf(context).height * vh / 100,
        child: child,
      ),
    );
  }
}

class _RenderMaxHeight extends SingleChildRenderObjectWidget {
  const _RenderMaxHeight({required this.maxHeight, required super.child});

  final double maxHeight;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _MaxHeightBox(maxHeight);

  @override
  void updateRenderObject(BuildContext context, _MaxHeightBox renderObject) {
    renderObject.maxHeight = maxHeight;
  }
}

class _MaxHeightBox extends RenderShiftedBox {
  _MaxHeightBox(this._maxHeight) : super(null);

  double _maxHeight;
  set maxHeight(double v) {
    if (v != _maxHeight) {
      _maxHeight = v;
      markNeedsLayout();
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final size =
        child?.getDryLayout(constraints.copyWith(maxHeight: double.infinity)) ??
        Size.zero;
    return constraints.constrain(
      Size(size.width, size.height.clamp(0, _maxHeight)),
    );
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child.layout(
      constraints.copyWith(minHeight: 0, maxHeight: double.infinity),
      parentUsesSize: true,
    );
    size = constraints.constrain(
      Size(child.size.width, child.size.height.clamp(0, _maxHeight)),
    );
  }
}
