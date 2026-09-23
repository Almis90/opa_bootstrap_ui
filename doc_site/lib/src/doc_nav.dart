import 'package:flutter/widgets.dart';

/// One entry in the sidebar: a page title and the widget that renders it.
///
/// Mirrors a single link under a group in Bootstrap's docs sidebar
/// (`site/data/sidebar.yml` + `DocsSidebar.astro`).
class DocNavPage {
  const DocNavPage(this.title, this.builder);

  final String title;
  final WidgetBuilder builder;
}

/// A titled group of [DocNavPage]s, e.g. "Components" or "Forms".
///
/// Mirrors a `group` entry in Bootstrap's `sidebar.yml`.
class DocNavSection {
  const DocNavSection(this.title, this.pages);

  final String title;
  final List<DocNavPage> pages;
}
