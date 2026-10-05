import 'package:flutter/widgets.dart';

/// A single full-page example listed in the Examples gallery — the
/// counterpart to Bootstrap's standalone `examples/*` pages (as opposed to
/// [DocNavPage]s, which are in-place component reference snippets).
class ExampleEntry {
  const ExampleEntry({required this.title, required this.description, required this.builder, this.fixed});

  final String title;

  /// Shown on the gallery card, one sentence.
  final String description;

  final WidgetBuilder builder;

  /// Content that is `position: fixed` in the original (a `.fixed-top` or
  /// `.fixed-bottom` navbar): placed over the page's own scrolling, in the
  /// viewport. Return a `Positioned` (or anything a `Stack` takes).
  final WidgetBuilder? fixed;
}
