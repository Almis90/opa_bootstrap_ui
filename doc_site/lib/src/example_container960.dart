import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

/// `.container { max-width: 960px }` (the Pricing and Product pages' own CSS):
/// a container that is as wide as it is allowed to be up to 960px at *every*
/// breakpoint, instead of Bootstrap's stepped `540/720/960/…` ones.
class Container960 extends StatelessWidget {
  const Container960({super.key, this.py, required this.child});

  final BsResponsive<BsSpacing>? py;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960),
        child: BsContainer.fluid(py: py, child: child),
      ),
    );
  }
}
