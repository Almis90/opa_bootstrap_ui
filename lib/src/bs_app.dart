import 'package:flutter/widgets.dart';

import 'bs_colors.dart';
import 'bs_theme.dart';
import 'tokens/bs_body.dart';
import 'tokens/bs_typography.dart';

/// The top-level app widget for an `opa_bootstrap_ui`-only app — the
/// equivalent of `MaterialApp`/`CupertinoApp` for this package.
///
/// `MaterialApp` and `CupertinoApp` are both themed wrappers around
/// [WidgetsApp]; [BsApp] uses the same technique, so an app built on this
/// package never has to reference [WidgetsApp], Material, or Cupertino
/// directly. It fixes [WidgetsApp.pageRouteBuilder] to a plain
/// [PageRouteBuilder] (the boilerplate every hand-rolled `WidgetsApp` in this
/// repo repeated), installs a [BsTheme] from [brightness] so every `Bs*`
/// widget beneath it can resolve dark-mode colors, and defaults [color] and
/// [textStyle] to [BsColors.blue]/[BsBody] + [BsTypography] (both
/// overridable, and both brightness-aware unless [textStyle] is set).
///
/// Only wraps [WidgetsApp]'s `Navigator`-based constructor — there's no
/// `BsApp.router` equivalent to `MaterialApp.router` yet, since nothing in
/// this package needs `Router`-based navigation.
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
  /// [BsTypography.fontSizeBase]/[BsTypography.fontWeightBase]. Set this to
  /// opt out of the brightness-aware default.
  final TextStyle? textStyle;

  /// Defaults to [BsColors.blue]. Only affects the OS task-switcher entry —
  /// this package has no `ThemeData`-style primary color to derive from.
  final Color? color;

  /// Bootstrap's `data-bs-theme`: `Brightness.light` (the default) or
  /// `Brightness.dark`. Installed as a [BsTheme] ancestor, so every `Bs*`
  /// widget beneath [home] resolves its dark-mode colors from this.
  final Brightness brightness;

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

  static TextStyle _defaultTextStyle(BuildContext context) {
    return TextStyle(
      color: BsBody.colorOf(context),
      fontFamily: BsTypography.fontFamilySansSerif.first,
      fontFamilyFallback: BsTypography.fontFamilySansSerif.skip(1).toList(),
      fontSize: BsTypography.fontSizeBase,
      fontWeight: BsTypography.fontWeightBase,
    );
  }

  @override
  Widget build(BuildContext context) {
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
        pageBuilder: (context, animation, secondaryAnimation) => pageBuilder(context),
      ),
      builder: (context, child) => BsTheme(
        brightness: brightness,
        child: Builder(
          builder: (context) {
            final styled = DefaultTextStyle(
              style: textStyle ?? _defaultTextStyle(context),
              child: child!,
            );
            return builder == null ? styled : builder!(context, styled);
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
