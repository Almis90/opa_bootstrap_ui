import 'package:flutter/widgets.dart';

/// Lets a docs page link to another: a page of the sidebar by its group and
/// title, or the examples.
class DocNavigation extends InheritedWidget {
  const DocNavigation({
    super.key,
    required this.openPage,
    required this.openExamples,
    required super.child,
  });

  /// Opens the page [title] of the sidebar group [group].
  final void Function(String group, String title) openPage;

  /// Opens the examples gallery.
  final VoidCallback openExamples;

  static DocNavigation? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DocNavigation>();

  @override
  bool updateShouldNotify(DocNavigation oldWidget) => false;
}
