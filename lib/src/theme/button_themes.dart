import 'package:flutter/widgets.dart';

import '../styles/button_style.dart';
import 'pure_theme.dart';

/// Overrides elevatedButton tokens for a subtree.
///
/// The nearest instance replaces the enclosing component style. Use [merge]
/// to retain tokens that are not explicitly supplied.
class ElevatedButtonTheme extends InheritedTheme {
  /// Creates a component theme for [child].
  const ElevatedButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The component tokens inherited by this subtree.
  final ButtonStyle data;

  /// Returns the nearest component theme or its PureTheme style.
  static ButtonStyle of(BuildContext context) {
    return maybeOf(context) ?? PureTheme.of(context).elevatedButtonStyle;
  }

  /// Returns the nearest local component theme, if present.
  static ButtonStyle? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ElevatedButtonTheme>()
        ?.data;
  }

  /// Adds [data] while inheriting its unset tokens from the enclosing theme.
  static Widget merge({
    Key? key,
    required ButtonStyle data,
    required Widget child,
  }) {
    return Builder(
      key: key,
      builder: (BuildContext context) {
        return ElevatedButtonTheme(data: data.merge(of(context)), child: child);
      },
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return ElevatedButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(ElevatedButtonTheme oldWidget) =>
      data != oldWidget.data;
}

/// Overrides outlinedButton tokens for a subtree.
///
/// The nearest instance replaces the enclosing component style. Use [merge]
/// to retain tokens that are not explicitly supplied.
class OutlinedButtonTheme extends InheritedTheme {
  /// Creates a component theme for [child].
  const OutlinedButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The component tokens inherited by this subtree.
  final ButtonStyle data;

  /// Returns the nearest component theme or its PureTheme style.
  static ButtonStyle of(BuildContext context) {
    return maybeOf(context) ?? PureTheme.of(context).outlinedButtonStyle;
  }

  /// Returns the nearest local component theme, if present.
  static ButtonStyle? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<OutlinedButtonTheme>()
        ?.data;
  }

  /// Adds [data] while inheriting its unset tokens from the enclosing theme.
  static Widget merge({
    Key? key,
    required ButtonStyle data,
    required Widget child,
  }) {
    return Builder(
      key: key,
      builder: (BuildContext context) {
        return OutlinedButtonTheme(data: data.merge(of(context)), child: child);
      },
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return OutlinedButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(OutlinedButtonTheme oldWidget) =>
      data != oldWidget.data;
}

/// Overrides textButton tokens for a subtree.
///
/// The nearest instance replaces the enclosing component style. Use [merge]
/// to retain tokens that are not explicitly supplied.
class TextButtonTheme extends InheritedTheme {
  /// Creates a component theme for [child].
  const TextButtonTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final ButtonStyle data;

  /// Returns the nearest component theme or its PureTheme style.
  static ButtonStyle of(BuildContext context) {
    return maybeOf(context) ?? PureTheme.of(context).textButtonStyle;
  }

  /// Returns the nearest local component theme, if present.
  static ButtonStyle? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TextButtonTheme>()?.data;
  }

  /// Adds [data] while inheriting its unset tokens from the enclosing theme.
  static Widget merge({
    Key? key,
    required ButtonStyle data,
    required Widget child,
  }) {
    return Builder(
      key: key,
      builder: (BuildContext context) {
        return TextButtonTheme(data: data.merge(of(context)), child: child);
      },
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return TextButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(TextButtonTheme oldWidget) => data != oldWidget.data;
}

/// Overrides iconButton tokens for a subtree.
///
/// The nearest instance replaces the enclosing component style. Use [merge]
/// to retain tokens that are not explicitly supplied.
class IconButtonTheme extends InheritedTheme {
  /// Creates a component theme for [child].
  const IconButtonTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final ButtonStyle data;

  /// Returns the nearest component theme or its PureTheme style.
  static ButtonStyle of(BuildContext context) {
    return maybeOf(context) ?? PureTheme.of(context).iconButtonStyle;
  }

  /// Returns the nearest local component theme, if present.
  static ButtonStyle? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<IconButtonTheme>()?.data;
  }

  /// Adds [data] while inheriting its unset tokens from the enclosing theme.
  static Widget merge({
    Key? key,
    required ButtonStyle data,
    required Widget child,
  }) {
    return Builder(
      key: key,
      builder: (BuildContext context) {
        return IconButtonTheme(data: data.merge(of(context)), child: child);
      },
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return IconButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(IconButtonTheme oldWidget) => data != oldWidget.data;
}
