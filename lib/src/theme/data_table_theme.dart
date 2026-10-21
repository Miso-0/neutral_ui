import 'package:flutter/widgets.dart';

import '../styles/data_table_style.dart';
import 'neutral_theme.dart';

/// Overrides data table tokens for a subtree.
///
/// The nearest instance replaces the enclosing component style. Use [merge]
/// to retain tokens that are not explicitly supplied.
class DataTableTheme extends InheritedTheme {
  /// Creates a component theme for [child].
  const DataTableTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final DataTableStyle data;

  /// Returns the nearest component theme or its NeutralTheme style.
  static DataTableStyle of(BuildContext context) {
    return maybeOf(context) ?? NeutralTheme.of(context).dataTableStyle;
  }

  /// Returns the nearest local component theme, if present.
  static DataTableStyle? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataTableTheme>()?.data;
  }

  /// Adds [data] while inheriting its unset tokens from the enclosing theme.
  static Widget merge({
    Key? key,
    required DataTableStyle data,
    required Widget child,
  }) {
    return Builder(
      key: key,
      builder: (BuildContext context) {
        return DataTableTheme(data: data.merge(of(context)), child: child);
      },
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DataTableTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(DataTableTheme oldWidget) => data != oldWidget.data;
}
