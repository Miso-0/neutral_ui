import 'package:flutter/widgets.dart';

import '../feedback/progress_indicator.dart';
import '../feedback/tooltip.dart';
import '../foundation/animated_surface.dart';
import '../foundation/glyphs.dart';
import '../foundation/interaction_detector.dart';
import '../foundation/interaction_state.dart';
import '../foundation/motion.dart';
import '../foundation/state_property.dart';
import '../foundation/style_resolution.dart';
import '../localizations/neutral_localizations.dart';
import '../styles/data_table_style.dart';
import '../theme/data_table_theme.dart';
import '../toggles/checkbox.dart';

import 'data_table_column.dart';
import 'data_table_group.dart';
import 'data_table_row.dart';
import 'data_table_theme.dart';

/// A highly customizable and flexible table widget for Flutter.
///
/// `DataTable` renders tabular data using Flutter's [Table] widget as its
/// layout engine. It supports:
///
/// - Flexible, fixed, intrinsic, and fractional column widths
/// - Sortable columns with ascending/descending indicators
/// - Checkbox row selection with select-all support
/// - Expandable rows with custom content builders
/// - Collapsible row groups
/// - Alternating/striped row colors
/// - Column visibility toggling
/// - Loading and empty states with custom builders
/// - Footer rows for summaries/totals
/// - Hover effects and rich row/cell interaction callbacks
/// - Comprehensive per-column, per-row, and theme-level styling
///
/// The table does not manage its own scrolling. Wrap it in a [SingleChildScrollView]
/// or [ListView] when content may overflow.
///
/// ## Basic usage
///
/// ```dart
/// DataTable(
///   columns: [
///     DataTableColumn(header: Text('Name'), width: FlexColumnWidth(2), sortable: true),
///     DataTableColumn(header: Text('Age'), width: FixedColumnWidth(80)),
///   ],
///   rows: [
///     DataTableRow(cells: [Text('Alice'), Text('28')]),
///     DataTableRow(cells: [Text('Bob'), Text('34')]),
///   ],
/// )
/// ```
class DataTable extends StatefulWidget {
  /// Creates a table using widgets-layer controls and inherited style tokens.
  const DataTable({
    super.key,
    required this.columns,
    this.rows = const <DataTableRow>[],
    this.theme,
    this.style,
    // ── Builders ─────────────────────────────────────────────────────────────
    this.headerBuilder,
    this.cellBuilder,
    this.rowBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
    // ── Footer ───────────────────────────────────────────────────────────────
    this.footerRows,
    // ── Selection ────────────────────────────────────────────────────────────
    this.showCheckboxes = false,
    this.checkboxBuilder,
    this.onSelectAll,
    this.selectedRows = const <int>{},
    this.onRowSelected,
    // ── Expansion ────────────────────────────────────────────────────────────
    this.expandableRowBuilder,
    this.expandedRowChildBuilder,
    this.expandedRows = const <String>{},
    this.onRowExpanded,
    // ── Loading ───────────────────────────────────────────────────────────────
    this.isLoading = false,
    // ── Sorting ───────────────────────────────────────────────────────────────
    this.onSort,
    this.sortColumnIndex,
    this.sortAscending = true,
    // ── Groups ───────────────────────────────────────────────────────────────
    this.groups,
    this.groupHeaderBuilder,
    this.collapsedGroups = const <int>{},
    this.onGroupToggled,
    // ── Callbacks ────────────────────────────────────────────────────────────
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowLongPress,
    this.onRowSecondaryTap,
    this.onCellTap,
    // ── Styling ───────────────────────────────────────────────────────────────
    this.border,
    this.rowDivider,
  });

  // ── Data ───────────────────────────────────────────────────────────────────

  /// Column definitions. Columns with [DataTableColumn.visible] set to `false`
  /// are excluded from layout and rendering.
  final List<DataTableColumn> columns;

  /// Data rows. Each row's [DataTableRow.cells] list corresponds positionally
  /// to [columns], including hidden columns.
  final List<DataTableRow> rows;

  /// Inline appearance overrides retained for compatibility.
  ///
  /// Unset tokens inherit the component theme; [style] takes precedence.
  final DataTableThemeData? theme;

  /// Inline tokens that override the component and central table themes.
  final DataTableStyle? style;

  // ── Builders ───────────────────────────────────────────────────────────────

  /// Replaces the default header cell rendering for every column.
  ///
  /// Receives the [BuildContext], the [DataTableColumn] (original, including
  /// hidden columns that are filtered before this is called), and its original
  /// index in [columns].
  final Widget Function(
    BuildContext context,
    DataTableColumn column,
    int columnIndex,
  )?
  headerBuilder;

  /// Replaces the default data cell rendering for every cell.
  ///
  /// Receives the original cell [Widget], its [DataTableColumn], the
  /// [DataTableRow], the row index, and the original column index.
  final Widget Function(
    BuildContext context,
    Widget cell,
    DataTableColumn column,
    DataTableRow row,
    int rowIndex,
    int columnIndex,
  )?
  cellBuilder;

  /// Wraps or replaces the rendered widget for each data row.
  ///
  /// `defaultRow` is the widget produced by the default rendering pipeline.
  final Widget Function(
    BuildContext context,
    DataTableRow row,
    int rowIndex,
    Widget defaultRow,
  )?
  rowBuilder;

  /// Replaces the default empty-state widget shown when [rows] is empty.
  final Widget Function(BuildContext context)? emptyBuilder;

  /// Replaces the default loading widget shown when [isLoading] is `true`.
  final Widget Function(BuildContext context)? loadingBuilder;

  // ── Footer ─────────────────────────────────────────────────────────────────

  /// Optional footer rows rendered below data rows (e.g., totals).
  final List<DataTableRow>? footerRows;

  // ── Selection ──────────────────────────────────────────────────────────────

  /// Whether to show a leading checkbox column.
  final bool showCheckboxes;

  /// Replaces the default [Checkbox] widget for both the header (select-all)
  /// and data row checkboxes.
  ///
  /// `value` is `true` (selected), `false` (unselected), or `null` (tristate
  /// indeterminate, header only).
  final Widget Function(
    BuildContext context,
    bool? value,
    ValueChanged<bool?>? onChanged,
  )?
  checkboxBuilder;

  /// Called when the header (select-all) checkbox changes. The argument is
  /// `true` (select all), `false` (deselect all), or `null`.
  final ValueChanged<bool?>? onSelectAll;

  /// Top-level row indices that are selected. Child rows have no checkbox.
  /// The widget keeps an internal copy
  /// and re-syncs when this set changes identity.
  final Set<int> selectedRows;

  /// Called with the row index when a checkbox is toggled.
  final ValueChanged<int>? onRowSelected;

  // ── Expansion ──────────────────────────────────────────────────────────────

  /// Returns the widget to display below the row when it is expanded, or
  /// `null` if the row is not expandable.
  ///
  /// The returned widget is placed inside the first table cell, so
  /// it is constrained to that column's width. Use [expandedRowChildBuilder]
  /// instead when the content needs to span the full width of the table.
  ///
  /// **Note:** If rows have [DataTableRow.children], they will automatically
  /// be expandable regardless of this builder. This builder is for custom
  /// expandable content that isn't hierarchical sub-rows.
  final Widget? Function(BuildContext context, DataTableRow row, int rowIndex)?
  expandableRowBuilder;

  /// Returns a widget to display below the row when it is expanded, sized to
  /// the full width of the table rather than a single column.
  ///
  /// Unlike [expandableRowBuilder], the returned widget is not placed inside
  /// a table cell - it renders as its own full-width block between the
  /// surrounding table rows. This means table borders/dividers configured via
  /// [DataTableThemeData.border] or [rowDivider] will not draw through it.
  ///
  /// Returning `null` for a row falls back to [expandableRowBuilder] (if
  /// provided) for that row. If both are `null` for a row, no expand toggle
  /// is shown unless the row also has [DataTableRow.children].
  final Widget? Function(BuildContext context, DataTableRow row, int rowIndex)?
  expandedRowChildBuilder;

  /// Row paths that are currently expanded.
  /// For hierarchical rows, use dot-separated paths like "0", "0.1", "0.1.2".
  /// For simple rows without children, use the row index as a string like "0", "1", "2".
  final Set<String> expandedRows;

  /// Called with the row path when the expand/collapse button is tapped.
  /// For hierarchical rows, the path is dot-separated like "0.1.2".
  final ValueChanged<String>? onRowExpanded;

  // ── Loading ─────────────────────────────────────────────────────────────────

  /// When `true`, the table body is replaced by the loading indicator.
  final bool isLoading;

  // ── Sorting ─────────────────────────────────────────────────────────────────

  /// Called with the original column index when a sortable header is tapped.
  final void Function(int columnIndex)? onSort;

  /// Original column index of the currently sorted column. The sort indicator
  /// is shown only when this matches a visible, sortable column.
  final int? sortColumnIndex;

  /// Direction of the current sort. Defaults to `true` (ascending).
  final bool sortAscending;

  // ── Groups ─────────────────────────────────────────────────────────────────

  /// Optional list of [DataTableGroup] definitions. When provided, rows are
  /// rendered in group sections with a spanning header row.
  final List<DataTableGroup>? groups;

  /// Replaces the default group header cell rendering.
  final Widget Function(
    BuildContext context,
    DataTableGroup group,
    int groupIndex,
  )?
  groupHeaderBuilder;

  /// Group indices (position in [groups]) that are currently collapsed.
  final Set<int> collapsedGroups;

  /// Called with the group index when a collapsible group header is tapped.
  final ValueChanged<int>? onGroupToggled;

  // ── Callbacks ──────────────────────────────────────────────────────────────

  /// Called with the row index when a data row is tapped.
  final ValueChanged<int>? onRowTap;

  /// Called with the row index when a data row is double-tapped.
  final ValueChanged<int>? onRowDoubleTap;

  /// Called with the row index when a data row is long-pressed.
  final ValueChanged<int>? onRowLongPress;

  /// Called with the row index when a data row receives a secondary tap
  /// (right-click on desktop, long-press context on some platforms).
  final ValueChanged<int>? onRowSecondaryTap;

  /// Called with (rowIndex, columnIndex) when a data cell is tapped.
  /// Column index is the *original* index in [columns].
  final void Function(int rowIndex, int columnIndex)? onCellTap;

  // ── Styling ─────────────────────────────────────────────────────────────────

  /// Table border overriding [DataTableThemeData.border].
  final TableBorder? border;

  /// When set, this [BorderSide] is drawn as the bottom edge of every data row,
  /// creating a visual divider between rows.
  final BorderSide? rowDivider;

  @override
  State<DataTable> createState() => _DataTableState();
}

class _DataTableState extends State<DataTable> {
  late Set<int> _selectedRows;
  late Set<String> _expandedRows;
  late Set<int> _collapsedGroups;
  final Map<(Object, Object), GlobalKey> _cellKeys =
      <(Object, Object), GlobalKey>{};
  final Set<(Object, Object)> _usedCellKeys = <(Object, Object)>{};
  late List<Object> _columnIds;
  bool _columnRefreshScheduled = false;
  late List<DataTableStyle?> _layers;
  late Map<int, TableColumnWidth> _columnWidths;
  late Map<int, List<GlobalKey>> _columnCells;

  @override
  void initState() {
    super.initState();
    _selectedRows = Set<int>.of(widget.selectedRows);
    _expandedRows = Set<String>.of(widget.expandedRows);
    _collapsedGroups = Set<int>.of(widget.collapsedGroups);
  }

  @override
  void didUpdateWidget(DataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedRows != oldWidget.selectedRows) {
      _selectedRows = Set<int>.of(widget.selectedRows);
    }
    if (widget.expandedRows != oldWidget.expandedRows) {
      _expandedRows = Set<String>.of(widget.expandedRows);
    }
    if (widget.collapsedGroups != oldWidget.collapsedGroups) {
      _collapsedGroups = Set<int>.of(widget.collapsedGroups);
    }
    _selectedRows.removeWhere(
      (int index) => index < 0 || index >= widget.rows.length,
    );
  }

  T? _plain<T>(T? Function(DataTableStyle style) select) =>
      resolvePlain<DataTableStyle, T>(_layers, select);

  T? _token<T>(
    InteractionState state,
    StateProperty<T?>? Function(DataTableStyle style) select,
  ) => resolveStateful<DataTableStyle, T>(state, _layers, select);

  EdgeInsetsGeometry get _cellPadding =>
      _plain<EdgeInsetsGeometry>((DataTableStyle s) => s.cellPadding) ??
      EdgeInsets.zero;

  AlignmentGeometry get _cellAlignment =>
      _plain<AlignmentGeometry>((DataTableStyle s) => s.cellAlignment) ??
      AlignmentDirectional.centerStart;

  Duration get _duration => reducedMotionDuration(
    context,
    _plain<Duration>((DataTableStyle s) => s.animationDuration) ??
        const Duration(milliseconds: 200),
  );

  Curve get _curve =>
      _plain<Curve>((DataTableStyle s) => s.animationCurve) ?? Curves.easeInOut;

  List<(int, DataTableColumn)> get _visibleColumns => <(int, DataTableColumn)>[
    for (int i = 0; i < widget.columns.length; i++)
      if (widget.columns[i].visible) (i, widget.columns[i]),
  ];

  bool get _hasExpandColumn =>
      widget.expandableRowBuilder != null ||
      widget.expandedRowChildBuilder != null ||
      widget.rows.any((DataTableRow row) => row.children?.isNotEmpty ?? false);

  int get _totalColumnCount =>
      _visibleColumns.length +
      (widget.showCheckboxes ? 1 : 0) +
      (_hasExpandColumn ? 1 : 0);

  TableBorder? get _border =>
      widget.border ?? _plain<TableBorder>((DataTableStyle s) => s.border);

  @override
  Widget build(BuildContext context) {
    _layers = <DataTableStyle?>[
      widget.style,
      widget.theme?.toStyle(),
      DataTableTheme.of(context),
    ];
    if (widget.isLoading) {
      return widget.loadingBuilder?.call(context) ??
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          );
    }
    if (widget.rows.isEmpty && (widget.groups?.isEmpty ?? true)) {
      return widget.emptyBuilder?.call(context) ??
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text(
                'No data available',
                style: _plain<TextStyle>(
                  (DataTableStyle s) => s.emptyTextStyle,
                ),
              ),
            ),
          );
    }
    if (_totalColumnCount == 0) return const SizedBox.shrink();

    _usedCellKeys.clear();
    _columnIds = <Object>[
      if (widget.showCheckboxes) 'selection',
      for (final (int index, DataTableColumn _) in _visibleColumns) index,
      if (_hasExpandColumn) 'expansion',
    ];
    _columnCells = <int, List<GlobalKey>>{};
    _columnWidths = _buildColumnWidths();
    final List<Widget> rows = <Widget>[_buildHeader()];
    if (widget.groups case final List<DataTableGroup> groups) {
      for (int gi = 0; gi < groups.length; gi++) {
        final DataTableGroup group = groups[gi];
        rows.add(_buildGroupHeader(group, gi));
        if (!_collapsedGroups.contains(gi)) {
          for (
            int ri = group.startIndex;
            ri <= group.endIndex && ri < widget.rows.length;
            ri++
          ) {
            if (ri >= 0) _appendDataRow(rows, widget.rows[ri], ri, '$ri', 0);
          }
        }
      }
    } else {
      for (int i = 0; i < widget.rows.length; i++) {
        _appendDataRow(rows, widget.rows[i], i, '$i', 0);
      }
    }
    final List<DataTableRow> footerRows =
        widget.footerRows ?? const <DataTableRow>[];
    for (int i = 0; i < footerRows.length; i++) {
      rows.add(_buildFooter(footerRows[i], i));
    }
    _cellKeys.removeWhere(
      ((Object, Object) id, GlobalKey key) => !_usedCellKeys.contains(id),
    );

    final TableBorder? border = _border;
    final BorderSide inside = border?.horizontalInside ?? BorderSide.none;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: border == null
            ? null
            : Border(
                top: border.top,
                bottom: border.bottom,
                left: border.left,
                right: border.right,
              ),
        borderRadius: border?.borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (int i = 0; i < rows.length; i++)
            DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                border: Border(
                  bottom: i < rows.length - 1 ? inside : BorderSide.none,
                ),
              ),
              child: rows[i],
            ),
        ],
      ),
    );
  }

  Map<int, TableColumnWidth> _buildColumnWidths() {
    final Map<int, TableColumnWidth> widths = <int, TableColumnWidth>{};
    int index = 0;
    void add(TableColumnWidth width) {
      final List<GlobalKey> cells = <GlobalKey>[];
      _columnCells[index] = cells;
      widths[index] = _SharedColumnWidth(width, cells, _refreshColumnWidths);
      index++;
    }

    if (widget.showCheckboxes) add(const FixedColumnWidth(48));
    for (final (int _, DataTableColumn column) in _visibleColumns) {
      TableColumnWidth width = column.width ?? const FlexColumnWidth();
      if (column.minWidth != null) {
        width = MaxColumnWidth(FixedColumnWidth(column.minWidth!), width);
      }
      if (column.maxWidth != null) {
        width = MinColumnWidth(FixedColumnWidth(column.maxWidth!), width);
      }
      add(width);
    }
    if (_hasExpandColumn) add(const FixedColumnWidth(48));
    return widths;
  }

  void _refreshColumnWidths() {
    if (_columnRefreshScheduled) return;
    _columnRefreshScheduled = true;
    // A cell may rebuild without rebuilding the table (for example through a
    // ValueListenableBuilder). Refresh the other segments after that layout.
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _columnRefreshScheduled = false;
      if (mounted) setState(() {});
    });
  }

  // Each row uses the same intrinsic measurements, including across spanning
  // group/detail blocks and custom row wrappers. Keys keep cell state intact.
  Widget _table(Object id, List<Widget> cells, {Decoration? decoration}) {
    return Table(
      columnWidths: _columnWidths,
      border: _border == null
          ? null
          : TableBorder(verticalInside: _border!.verticalInside),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          decoration: decoration,
          children: <Widget>[
            for (int i = 0; i < cells.length; i++)
              _measureCell((id, _columnIds[i]), i, cells[i]),
          ],
        ),
      ],
    );
  }

  Widget _measureCell((Object, Object) id, int column, Widget child) {
    _usedCellKeys.add(id);
    final GlobalKey key = _cellKeys.putIfAbsent(
      id,
      () => GlobalKey(debugLabel: 'table:$id'),
    );
    _columnCells[column]!.add(key);
    return KeyedSubtree(key: key, child: child);
  }

  Widget _action(
    Widget child,
    VoidCallback? onTap, {
    bool header = false,
    bool? expanded,
  }) {
    return Semantics(
      button: onTap != null,
      header: header,
      expanded: expanded,
      child: InteractionDetector(
        onTap: onTap,
        canRequestFocus: onTap != null,
        mouseCursor: StateProperty<MouseCursor?>.resolveWith(
          (InteractionState state) =>
              _token<MouseCursor>(state, (DataTableStyle s) => s.mouseCursor),
        ),
        builder: (BuildContext context, InteractionState state) => child,
      ),
    );
  }

  Widget _buildHeader() {
    final List<Widget> cells = <Widget>[];
    if (widget.showCheckboxes) {
      final int count = <int>{
        for (int i = 0; i < widget.rows.length; i++)
          if (_selectedRows.contains(i)) i,
      }.length;
      final bool? value = count == 0
          ? false
          : count == widget.rows.length
          ? true
          : null;
      void onChanged(bool? next) {
        // Indeterminate selection selects the remaining rows, matching the
        // select-all intent regardless of the checkbox's tristate tap cycle.
        final bool select = value != true;
        setState(
          () => _selectedRows = select
              ? <int>{for (int i = 0; i < widget.rows.length; i++) i}
              : <int>{},
        );
        widget.onSelectAll?.call(select);
      }

      cells.add(
        Container(
          padding:
              _plain<EdgeInsetsGeometry>(
                (DataTableStyle s) => s.headerCellPadding,
              ) ??
              EdgeInsets.zero,
          alignment: Alignment.center,
          child:
              widget.checkboxBuilder?.call(context, value, onChanged) ??
              Checkbox(
                value: value,
                tristate: true,
                onChanged: onChanged,
                semanticLabel: 'Select all rows',
              ),
        ),
      );
    }
    for (final (int index, DataTableColumn column) in _visibleColumns) {
      if (widget.headerBuilder != null) {
        cells.add(widget.headerBuilder!(context, column, index));
        continue;
      }
      Widget content = column.header;
      if (column.sortable && widget.sortColumnIndex == index) {
        content = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(child: content),
            const SizedBox(width: 4),
            widget.sortAscending
                ? _plain<Widget>((DataTableStyle s) => s.sortAscendingIcon) ??
                      ArrowGlyph(
                        direction: GlyphDirection.up,
                        size: 16,
                        color: _plain<Color>(
                          (DataTableStyle s) => s.sortIconColor,
                        ),
                      )
                : _plain<Widget>((DataTableStyle s) => s.sortDescendingIcon) ??
                      ArrowGlyph(
                        direction: GlyphDirection.down,
                        size: 16,
                        color: _plain<Color>(
                          (DataTableStyle s) => s.sortIconColor,
                        ),
                      ),
          ],
        );
      }
      content = Container(
        padding:
            column.headerPadding ??
            _plain<EdgeInsetsGeometry>(
              (DataTableStyle s) => s.headerCellPadding,
            ) ??
            EdgeInsets.zero,
        alignment:
            column.headerAlignment ??
            _plain<AlignmentGeometry>(
              (DataTableStyle s) => s.headerCellAlignment,
            ) ??
            AlignmentDirectional.centerStart,
        child: DefaultTextStyle.merge(
          style: _plain<TextStyle>((DataTableStyle s) => s.headerTextStyle),
          child: content,
        ),
      );
      content = _action(
        content,
        column.sortable && widget.onSort != null
            ? () => widget.onSort!(index)
            : column.onTap,
        header: true,
      );
      if (column.tooltip != null) {
        content = Tooltip(message: column.tooltip!, child: content);
      }
      cells.add(content);
    }
    if (_hasExpandColumn) cells.add(const SizedBox.shrink());
    return _table(
      'header',
      cells,
      decoration: _plain<Decoration>((DataTableStyle s) => s.headerDecoration),
    );
  }

  void _appendDataRow(
    List<Widget> rows,
    DataTableRow row,
    int rowIndex,
    String path,
    int depth,
  ) {
    final Widget? fullWidth = widget.expandedRowChildBuilder?.call(
      context,
      row,
      rowIndex,
    );
    final Widget? confined = fullWidth == null
        ? widget.expandableRowBuilder?.call(context, row, rowIndex)
        : null;
    final List<DataTableRow> children = row.children ?? const <DataTableRow>[];
    final bool expandable =
        children.isNotEmpty || fullWidth != null || confined != null;
    rows.add(_buildDataRow(row, rowIndex, path, depth, expandable));
    if (!_expandedRows.contains(path)) return;
    if (fullWidth != null) {
      rows.add(
        Container(
          padding:
              _plain<EdgeInsetsGeometry>(
                (DataTableStyle s) => s.expandedRowPadding,
              ) ??
              _cellPadding,
          decoration: _plain<Decoration>(
            (DataTableStyle s) => s.expandedRowDecoration,
          ),
          child: fullWidth,
        ),
      );
    } else if (confined != null) {
      rows.add(
        _table(
          'detail:$path',
          <Widget>[
            Padding(
              padding:
                  _plain<EdgeInsetsGeometry>(
                    (DataTableStyle s) => s.expandedRowPadding,
                  ) ??
                  _cellPadding,
              child: confined,
            ),
            for (int i = 1; i < _totalColumnCount; i++) const SizedBox.shrink(),
          ],
          decoration: _plain<Decoration>(
            (DataTableStyle s) => s.expandedRowDecoration,
          ),
        ),
      );
    }
    for (int i = 0; i < children.length; i++) {
      _appendDataRow(rows, children[i], i, '$path.$i', depth + 1);
    }
  }

  Decoration? _rowDecoration(
    DataTableRow row,
    int index,
    InteractionState state,
  ) {
    if (row.decoration != null) return row.decoration;
    for (final DataTableStyle? layer in _layers) {
      if (layer == null) continue;
      final Decoration? decoration =
          layer.decoration?.resolve(state) ??
          (state.isSelected ? layer.selectedRowDecoration : null) ??
          (state.isHovered ? layer.hoveredRowDecoration : null) ??
          (index.isOdd ? layer.alternateRowDecoration : null) ??
          layer.rowDecoration;
      if (decoration != null) return decoration;
    }
    return null;
  }

  TextStyle? _rowTextStyle(InteractionState state) {
    for (final DataTableStyle? layer in _layers) {
      final TextStyle? value =
          layer?.textStyle?.resolve(state) ?? layer?.cellTextStyle;
      if (value != null) return value;
    }
    return null;
  }

  Widget _buildDataRow(
    DataTableRow row,
    int rowIndex,
    String path,
    int depth,
    bool expandable,
  ) {
    final bool selected = depth == 0 && _selectedRows.contains(rowIndex);
    final List<Widget> cells = <Widget>[];
    if (widget.showCheckboxes) {
      void onChanged(bool? value) {
        setState(() {
          if (value == true) {
            _selectedRows.add(rowIndex);
          } else {
            _selectedRows.remove(rowIndex);
          }
        });
        widget.onRowSelected?.call(rowIndex);
      }

      cells.add(
        depth > 0
            ? const SizedBox.shrink()
            : Container(
                padding: _cellPadding,
                alignment: Alignment.center,
                child:
                    widget.checkboxBuilder?.call(
                      context,
                      selected,
                      onChanged,
                    ) ??
                    Checkbox(
                      value: selected,
                      onChanged: onChanged,
                      semanticLabel: 'Select row ${rowIndex + 1}',
                    ),
              ),
      );
    }
    final List<(int, DataTableColumn)> visible = _visibleColumns;
    for (int vi = 0; vi < visible.length; vi++) {
      final (int ci, DataTableColumn column) = visible[vi];
      final Widget cell = ci < row.cells.length
          ? row.cells[ci]
          : const SizedBox.shrink();
      if (widget.cellBuilder != null) {
        cells.add(
          widget.cellBuilder!(context, cell, column, row, rowIndex, ci),
        );
        continue;
      }
      Widget content = Container(
        padding: row.cellPadding ?? column.cellPadding ?? _cellPadding,
        alignment: row.cellAlignment ?? column.cellAlignment ?? _cellAlignment,
        constraints: column.constraints,
        child: vi == 0 && depth > 0
            ? Padding(
                padding: EdgeInsetsDirectional.only(start: depth * 24),
                child: cell,
              )
            : cell,
      );
      if (widget.onCellTap != null) {
        content = _action(content, () => widget.onCellTap!(rowIndex, ci));
      }
      cells.add(content);
    }
    if (_hasExpandColumn) {
      final bool expanded = _expandedRows.contains(path);
      final NeutralLocalizations strings = NeutralLocalizations.of(context);
      final Widget glyph = expanded
          ? _plain<Widget>((DataTableStyle s) => s.rowCollapseIcon) ??
                const ChevronGlyph(direction: GlyphDirection.up, size: 20)
          : _plain<Widget>((DataTableStyle s) => s.rowExpandIcon) ??
                const ChevronGlyph(size: 20);
      cells.add(
        !expandable
            ? const SizedBox.shrink()
            : Semantics(
                label: expanded
                    ? strings.expandedIconTapHint
                    : strings.collapsedIconTapHint,
                child: _action(
                  SizedBox(width: 48, height: 48, child: Center(child: glyph)),
                  () {
                    setState(() {
                      if (!_expandedRows.remove(path)) _expandedRows.add(path);
                    });
                    widget.onRowExpanded?.call(path);
                  },
                  expanded: expanded,
                ),
              ),
      );
    }
    final Widget table = _table(('row', row.key ?? path), cells);
    final bool hasTap = widget.onRowTap != null || row.onTap != null;
    Widget result = Semantics(
      container: true,
      selected: selected,
      button: hasTap,
      child: InteractionDetector(
        isSelected: selected,
        canRequestFocus: hasTap,
        onTap: hasTap
            ? () {
                widget.onRowTap?.call(rowIndex);
                row.onTap?.call();
              }
            : null,
        onLongPress: widget.onRowLongPress == null
            ? null
            : () => widget.onRowLongPress!(rowIndex),
        mouseCursor: StateProperty<MouseCursor?>.resolveWith(
          (InteractionState state) =>
              _token<MouseCursor>(state, (DataTableStyle s) => s.mouseCursor),
        ),
        builder: (BuildContext context, InteractionState detected) {
          final InteractionState state = detected.copyWith(
            isHovered:
                (_plain<bool>((DataTableStyle s) => s.enableHoverEffect) ??
                    true) &&
                detected.isHovered,
          );
          Widget child = AnimatedDefaultTextStyle(
            style: DefaultTextStyle.of(context).style
                .merge(_rowTextStyle(state)),
            duration: _duration,
            curve: _curve,
            child: table,
          );
          child = Stack(
            children: <Widget>[
              // Row borders paint across the table without changing the
              // column constraints or shifting cells in another state.
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedSurface(
                    duration: _duration,
                    curve: _curve,
                    transitionKey: state.toWidgetStates().join(','),
                    decoration: _rowDecoration(row, rowIndex, state),
                  ),
                ),
              ),
              child,
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: widget.rowDivider == null
                          ? null
                          : Border(bottom: widget.rowDivider!),
                    ),
                  ),
                ),
              ),
            ],
          );
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTap: widget.onRowDoubleTap == null
                ? null
                : () => widget.onRowDoubleTap!(rowIndex),
            onSecondaryTap: widget.onRowSecondaryTap == null
                ? null
                : () => widget.onRowSecondaryTap!(rowIndex),
            child: child,
          );
        },
      ),
    );
    if (row.tooltip != null) {
      result = Tooltip(message: row.tooltip!, child: result);
    }
    result = KeyedSubtree(key: row.key, child: result);
    return widget.rowBuilder?.call(context, row, rowIndex, result) ?? result;
  }

  Widget _buildGroupHeader(DataTableGroup group, int index) {
    final bool collapsed = _collapsedGroups.contains(index);
    Widget content =
        widget.groupHeaderBuilder?.call(context, group, index) ??
        Row(
          children: <Widget>[
            Expanded(child: group.header),
            if (group.collapsible)
              collapsed
                  ? _plain<Widget>((DataTableStyle s) => s.groupExpandIcon) ??
                        const ChevronGlyph(
                          direction: GlyphDirection.end,
                          size: 20,
                        )
                  : _plain<Widget>((DataTableStyle s) => s.groupCollapseIcon) ??
                        const ChevronGlyph(size: 20),
          ],
        );
    content = Container(
      decoration:
          _plain<Decoration>((DataTableStyle s) => s.groupHeaderDecoration) ??
          _plain<Decoration>((DataTableStyle s) => s.headerDecoration),
      padding:
          _plain<EdgeInsetsGeometry>(
            (DataTableStyle s) => s.groupHeaderPadding,
          ) ??
          _cellPadding,
      child: DefaultTextStyle.merge(
        style: _plain<TextStyle>((DataTableStyle s) => s.groupHeaderTextStyle),
        child: content,
      ),
    );
    return KeyedSubtree(
      key: group.key,
      child: _action(
        content,
        !group.collapsible
            ? null
            : () {
                setState(() {
                  if (!_collapsedGroups.remove(index)) {
                    _collapsedGroups.add(index);
                  }
                });
                widget.onGroupToggled?.call(index);
              },
        header: true,
        expanded: group.collapsible ? !collapsed : null,
      ),
    );
  }

  Widget _buildFooter(DataTableRow row, int index) {
    final List<Widget> cells = <Widget>[
      if (widget.showCheckboxes) const SizedBox.shrink(),
      for (final (int ci, DataTableColumn column) in _visibleColumns)
        Container(
          padding:
              row.cellPadding ??
              column.cellPadding ??
              _plain<EdgeInsetsGeometry>(
                (DataTableStyle s) => s.footerCellPadding,
              ) ??
              _cellPadding,
          alignment:
              row.cellAlignment ??
              column.cellAlignment ??
              _plain<AlignmentGeometry>(
                (DataTableStyle s) => s.footerCellAlignment,
              ) ??
              _cellAlignment,
          child: DefaultTextStyle.merge(
            style: _plain<TextStyle>((DataTableStyle s) => s.footerTextStyle),
            child: ci < row.cells.length
                ? row.cells[ci]
                : const SizedBox.shrink(),
          ),
        ),
      if (_hasExpandColumn) const SizedBox.shrink(),
    ];
    return KeyedSubtree(
      key: row.key,
      child: _table(
        ('footer', row.key ?? index),
        cells,
        decoration:
            row.decoration ??
            _plain<Decoration>((DataTableStyle s) => s.footerDecoration),
      ),
    );
  }
}

// Table segments must measure every row, rather than just their own cells.
// This keeps intrinsic widths aligned around spanning rows and rowBuilder.
class _SharedColumnWidth extends TableColumnWidth {
  _SharedColumnWidth(this.delegate, this.keys, this.onChanged);

  final VoidCallback onChanged;
  final Map<double, double> _minimums = <double, double>{};
  final Map<double, double> _maximums = <double, double>{};
  final _ColumnWidthCache _cache = _ColumnWidthCache();

  void _cacheForFrame() {
    if (_cache.scheduled) return;
    _cache.scheduled = true;
    // All segments share the measurement work in this frame. Clear it after
    // layout so independent cell rebuilds can change the next frame's widths.
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _cache.scheduled = false;
      _cache.minimums.clear();
      _cache.maximums.clear();
      _cache.hasFlex = false;
    });
  }

  double _observe(Map<double, double> values, double width, double value) {
    final double? previous = values[width];
    values[width] = value;
    if (previous != null && previous != value) onChanged();
    return value;
  }

  final TableColumnWidth delegate;
  final List<GlobalKey> keys;

  Iterable<RenderBox> get _cells sync* {
    for (final GlobalKey key in keys) {
      final RenderObject? object = key.currentContext?.findRenderObject();
      if (object is RenderBox) yield object;
    }
  }

  @override
  double minIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) {
    _cacheForFrame();
    return _cache.minimums.putIfAbsent(
      containerWidth,
      () => _observe(
        _minimums,
        containerWidth,
        delegate.minIntrinsicWidth(_cells, containerWidth),
      ),
    );
  }

  @override
  double maxIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) {
    _cacheForFrame();
    return _cache.maximums.putIfAbsent(
      containerWidth,
      () => _observe(
        _maximums,
        containerWidth,
        delegate.maxIntrinsicWidth(_cells, containerWidth),
      ),
    );
  }

  @override
  double? flex(Iterable<RenderBox> cells) {
    _cacheForFrame();
    if (!_cache.hasFlex) {
      _cache.flex = delegate.flex(_cells);
      _cache.hasFlex = true;
    }
    return _cache.flex;
  }
}

// Kept separate because Flutter's TableColumnWidth values are immutable.
class _ColumnWidthCache {
  final Map<double, double> minimums = <double, double>{};
  final Map<double, double> maximums = <double, double>{};
  bool scheduled = false;
  bool hasFlex = false;
  double? flex;
}
