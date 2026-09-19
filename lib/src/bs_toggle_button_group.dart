import 'package:flutter/widgets.dart';

import 'bs_button.dart';
import 'bs_button_group.dart';
import 'bs_size.dart';
import 'bs_variant.dart';

/// A group of toggleable [BsButton]s, mirroring Bootstrap's checkbox/radio
/// "toggle button" groups (`<input class="btn-check">` + `<label class="btn">`).
///
/// Fully controlled, like Flutter's own `ToggleButtons`: this widget only
/// renders [isSelected] and reports taps via [onPressed] — it does not track
/// selection itself. That single contract covers both of Bootstrap's HTML
/// variants:
///  * checkbox-like (independent toggles): flip just the tapped index in
///    [isSelected].
///  * radio-like (mutually exclusive): replace [isSelected] with a list
///    where only the tapped index is true.
class BsToggleButtonGroup extends StatelessWidget {
  const BsToggleButtonGroup({
    super.key,
    required this.children,
    required this.isSelected,
    required this.onPressed,
    this.variant = BsVariant.primary,
    this.outline = true,
    this.vertical = false,
    this.size,
  }) : assert(
         children.length == isSelected.length,
         'children and isSelected must have the same length',
       );

  /// The content of each toggle button.
  final List<Widget> children;

  /// Whether each button (by index) is currently selected/checked, i.e.
  /// rendered with [BsButton.active].
  final List<bool> isSelected;

  /// Called with the tapped button's index. The caller updates
  /// [isSelected] accordingly (see the class doc for checkbox vs radio
  /// behavior).
  final ValueChanged<int> onPressed;

  /// The Bootstrap contextual color applied to every button.
  final BsVariant variant;

  /// Whether to render the outline style, per Bootstrap's own examples
  /// (`.btn-outline-primary`).
  final bool outline;

  /// Whether to stack the buttons vertically.
  final bool vertical;

  /// Applies this size to every button. Defaults to [BsSize.normal].
  final BsSize? size;

  @override
  Widget build(BuildContext context) {
    return BsButtonGroup(
      vertical: vertical,
      size: size,
      children: [
        for (var i = 0; i < children.length; i++)
          BsButton(
            variant: variant,
            outline: outline,
            active: isSelected[i],
            onPressed: () => onPressed(i),
            child: children[i],
          ),
      ],
    );
  }
}
