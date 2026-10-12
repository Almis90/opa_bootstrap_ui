import 'package:flutter/widgets.dart';

import 'bs_colors.dart';
import 'bs_theme.dart';
import 'tokens/bs_body.dart';
import 'tokens/bs_typography.dart';

/// The top-level app widget for an app built only on `opa_bootstrap_ui`.
///
/// [BsApp] wraps [WidgetsApp], so an app built on this package never has to reference
/// [WidgetsApp] or another design system's app widget directly. It fixes
/// [WidgetsApp.pageRouteBuilder] to a plain [PageRouteBuilder], installs a [BsTheme] from
/// [brightness] so that every `Bs*` widget beneath it can resolve dark-mode colors, and
/// defaults [color] and [textStyle] to [BsColors.blue] and [BsBody] plus [BsTypography] (both
/// overridable, and both brightness-aware unless [textStyle] is set).
///
/// Only wraps [WidgetsApp]'s `Navigator`-based constructor: there is no router-based variant,
/// since nothing in this package needs `Router`-based navigation.
class BsApp extends StatelessWidget {
  const BsApp({
    super.key,
    this.navigatorKey,
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.builder,
    this.title,
    this.onGenerateTitle,
    this.textStyle,
    this.extraFontFamilyFallback = const [],
    this.color,
    this.brightness = Brightness.light,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowWidgetInspector = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
  });

  final GlobalKey<NavigatorState>? navigatorKey;
  final Widget? home;
  final Map<String, WidgetBuilder> routes;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  final InitialRouteListFactory? onGenerateInitialRoutes;
  final RouteFactory? onUnknownRoute;
  final List<NavigatorObserver> navigatorObservers;
  final TransitionBuilder? builder;
  final String? title;
  final GenerateAppTitle? onGenerateTitle;

  /// Defaults to [BsBody.colorOf] (light or dark depending on [brightness])
  /// on [BsTypography.fontFamilySansSerif] at
  /// [BsTypography.fontSizeBase]/[BsTypography.fontWeightBase] with
  /// [BsTypography.lineHeightBase] (`body`'s `line-height`). Set this to
  /// opt out of the brightness-aware default.
  final TextStyle? textStyle;

  /// Font families tried after [BsTypography.fontFamilySansSerif] for glyphs
  /// none of them has — typically a bundled font for a script the stack lacks
  /// (Arabic, say), so the engine need not download one on first use.
  /// Ignored when [textStyle] is set.
  final List<String> extraFontFamilyFallback;

  /// Defaults to [BsColors.blue]. Only affects the OS task-switcher entry —
  /// this package has no `ThemeData`-style primary color to derive from.
  final Color? color;

  /// The app's theme: [Brightness.light] (the default) or [Brightness.dark]. Pass null to follow
  /// the operating system's setting ([MediaQueryData.platformBrightness]) instead of a fixed
  /// value, switching live if the user changes it while the app keeps running. Installed as a
  /// [BsTheme] ancestor, so every `Bs*` widget beneath [home] resolves its dark-mode colors from
  /// this.
  final Brightness? brightness;

  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool showPerformanceOverlay;
  final bool showSemanticsDebugger;
  final bool debugShowWidgetInspector;
  final bool debugShowCheckedModeBanner;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;
  final String? restorationScopeId;

  TextStyle _defaultTextStyle(BuildContext context) {
    return TextStyle(
      color: BsBody.colorOf(context),
      fontFamily: BsTypography.fontFamilySansSerif.first,
      fontFamilyFallback: [
        ...BsTypography.fontFamilySansSerif.skip(1),
        ...extraFontFamilyFallback,
      ],
      fontSize: BsTypography.fontSizeBase,
      fontWeight: BsTypography.fontWeightBase,
      // The base line height, inherited by every widget that does not set its own.
      height: BsTypography.lineHeightBase,
      // Half-leading goes above and below the glyphs equally, as on the web; Flutter's default
      // splits it in proportion to ascent and descent, which sits text about a pixel high in a
      // 1.5 line box.
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolvedBrightness =
        brightness ?? MediaQuery.platformBrightnessOf(context);
    return WidgetsApp(
      navigatorKey: navigatorKey,
      home: home,
      routes: routes,
      initialRoute: initialRoute,
      onGenerateRoute: onGenerateRoute,
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      onUnknownRoute: onUnknownRoute,
      navigatorObservers: navigatorObservers,
      pageRouteBuilder: <T>(settings, pageBuilder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            pageBuilder(context),
      ),
      builder: (context, child) => BsTheme(
        brightness: resolvedBrightness,
        child: Builder(
          builder: (context) {
            final styled = DefaultTextStyle(
              style: textStyle ?? _defaultTextStyle(context),
              child: child!,
            );
            final blurring = _BsBlurOnPointerOutside(child: styled);
            return builder == null ? blurring : builder!(context, blurring);
          },
        ),
      ),
      title: title,
      onGenerateTitle: onGenerateTitle,
      color: color ?? BsColors.blue,
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      localeListResolutionCallback: localeListResolutionCallback,
      localeResolutionCallback: localeResolutionCallback,
      supportedLocales: supportedLocales,
      showPerformanceOverlay: showPerformanceOverlay,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowWidgetInspector: debugShowWidgetInspector,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      shortcuts: shortcuts,
      actions: actions,
      restorationScopeId: restorationScopeId,
    );
  }
}

/// A web browser takes focus off a control when something else is pressed; Flutter leaves it
/// where it is. A pointer pressed outside the focused control's box unfocuses it (and so its
/// focus ring), and a control that was pressed takes the focus itself as it handles the tap.
class _BsBlurOnPointerOutside extends StatelessWidget {
  const _BsBlurOnPointerOutside({required this.child});

  final Widget child;

  static void _onPointerDown(PointerDownEvent event) {
    final node = FocusManager.instance.primaryFocus;
    if (node == null || node is FocusScopeNode) return;
    final box = node.context?.findRenderObject();
    if (box is RenderBox && box.attached && box.hasSize) {
      if ((Offset.zero & box.size).contains(box.globalToLocal(event.position))) return;
    }
    node.unfocus();
  }

  @override
  Widget build(BuildContext context) => Listener(
    behavior: HitTestBehavior.translucent,
    onPointerDown: _onPointerDown,
    child: child,
  );
}
