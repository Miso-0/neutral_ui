import 'package:flutter/widgets.dart';

import '../styles/text_field_style.dart';
import '../styles/autocomplete_style.dart';
import '../styles/search_style.dart';
import 'pure_theme.dart';

/// Overrides textField tokens within a subtree.
class TextFieldTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const TextFieldTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final TextFieldStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static TextFieldStyle of(BuildContext context) =>
      maybeOf(context) ?? PureTheme.of(context).textFieldStyle;

  /// Returns local tokens when this component theme is present.
  static TextFieldStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TextFieldTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required TextFieldStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        TextFieldTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      TextFieldTheme(data: data, child: child);

  @override
  bool updateShouldNotify(TextFieldTheme oldWidget) => data != oldWidget.data;
}

/// Overrides autocomplete tokens within a subtree.
class AutocompleteTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const AutocompleteTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The component tokens inherited by this subtree.
  final AutocompleteStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static AutocompleteStyle of(BuildContext context) =>
      maybeOf(context) ?? PureTheme.of(context).autocompleteStyle;

  /// Returns local tokens when this component theme is present.
  static AutocompleteStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AutocompleteTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required AutocompleteStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        AutocompleteTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      AutocompleteTheme(data: data, child: child);

  @override
  bool updateShouldNotify(AutocompleteTheme oldWidget) =>
      data != oldWidget.data;
}

/// Overrides search tokens within a subtree.
class SearchTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const SearchTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final SearchStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static SearchStyle of(BuildContext context) =>
      maybeOf(context) ?? PureTheme.of(context).searchStyle;

  /// Returns local tokens when this component theme is present.
  static SearchStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SearchTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required SearchStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        SearchTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      SearchTheme(data: data, child: child);

  @override
  bool updateShouldNotify(SearchTheme oldWidget) => data != oldWidget.data;
}
