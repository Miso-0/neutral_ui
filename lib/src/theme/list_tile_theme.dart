import 'package:flutter/widgets.dart';

import '../styles/list_tile_style.dart';
import 'neutral_theme.dart';

/// Overrides listTile tokens for a subtree.
///
/// The nearest instance replaces the enclosing component style. Use [merge]
/// to retain tokens that are not explicitly supplied.
class ListTileTheme extends InheritedTheme {
  /// Creates a component theme for [child].
  const ListTileTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final ListTileStyle data;

  /// Returns the nearest component theme or its NeutralTheme style.
  static ListTileStyle of(BuildContext context) {
    return maybeOf(context) ?? NeutralTheme.of(context).listTileStyle;
  }

  /// Returns the nearest local component theme, if present.
  static ListTileStyle? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ListTileTheme>()?.data;
  }

  /// Adds [data] while inheriting its unset tokens from the enclosing theme.
  static Widget merge({
    Key? key,
    required ListTileStyle data,
    required Widget child,
  }) {
    return Builder(
      key: key,
      builder: (BuildContext context) {
        return ListTileTheme(data: data.merge(of(context)), child: child);
      },
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return ListTileTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(ListTileTheme oldWidget) => data != oldWidget.data;
}
