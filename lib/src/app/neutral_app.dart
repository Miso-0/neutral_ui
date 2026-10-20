import 'package:flutter/widgets.dart';

import '../localizations/neutral_localizations.dart';
import '../theme/neutral_theme.dart';
import '../theme/theme_data.dart';

/// A widgets-layer application with NeutralUI themes, strings and navigation.
class NeutralApp extends StatefulWidget {
  /// Creates an application with a Navigator and widgets-layer page routes.
  const NeutralApp({
    super.key,
    required this.color,
    this.theme = const ThemeData(),
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.initialRoute,
    this.navigatorKey,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.builder,
    this.title = '',
    this.textStyle,
    this.locale,
    this.localizationsDelegates = const <LocalizationsDelegate<dynamic>>[],
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.localeResolutionCallback,
    this.localeListResolutionCallback,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.debugShowCheckedModeBanner = true,
  }) : _contentBuilder = null;

  /// Creates a navigator-free application with an Overlay around its content.
  const NeutralApp.builder({
    super.key,
    required this.color,
    required WidgetBuilder builder,
    this.theme = const ThemeData(),
    this.title = '',
    this.textStyle,
    this.locale,
    this.localizationsDelegates = const <LocalizationsDelegate<dynamic>>[],
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.localeResolutionCallback,
    this.localeListResolutionCallback,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.debugShowCheckedModeBanner = true,
  }) : _contentBuilder = builder,
       builder = null,
       home = null,
       routes = const <String, WidgetBuilder>{},
       onGenerateRoute = null,
       onUnknownRoute = null,
       initialRoute = null,
       navigatorKey = null,
       navigatorObservers = const <NavigatorObserver>[];

  /// The operating system's application color, as required by WidgetsApp.
  final Color color;

  /// The component tokens supplied to all routes and overlays.
  final ThemeData theme;

  /// The default route's contents.
  final Widget? home;

  /// The named route builders.
  final Map<String, WidgetBuilder> routes;

  /// Generates routes not found in [routes].
  final RouteFactory? onGenerateRoute;

  /// Handles routes that [onGenerateRoute] could not create.
  final RouteFactory? onUnknownRoute;

  /// The first named route to display.
  final String? initialRoute;

  /// A key for accessing the application's Navigator.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Observers attached to the application's Navigator.
  final List<NavigatorObserver> navigatorObservers;

  /// Wraps the Navigator in application-specific widgets below NeutralTheme.
  final TransitionBuilder? builder;

  final WidgetBuilder? _contentBuilder;

  /// The application's operating-system title.
  final String title;

  /// The default text style for the application.
  final TextStyle? textStyle;

  /// An explicitly selected application locale.
  final Locale? locale;

  /// Custom localization delegates, which take precedence over the defaults.
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;

  /// The locales the application supports.
  final Iterable<Locale> supportedLocales;

  /// Resolves one preferred locale.
  final LocaleResolutionCallback? localeResolutionCallback;

  /// Resolves the platform's preferred locale list.
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// Application keyboard shortcuts.
  final Map<ShortcutActivator, Intent>? shortcuts;

  /// Application actions for keyboard intents.
  final Map<Type, Action<Intent>>? actions;

  /// The application restoration scope identifier.
  final String? restorationScopeId;

  /// Whether to show Flutter's debug mode banner.
  final bool debugShowCheckedModeBanner;

  @override
  State<NeutralApp> createState() => _NeutralAppState();
}

class _NeutralAppState extends State<NeutralApp> {
  final HeroController _heroController = HeroController();

  @override
  Widget build(BuildContext context) => HeroControllerScope(
    controller: _heroController,
    child: WidgetsApp(
      color: widget.color,
      home: widget.home,
      routes: widget.routes,
      onGenerateRoute: widget.onGenerateRoute,
      onUnknownRoute: widget.onUnknownRoute,
      initialRoute: widget.initialRoute,
      navigatorKey: widget.navigatorKey,
      navigatorObservers: widget.navigatorObservers,
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
          PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) => builder(context),
          ),
      builder: (BuildContext context, Widget? child) => NeutralTheme(
        data: widget.theme,
        child: Builder(
          builder: (BuildContext context) => widget._contentBuilder != null
              ? _AppOverlay(builder: widget._contentBuilder!)
              : widget.builder?.call(context, child) ?? child!,
        ),
      ),
      title: widget.title,
      textStyle: widget.textStyle,
      locale: widget.locale,
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        ...widget.localizationsDelegates,
        NeutralLocalizations.delegate,
      ],
      supportedLocales: widget.supportedLocales,
      localeResolutionCallback: widget.localeResolutionCallback,
      localeListResolutionCallback: widget.localeListResolutionCallback,
      shortcuts: widget.shortcuts,
      actions: widget.actions,
      restorationScopeId: widget.restorationScopeId,
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
    ),
  );

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }
}

class _AppOverlay extends StatefulWidget {
  const _AppOverlay({required this.builder});

  final WidgetBuilder builder;

  @override
  State<_AppOverlay> createState() => _AppOverlayState();
}

class _AppOverlayState extends State<_AppOverlay> {
  late final OverlayEntry _entry = OverlayEntry(
    builder: (BuildContext context) => widget.builder(context),
  );

  @override
  void didUpdateWidget(_AppOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _entry.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) =>
      Overlay(initialEntries: <OverlayEntry>[_entry]);

  @override
  void dispose() {
    _entry.remove();
    _entry.dispose();
    super.dispose();
  }
}
