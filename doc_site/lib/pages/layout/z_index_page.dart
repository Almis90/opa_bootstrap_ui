import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_content.dart';
import '../../src/doc_page.dart';

/// "Z-index": the order in which components stack, with no `z-index`.
class ZIndexPage extends StatelessWidget {
  const ZIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Z-index',
      lead:
          'While not a part of the grid system, the stacking order plays an '
          'important part in how components overlay and interact with one '
          'another.',
      children: [
        DocText([
          'Several Bootstrap components use ',
          DocCode('z-index'),
          ', the CSS property that gives layout a third axis to arrange '
              'content on, with a scale designed to layer navigation, '
              'tooltips and popovers, modals and more. Flutter has no such '
              'property. A widget is painted over the ones before it, so the '
              'order in which things stack is the order in which they are '
              'built, and what is shown over the page lives in an ',
          DocCode('Overlay'),
          '. That is what the library relies on, and the sections below '
              'describe how.',
        ]),
        const DocHeading('Paint order'),
        DocText([
          'Within a layout, a widget is painted after its previous siblings, '
              'and so it covers them where they overlap. In a ',
          DocCode('Stack'),
          ' the last child is the one on top, and moving a child later in '
              'the list is what ',
          DocCode('z-index'),
          ' would do. Rows, columns and the grid paint in the order of '
              'their children too.',
        ]),
        const DocCodeSnippet('''
Stack(
  children: [
    // At the back.
    Positioned.fill(child: ColoredBox(color: Color(0xFF212529))),
    // Over the box.
    Positioned(
      bottom: 16,
      child: BsBadge(variant: BsVariant.danger, child: Text('New')),
    ),
  ],
)'''),
        DocText([
          'This is also how the overlapping borders are handled. Where '
              'Bootstrap gives the buttons of a group a ',
          DocCode('z-index'),
          ' of 1, 2 and 3 for the default, hover and active states, here '
              'the group shifts each button by the width of a border, so '
              'that the seam between two of them is a single line, and the '
              'later button is painted over the earlier one.',
        ]),
        const DocHeading('Layers'),
        DocText([
          'Whatever floats over the page is painted in an ',
          DocCode('Overlay'),
          ', which the ',
          DocCode('Navigator'),
          ' of ',
          DocCode('BsApp'),
          ' provides. The table follows Bootstrap\'s scale, from the lowest '
              'layer to the highest, and says where each one is in Flutter.',
        ]),
        DocTable(
          headers: ['Layer', 'Bootstrap', 'BsZIndex', 'In Flutter'],
          rows: [
            [
              'Dropdown',
              '1000',
              BsZIndex.dropdown.toString(),
              'The menu of a BsDropdown, in an OverlayPortal.',
            ],
            [
              'Sticky',
              '1020',
              BsZIndex.sticky.toString(),
              'No widget of the library. A sticky header is yours to build, '
                  'with a Stack or a sliver.',
            ],
            [
              'Fixed',
              '1030',
              BsZIndex.fixed.toString(),
              'No widget of the library: a fixed bar is a child of the Stack '
                  'that holds the page, painted after it.',
            ],
            [
              'Offcanvas backdrop',
              '1040',
              BsZIndex.offcanvasBackdrop.toString(),
              'The barrier of the route that showBsOffcanvas pushes.',
            ],
            [
              'Offcanvas',
              '1045',
              BsZIndex.offcanvas.toString(),
              'The route that showBsOffcanvas pushes.',
            ],
            [
              'Modal backdrop',
              '1050',
              BsZIndex.modalBackdrop.toString(),
              'The barrier of the route that showBsModal pushes.',
            ],
            [
              'Modal',
              '1055',
              BsZIndex.modal.toString(),
              'The route that showBsModal pushes.',
            ],
            [
              'Popover',
              '1070',
              BsZIndex.popover.toString(),
              'The popup of a BsPopover, in an OverlayPortal.',
            ],
            [
              'Tooltip',
              '1080',
              BsZIndex.tooltip.toString(),
              'The tip of a BsTooltip, in an OverlayPortal.',
            ],
            [
              'Toast',
              '1090',
              BsZIndex.toast.toString(),
              'An OverlayEntry that showBsToast inserts into the Overlay.',
            ],
          ],
        ),
        const DocHeading('How they stack', sub: true),
        DocList([
          DocListItem([
            DocBold('Modals and offcanvas panels are routes.'),
            ' ',
            DocCode('showBsModal'),
            ' and ',
            DocCode('showBsOffcanvas'),
            ' push a route, as ',
            DocCode('showDialog'),
            ' does, so one opened later is over the one before it, and over '
                'the page, and ',
            DocCode('Navigator.pop'),
            ' takes it away. The barrier of the route is the backdrop.',
          ]),
          DocListItem([
            DocBold(
              'Dropdowns, tooltips and popovers are in the route '
              'that holds them.',
            ),
            ' Flutter paints the popup of an ',
            DocCode('OverlayPortal'),
            ' after the route of its anchor and before the next one. So a '
                'tooltip or a dropdown inside a modal is over the modal, '
                'and one on the page is under a modal opened over it. '
                'Within one route, the one that was shown last is on top.',
          ]),
          DocListItem([
            DocBold('Toasts are in the topmost layer.'),
            ' A toast is over a modal or an offcanvas panel, whether it was '
                'shown before or after, as it is in Bootstrap.',
          ]),
        ]),
        const DocHeading('BsZIndex'),
        DocText([
          'The constants of ',
          DocCode('BsZIndex'),
          ' are Bootstrap\'s ',
          DocCode(r'$zindex-*'),
          ' variables, as numbers, and the library does not read them: its '
              'widgets stack as above. They are there as the vocabulary of '
              'the scale, so that a layer of your own can be ranked against '
              'the components, such as a custom sticky header that you want '
              'under the modals.',
        ]),
        const DocCodeSnippet('''
final layers = [
  (z: BsZIndex.sticky, child: stickyHeader),
  (z: 0, child: page),
  (z: BsZIndex.fixed, child: floatingButton),
]..sort((a, b) => a.z.compareTo(b.z));

Stack(children: [for (final layer in layers) layer.child])'''),
        DocText([
          'Bootstrap does not encourage customizing these values, and so '
              'they are constants that cannot be reassigned. Should one '
              'ever need to change, they would all need to.',
        ]),
      ],
    );
  }
}
