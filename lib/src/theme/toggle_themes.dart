import 'package:flutter/widgets.dart';

import '../styles/toggle_style.dart';
import 'pure_theme.dart';

/// Overrides checkbox tokens for a subtree.
///
/// The nearest instance replaces the enclosing component style. Use [merge]
/// to retain tokens that are not explicitly supplied.
class CheckboxTheme extends InheritedTheme {
  /// Creates a component theme for [child].
  const CheckboxTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final ToggleStyle data;

  /// Returns the nearest component theme or its PureTheme style.
  static ToggleStyle of(BuildContext context) {
    return maybeOf(context) ?? PureTheme.of(context).checkboxStyle;
  }

  /// Returns the nearest local component theme, if present.
  static ToggleStyle? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CheckboxTheme>()?.data;
  }

  /// Adds [data] while inheriting its unset tokens from the enclosing theme.
  static Widget merge({
    Key? key,
    required ToggleStyle data,
    required Widget child,
  }) {
    return Builder(
      key: key,
      builder: (BuildContext context) {
        return CheckboxTheme(data: data.merge(of(context)), child: child);
      },
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CheckboxTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(CheckboxTheme oldWidget) => data != oldWidget.data;
}

/// Overrides switch tokens for a subtree.
///
/// The nearest instance replaces the enclosing component style. Use [merge]
/// to retain tokens that are not explicitly supplied.
class SwitchTheme extends InheritedTheme {
  /// Creates a component theme for [child].
  const SwitchTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final ToggleStyle data;

  /// Returns the nearest component theme or its PureTheme style.
  static ToggleStyle of(BuildContext context) {
    return maybeOf(context) ?? PureTheme.of(context).switchStyle;
  }

  /// Returns the nearest local component theme, if present.
  static ToggleStyle? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SwitchTheme>()?.data;
  }

  /// Adds [data] while inheriting its unset tokens from the enclosing theme.
  static Widget merge({
    Key? key,
    required ToggleStyle data,
    required Widget child,
  }) {
    return Builder(
      key: key,
      builder: (BuildContext context) {
        return SwitchTheme(data: data.merge(of(context)), child: child);
      },
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return SwitchTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(SwitchTheme oldWidget) => data != oldWidget.data;
}

/// Overrides radio tokens for a subtree.
///
/// The nearest instance replaces the enclosing component style. Use [merge]
/// to retain tokens that are not explicitly supplied.
class RadioTheme extends InheritedTheme {
  /// Creates a component theme for [child].
  const RadioTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final ToggleStyle data;

  /// Returns the nearest component theme or its PureTheme style.
  static ToggleStyle of(BuildContext context) {
    return maybeOf(context) ?? PureTheme.of(context).radioStyle;
  }

  /// Returns the nearest local component theme, if present.
  static ToggleStyle? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RadioTheme>()?.data;
  }

  /// Adds [data] while inheriting its unset tokens from the enclosing theme.
  static Widget merge({
    Key? key,
    required ToggleStyle data,
    required Widget child,
  }) {
    return Builder(
      key: key,
      builder: (BuildContext context) {
        return RadioTheme(data: data.merge(of(context)), child: child);
      },
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return RadioTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(RadioTheme oldWidget) => data != oldWidget.data;
}
