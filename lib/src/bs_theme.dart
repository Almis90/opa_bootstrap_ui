import 'package:flutter/widgets.dart';

/// Provides the ambient [Brightness] (Bootstrap's `data-bs-theme`
/// `light`/`dark`) to every `Bs*` widget beneath it, the same way
/// [MediaQuery] provides ambient context in its own ecosystem.
///
/// [BsApp] installs one automatically from its `brightness` parameter.
/// Nest another [BsTheme] deeper in the tree to override it for a subtree
/// (e.g. a docs site's live dark-mode preview pane).
class BsTheme extends InheritedWidget {
  const BsTheme({super.key, required this.brightness, required super.child});

  final Brightness brightness;

  /// The ambient brightness, defaulting to [Brightness.light] when there's
  /// no [BsTheme] ancestor — every `Bs*` widget works unchanged for callers
  /// who never opt into dark mode.
  static Brightness of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BsTheme>()?.brightness ?? Brightness.light;
  }

  @override
  bool updateShouldNotify(BsTheme oldWidget) => brightness != oldWidget.brightness;
}
