import 'package:flutter/widgets.dart';

import '../../src/doc_content.dart';
import '../../src/doc_page.dart';

/// "Interactivity": configuring widgets, callbacks, state, controllers,
/// animations and the lifecycle of what a widget owns.
class InteractivityPage extends StatelessWidget {
  const InteractivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DocPage(
      leadGap: 0,
      title: 'Interactivity',
      lead:
          'Components are widgets: you configure them with constructor '
          'parameters, react to them with callbacks, and drive them from code '
          'with controllers.',
      children: [
        DocHeading('Dart imports'),
        DocText([
          'One import gives access to every widget, controller, style and '
              'utility:',
        ]),
        DocCodeSnippet(
          "import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';",
        ),
        DocText([
          'To keep the names it brings in under control, import only what you '
              'use, or give the library a prefix:',
        ]),
        DocCodeSnippet('''
// Only what you use:
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart' show BsButton, BsCard;

// Or everything, under a prefix:
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart' as bs;'''),
        DocHeading('Dependencies'),
        DocText([
          'opa_bootstrap_ui depends on the Flutter SDK and on no other '
              'package. A few widgets need something that only your app can '
              'provide: ',
          DocCode('BsFormFile'),
          ' draws the file input but your app opens the file picker, and a '
              'bundled font is needed for scripts the default font stack does '
              'not cover.',
        ]),
        DocHeading('Widget configuration'),
        DocText([
          'There are no attributes to set on an element: a widget is '
              'configured through the parameters of its constructor, named '
              'after Bootstrap\'s own options and checked by the compiler.',
        ]),
        DocCodeSnippet('''
BsButton(
  variant: BsVariant.primary,
  size: BsSize.lg,
  outline: true,
  onPressed: () {},
  child: const Text('Save'),
)'''),
        DocHeading('Default settings'),
        DocText([
          'Every component takes a ',
          DocCode('style'),
          ' parameter, an object of that component\'s visual values, such as ',
          DocCode('BsButtonStyle'),
          '. Whatever you set replaces the default, and the rest is kept, in '
              'light and in dark mode.',
        ]),
        DocCodeSnippet('''
BsButton(
  onPressed: () {},
  style: const BsButtonStyle(
    background: Color(0xFF712CF9),
    borderColor: Color(0xFF712CF9),
  ),
  child: const Text('Violet'),
)'''),
        DocText([
          'There is no app-wide registry of component styles: to restyle a '
              'component everywhere, wrap it in a small widget of your own '
              'that passes the style. The light and dark theme is set once, '
              'with ',
          DocCode('BsApp'),
          ' or a ',
          DocCode('BsTheme'),
          '.',
        ]),
        DocHeading('Callbacks and events'),
        DocText([
          'Widgets report what happens with callbacks, which are ordinary '
              'parameters:',
        ]),
        DocTable(
          headers: ['Callback', 'Where', 'Called'],
          rows: [
            [
              'onPressed, onTap',
              'Buttons, nav items, list items, dropdown items',
              'When tapped',
            ],
            [
              'onChanged',
              'Form controls, select, checks, range',
              'When the value changes',
            ],
            [
              'onShow, onShown, onHide, onHidden',
              'Collapse, dropdown, popover, tooltip, navbar, modal, offcanvas, '
                  'toast, tab view',
              'As it starts to open or close, and when it has finished',
            ],
            [
              'onSlide, onSlid',
              'Carousel',
              'As a slide change starts, and when it has finished',
            ],
            [
              'onClose, onDismissed',
              'Alert',
              'When the close begins, and when it has finished',
            ],
            [
              'onExpansionChanged, onExpansionEnd',
              'Accordion',
              'As an item starts to expand or collapse, and when it has finished',
            ],
            ['onActivate', 'Scrollspy', 'When the active section changes'],
          ],
        ),
        DocCodeSnippet('''
BsCollapse(
  isExpanded: _open,
  onShown: () => debugPrint('opened'),
  child: const Text('Details'),
)'''),
        DocHeading('State management'),
        DocText([
          'A component keeps its state in one of two ways, and many support '
              'both.',
        ]),
        DocList([
          DocListItem([
            DocBold('Controlled.'),
            ' You hold the state and pass it in, with a callback to change '
                'it. Form controls work like this: ',
            DocCode('BsFormCheck'),
            ', ',
            DocCode('BsFormRange'),
            ' and ',
            DocCode('BsFormSelect'),
            ' take a ',
            DocCode('value'),
            ' and an ',
            DocCode('onChanged'),
            '. A control with no ',
            DocCode('onChanged'),
            ' is disabled.',
          ]),
          DocListItem([
            DocBold('Uncontrolled.'),
            ' The widget keeps the state itself and starts from an initial '
                'value, such as ',
            DocCode('initiallyExpanded'),
            ' on an accordion or ',
            DocCode('initialIndex'),
            ' on a carousel.',
          ]),
          DocListItem([
            DocBold('Either, with a controller.'),
            ' ',
            DocCode('BsCollapse'),
            ' and ',
            DocCode('BsTabView'),
            ' follow a value you pass in, or a controller you call.',
          ]),
        ]),
        DocCodeSnippet('''
BsFormCheck(
  value: _remember,
  onChanged: (value) => setState(() => _remember = value),
  label: const Text('Remember me'),
)'''),
        DocHeading('Controllers'),
        DocText([
          'A controller drives a component from code, and tells you its '
              'state. Create it, pass it as ',
          DocCode('controller'),
          ', and call its methods from anywhere.',
        ]),
        DocTable(
          headers: ['Controller', 'Controls', 'Members'],
          rows: [
            [
              'BsAccordionController',
              'Accordion',
              'expand, collapse, toggle, collapseAll, isExpanded',
            ],
            ['BsAlertController', 'Alert', 'close, isClosed'],
            [
              'BsCarouselController',
              'Carousel',
              'next, previous, goTo, pause, cycle, index',
            ],
            [
              'BsCollapseController',
              'Collapse and the navbar menu',
              'expand, collapse, toggle, isExpanded',
            ],
            [
              'BsDropdownController',
              'Dropdown',
              'show, hide, toggle, enable, disable, setItems, setDirection',
            ],
            [
              'BsPopoverController, BsTooltipController',
              'Popover and tooltip',
              'show, hide, toggle, enable, disable, setContent, setPlacement',
            ],
            [
              'BsModalController, BsOffcanvasController',
              'Modal and offcanvas',
              'show, hide, enable, disable, isShown',
            ],
            ['BsToastController', 'A toast', 'hide, isShown'],
            ['BsTabController', 'Tab view', 'show, index'],
            [
              'BsScrollspyController',
              'Scrollspy',
              'scrollToSection, refresh, activeIndex',
            ],
          ],
        ),
        DocCodeSnippet('''
final controller = BsCollapseController();

BsButton(onPressed: controller.toggle, child: const Text('Toggle'));
BsCollapse(controller: controller, child: const Text('Details'));'''),
        DocHeading('Animations and transitions'),
        DocText([
          'Components that open, close or change animate with Flutter\'s '
              'animations. ',
          DocCode('BsCollapse'),
          ' and ',
          DocCode('BsTabView'),
          ' take a ',
          DocCode('duration'),
          ', and a ',
          DocCode('curve'),
          ' where it applies. Every transition honors the system\'s '
              'reduced-motion setting.',
        ]),
        DocText([
          'The callbacks ending in ',
          DocCode('Shown'),
          ' and ',
          DocCode('Hidden'),
          ' are called when the animation completes. If another change '
              'interrupts it, they are not called for the one that never '
              'finished. A component with no animation, such as a dropdown '
              'or a popover, calls ',
          DocCode('onShown'),
          ' right after ',
          DocCode('onShow'),
          '.',
        ]),
        DocHeading('Widget lifecycle'),
        DocText([
          'A stateful component sets itself up when it enters the tree, '
              'follows the parameters you change on rebuild, and releases what '
              'it created when it leaves. Changing ',
          DocCode('isExpanded'),
          ' on a rebuild animates the change, and a component that is given '
              'a controller listens to it for as long as it stays in the tree.',
        ]),
        DocHeading('Resource disposal'),
        DocText([
          'A widget disposes what it created itself, and nothing else. The '
              'controller, focus node or text controller that you create is '
              'yours to dispose, in the ',
          DocCode('dispose'),
          ' method of your ',
          DocCode('State'),
          '. A controller returned by ',
          DocCode('showBsToast'),
          ' is yours as well.',
        ]),
        DocCodeSnippet('''
class _PageState extends State<Page> {
  final _controller = BsCollapseController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}'''),
        DocHeading('Widget API reference'),
        DocText([
          'Every public class, parameter, method and callback has a doc '
              'comment, which your editor shows as you type or hover, and the '
              'pages of each component in this documentation show it at work. '
              'The conventions are the same throughout:',
        ]),
        DocList([
          DocListItem([
            'Parameters carry the names of Bootstrap\'s options, such as ',
            DocCode('variant'),
            ', ',
            DocCode('outline'),
            ' and ',
            DocCode('size'),
            '.',
          ]),
          DocListItem([
            'Appearance is overridden with the ',
            DocCode('style'),
            ' parameter, and a component\'s state with ',
            DocCode('controller'),
            '.',
          ]),
          DocListItem([
            'Callbacks start with ',
            DocCode('on'),
            ', and are called with the new value where there is one.',
          ]),
        ]),
      ],
    );
  }
}
