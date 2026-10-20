import 'package:flutter/widgets.dart';

import '../styles/tab_bar_style.dart';
import '../styles/navigation_style.dart';
import '../styles/expansion_tile_style.dart';
import '../styles/progress_indicator_style.dart';
import '../styles/badge_style.dart';
import 'neutral_theme.dart';

/// Overrides tabBar tokens within a subtree.
class TabBarTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const TabBarTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final TabBarStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static TabBarStyle of(BuildContext context) =>
      maybeOf(context) ?? NeutralTheme.of(context).tabBarStyle;

  /// Returns local tokens when this component theme is present.
  static TabBarStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TabBarTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required TabBarStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        TabBarTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      TabBarTheme(data: data, child: child);

  @override
  bool updateShouldNotify(TabBarTheme oldWidget) => data != oldWidget.data;
}

/// Overrides navigation tokens within a subtree.
class NavigationTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const NavigationTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final NavigationStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static NavigationStyle of(BuildContext context) =>
      maybeOf(context) ?? NeutralTheme.of(context).navigationStyle;

  /// Returns local tokens when this component theme is present.
  static NavigationStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NavigationTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required NavigationStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        NavigationTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      NavigationTheme(data: data, child: child);

  @override
  bool updateShouldNotify(NavigationTheme oldWidget) => data != oldWidget.data;
}

/// Overrides navigation tokens within a subtree.
class NavigationBarTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const NavigationBarTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The component tokens inherited by this subtree.
  final NavigationStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static NavigationStyle of(BuildContext context) =>
      maybeOf(context) ?? NavigationTheme.of(context);

  /// Returns local tokens when this component theme is present.
  static NavigationStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NavigationBarTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required NavigationStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        NavigationBarTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      NavigationBarTheme(data: data, child: child);

  @override
  bool updateShouldNotify(NavigationBarTheme oldWidget) =>
      data != oldWidget.data;
}

/// Overrides navigation tokens within a subtree.
class NavigationRailTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const NavigationRailTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The component tokens inherited by this subtree.
  final NavigationStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static NavigationStyle of(BuildContext context) =>
      maybeOf(context) ?? NavigationTheme.of(context);

  /// Returns local tokens when this component theme is present.
  static NavigationStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NavigationRailTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required NavigationStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        NavigationRailTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      NavigationRailTheme(data: data, child: child);

  @override
  bool updateShouldNotify(NavigationRailTheme oldWidget) =>
      data != oldWidget.data;
}

/// Overrides navigation tokens within a subtree.
class NavigationDrawerTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const NavigationDrawerTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The component tokens inherited by this subtree.
  final NavigationStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static NavigationStyle of(BuildContext context) =>
      maybeOf(context) ?? NavigationTheme.of(context);

  /// Returns local tokens when this component theme is present.
  static NavigationStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NavigationDrawerTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required NavigationStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        NavigationDrawerTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      NavigationDrawerTheme(data: data, child: child);

  @override
  bool updateShouldNotify(NavigationDrawerTheme oldWidget) =>
      data != oldWidget.data;
}

/// Overrides expansionTile tokens within a subtree.
class ExpansionTileTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const ExpansionTileTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The component tokens inherited by this subtree.
  final ExpansionTileStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static ExpansionTileStyle of(BuildContext context) =>
      maybeOf(context) ?? NeutralTheme.of(context).expansionTileStyle;

  /// Returns local tokens when this component theme is present.
  static ExpansionTileStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ExpansionTileTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required ExpansionTileStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        ExpansionTileTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      ExpansionTileTheme(data: data, child: child);

  @override
  bool updateShouldNotify(ExpansionTileTheme oldWidget) =>
      data != oldWidget.data;
}

/// Overrides progressIndicator tokens within a subtree.
class ProgressIndicatorTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const ProgressIndicatorTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The component tokens inherited by this subtree.
  final ProgressIndicatorStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static ProgressIndicatorStyle of(BuildContext context) =>
      maybeOf(context) ?? NeutralTheme.of(context).progressIndicatorStyle;

  /// Returns local tokens when this component theme is present.
  static ProgressIndicatorStyle? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ProgressIndicatorTheme>()
      ?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required ProgressIndicatorStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        ProgressIndicatorTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      ProgressIndicatorTheme(data: data, child: child);

  @override
  bool updateShouldNotify(ProgressIndicatorTheme oldWidget) =>
      data != oldWidget.data;
}

/// Overrides badge tokens within a subtree.
class BadgeTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const BadgeTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final BadgeStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static BadgeStyle of(BuildContext context) =>
      maybeOf(context) ?? NeutralTheme.of(context).badgeStyle;

  /// Returns local tokens when this component theme is present.
  static BadgeStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BadgeTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required BadgeStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        BadgeTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      BadgeTheme(data: data, child: child);

  @override
  bool updateShouldNotify(BadgeTheme oldWidget) => data != oldWidget.data;
}
