import 'package:flutter/widgets.dart';

import '../foundation/state_property.dart';

/// Tokens for the structure, appearance, and motion of a data table.
///
/// Null tokens inherit from the next style layer. No visual values are supplied.
/// Stateful row tokens fall through to lower style layers when they resolve null.
@immutable
class DataTableStyle {
  /// Creates a collection of optional table tokens.
  const DataTableStyle({
    this.decoration,
    this.textStyle,
    this.mouseCursor,
    this.headerDecoration,
    this.rowDecoration,
    this.alternateRowDecoration,
    this.hoveredRowDecoration,
    this.selectedRowDecoration,
    this.footerDecoration,
    this.expandedRowDecoration,
    this.groupHeaderDecoration,
    this.border,
    this.headerCellPadding,
    this.cellPadding,
    this.footerCellPadding,
    this.expandedRowPadding,
    this.groupHeaderPadding,
    this.headerCellAlignment,
    this.cellAlignment,
    this.footerCellAlignment,
    this.headerTextStyle,
    this.cellTextStyle,
    this.footerTextStyle,
    this.groupHeaderTextStyle,
    this.emptyTextStyle,
    this.sortIconColor,
    this.sortAscendingIcon,
    this.sortDescendingIcon,
    this.rowExpandIcon,
    this.rowCollapseIcon,
    this.groupExpandIcon,
    this.groupCollapseIcon,
    this.enableHoverEffect,
    this.animationDuration,
    this.animationCurve,
  });

  /// The decoration behind a data row for its interaction state.
  final StateProperty<Decoration?>? decoration;

  /// The text style inherited by data cells for their interaction state.
  final StateProperty<TextStyle?>? textStyle;

  /// The pointer cursor for interactive table content.
  final StateProperty<MouseCursor?>? mouseCursor;

  /// The decoration behind the header row.
  final Decoration? headerDecoration;

  /// The decoration behind data rows when no state decoration resolves.
  final Decoration? rowDecoration;

  /// The decoration behind alternating data rows.
  final Decoration? alternateRowDecoration;

  /// The decoration behind a hovered data row.
  final Decoration? hoveredRowDecoration;

  /// The decoration behind a selected data row.
  final Decoration? selectedRowDecoration;

  /// The decoration behind footer rows.
  final Decoration? footerDecoration;

  /// The decoration behind expanded row content.
  final Decoration? expandedRowDecoration;

  /// The decoration behind group headers.
  final Decoration? groupHeaderDecoration;

  /// The border around and between table cells.
  final TableBorder? border;

  /// The inset around header cell content.
  final EdgeInsetsGeometry? headerCellPadding;

  /// The inset around data cell content.
  final EdgeInsetsGeometry? cellPadding;

  /// The inset around footer content, falling back to cellPadding.
  final EdgeInsetsGeometry? footerCellPadding;

  /// The inset around expanded content, falling back to cellPadding.
  final EdgeInsetsGeometry? expandedRowPadding;

  /// The inset around group headers, falling back to cellPadding.
  final EdgeInsetsGeometry? groupHeaderPadding;

  /// The alignment of header cell content.
  final AlignmentGeometry? headerCellAlignment;

  /// The alignment of data cell content.
  final AlignmentGeometry? cellAlignment;

  /// The alignment of footer content, falling back to cellAlignment.
  final AlignmentGeometry? footerCellAlignment;

  /// The text style inherited by header cell content.
  final TextStyle? headerTextStyle;

  /// The text style inherited by data cell content.
  final TextStyle? cellTextStyle;

  /// The text style inherited by footer content.
  final TextStyle? footerTextStyle;

  /// The text style inherited by group header content.
  final TextStyle? groupHeaderTextStyle;

  /// The text style inherited by the empty-state message.
  final TextStyle? emptyTextStyle;

  /// The color inherited by the sort direction glyph.
  final Color? sortIconColor;

  /// The glyph for an ascending sort, falling back to a neutral arrow.
  final Widget? sortAscendingIcon;

  /// The glyph for a descending sort, falling back to a neutral arrow.
  final Widget? sortDescendingIcon;

  /// The glyph for a collapsed row, falling back to a neutral chevron.
  final Widget? rowExpandIcon;

  /// The glyph for an expanded row, falling back to a neutral chevron.
  final Widget? rowCollapseIcon;

  /// The glyph for a collapsed group, falling back to a neutral chevron.
  final Widget? groupExpandIcon;

  /// The glyph for an expanded group, falling back to a neutral chevron.
  final Widget? groupCollapseIcon;

  /// Whether pointer hover updates the row decoration.
  final bool? enableHoverEffect;

  /// The duration of interaction transitions.
  final Duration? animationDuration;

  /// The curve of interaction transitions.
  final Curve? animationCurve;

  /// Returns a copy with the supplied non-null tokens replaced.
  DataTableStyle copyWith({
    StateProperty<Decoration?>? decoration,
    StateProperty<TextStyle?>? textStyle,
    StateProperty<MouseCursor?>? mouseCursor,
    Decoration? headerDecoration,
    Decoration? rowDecoration,
    Decoration? alternateRowDecoration,
    Decoration? hoveredRowDecoration,
    Decoration? selectedRowDecoration,
    Decoration? footerDecoration,
    Decoration? expandedRowDecoration,
    Decoration? groupHeaderDecoration,
    TableBorder? border,
    EdgeInsetsGeometry? headerCellPadding,
    EdgeInsetsGeometry? cellPadding,
    EdgeInsetsGeometry? footerCellPadding,
    EdgeInsetsGeometry? expandedRowPadding,
    EdgeInsetsGeometry? groupHeaderPadding,
    AlignmentGeometry? headerCellAlignment,
    AlignmentGeometry? cellAlignment,
    AlignmentGeometry? footerCellAlignment,
    TextStyle? headerTextStyle,
    TextStyle? cellTextStyle,
    TextStyle? footerTextStyle,
    TextStyle? groupHeaderTextStyle,
    TextStyle? emptyTextStyle,
    Color? sortIconColor,
    Widget? sortAscendingIcon,
    Widget? sortDescendingIcon,
    Widget? rowExpandIcon,
    Widget? rowCollapseIcon,
    Widget? groupExpandIcon,
    Widget? groupCollapseIcon,
    bool? enableHoverEffect,
    Duration? animationDuration,
    Curve? animationCurve,
  }) => DataTableStyle(
    decoration: decoration ?? this.decoration,
    textStyle: textStyle ?? this.textStyle,
    mouseCursor: mouseCursor ?? this.mouseCursor,
    headerDecoration: headerDecoration ?? this.headerDecoration,
    rowDecoration: rowDecoration ?? this.rowDecoration,
    alternateRowDecoration:
        alternateRowDecoration ?? this.alternateRowDecoration,
    hoveredRowDecoration: hoveredRowDecoration ?? this.hoveredRowDecoration,
    selectedRowDecoration: selectedRowDecoration ?? this.selectedRowDecoration,
    footerDecoration: footerDecoration ?? this.footerDecoration,
    expandedRowDecoration: expandedRowDecoration ?? this.expandedRowDecoration,
    groupHeaderDecoration: groupHeaderDecoration ?? this.groupHeaderDecoration,
    border: border ?? this.border,
    headerCellPadding: headerCellPadding ?? this.headerCellPadding,
    cellPadding: cellPadding ?? this.cellPadding,
    footerCellPadding: footerCellPadding ?? this.footerCellPadding,
    expandedRowPadding: expandedRowPadding ?? this.expandedRowPadding,
    groupHeaderPadding: groupHeaderPadding ?? this.groupHeaderPadding,
    headerCellAlignment: headerCellAlignment ?? this.headerCellAlignment,
    cellAlignment: cellAlignment ?? this.cellAlignment,
    footerCellAlignment: footerCellAlignment ?? this.footerCellAlignment,
    headerTextStyle: headerTextStyle ?? this.headerTextStyle,
    cellTextStyle: cellTextStyle ?? this.cellTextStyle,
    footerTextStyle: footerTextStyle ?? this.footerTextStyle,
    groupHeaderTextStyle: groupHeaderTextStyle ?? this.groupHeaderTextStyle,
    emptyTextStyle: emptyTextStyle ?? this.emptyTextStyle,
    sortIconColor: sortIconColor ?? this.sortIconColor,
    sortAscendingIcon: sortAscendingIcon ?? this.sortAscendingIcon,
    sortDescendingIcon: sortDescendingIcon ?? this.sortDescendingIcon,
    rowExpandIcon: rowExpandIcon ?? this.rowExpandIcon,
    rowCollapseIcon: rowCollapseIcon ?? this.rowCollapseIcon,
    groupExpandIcon: groupExpandIcon ?? this.groupExpandIcon,
    groupCollapseIcon: groupCollapseIcon ?? this.groupCollapseIcon,
    enableHoverEffect: enableHoverEffect ?? this.enableHoverEffect,
    animationDuration: animationDuration ?? this.animationDuration,
    animationCurve: animationCurve ?? this.animationCurve,
  );

  /// Fills unset tokens from [other], preserving this value's tokens.
  DataTableStyle merge(DataTableStyle? other) => other == null
      ? this
      : DataTableStyle(
          decoration: decoration ?? other.decoration,
          textStyle: textStyle ?? other.textStyle,
          mouseCursor: mouseCursor ?? other.mouseCursor,
          headerDecoration: headerDecoration ?? other.headerDecoration,
          rowDecoration: rowDecoration ?? other.rowDecoration,
          alternateRowDecoration:
              alternateRowDecoration ?? other.alternateRowDecoration,
          hoveredRowDecoration:
              hoveredRowDecoration ?? other.hoveredRowDecoration,
          selectedRowDecoration:
              selectedRowDecoration ?? other.selectedRowDecoration,
          footerDecoration: footerDecoration ?? other.footerDecoration,
          expandedRowDecoration:
              expandedRowDecoration ?? other.expandedRowDecoration,
          groupHeaderDecoration:
              groupHeaderDecoration ?? other.groupHeaderDecoration,
          border: border ?? other.border,
          headerCellPadding: headerCellPadding ?? other.headerCellPadding,
          cellPadding: cellPadding ?? other.cellPadding,
          footerCellPadding: footerCellPadding ?? other.footerCellPadding,
          expandedRowPadding: expandedRowPadding ?? other.expandedRowPadding,
          groupHeaderPadding: groupHeaderPadding ?? other.groupHeaderPadding,
          headerCellAlignment: headerCellAlignment ?? other.headerCellAlignment,
          cellAlignment: cellAlignment ?? other.cellAlignment,
          footerCellAlignment: footerCellAlignment ?? other.footerCellAlignment,
          headerTextStyle: headerTextStyle ?? other.headerTextStyle,
          cellTextStyle: cellTextStyle ?? other.cellTextStyle,
          footerTextStyle: footerTextStyle ?? other.footerTextStyle,
          groupHeaderTextStyle:
              groupHeaderTextStyle ?? other.groupHeaderTextStyle,
          emptyTextStyle: emptyTextStyle ?? other.emptyTextStyle,
          sortIconColor: sortIconColor ?? other.sortIconColor,
          sortAscendingIcon: sortAscendingIcon ?? other.sortAscendingIcon,
          sortDescendingIcon: sortDescendingIcon ?? other.sortDescendingIcon,
          rowExpandIcon: rowExpandIcon ?? other.rowExpandIcon,
          rowCollapseIcon: rowCollapseIcon ?? other.rowCollapseIcon,
          groupExpandIcon: groupExpandIcon ?? other.groupExpandIcon,
          groupCollapseIcon: groupCollapseIcon ?? other.groupCollapseIcon,
          enableHoverEffect: enableHoverEffect ?? other.enableHoverEffect,
          animationDuration: animationDuration ?? other.animationDuration,
          animationCurve: animationCurve ?? other.animationCurve,
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataTableStyle &&
          decoration == other.decoration &&
          textStyle == other.textStyle &&
          mouseCursor == other.mouseCursor &&
          headerDecoration == other.headerDecoration &&
          rowDecoration == other.rowDecoration &&
          alternateRowDecoration == other.alternateRowDecoration &&
          hoveredRowDecoration == other.hoveredRowDecoration &&
          selectedRowDecoration == other.selectedRowDecoration &&
          footerDecoration == other.footerDecoration &&
          expandedRowDecoration == other.expandedRowDecoration &&
          groupHeaderDecoration == other.groupHeaderDecoration &&
          border == other.border &&
          headerCellPadding == other.headerCellPadding &&
          cellPadding == other.cellPadding &&
          footerCellPadding == other.footerCellPadding &&
          expandedRowPadding == other.expandedRowPadding &&
          groupHeaderPadding == other.groupHeaderPadding &&
          headerCellAlignment == other.headerCellAlignment &&
          cellAlignment == other.cellAlignment &&
          footerCellAlignment == other.footerCellAlignment &&
          headerTextStyle == other.headerTextStyle &&
          cellTextStyle == other.cellTextStyle &&
          footerTextStyle == other.footerTextStyle &&
          groupHeaderTextStyle == other.groupHeaderTextStyle &&
          emptyTextStyle == other.emptyTextStyle &&
          sortIconColor == other.sortIconColor &&
          sortAscendingIcon == other.sortAscendingIcon &&
          sortDescendingIcon == other.sortDescendingIcon &&
          rowExpandIcon == other.rowExpandIcon &&
          rowCollapseIcon == other.rowCollapseIcon &&
          groupExpandIcon == other.groupExpandIcon &&
          groupCollapseIcon == other.groupCollapseIcon &&
          enableHoverEffect == other.enableHoverEffect &&
          animationDuration == other.animationDuration &&
          animationCurve == other.animationCurve;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    decoration,
    textStyle,
    mouseCursor,
    headerDecoration,
    rowDecoration,
    alternateRowDecoration,
    hoveredRowDecoration,
    selectedRowDecoration,
    footerDecoration,
    expandedRowDecoration,
    groupHeaderDecoration,
    border,
    headerCellPadding,
    cellPadding,
    footerCellPadding,
    expandedRowPadding,
    groupHeaderPadding,
    headerCellAlignment,
    cellAlignment,
    footerCellAlignment,
    headerTextStyle,
    cellTextStyle,
    footerTextStyle,
    groupHeaderTextStyle,
    emptyTextStyle,
    sortIconColor,
    sortAscendingIcon,
    sortDescendingIcon,
    rowExpandIcon,
    rowCollapseIcon,
    groupExpandIcon,
    groupCollapseIcon,
    enableHoverEffect,
    animationDuration,
    animationCurve,
  ]);

  @override
  String toString() =>
      'DataTableStyle(decoration: $decoration, textStyle: $textStyle, mouseCursor: $mouseCursor, headerDecoration: $headerDecoration, rowDecoration: $rowDecoration, alternateRowDecoration: $alternateRowDecoration, hoveredRowDecoration: $hoveredRowDecoration, selectedRowDecoration: $selectedRowDecoration, footerDecoration: $footerDecoration, expandedRowDecoration: $expandedRowDecoration, groupHeaderDecoration: $groupHeaderDecoration, border: $border, headerCellPadding: $headerCellPadding, cellPadding: $cellPadding, footerCellPadding: $footerCellPadding, expandedRowPadding: $expandedRowPadding, groupHeaderPadding: $groupHeaderPadding, headerCellAlignment: $headerCellAlignment, cellAlignment: $cellAlignment, footerCellAlignment: $footerCellAlignment, headerTextStyle: $headerTextStyle, cellTextStyle: $cellTextStyle, footerTextStyle: $footerTextStyle, groupHeaderTextStyle: $groupHeaderTextStyle, emptyTextStyle: $emptyTextStyle, sortIconColor: $sortIconColor, sortAscendingIcon: $sortAscendingIcon, sortDescendingIcon: $sortDescendingIcon, rowExpandIcon: $rowExpandIcon, rowCollapseIcon: $rowCollapseIcon, groupExpandIcon: $groupExpandIcon, groupCollapseIcon: $groupCollapseIcon, enableHoverEffect: $enableHoverEffect, animationDuration: $animationDuration, animationCurve: $animationCurve)';
}
