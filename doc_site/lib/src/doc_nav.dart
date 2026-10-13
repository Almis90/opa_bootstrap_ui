import 'package:flutter/widgets.dart';

import 'bootstrap_icon.dart';
import 'doc_page.dart';

/// One entry in the sidebar: a page title and the widget that renders it.
class DocNavPage {
  const DocNavPage(this.title, this.builder) : planned = false;

  /// A page that is listed but not written yet: it opens a short notice.
  DocNavPage.planned(this.title)
    : builder = ((_) => DocPage(
        title: title,
        lead:
            'This page of Bootstrap\'s documentation has not been written for '
            'opa_bootstrap_ui yet.',
      )),
      planned = true;

  final String title;
  final WidgetBuilder builder;

  /// Whether the page is a placeholder (kept out of the search results).
  final bool planned;
}

/// A titled group of [DocNavPage]s, for example "Components" or "Forms", with
/// the [icon] shown before its title.
///
/// A group with no pages of its own is a single link: see [DocNavSection.link].
class DocNavSection {
  const DocNavSection(this.title, this.pages, {this.icon, this.iconColor})
    : link = null;

  /// A link that stands on its own below the groups, set apart by a rule.
  DocNavSection.link(DocNavPage page)
    : title = page.title,
      pages = const [],
      icon = null,
      iconColor = null,
      link = page;

  final String title;
  final List<DocNavPage> pages;
  final BootstrapIconData? icon;
  final Color? iconColor;

  /// The page of a stand-alone link, null for a group.
  final DocNavPage? link;

  /// Every page of the section.
  Iterable<DocNavPage> get allPages => link == null ? pages : [link!];
}
