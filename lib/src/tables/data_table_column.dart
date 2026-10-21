import 'package:flutter/widgets.dart';

/// Defines a column in a [DataTable].
///
/// Each column specifies its header widget, width strategy, sorting behavior,
/// and per-column styling overrides.
@immutable
class DataTableColumn {
  /// Creates a table column definition.
  const DataTableColumn({
    required this.header,
    this.width,
    this.minWidth,
    this.maxWidth,
    this.sortable = false,
    this.visible = true,
    this.tooltip,
    this.onTap,
    this.headerPadding,
    this.headerAlignment,
    this.cellPadding,
    this.cellAlignment,
    this.constraints,
  }) : assert(
         minWidth == null || (minWidth >= 0 && minWidth < double.infinity),
       ),
       assert(
         maxWidth == null || (maxWidth >= 0 && maxWidth < double.infinity),
       ),
       assert(minWidth == null || maxWidth == null || minWidth <= maxWidth);

  /// Widget displayed in the column header.
  final Widget header;

  /// Width strategy for this column.
  ///
  /// Accepts any [TableColumnWidth]: [FlexColumnWidth], [FixedColumnWidth],
  /// [IntrinsicColumnWidth], or [FractionColumnWidth]. Defaults to
  /// `FlexColumnWidth(1)` if not provided.
  final TableColumnWidth? width;

  /// Minimum width in logical pixels. Wraps [width] with [MaxColumnWidth].
  final double? minWidth;

  /// Maximum width in logical pixels. Wraps [width] with [MinColumnWidth].
  final double? maxWidth;

  /// Whether tapping this column header triggers sorting via [DataTable.onSort].
  final bool sortable;

  /// Whether this column is rendered. Hidden columns are completely excluded
  /// from layout. Defaults to `true`.
  final bool visible;

  /// Tooltip shown when hovering over the column header.
  final String? tooltip;

  /// Tap callback for non-sortable column headers. Ignored when [sortable] is
  /// `true` and [DataTable.onSort] is provided.
  final VoidCallback? onTap;

  /// Padding applied to this column's header cell, overriding
  /// [DataTableThemeData.headerCellPadding].
  final EdgeInsetsGeometry? headerPadding;

  /// Alignment of the header cell content, overriding
  /// [DataTableThemeData.headerCellAlignment].
  final AlignmentGeometry? headerAlignment;

  /// Padding applied to all data cells in this column, overriding
  /// [DataTableThemeData.cellPadding].
  final EdgeInsetsGeometry? cellPadding;

  /// Alignment of all data cell content in this column, overriding
  /// [DataTableThemeData.cellAlignment].
  final AlignmentGeometry? cellAlignment;

  /// Additional box constraints applied to data cells in this column.
  final BoxConstraints? constraints;

  /// Creates a copy of this column with the given fields replaced.
  DataTableColumn copyWith({
    Widget? header,
    TableColumnWidth? width,
    double? minWidth,
    double? maxWidth,
    bool? sortable,
    bool? visible,
    String? tooltip,
    VoidCallback? onTap,
    EdgeInsetsGeometry? headerPadding,
    AlignmentGeometry? headerAlignment,
    EdgeInsetsGeometry? cellPadding,
    AlignmentGeometry? cellAlignment,
    BoxConstraints? constraints,
  }) {
    return DataTableColumn(
      header: header ?? this.header,
      width: width ?? this.width,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      sortable: sortable ?? this.sortable,
      visible: visible ?? this.visible,
      tooltip: tooltip ?? this.tooltip,
      onTap: onTap ?? this.onTap,
      headerPadding: headerPadding ?? this.headerPadding,
      headerAlignment: headerAlignment ?? this.headerAlignment,
      cellPadding: cellPadding ?? this.cellPadding,
      cellAlignment: cellAlignment ?? this.cellAlignment,
      constraints: constraints ?? this.constraints,
    );
  }
}
