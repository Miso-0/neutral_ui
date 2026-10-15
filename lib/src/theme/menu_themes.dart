import 'package:flutter/widgets.dart';

import '../styles/dropdown_style.dart';
import '../styles/popup_menu_style.dart';
import 'pure_theme.dart';

/// Overrides dropdownButton tokens for a subtree.
///
/// The nearest instance replaces the enclosing component style. Use [merge]
/// to retain tokens that are not explicitly supplied.
class DropdownButtonTheme extends InheritedTheme {
  /// Creates a component theme for [child].
  const DropdownButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The component tokens inherited by this subtree.
  final DropdownStyle data;

  /// Returns the nearest component theme or its PureTheme style.
  static DropdownStyle of(BuildContext context) {
    return maybeOf(context) ?? PureTheme.of(context).dropdownButtonStyle;
  }

  /// Returns the nearest local component theme, if present.
  static DropdownStyle? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DropdownButtonTheme>()
        ?.data;
  }

  /// Adds [data] while inheriting its unset tokens from the enclosing theme.
  static Widget merge({
    Key? key,
    required DropdownStyle data,
    required Widget child,
  }) {
    return Builder(
      key: key,
      builder: (BuildContext context) {
        return DropdownButtonTheme(data: data.merge(of(context)), child: child);
      },
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DropdownButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(DropdownButtonTheme oldWidget) =>
      data != oldWidget.data;
}

/// Overrides dropdownMenu tokens for a subtree.
///
/// The nearest instance replaces the enclosing component style. Use [merge]
/// to retain tokens that are not explicitly supplied.
class DropdownMenuTheme extends InheritedTheme {
  /// Creates a component theme for [child].
  const DropdownMenuTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The component tokens inherited by this subtree.
  final DropdownStyle data;

  /// Returns the nearest component theme or its PureTheme style.
  static DropdownStyle of(BuildContext context) {
    return maybeOf(context) ?? PureTheme.of(context).dropdownMenuStyle;
  }

  /// Returns the nearest local component theme, if present.
  static DropdownStyle? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DropdownMenuTheme>()
        ?.data;
  }

  /// Adds [data] while inheriting its unset tokens from the enclosing theme.
  static Widget merge({
    Key? key,
    required DropdownStyle data,
    required Widget child,
  }) {
    return Builder(
      key: key,
      builder: (BuildContext context) {
        return DropdownMenuTheme(data: data.merge(of(context)), child: child);
      },
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DropdownMenuTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(DropdownMenuTheme oldWidget) =>
      data != oldWidget.data;
}

/// Overrides popupMenu tokens for a subtree.
///
/// The nearest instance replaces the enclosing component style. Use [merge]
/// to retain tokens that are not explicitly supplied.
class PopupMenuTheme extends InheritedTheme {
  /// Creates a component theme for [child].
  const PopupMenuTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final PopupMenuStyle data;

  /// Returns the nearest component theme or its PureTheme style.
  static PopupMenuStyle of(BuildContext context) {
    return maybeOf(context) ?? PureTheme.of(context).popupMenuStyle;
  }

  /// Returns the nearest local component theme, if present.
  static PopupMenuStyle? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PopupMenuTheme>()?.data;
  }

  /// Adds [data] while inheriting its unset tokens from the enclosing theme.
  static Widget merge({
    Key? key,
    required PopupMenuStyle data,
    required Widget child,
  }) {
    return Builder(
      key: key,
      builder: (BuildContext context) {
        return PopupMenuTheme(data: data.merge(of(context)), child: child);
      },
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return PopupMenuTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(PopupMenuTheme oldWidget) => data != oldWidget.data;
}
