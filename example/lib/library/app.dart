import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

import 'catalog.dart';
import 'chrome_theme.dart';
import 'shell.dart';

/// A browsable library whose examples carry their own visual styles.
class LibraryApp extends StatefulWidget {
  /// Creates the library, optionally starting at a named category route.
  const LibraryApp({super.key, this.initialRoute});

  /// The initial category path, such as `/pickers`.
  final String? initialRoute;

  @override
  State<LibraryApp> createState() => _LibraryAppState();
}

class _LibraryAppState extends State<LibraryApp> {
  bool _rtl = false;
  bool _reducedMotion = false;

  Route<void> _route(RouteSettings settings) {
    final String id = (settings.name ?? '/').replaceFirst('/', '');
    final ComponentCategory? category = categoryById(id);
    return PageRouteBuilder<void>(
      settings: category == null ? const RouteSettings(name: '/') : settings,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      pageBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) => ScaffoldMessenger(
            child: NeutralTheme(
              data: chromeTheme(),
              child: LibraryShell(category: category),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) => NeutralApp(
    color: canvas,
    title: 'NeutralUI Components',
    debugShowCheckedModeBanner: false,
    theme: const ThemeData(),
    textStyle: const TextStyle(color: ink, fontSize: 14, height: 1.4),
    initialRoute: widget.initialRoute,
    onGenerateRoute: _route,
    builder: (BuildContext context, Widget? child) => LibraryPreferences(
      rtl: _rtl,
      reducedMotion: _reducedMotion,
      onRtlChanged: (bool value) => setState(() => _rtl = value),
      onReducedMotionChanged: (bool value) =>
          setState(() => _reducedMotion = value),
      child: Directionality(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(disableAnimations: _reducedMotion),
          child: child!,
        ),
      ),
    ),
  );
}
