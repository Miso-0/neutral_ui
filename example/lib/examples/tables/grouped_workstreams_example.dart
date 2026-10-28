import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);
const Color _accent = Color(0xFF087F6D);
const Color _canvas = Color(0xFFF4F7F3);
const Color _line = Color(0xFFCFDDD4);
const Color _white = Color(0xFFFFFFFF);

const DataTableStyle _tableStyle = DataTableStyle(
  headerDecoration: BoxDecoration(color: _canvas),
  rowDecoration: BoxDecoration(color: _white),
  alternateRowDecoration: BoxDecoration(color: Color(0xFFFAFCF9)),
  hoveredRowDecoration: BoxDecoration(color: Color(0xFFF0F5F0)),
  selectedRowDecoration: BoxDecoration(color: Color(0xFFE4F1E7)),
  footerDecoration: BoxDecoration(color: _canvas),
  expandedRowDecoration: BoxDecoration(color: Color(0xFFF0F5F0)),
  groupHeaderDecoration: BoxDecoration(color: Color(0xFFE9F2EB)),
  headerCellPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  cellPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 15),
  footerCellPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 15),
  expandedRowPadding: EdgeInsets.all(18),
  groupHeaderPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
  headerCellAlignment: AlignmentDirectional.centerStart,
  cellAlignment: AlignmentDirectional.centerStart,
  headerTextStyle: TextStyle(
    color: _muted,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  ),
  cellTextStyle: TextStyle(color: _ink, fontSize: 13),
  footerTextStyle: TextStyle(
    color: _ink,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  ),
  groupHeaderTextStyle: TextStyle(
    color: _accent,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  ),
  sortIconColor: _accent,
  rowExpandIcon: ChevronGlyph(direction: GlyphDirection.end, size: 16),
  rowCollapseIcon: ChevronGlyph(direction: GlyphDirection.down, size: 16),
  groupExpandIcon: ChevronGlyph(direction: GlyphDirection.end, size: 16),
  groupCollapseIcon: ChevronGlyph(direction: GlyphDirection.down, size: 16),
);

/// Collapsible workstream groups and independently expandable nested tasks.
class GroupedWorkstreamsExample extends StatefulWidget {
  /// Creates the example.
  const GroupedWorkstreamsExample({super.key});

  @override
  State<GroupedWorkstreamsExample> createState() =>
      _GroupedWorkstreamsExampleState();
}

class _GroupedWorkstreamsExampleState extends State<GroupedWorkstreamsExample> {
  final Set<int> _collapsedGroups = <int>{1};
  final Set<String> _expandedWorkstreams = <String>{};

  void _toggle<T>(Set<T> values, T value) {
    if (!values.remove(value)) values.add(value);
  }

  Widget _scrollableTable({required double minWidth, required Widget child}) =>
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: _line),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: constraints.maxWidth < minWidth
                      ? minWidth
                      : constraints.maxWidth,
                  child: child,
                ),
              ),
        ),
      );

  Widget _groupedTable() => _scrollableTable(
    minWidth: 620,
    child: DataTable(
      style: _tableStyle,
      rowDivider: const BorderSide(color: _line),
      columns: const <DataTableColumn>[
        DataTableColumn(header: Text('Workstream'), width: FlexColumnWidth(2)),
        DataTableColumn(header: Text('Tasks'), width: FixedColumnWidth(100)),
        DataTableColumn(header: Text('Progress'), width: FlexColumnWidth()),
      ],
      rows: const <DataTableRow>[
        DataTableRow(
          cells: <Widget>[
            Text('Design system'),
            Text('12'),
            Text('8 of 12 complete'),
          ],
          children: <DataTableRow>[
            DataTableRow(
              cells: <Widget>[Text('Token audit'), Text('4'), Text('Complete')],
            ),
            DataTableRow(
              cells: <Widget>[
                Text('Component QA'),
                Text('8'),
                Text('4 of 8 complete'),
              ],
            ),
          ],
        ),
        DataTableRow(
          cells: <Widget>[
            Text('Website launch'),
            Text('8'),
            Text('6 of 8 complete'),
          ],
        ),
        DataTableRow(
          cells: <Widget>[
            Text('Team onboarding'),
            Text('6'),
            Text('3 of 6 complete'),
          ],
        ),
        DataTableRow(
          cells: <Widget>[
            Text('Quarterly planning'),
            Text('4'),
            Text('Not started'),
          ],
        ),
      ],
      groups: const <DataTableGroup>[
        DataTableGroup(
          header: Text('Product / 2 workstreams'),
          startIndex: 0,
          endIndex: 1,
          collapsible: true,
        ),
        DataTableGroup(
          header: Text('Operations / 2 workstreams'),
          startIndex: 2,
          endIndex: 3,
          collapsible: true,
        ),
      ],
      collapsedGroups: Set<int>.of(_collapsedGroups),
      onGroupToggled: (int group) =>
          setState(() => _toggle(_collapsedGroups, group)),
      expandedRows: Set<String>.of(_expandedWorkstreams),
      onRowExpanded: (String path) =>
          setState(() => _toggle(_expandedWorkstreams, path)),
    ),
  );

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(color: Color(0xFF142C2A), fontSize: 14),
    child: IconTheme(
      data: const IconThemeData(color: _accent, size: 16),
      child: _groupedTable(),
    ),
  );
}
