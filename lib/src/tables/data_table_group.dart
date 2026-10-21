import 'package:flutter/widgets.dart';

/// Defines a named section of rows in a [DataTable].
///
/// Groups add a spanning header above a contiguous range of rows. When
/// [collapsible] is `true`, users can tap the header to show or hide the rows.
@immutable
class DataTableGroup {
  /// Creates a table group definition.
  const DataTableGroup({
    required this.header,
    required this.startIndex,
    required this.endIndex,
    this.collapsible = false,
    this.key,
  }) : assert(startIndex >= 0),
       assert(endIndex >= startIndex);

  /// Widget displayed as the group header, spanning all columns.
  final Widget header;

  /// First row index (inclusive) belonging to this group.
  final int startIndex;

  /// Last row index (inclusive) belonging to this group.
  final int endIndex;

  /// When `true`, a toggle icon is shown in the group header and users can
  /// collapse the group to hide its rows. Collapsed state is tracked via
  /// [DataTable.collapsedGroups] and [DataTable.onGroupToggled].
  final bool collapsible;

  /// Optional key, useful for list animations.
  final Key? key;

  /// Creates a copy of this group with the given fields replaced.
  DataTableGroup copyWith({
    Widget? header,
    int? startIndex,
    int? endIndex,
    bool? collapsible,
    Key? key,
  }) {
    return DataTableGroup(
      header: header ?? this.header,
      startIndex: startIndex ?? this.startIndex,
      endIndex: endIndex ?? this.endIndex,
      collapsible: collapsible ?? this.collapsible,
      key: key ?? this.key,
    );
  }
}
