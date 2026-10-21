import 'package:flutter/widgets.dart';

/// Defines a data row in a [DataTable].
@immutable
class DataTableRow {
  /// Creates a table row definition.
  const DataTableRow({
    required this.cells,
    this.decoration,
    this.onTap,
    this.cellPadding,
    this.cellAlignment,
    this.tooltip,
    this.key,
    this.children,
  });

  /// Widgets rendered in each cell, corresponding to all column definitions,
  /// including hidden columns. Extra cells are ignored; missing cells are empty.
  final List<Widget> cells;

  /// Optional decoration applied to the entire row, overriding theme defaults.
  final BoxDecoration? decoration;

  /// Tap callback specific to this row. Called in addition to
  /// [DataTable.onRowTap].
  final VoidCallback? onTap;

  /// Padding applied to all cells in this row, overriding
  /// [DataTableThemeData.cellPadding] and column-level padding.
  final EdgeInsetsGeometry? cellPadding;

  /// Alignment of all cells in this row, overriding [DataTableThemeData.cellAlignment]
  /// and column-level alignment.
  final AlignmentGeometry? cellAlignment;

  /// Tooltip message shown when hovering over any cell in this row.
  final String? tooltip;

  /// Optional key, useful for list animations.
  final Key? key;

  /// Optional child rows for hierarchical/nested table structures.
  /// When provided, an expand/collapse toggle is automatically shown.
  final List<DataTableRow>? children;

  /// Creates a copy of this row with the given fields replaced.
  DataTableRow copyWith({
    List<Widget>? cells,
    BoxDecoration? decoration,
    VoidCallback? onTap,
    EdgeInsetsGeometry? cellPadding,
    AlignmentGeometry? cellAlignment,
    String? tooltip,
    Key? key,
    List<DataTableRow>? children,
  }) {
    return DataTableRow(
      cells: cells ?? this.cells,
      decoration: decoration ?? this.decoration,
      onTap: onTap ?? this.onTap,
      cellPadding: cellPadding ?? this.cellPadding,
      cellAlignment: cellAlignment ?? this.cellAlignment,
      tooltip: tooltip ?? this.tooltip,
      key: key ?? this.key,
      children: children ?? this.children,
    );
  }
}
