import 'package:flutter/widgets.dart';

import 'bs_decorated_box.dart';
import 'bs_responsive_value.dart';
import 'bs_spacing.dart';
import 'bs_breakpoint.dart';

/// `<hr>`: a 1px horizontal rule in the current text color at 25% opacity,
/// with Reboot's `1rem` vertical margin unless [my] says otherwise
/// (`<hr class="my-4">`).
class BsHr extends StatelessWidget {
  const BsHr({super.key, this.my});

  /// `my-*`: vertical margin; `1rem` (`my-3`) when null.
  final BsResponsive<BsSpacing>? my;

  @override
  Widget build(BuildContext context) {
    final breakpoint = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
    final margin = (my?.resolve(breakpoint) ?? BsSpacing.s3).size;
    final color = DefaultTextStyle.of(context).style.color ?? const Color(0xFF000000);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: margin),
      child: SizedBox(
        height: 1,
        width: double.infinity,
        child: BsDecoratedBox(
          decoration: BoxDecoration(color: color.withValues(alpha: color.a * 0.25)),
        ),
      ),
    );
  }
}
