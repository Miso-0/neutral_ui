import 'package:flutter/widgets.dart';

import 'theme_data.dart';

/// Supplies component tokens to a subtree and to captured routes or overlays.
class PureTheme extends InheritedTheme {
  /// Creates a theme for [child].
  const PureTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final ThemeData data;

  /// Returns the nearest theme, or an empty theme when no ancestor exists.
  static ThemeData of(BuildContext context) {
    return maybeOf(context) ?? const ThemeData();
  }

  /// Returns the nearest theme, if present.
  static ThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PureTheme>()?.data;
  }

  /// Adds [data] while inheriting its unset tokens from the enclosing theme.
  static Widget merge({
    Key? key,
    required ThemeData data,
    required Widget child,
  }) {
    return Builder(
      key: key,
      builder: (BuildContext context) {
        return PureTheme(data: data.merge(of(context)), child: child);
      },
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return PureTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(PureTheme oldWidget) => data != oldWidget.data;
}
