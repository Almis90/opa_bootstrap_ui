import 'package:flutter/widgets.dart';

import 'bs_decorated_box.dart';
import 'bs_responsive_value.dart';
import 'bs_spacing.dart';
import 'bs_breakpoint.dart';

/// A 1px horizontal rule in the current text color at 25% opacity, with a 16 logical pixel
/// vertical margin unless [my] says otherwise.
class BsHr extends StatelessWidget {
  const BsHr({super.key, this.my});

  /// The vertical margin; 16 logical pixels when null.
  final BsResponsive<BsSpacing>? my;

  @override
  Widget build(BuildContext context) {
    final breakpoint = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
    final margin = (my?.resolve(breakpoint) ?? BsSpacing.s3).size;
    final color =
        DefaultTextStyle.of(context).style.color ?? const Color(0xFF000000);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: margin),
      child: SizedBox(
        height: 1,
        width: double.infinity,
        child: BsDecoratedBox(
          decoration: BoxDecoration(
            color: color.withValues(alpha: color.a * 0.25),
          ),
        ),
      ),
    );
  }
}

/// A 1px vertical rule in the current text color at 25% opacity, at least one font size tall.
/// In a flex row it stretches to the row's height.
class BsVr extends StatelessWidget {
  const BsVr({super.key});

  @override
  Widget build(BuildContext context) {
    final style = DefaultTextStyle.of(context).style;
    final color = style.color ?? const Color(0xFF000000);
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 1,
        maxWidth: 1,
        minHeight: style.fontSize ?? 16,
      ),
      child: BsDecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: color.a * 0.25),
        ),
      ),
    );
  }
}
