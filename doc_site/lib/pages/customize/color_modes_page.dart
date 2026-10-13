import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_content.dart';
import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

/// "Color modes": light, dark and automatic, for the app or for a subtree.
class ColorModesPage extends StatelessWidget {
  const ColorModesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Color modes',
      lead:
          'opa_bootstrap_ui supports a light mode (the default) and a dark '
          'mode, for the whole app or for any part of it, and can follow the '
          'setting of the system.',
      children: [
        const DocHeading('Dark mode'),
        DocText([
          'Bootstrap 5.3 turns dark mode on with the ',
          DocCode('data-bs-theme'),
          ' attribute, on the ',
          DocCode('<html>'),
          ' element for everything or on a component for just that part. '
              'Here the attribute is the ',
          DocCode('Brightness'),
          ' of a ',
          DocCode('BsTheme'),
          ': ',
          DocCode('BsApp'),
          ' installs one for the whole app, and you can nest another around '
              'any subtree. Every widget of the library reads it, so a '
              'single value switches the colors of the text, the '
              'backgrounds, the borders, the form controls and the '
              'components together.',
        ]),
        const DocHeading('Example', sub: true),
        DocText([
          'To change the color mode of a dropdown menu, wrap it in a ',
          DocCode('BsTheme'),
          '. Now, no matter the mode of the app, these two display with the '
              'brightness they are given. The menu is part of the dropdown, '
              'and takes the same one.',
        ]),
        DocExample(
          code: '''
Widget panel(Brightness brightness, String label) {
  return BsTheme(
    brightness: brightness,
    child: BsBox(
      p: BsSpacing.s3,
      bg: BsBg.body,
      textColor: BsTextColor.body,
      border: true,
      rounded: BsRounded.r2,
      child: BsDropdown(
        toggleBuilder: (context, toggle, isOpen) => BsButton(
          variant: BsVariant.secondary,
          onPressed: toggle,
          child: Text(label),
        ),
        items: [
          const BsDropdownItem(active: true, child: Text('Action')),
          const BsDropdownItem(child: Text('Another action')),
          const BsDropdownItem(child: Text('Something else here')),
          const BsDropdownDivider(),
          const BsDropdownItem(child: Text('Separated link')),
        ],
      ),
    ),
  );
}''',
          preview: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _panel(Brightness.light, 'Default dropdown'),
              _panel(Brightness.dark, 'Dark dropdown'),
            ],
          ),
        ),
        DocText([
          DocBold('The panel needs its own background and text color.'),
          ' A ',
          DocCode('BsTheme'),
          ' only says which colors the widgets of the library should use: '
              'it paints nothing, and the plain text of Flutter keeps the '
              'style it inherits from the app. The ',
          DocCode('BsBox'),
          ' with the body background and the body text color, as above, '
              'is what makes the subtree a page of its own. The widgets of '
              'the library, such as an alert or a button, do not need it.',
        ]),
        const DocHeading('How it works'),
        DocList([
          DocListItem([
            'The color mode is the ',
            DocCode('Brightness'),
            ' of the nearest ',
            DocCode('BsTheme'),
            ' above a widget, which ',
            DocCode('BsTheme.of(context)'),
            ' returns. With none, it is light. It is applied to everything '
                'below, unless another ',
            DocCode('BsTheme'),
            ' sets it for a smaller part.',
          ]),
          DocListItem([
            'Each value that differs between the modes comes in a pair: ',
            DocCode('BsBody.color'),
            ' and ',
            DocCode('BsBody.darkColor'),
            ', ',
            DocCode('BsBorders.color'),
            ' and ',
            DocCode('BsBorders.darkColor'),
            ', ',
            DocCode('BsVariant.bgSubtle'),
            ' and ',
            DocCode('BsVariant.darkBgSubtle'),
            ', and so on. The ',
            DocCode('Of(context)'),
            ' methods, such as ',
            DocCode('BsBody.colorOf(context)'),
            ', choose by the ambient mode.',
          ]),
          DocListItem([
            'The theme colors of ',
            DocCode('BsVariant.color'),
            ' do not change, as in Bootstrap. The subtle backgrounds, '
                'subtle borders and emphasis text of each do: in dark mode a '
                'subtle background is a heavy shade, so that it reads as a '
                'dark surface, and the emphasis text a tint.',
          ]),
          DocListItem([
            'There is no dark-mode stylesheet of images to maintain. The '
                'glyphs that Bootstrap embeds in its CSS, and recolors for '
                'dark mode, are painted here in the color of the text '
                'they are in.',
          ]),
        ]),
        const DocHeading('Usage'),
        const DocHeading('Enable dark mode', sub: true),
        DocText([
          'Turn the built-in dark mode on for the entire app with the ',
          DocCode('brightness'),
          ' of ',
          DocCode('BsApp'),
          '. The default is light. This applies to every component and '
              'element other than those inside a ',
          DocCode('BsTheme'),
          ' of their own.',
        ]),
        const DocCodeSnippet('''
BsApp(
  brightness: Brightness.dark,
  home: const MyHome(),
)'''),
        DocText([
          'Pass ',
          DocCode('null'),
          ' to follow the setting of the system, which is what Bootstrap\'s '
              'media query implementation does with ',
          DocCode('prefers-color-scheme'),
          '. The app switches as the system does, with no listener to '
              'write.',
        ]),
        const DocCodeSnippet('''
BsApp(
  brightness: null, // light or dark, as the system says
  home: const MyHome(),
)'''),
        DocText([
          'Bootstrap\'s attribute and its media query exclude each other, '
              'because the first lets the visitor choose and the second '
              'does not. A single value does both here: the state of your '
              'toggler is a ',
          DocCode('Brightness?'),
          ', where ',
          DocCode('null'),
          ' is automatic. Bootstrap\'s ',
          DocCode(r'$enable-dark-mode'),
          ' has no counterpart, since the mode costs nothing if you never '
              'leave light.',
        ]),
        const DocHeading('Choosing a mode', sub: true),
        DocText([
          'Bootstrap has no color mode picker, and neither does this '
              'package; the documentation navbar has a picker that you can '
              'borrow from. This one is built from ',
          DocCode('BsButtonGroup'),
          ' and keeps a ',
          DocCode('Brightness?'),
          '. The panel follows it, and, for automatic, the brightness of '
              'the platform.',
        ]),
        const DocExample(
          code: '''
class _MyAppState extends State<MyApp> {
  Brightness? _mode; // null follows the system

  @override
  Widget build(BuildContext context) {
    return BsApp(
      brightness: _mode,
      home: MyHome(onModeChanged: (mode) => setState(() => _mode = mode)),
    );
  }
}

// In the picker:
BsButtonGroup(
  children: [
    BsButton(
      variant: BsVariant.secondary,
      outline: true,
      active: mode == Brightness.light,
      onPressed: () => onModeChanged(Brightness.light),
      child: const Text('Light'),
    ),
    BsButton(
      variant: BsVariant.secondary,
      outline: true,
      active: mode == Brightness.dark,
      onPressed: () => onModeChanged(Brightness.dark),
      child: const Text('Dark'),
    ),
    BsButton(
      variant: BsVariant.secondary,
      outline: true,
      active: mode == null,
      onPressed: () => onModeChanged(null),
      child: const Text('Auto'),
    ),
  ],
)''',
          preview: _ModePicker(),
        ),
        DocText([
          'Keep the choice with a package such as ',
          DocLink.url(
            'shared_preferences',
            'https://pub.dev/packages/shared_preferences',
          ),
          ', and read it before ',
          DocCode('runApp'),
          ', so the first frame is already in the mode the visitor chose.',
        ]),
        const DocHeading('Your own colors'),
        DocText([
          'The colors you choose yourself, in a style or a decoration, do '
              'not follow the mode: they are the colors you wrote. Choose '
              'them from the ambient mode where you build the widget, '
              'with the same pairs the library uses.',
        ]),
        const DocCodeSnippet('''
final dark = BsTheme.of(context) == Brightness.dark;

Container(
  color: dark ? BsVariant.primary.darkBgSubtle : BsVariant.primary.bgSubtle,
  child: Text(
    'Primary subtle',
    style: TextStyle(
      color: dark
          ? BsVariant.primary.darkTextEmphasis
          : BsVariant.primary.textEmphasis,
    ),
  ),
)'''),
        const DocHeading('Custom color modes'),
        DocText([
          'Bootstrap\'s attribute takes any name, so that you can write a ',
          DocCode('blue'),
          ' theme beside light and dark. A ',
          DocCode('BsTheme'),
          ' holds a ',
          DocCode('Brightness'),
          ', and that has two values: the library has the two modes, and '
              'no third. A theme of your own is built on top of them, from '
              'the same pieces as everything here:',
        ]),
        DocList([
          DocListItem([
            'start from the light or the dark mode, whichever it is closer '
                'to, with a ',
            DocCode('BsTheme'),
            ';',
          ]),
          DocListItem([
            'give the widgets of the theme the colors it needs through their ',
            DocCode('Bs*Style'),
            ' objects, in a widget of your own so they live in one place;',
          ]),
          DocListItem([
            'paint its page with a ',
            DocCode('BsBox'),
            ' or a ',
            DocCode('ColoredBox'),
            ' in the color of the theme, and set the text color with a ',
            DocCode('DefaultTextStyle'),
            '.',
          ]),
        ]),
        const DocHeading('Adding theme colors'),
        DocText([
          'In Bootstrap a new theme color needs six more Sass entries '
              'before the alerts and the list groups know it: its text, '
              'subtle background and subtle border, each for light and for '
              'dark. They are manual, since Sass cannot make them from '
              'a map. In Dart they are a function. Wrap it up once, and '
              'the colors follow the mode:',
        ]),
        DocExample(
          code: '''
BsAlertStyle purpleAlert(BuildContext context) {
  final dark = BsTheme.of(context) == Brightness.dark;
  const purple = BsColors.purple;
  return BsAlertStyle(
    color: dark
        ? BsColorUtils.tint(purple, 0.4)
        : BsColorUtils.shade(purple, 0.6),
    background: dark
        ? BsColorUtils.shade(purple, 0.8)
        : BsColorUtils.tint(purple, 0.8),
    borderColor: dark
        ? BsColorUtils.shade(purple, 0.4)
        : BsColorUtils.tint(purple, 0.6),
  );
}''',
          preview: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _themed(Brightness.light, const _PurpleAlert()),
              _themed(Brightness.dark, const _PurpleAlert()),
            ],
          ),
        ),
        DocText([
          'Those are the formulas that ',
          DocCode('BsVariant'),
          ' uses for its own colors, so the result sits beside the '
              'others. The ',
          DocLink.page('Color', 'Customize', 'Color'),
          ' page has the rest of the scale, and the tokens they are built '
              'from.',
        ]),
      ],
    );
  }
}

Widget _themed(Brightness brightness, Widget child) {
  return BsTheme(
    brightness: brightness,
    child: BsBox(
      p: BsSpacing.s3,
      bg: BsBg.body,
      textColor: BsTextColor.body,
      border: true,
      rounded: BsRounded.r2,
      child: child,
    ),
  );
}

Widget _panel(Brightness brightness, String label) {
  return _themed(
    brightness,
    BsDropdown(
      toggleBuilder: (context, toggle, isOpen) => BsButton(
        variant: BsVariant.secondary,
        onPressed: toggle,
        child: Text(label),
      ),
      items: const [
        BsDropdownItem(active: true, child: Text('Action')),
        BsDropdownItem(child: Text('Another action')),
        BsDropdownItem(child: Text('Something else here')),
        BsDropdownDivider(),
        BsDropdownItem(child: Text('Separated link')),
      ],
    ),
  );
}

class _PurpleAlert extends StatelessWidget {
  const _PurpleAlert();

  @override
  Widget build(BuildContext context) {
    final dark = BsTheme.of(context) == Brightness.dark;
    const purple = BsColors.purple;
    return SizedBox(
      width: 260,
      child: BsAlert(
        variant: BsVariant.primary,
        style: BsAlertStyle(
          color: dark
              ? BsColorUtils.tint(purple, 0.4)
              : BsColorUtils.shade(purple, 0.6),
          background: dark
              ? BsColorUtils.shade(purple, 0.8)
              : BsColorUtils.tint(purple, 0.8),
          borderColor: dark
              ? BsColorUtils.shade(purple, 0.4)
              : BsColorUtils.tint(purple, 0.6),
          marginBottom: 0,
        ),
        child: Text(dark ? 'A purple alert, dark.' : 'A purple alert, light.'),
      ),
    );
  }
}

class _ModePicker extends StatefulWidget {
  const _ModePicker();

  @override
  State<_ModePicker> createState() => _ModePickerState();
}

class _ModePickerState extends State<_ModePicker> {
  Brightness? _mode = Brightness.light;

  BsButton _button(String label, Brightness? mode) {
    return BsButton(
      variant: BsVariant.secondary,
      outline: true,
      active: _mode == mode,
      onPressed: () => setState(() => _mode = mode),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = _mode ?? MediaQuery.platformBrightnessOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BsButtonGroup(
          children: [
            _button('Light', Brightness.light),
            _button('Dark', Brightness.dark),
            _button('Auto', null),
          ],
        ),
        const SizedBox(height: 16),
        _themed(
          brightness,
          Text(
            _mode == null
                ? 'Following the system: ${brightness.name}.'
                : 'Always ${brightness.name}.',
          ),
        ),
      ],
    );
  }
}
